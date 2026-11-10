import psycopg2
from flask import Flask, render_template

import db
from config import Config
from routes.autores import bp as autores_bp
from routes.categorias import bp as categorias_bp

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)

app.register_blueprint(autores_bp)
app.register_blueprint(categorias_bp)


@app.route("/")
def inicio():
    conteos = db.query("""
        SELECT (SELECT COUNT(*) FROM autores)    AS autores,
               (SELECT COUNT(*) FROM categorias) AS categorias,
               (SELECT COUNT(*) FROM socios)     AS socios,
               (SELECT COUNT(*) FROM libros)     AS libros,
               (SELECT COUNT(*) FROM prestamos)  AS prestamos
    """, one=True)
    return render_template("index.html", c=conteos)


@app.errorhandler(psycopg2.OperationalError)
def error_conexion(exc):
    return render_template("error_db.html", error=str(exc)), 500


@app.errorhandler(404)
def no_encontrado(exc):
    return render_template("404.html"), 404


if __name__ == "__main__":
    app.run(debug=True)
