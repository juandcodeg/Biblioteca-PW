from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

from db import DatabaseError, error_message, execute, query

bp = Blueprint("libros", __name__, url_prefix="/libros")


def validar(form):
    errores = []
    datos = {
        "titulo": form.get("titulo", "").strip(),
        "isbn": form.get("isbn", "").strip(),
        "anio": form.get("anio", "").strip(),
        "ejemplares": form.get("ejemplares", "").strip(),
        "id_autor": form.get("id_autor", ""),
        "id_categoria": form.get("id_categoria", ""),
    }
    if datos["titulo"] == "":
        errores.append("El título es obligatorio.")
    if datos["isbn"] == "":
        errores.append("El ISBN es obligatorio.")
    if not datos["anio"].isdigit():
        errores.append("El año debe ser un número entero.")
    elif int(datos["anio"]) < 1000 or int(datos["anio"]) > 2100:
        errores.append("El año debe estar entre 1000 y 2100.")
    if not datos["ejemplares"].isdigit():
        errores.append("Los ejemplares deben ser un número entero mayor o igual a 0.")
    if datos["id_autor"] == "":
        errores.append("Debes seleccionar un autor.")
    if datos["id_categoria"] == "":
        errores.append("Debes seleccionar una categoría.")
    return datos, errores


def mostrar_formulario(libro, titulo):
    autores = query("SELECT id_autor, nombre FROM autores ORDER BY nombre")
    categorias = query("SELECT id_categoria, nombre FROM categorias ORDER BY nombre")
    return render_template("libros/form.html", libro=libro, titulo=titulo,
                           autores=autores, categorias=categorias)


@bp.route("/")
def listar():
    libros = query("""
        SELECT l.*, a.nombre AS autor, c.nombre AS categoria
        FROM libros l
        JOIN autores a ON a.id_autor = l.id_autor
        JOIN categorias c ON c.id_categoria = l.id_categoria
        ORDER BY l.id_libro
    """)
    return render_template("libros/list.html", libros=libros)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    libro = {}
    if request.method == "POST":
        libro = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""INSERT INTO libros (titulo, isbn, anio, ejemplares, id_autor, id_categoria)
                           VALUES (%s, %s, %s, %s, %s, %s)""",
                        (datos["titulo"], datos["isbn"], datos["anio"], datos["ejemplares"],
                         datos["id_autor"], datos["id_categoria"]))
                flash("Libro creado correctamente.", "success")
                return redirect(url_for("libros.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return mostrar_formulario(libro, "Nuevo libro")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    libro = query("SELECT * FROM libros WHERE id_libro = %s", (id,), one=True)
    if libro is None:
        abort(404)
    if request.method == "POST":
        libro = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("""UPDATE libros
                           SET titulo = %s, isbn = %s, anio = %s, ejemplares = %s,
                               id_autor = %s, id_categoria = %s
                           WHERE id_libro = %s""",
                        (datos["titulo"], datos["isbn"], datos["anio"], datos["ejemplares"],
                         datos["id_autor"], datos["id_categoria"], id))
                flash("Libro actualizado correctamente.", "success")
                return redirect(url_for("libros.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return mostrar_formulario(libro, "Editar libro")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        execute("DELETE FROM libros WHERE id_libro = %s", (id,))
        flash("Libro eliminado.", "success")
    except DatabaseError as e:
        flash(error_message(e), "danger")
    return redirect(url_for("libros.listar"))
