from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

from db import DatabaseError, error_message, execute, query

bp = Blueprint("autores", __name__, url_prefix="/autores")


def validar(form):
    errores = []
    datos = {
        "nombre": form.get("nombre", "").strip(),
        "nacionalidad": form.get("nacionalidad", "").strip(),
    }
    if datos["nombre"] == "":
        errores.append("El nombre es obligatorio.")
    if len(datos["nombre"]) > 100:
        errores.append("El nombre admite máximo 100 caracteres.")
    if datos["nacionalidad"] == "":
        errores.append("La nacionalidad es obligatoria.")
    return datos, errores


@bp.route("/")
def listar():
    autores = query("SELECT * FROM autores ORDER BY id_autor")
    return render_template("autores/list.html", autores=autores)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    autor = {}
    if request.method == "POST":
        autor = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("INSERT INTO autores (nombre, nacionalidad) VALUES (%s, %s)",
                        (datos["nombre"], datos["nacionalidad"]))
                flash("Autor creado correctamente.", "success")
                return redirect(url_for("autores.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("autores/form.html", autor=autor, titulo="Nuevo autor")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    autor = query("SELECT * FROM autores WHERE id_autor = %s", (id,), one=True)
    if autor is None:
        abort(404)
    if request.method == "POST":
        autor = request.form.to_dict()
        datos, errores = validar(request.form)
        if len(errores) == 0:
            try:
                execute("UPDATE autores SET nombre = %s, nacionalidad = %s WHERE id_autor = %s",
                        (datos["nombre"], datos["nacionalidad"], id))
                flash("Autor actualizado correctamente.", "success")
                return redirect(url_for("autores.listar"))
            except DatabaseError as e:
                errores.append(error_message(e))
        for error in errores:
            flash(error, "danger")
    return render_template("autores/form.html", autor=autor, titulo="Editar autor")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        execute("DELETE FROM autores WHERE id_autor = %s", (id,))
        flash("Autor eliminado.", "success")
    except DatabaseError as e:
        flash(error_message(e), "danger")
    return redirect(url_for("autores.listar"))
