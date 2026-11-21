--
-- PostgreSQL database dump
--

\restrict ANHyynbT5ZvSEnguakOtaJePwb7D0jbTrazqBnaCf6sgfAv62ir6UsQinH8znSE

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: autores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autores (
    id_autor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    nacionalidad character varying(50) NOT NULL
);


--
-- Name: autores_id_autor_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autores_id_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: autores_id_autor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autores_id_autor_seq OWNED BY public.autores.id_autor;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(200)
);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorias_id_categoria_seq OWNED BY public.categorias.id_categoria;


--
-- Name: libros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.libros (
    id_libro integer NOT NULL,
    titulo character varying(150) NOT NULL,
    isbn character varying(20) NOT NULL,
    anio integer NOT NULL,
    ejemplares integer NOT NULL,
    id_autor integer NOT NULL,
    id_categoria integer NOT NULL,
    CONSTRAINT libros_anio_check CHECK (((anio >= 1000) AND (anio <= 2100))),
    CONSTRAINT libros_ejemplares_check CHECK ((ejemplares >= 0))
);


--
-- Name: libros_id_libro_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.libros_id_libro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: libros_id_libro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.libros_id_libro_seq OWNED BY public.libros.id_libro;


--
-- Name: prestamos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prestamos (
    id_prestamo integer NOT NULL,
    id_libro integer NOT NULL,
    id_socio integer NOT NULL,
    fecha_prestamo date NOT NULL,
    fecha_devolucion date,
    estado character varying(20) NOT NULL,
    CONSTRAINT prestamos_check CHECK (((fecha_devolucion IS NULL) OR (fecha_devolucion >= fecha_prestamo))),
    CONSTRAINT prestamos_estado_check CHECK (((estado)::text = ANY ((ARRAY['Prestado'::character varying, 'Devuelto'::character varying])::text[])))
);


--
-- Name: prestamos_id_prestamo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prestamos_id_prestamo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prestamos_id_prestamo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prestamos_id_prestamo_seq OWNED BY public.prestamos.id_prestamo;


--
-- Name: socios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.socios (
    id_socio integer NOT NULL,
    nombre character varying(100) NOT NULL,
    documento character varying(20) NOT NULL,
    correo character varying(100) NOT NULL,
    telefono character varying(20)
);


--
-- Name: socios_id_socio_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.socios_id_socio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: socios_id_socio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.socios_id_socio_seq OWNED BY public.socios.id_socio;


--
-- Name: autores id_autor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autores ALTER COLUMN id_autor SET DEFAULT nextval('public.autores_id_autor_seq'::regclass);


--
-- Name: categorias id_categoria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_id_categoria_seq'::regclass);


--
-- Name: libros id_libro; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros ALTER COLUMN id_libro SET DEFAULT nextval('public.libros_id_libro_seq'::regclass);


--
-- Name: prestamos id_prestamo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos ALTER COLUMN id_prestamo SET DEFAULT nextval('public.prestamos_id_prestamo_seq'::regclass);


--
-- Name: socios id_socio; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socios ALTER COLUMN id_socio SET DEFAULT nextval('public.socios_id_socio_seq'::regclass);


--
-- Data for Name: autores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.autores (id_autor, nombre, nacionalidad) FROM stdin;
1	Gabriel García Márquez	Colombiana
2	Isabel Allende	Chilena
3	Mario Vargas Llosa	Peruana
4	Julio Cortázar	Argentina
5	Jorge Luis Borges	Argentina
6	Laura Restrepo	Colombiana
7	Stephen King	Estadounidense
8	J. K. Rowling	Británica
9	George Orwell	Británica
10	Yuval Noah Harari	Israelí
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias (id_categoria, nombre, descripcion) FROM stdin;
1	Novela	Narraciones largas de ficción
2	Cuento	Narraciones cortas
3	Terror	Historias de miedo y suspenso
4	Fantasía	Mundos mágicos e imaginarios
5	Ciencia ficción	Historias sobre ciencia y futuro
6	Historia	Libros sobre hechos históricos
7	Realismo mágico	Lo fantástico dentro de lo cotidiano
8	Ensayo	Textos de opinión y análisis
9	Poesía	Obras escritas en verso
10	Infantil	Libros para niños
\.


--
-- Data for Name: libros; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.libros (id_libro, titulo, isbn, anio, ejemplares, id_autor, id_categoria) FROM stdin;
1	Cien años de soledad	978-0001	1967	5	1	7
2	La casa de los espíritus	978-0002	1982	3	2	7
3	La ciudad y los perros	978-0003	1963	2	3	1
4	Rayuela	978-0004	1963	4	4	1
5	Ficciones	978-0005	1944	3	5	2
6	Delirio	978-0006	2004	2	6	1
7	It	978-0007	1986	4	7	3
8	Harry Potter y la piedra filosofal	978-0008	1997	6	8	4
9	1984	978-0009	1949	5	9	5
10	Sapiens	978-0010	2011	3	10	6
\.


--
-- Data for Name: prestamos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.prestamos (id_prestamo, id_libro, id_socio, fecha_prestamo, fecha_devolucion, estado) FROM stdin;
1	1	1	2026-10-01	2026-10-10	Devuelto
2	2	2	2026-10-03	2026-10-12	Devuelto
3	3	3	2026-10-05	\N	Prestado
4	4	4	2026-10-07	2026-10-15	Devuelto
5	5	5	2026-10-09	\N	Prestado
6	6	6	2026-10-11	2026-10-20	Devuelto
7	7	7	2026-10-13	\N	Prestado
8	8	8	2026-10-15	2026-10-25	Devuelto
9	9	9	2026-10-17	\N	Prestado
10	10	1	2026-10-19	\N	Prestado
\.


--
-- Data for Name: socios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.socios (id_socio, nombre, documento, correo, telefono) FROM stdin;
1	Ana Torres	1075000001	ana.torres@correo.com	3101111111
2	Carlos Pérez	1075000002	carlos.perez@correo.com	3102222222
3	Laura Gómez	1075000003	laura.gomez@correo.com	3103333333
4	Andrés Rojas	1075000004	andres.rojas@correo.com	3104444444
5	María Díaz	1075000005	maria.diaz@correo.com	3105555555
6	Jorge Castro	1075000006	jorge.castro@correo.com	3106666666
7	Sofía Ramírez	1075000007	sofia.ramirez@correo.com	3107777777
8	Daniel Vargas	1075000008	daniel.vargas@correo.com	3108888888
9	Valentina Ruiz	1075000009	valentina.ruiz@correo.com	3109999999
10	Felipe Morales	1075000010	felipe.morales@correo.com	3100000000
\.


--
-- Name: autores_id_autor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.autores_id_autor_seq', 10, true);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 10, true);


--
-- Name: libros_id_libro_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.libros_id_libro_seq', 10, true);


--
-- Name: prestamos_id_prestamo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.prestamos_id_prestamo_seq', 10, true);


--
-- Name: socios_id_socio_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.socios_id_socio_seq', 10, true);


--
-- Name: autores autores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autores
    ADD CONSTRAINT autores_pkey PRIMARY KEY (id_autor);


--
-- Name: categorias categorias_nombre_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nombre_key UNIQUE (nombre);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: libros libros_isbn_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_isbn_key UNIQUE (isbn);


--
-- Name: libros libros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_pkey PRIMARY KEY (id_libro);


--
-- Name: prestamos prestamos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (id_prestamo);


--
-- Name: socios socios_correo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_correo_key UNIQUE (correo);


--
-- Name: socios socios_documento_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_documento_key UNIQUE (documento);


--
-- Name: socios socios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.socios
    ADD CONSTRAINT socios_pkey PRIMARY KEY (id_socio);


--
-- Name: libros libros_id_autor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_id_autor_fkey FOREIGN KEY (id_autor) REFERENCES public.autores(id_autor);


--
-- Name: libros libros_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria);


--
-- Name: prestamos prestamos_id_libro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libros(id_libro);


--
-- Name: prestamos prestamos_id_socio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_socio_fkey FOREIGN KEY (id_socio) REFERENCES public.socios(id_socio);


--
-- PostgreSQL database dump complete
--

\unrestrict ANHyynbT5ZvSEnguakOtaJePwb7D0jbTrazqBnaCf6sgfAv62ir6UsQinH8znSE

