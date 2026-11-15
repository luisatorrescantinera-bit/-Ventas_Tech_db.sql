# RetailPro

Proyecto de análisis de ventas para **TechStore**, una tienda ficticia de tecnología. Parte de un modelo relacional en estrella en SQL Server (`Ventas_Tech_DB`), con consultas que resumen la actividad comercial, y un modelo en Power BI que usa esas consultas como fuente de datos. Se desarrolló como práctica del curso de SQL con Power BI.

## Objetivo

- Modelar una base de ventas con clientes, productos y categorías.
- Responder preguntas de negocio con SQL: facturación mensual, ranking de productos, clientes y productos sin ventas.
- Alimentar un tablero en Power BI con una consulta consolidada.

## Herramientas utilizadas

| Herramienta | Uso |
|---|---|
| SQL Server | Motor de base de datos (`Ventas_Tech_DB`) |
| SQL Server Management Studio (SSMS) | Ejecución y prueba de scripts |
| Power BI Desktop | Modelo de datos y visualizaciones |
| DAX | Creación de la tabla de fechas (`Dim_Fechas`) |
| Git y GitHub | Control de versiones del proyecto |

## Modelo de datos

Modelo en estrella con una tabla de hechos (`ventas`) y tres dimensiones.

| Tabla | Tipo | Columnas | Registros |
|---|---|---|---|
| `categorias` | Dimensión | id_categoria, nombre_categoria, descripcion | 4 |
| `clientes` | Dimensión | id_cliente, nombre, email, ciudad, fecha_registro | 5 |
| `productos` | Dimensión | id_producto, nombre_producto, id_categoria, precio, stock, activo | 6 |
| `ventas` | Hechos | id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta | 10 |

Relaciones: `productos.id_categoria → categorias`, `ventas.id_cliente → clientes` y `ventas.id_producto → productos`.

**Modelo en Power BI:** `Fac_Ventas` se relaciona con `Dim_Clientes`, `Dim_Productos` y `Dim_Fechas`, y `Dim_Productos` con `Dim_Categorias`. Son cuatro relaciones de uno a muchos con filtro en un solo sentido.

## Estructura del repositorio

> Ajustá los nombres a los de tu repositorio.

```
RetailPro/
├── README.md
├── sql/
│   ├── 01_crear_y_cargar_Ventas_Tech_DB.sql
│   └── 02_consultas.sql
└── powerbi/
    └── RetailPro.pbix
```

## Cómo ejecutar los scripts SQL

1. Abrí SQL Server Management Studio y conectate a tu instancia de SQL Server.
2. Creá la base de datos y seleccionala (el script no incluye `CREATE DATABASE`):
   ```sql
   CREATE DATABASE Ventas_Tech_DB;
   GO
   USE Ventas_Tech_DB;
   GO
   ```
3. Abrí el script de creación y carga y ejecutalo completo con **F5**. Hace cuatro cosas, en este orden:
   1. **DROP TABLE:** elimina las tablas existentes en orden inverso a sus dependencias (`DROP TABLE IF EXISTS` requiere SQL Server 2016 o superior).
   2. **CREATE TABLE:** crea `categorias`, `clientes`, `productos` y `ventas`.
   3. **INSERT:** carga los datos de ejemplo.
   4. **Validación:** corre un `SELECT *` por tabla. Deberías ver 4, 5, 6 y 10 filas.
4. Abrí el script de consultas y ejecutá cada una por separado (seleccioná el bloque y presioná **F5**).

Como el script empieza borrando las tablas, se puede volver a ejecutar para reiniciar la base.

## Consultas incluidas

1. **Resumen ejecutivo mensual:** total facturado, cantidad de pedidos y ticket promedio por mes.
2. **Ranking de productos:** top 5 de `id_producto` por total facturado, con unidades vendidas.
3. **Consulta para Power BI:** `INNER JOIN` de `ventas` con `clientes`, `productos` y `categorias`.
4. **Clientes y productos sin ventas:** `LEFT JOIN` consolidado con `UNION ALL`.

> En PostgreSQL, `MONTH(fecha_venta)` se reemplaza por `EXTRACT(MONTH FROM fecha_venta)` y `TOP 5` por `LIMIT 5`.

## Resultados con los datos de ejemplo

Las 10 ventas son de marzo de 2024, por eso el resumen mensual devuelve una sola fila.

| Mes | Total facturado | Pedidos | Ticket promedio |
|---|---|---|---|
| 3 | 6.444,00 | 10 | 644,40 |

Top 5 de productos por facturación:

| id_producto | Unidades vendidas | Total generado |
|---|---|---|
| 1 | 3 | 3.600,00 |
| 3 | 3 | 1.350,00 |
| 5 | 3 | 390,00 |
| 6 | 4 | 380,00 |
| 2 | 13 | 364,00 |

Con estos datos, todos los clientes y todos los productos tienen al menos una venta, así que la consulta de clientes y productos sin ventas no devuelve filas. Es lo esperado.

## Cómo conectar Power BI

1. En Power BI Desktop, elegí **Obtener datos > SQL Server**.
2. Ingresá el servidor y la base `Ventas_Tech_DB`.
3. Cargá la consulta con `INNER JOIN` como fuente principal o las tablas por separado.
4. Creá `Dim_Fechas` con DAX y definí las relaciones del modelo.

## LUISA TORRES

Proyecto realizado como práctica del curso de SQL con Power BI.
