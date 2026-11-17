from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

from db import DatabaseError, error_message, execute, query

bp = Blueprint("prestamos", __name__, url_prefix="/prestamos")


def validar(form):
    errores = []
    datos = {
        "id_libro": form.get("id_libro", ""),
        "id_socio": form.get("id_socio", ""),
        "fecha_prestamo": form.get("fecha_prestamo", ""),
        "fecha_devolucion": form.get("fecha_devolucion", ""),
        "estado": form.get("estado", ""),
    }
    if datos["id_libro"] == "":
        errores.append("Debes seleccionar un libro.")
    if datos["id_socio"] == "":
        errores.append("Debes seleccionar un socio.")
    if datos["fecha_prestamo"] == "":
        errores.append("La fecha de préstamo es obligatoria.")
    if datos["estado"] not in ("Prestado", "Devuelto"):
        errores.append("El estado debe ser Prestado o Devuelto.")
    if datos["fecha_devolucion"] == "":
        datos["fecha_devolucion"] = None
    elif datos["fecha_prestamo"] != "" and datos["fecha_devolucion"] < datos["fecha_prestamo"]:
        errores.append("La fecha de devolución no puede ser anterior a la fecha de préstamo.")
    return datos, errores


def mostrar_formulario(prestamo, titulo):
    libros = query("SELECT id_libro, titulo FROM libros ORDER BY titulo")
    socios = query("SELECT id_socio, nombre FROM socios ORDER BY nombre")
    return render_template("prestamos/form.html", prestamo=prestamo, titulo=titulo,
                           libros=libros, socios=socios)


@bp.route("/")
def listar():
    prestamos = query("""
        SELECT p.*, l.titulo AS libro, s.nombre AS socio
        FROM prestamos p
        JOIN libros l ON l.id_libro = p.id_libro
        JOIN socios s ON s.id_socio = p.id_socio
        ORDER BY p.id_prestamo
    """)
    return render_template("prestamos/list.html", prestamos=prestamos)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    prestamo = {"estado": "Prestado"}
    if request.method == "POST":
        prestamo = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion, estado)
                           VALUES (%s, %s, %s, %s, %s)""",
                        (datos["id_libro"], datos["id_socio"], datos["fecha_prestamo"],
                         datos["fecha_devolucion"], datos["estado"]))
                flash("Préstamo registrado correctamente.", "success")
                return redirect(url_for("prestamos.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return mostrar_formulario(prestamo, "Nuevo préstamo")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    prestamo = query("SELECT * FROM prestamos WHERE id_prestamo = %s", (id,), one=True)
    if prestamo is None:
        abort(404)
    if request.method == "POST":
        prestamo = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""UPDATE prestamos
                           SET id_libro = %s, id_socio = %s, fecha_prestamo = %s,
                               fecha_devolucion = %s, estado = %s
                           WHERE id_prestamo = %s""",
                        (datos["id_libro"], datos["id_socio"], datos["fecha_prestamo"],
                         datos["fecha_devolucion"], datos["estado"], id))
                flash("Préstamo actualizado correctamente.", "success")
                return redirect(url_for("prestamos.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return mostrar_formulario(prestamo, "Editar préstamo")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        execute("DELETE FROM prestamos WHERE id_prestamo = %s", (id,))
        flash("Préstamo eliminado.", "success")
    except DatabaseError as e:
        flash(error_message(e), "danger")
    return redirect(url_for("prestamos.listar"))
