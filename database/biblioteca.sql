-- =====================================================
-- Proyecto Final Programación Web
-- Base de datos: biblioteca_db
-- 5 tablas en 3FN. La tabla "prestamos" tiene 2 llaves foráneas
-- y la tabla "libros" también tiene 2 llaves foráneas.
--
-- Cómo usarlo (en psql o en la Query Tool de pgAdmin):
--   1) CREATE DATABASE biblioteca_db;
--   2) Conectarse a biblioteca_db y ejecutar este archivo.
-- =====================================================

-- El archivo está guardado en UTF-8 (para que las tildes y la ñ se vean bien en Windows)
SET client_encoding = 'UTF8';

-- Si las tablas ya existen, las borramos para empezar limpio
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS socios;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS autores;

-- ---------------------------------------------
-- LDD: creación de tablas
-- ---------------------------------------------

-- Tabla 1: autores de los libros
CREATE TABLE autores (
    id_autor      SERIAL PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    nacionalidad  VARCHAR(50)  NOT NULL
);

-- Tabla 2: categorías (géneros) de los libros
CREATE TABLE categorias (
    id_categoria  SERIAL PRIMARY KEY,
    nombre        VARCHAR(50)  NOT NULL UNIQUE,
    descripcion   VARCHAR(200)
);

-- Tabla 3: socios (personas que piden libros prestados)
CREATE TABLE socios (
    id_socio   SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    documento  VARCHAR(20)  NOT NULL UNIQUE,
    correo     VARCHAR(100) NOT NULL UNIQUE,
    telefono   VARCHAR(20)
);

-- Tabla 4: libros (FK a autores y FK a categorias)
CREATE TABLE libros (
    id_libro      SERIAL PRIMARY KEY,
    titulo        VARCHAR(150) NOT NULL,
    isbn          VARCHAR(20)  NOT NULL UNIQUE,
    anio          INTEGER      NOT NULL CHECK (anio BETWEEN 1000 AND 2100),
    ejemplares    INTEGER      NOT NULL CHECK (ejemplares >= 0),
    id_autor      INTEGER      NOT NULL REFERENCES autores (id_autor),
    id_categoria  INTEGER      NOT NULL REFERENCES categorias (id_categoria)
);

-- Tabla 5: prestamos (FK a libros y FK a socios)
CREATE TABLE prestamos (
    id_prestamo       SERIAL PRIMARY KEY,
    id_libro          INTEGER     NOT NULL REFERENCES libros (id_libro),
    id_socio          INTEGER     NOT NULL REFERENCES socios (id_socio),
    fecha_prestamo    DATE        NOT NULL,
    fecha_devolucion  DATE,
    estado            VARCHAR(20) NOT NULL CHECK (estado IN ('Prestado', 'Devuelto')),
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
);

-- ---------------------------------------------
-- LMD: carga de datos (10 registros por tabla)
-- ---------------------------------------------

INSERT INTO autores (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiana'),
('Isabel Allende', 'Chilena'),
('Mario Vargas Llosa', 'Peruana'),
('Julio Cortázar', 'Argentina'),
('Jorge Luis Borges', 'Argentina'),
('Laura Restrepo', 'Colombiana'),
('Stephen King', 'Estadounidense'),
('J. K. Rowling', 'Británica'),
('George Orwell', 'Británica'),
('Yuval Noah Harari', 'Israelí');

INSERT INTO categorias (nombre, descripcion) VALUES
('Novela', 'Narraciones largas de ficción'),
('Cuento', 'Narraciones cortas'),
('Terror', 'Historias de miedo y suspenso'),
('Fantasía', 'Mundos mágicos e imaginarios'),
('Ciencia ficción', 'Historias sobre ciencia y futuro'),
('Historia', 'Libros sobre hechos históricos'),
('Realismo mágico', 'Lo fantástico dentro de lo cotidiano'),
('Ensayo', 'Textos de opinión y análisis'),
('Poesía', 'Obras escritas en verso'),
('Infantil', 'Libros para niños');

INSERT INTO socios (nombre, documento, correo, telefono) VALUES
('Ana Torres', '1075000001', 'ana.torres@correo.com', '3101111111'),
('Carlos Pérez', '1075000002', 'carlos.perez@correo.com', '3102222222'),
('Laura Gómez', '1075000003', 'laura.gomez@correo.com', '3103333333'),
('Andrés Rojas', '1075000004', 'andres.rojas@correo.com', '3104444444'),
('María Díaz', '1075000005', 'maria.diaz@correo.com', '3105555555'),
('Jorge Castro', '1075000006', 'jorge.castro@correo.com', '3106666666'),
('Sofía Ramírez', '1075000007', 'sofia.ramirez@correo.com', '3107777777'),
('Daniel Vargas', '1075000008', 'daniel.vargas@correo.com', '3108888888'),
('Valentina Ruiz', '1075000009', 'valentina.ruiz@correo.com', '3109999999'),
('Felipe Morales', '1075000010', 'felipe.morales@correo.com', '3100000000');

INSERT INTO libros (titulo, isbn, anio, ejemplares, id_autor, id_categoria) VALUES
('Cien años de soledad', '978-0001', 1967, 5, 1, 7),
('La casa de los espíritus', '978-0002', 1982, 3, 2, 7),
('La ciudad y los perros', '978-0003', 1963, 2, 3, 1),
('Rayuela', '978-0004', 1963, 4, 4, 1),
('Ficciones', '978-0005', 1944, 3, 5, 2),
('Delirio', '978-0006', 2004, 2, 6, 1),
('It', '978-0007', 1986, 4, 7, 3),
('Harry Potter y la piedra filosofal', '978-0008', 1997, 6, 8, 4),
('1984', '978-0009', 1949, 5, 9, 5),
('Sapiens', '978-0010', 2011, 3, 10, 6);

INSERT INTO prestamos (id_libro, id_socio, fecha_prestamo, fecha_devolucion, estado) VALUES
(1, 1, '2026-10-01', '2026-10-10', 'Devuelto'),
(2, 2, '2026-10-03', '2026-10-12', 'Devuelto'),
(3, 3, '2026-10-05', NULL, 'Prestado'),
(4, 4, '2026-10-07', '2026-10-15', 'Devuelto'),
(5, 5, '2026-10-09', NULL, 'Prestado'),
(6, 6, '2026-10-11', '2026-10-20', 'Devuelto'),
(7, 7, '2026-10-13', NULL, 'Prestado'),
(8, 8, '2026-10-15', '2026-10-25', 'Devuelto'),
(9, 9, '2026-10-17', NULL, 'Prestado'),
(10, 1, '2026-10-19', NULL, 'Prestado');
