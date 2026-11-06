import psycopg2
import psycopg2.extras
from flask import current_app, g

DatabaseError = psycopg2.Error


def get_db():
    if "db" not in g:
        cfg = current_app.config
        g.db = psycopg2.connect(
            host=cfg["DB_HOST"],
            port=cfg["DB_PORT"],
            dbname=cfg["DB_NAME"],
            user=cfg["DB_USER"],
            password=cfg["DB_PASSWORD"],
        )
    return g.db


def close_db(exc=None):
    conn = g.pop("db", None)
    if conn is not None:
        conn.close()


def init_app(app):
    app.teardown_appcontext(close_db)


def query(sql, params=(), one=False):
    conn = get_db()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute(sql, params)
    filas = cur.fetchall()
    cur.close()
    if one:
        if filas:
            return filas[0]
        return None
    return filas


def execute(sql, params=()):
    conn = get_db()
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        filas_afectadas = cur.rowcount
        cur.close()
        conn.commit()
        return filas_afectadas
    except psycopg2.Error:
        conn.rollback()
        raise


def error_message(exc):
    codigo = exc.pgcode
    if codigo == "23503":
        return "No se puede eliminar o guardar: el registro está relacionado con otros datos."
    if codigo == "23505":
        return "Ya existe un registro con ese valor (dato duplicado)."
    if codigo == "23514":
        return "Algún valor está fuera del rango permitido."
    if codigo == "23502":
        return "Falta un campo obligatorio."
    return "Error de base de datos: " + str(exc)
