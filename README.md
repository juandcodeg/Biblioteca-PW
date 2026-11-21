# Biblioteca - Proyecto Final Programación Web

Proyecto final de Programación Web. Es una aplicación en Flask con PostgreSQL para manejar una biblioteca: autores, categorías, libros, socios y préstamos.

## Integrante

- Juan David Gamboa Herrera

## Tema

La biblioteca guarda sus libros con su autor y su categoría, los socios que se inscriben y los préstamos de libros a los socios. En cada tabla se puede listar, crear, editar y eliminar.

Tablas: autores, categorias, socios, libros (tiene FK a autores y categorias) y prestamos (tiene FK a libros y socios).

## MER

![MER](docs/MER.png)

El diccionario de datos está en docs/diccionario_datos.md y el plan de pruebas en docs/plan_pruebas.md.

## Instalación

1. Clonar el repositorio:

```
git clone https://github.com/juandcodeg/Biblioteca-PW.git
cd Biblioteca-PW
```

2. En pgAdmin crear la base de datos biblioteca_db, abrir la Query Tool y ejecutar el archivo .sql de la carpeta database.

3. Crear el entorno virtual e instalar las librerías:

```
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

4. Copiar el archivo .env.example, cambiarle el nombre a .env y poner la contraseña de PostgreSQL.

5. Ejecutar:

```
python app.py
```

Y abrir http://127.0.0.1:5000

## Capturas

Las capturas de las pruebas están en la carpeta docs/evidencias.
