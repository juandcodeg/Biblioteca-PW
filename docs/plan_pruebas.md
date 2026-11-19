# Plan de pruebas funcionales

Las capturas de cada caso están en la carpeta `docs/evidencias/` con el nombre del caso (por ejemplo `CP-01.png`).

| ID | Tabla | Operación | Datos de entrada | Resultado esperado | Resultado obtenido | Evidencia |
|---|---|---|---|---|---|---|
| CP-01 | autores | Crear | Nombre "Rafael Pombo", nacionalidad "Colombiana" | Se guarda y aparece en el listado | Cumple ✓ | [CP-01](evidencias/CP-01.png) |
| CP-02 | autores | Crear (inválido) | Nombre vacío | Mensaje "El nombre es obligatorio." | Cumple ✓ | [CP-02](evidencias/CP-02.png) |
| CP-03 | autores | Eliminar relacionado | Eliminar "Gabriel García Márquez" (tiene libros) | Mensaje "No se puede eliminar...: el registro está relacionado" | Cumple ✓ | [CP-03](evidencias/CP-03.png) |
| CP-04 | categorias | Listar | Entrar a Categorías | Se ven las 10 categorías | Cumple ✓ | [CP-04](evidencias/CP-04.png) |
| CP-05 | categorias | Crear (duplicado) | Nombre "Novela" (ya existe) | Mensaje de dato duplicado | Cumple ✓ | [CP-05](evidencias/CP-05.png) |
| CP-06 | categorias | Editar | Cambiar la descripción de "Poesía" | Formulario precargado; se guarda el cambio | Cumple ✓ | [CP-06](evidencias/CP-06.png) |
| CP-07 | socios | Crear | Nombre, documento 1075000011, correo válido | Se guarda y aparece en el listado | Cumple ✓ | [CP-07](evidencias/CP-07.png) |
| CP-08 | socios | Crear (inválido) | Correo "anacorreo" (sin @) | Mensaje "El correo no tiene un formato válido." | Cumple ✓ | [CP-08](evidencias/CP-08.png) |
| CP-09 | socios | Eliminar | Eliminar el socio creado en CP-07 (sin préstamos) | Pide confirmación y lo elimina | Cumple ✓ | [CP-09](evidencias/CP-09.png) |
| CP-10 | libros | Crear | Título, ISBN nuevo, año 2020, autor y categoría desde la lista | Se guarda; el listado muestra nombre del autor y la categoría | Cumple ✓ | [CP-10](evidencias/CP-10.png) |
| CP-11 | libros | Crear (inválido) | Año "1500a" o sin autor | Mensajes "El año debe ser un número entero." / "Debes seleccionar un autor." | Cumple ✓ | [CP-11](evidencias/CP-11.png) |
| CP-12 | libros | Eliminar relacionado | Eliminar "Cien años de soledad" (tiene préstamos) | Mensaje "No se puede eliminar..." | Cumple ✓ | [CP-12](evidencias/CP-12.png) |
| CP-13 | prestamos | Crear | Libro, socio, fecha hoy, estado Prestado | Se guarda; el listado muestra título y nombre del socio | Cumple ✓ | [CP-13](evidencias/CP-13.png) |
| CP-14 | prestamos | Editar | Cambiar estado a "Devuelto" y poner fecha de devolución | Formulario precargado; se guarda el cambio | Cumple ✓ | [CP-14](evidencias/CP-14.png) |
| CP-15 | prestamos | Crear (inválido) | Fecha de devolución anterior a la de préstamo | Mensaje "La fecha de devolución no puede ser anterior..." | Cumple ✓ | [CP-15](evidencias/CP-15.png) |
