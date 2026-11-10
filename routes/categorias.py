from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

from db import DatabaseError, error_message, execute, query

bp = Blueprint("categorias", __name__, url_prefix="/categorias")


def validar(form):
    errores = []
    datos = {
        "nombre": form.get("nombre", "").strip(),
        "descripcion": form.get("descripcion", "").strip(),
    }
    if datos["nombre"] == "":
        errores.append("El nombre es obligatorio.")
    if len(datos["nombre"]) > 50:
        errores.append("El nombre admite máximo 50 caracteres.")
    if len(datos["descripcion"]) > 200:
        errores.append("La descripción admite máximo 200 caracteres.")
    return datos, errores


@bp.route("/")
def listar():
    categorias = query("SELECT * FROM categorias ORDER BY id_categoria")
    return render_template("categorias/list.html", categorias=categorias)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    categoria = {}
    if request.method == "POST":
        categoria = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("INSERT INTO categorias (nombre, descripcion) VALUES (%s, %s)",
                        (datos["nombre"], datos["descripcion"]))
                flash("Categoría creada correctamente.", "success")
                return redirect(url_for("categorias.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("categorias/form.html", categoria=categoria, titulo="Nueva categoría")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    categoria = query("SELECT * FROM categorias WHERE id_categoria = %s", (id,), one=True)
    if categoria is None:
        abort(404)
    if request.method == "POST":
        categoria = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("UPDATE categorias SET nombre = %s, descripcion = %s WHERE id_categoria = %s",
                        (datos["nombre"], datos["descripcion"], id))
                flash("Categoría actualizada correctamente.", "success")
                return redirect(url_for("categorias.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("categorias/form.html", categoria=categoria, titulo="Editar categoría")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        execute("DELETE FROM categorias WHERE id_categoria = %s", (id,))
        flash("Categoría eliminada.", "success")
    except DatabaseError as e:
        flash(error_message(e), "danger")
    return redirect(url_for("categorias.listar"))
