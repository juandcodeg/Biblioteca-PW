from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

from db import DatabaseError, error_message, execute, query

bp = Blueprint("socios", __name__, url_prefix="/socios")


def validar(form):
    errores = []
    datos = {
        "nombre": form.get("nombre", "").strip(),
        "documento": form.get("documento", "").strip(),
        "correo": form.get("correo", "").strip(),
        "telefono": form.get("telefono", "").strip(),
    }
    if datos["nombre"] == "":
        errores.append("El nombre es obligatorio.")
    if datos["documento"] == "":
        errores.append("El documento es obligatorio.")
    elif not datos["documento"].isdigit():
        errores.append("El documento solo debe tener números.")
    if datos["correo"] == "":
        errores.append("El correo es obligatorio.")
    elif "@" not in datos["correo"] or "." not in datos["correo"]:
        errores.append("El correo no tiene un formato válido.")
    return datos, errores


@bp.route("/")
def listar():
    socios = query("SELECT * FROM socios ORDER BY id_socio")
    return render_template("socios/list.html", socios=socios)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    socio = {}
    if request.method == "POST":
        socio = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""INSERT INTO socios (nombre, documento, correo, telefono)
                           VALUES (%s, %s, %s, %s)""",
                        (datos["nombre"], datos["documento"], datos["correo"], datos["telefono"]))
                flash("Socio creado correctamente.", "success")
                return redirect(url_for("socios.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("socios/form.html", socio=socio, titulo="Nuevo socio")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    socio = query("SELECT * FROM socios WHERE id_socio = %s", (id,), one=True)
    if socio is None:
        abort(404)
    if request.method == "POST":
        socio = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""UPDATE socios
                           SET nombre = %s, documento = %s, correo = %s, telefono = %s
                           WHERE id_socio = %s""",
                        (datos["nombre"], datos["documento"], datos["correo"], datos["telefono"], id))
                flash("Socio actualizado correctamente.", "success")
                return redirect(url_for("socios.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("socios/form.html", socio=socio, titulo="Editar socio")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        execute("DELETE FROM socios WHERE id_socio = %s", (id,))
        flash("Socio eliminado.", "success")
    except DatabaseError as e:
        flash(error_message(e), "danger")
    return redirect(url_for("socios.listar"))
