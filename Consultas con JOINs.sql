-- =====================================================
-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Consigna: combinar con INNER JOIN la tabla de ventas con las tablas
-- descriptivas (clientes, productos, categorías) para obtener en una
-- sola fila: fecha, identificación del cliente, descripción del
-- producto, cantidad, precio unitario y total de venta, más las
-- columnas descriptivas del esquema (ciudad, categoría).
-- HALLAZGO: la vista devuelve 10 filas que son ventas del mes de marzo del 5 al 15
 --  =====================================================
SELECT
    v.id_venta,
    v.fecha_venta                       AS fecha,
    c.id_cliente,
    c.nombre                            AS cliente,
    c.ciudad,
    p.nombre_producto                   AS producto,
    cat.nombre_categoria                AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario      AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Hallazgo: la vista no muestra nada, es decir que todos los clientes compraron alguna vez. No tenemos clientes inactivos.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Hallazgo: Todos nuestro productos tienen rotacion; se vendio por lo menos alguna vez. arroja 0 resultado.

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;


SELECT COUNT(*) AS productos_sin_ventas
FROM productos
WHERE id_producto NOT IN (SELECT id_producto FROM ventas);

-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Hallazgo: La vista nos dice que las ventas total por canal del primer trimestre es de 6444,00.
-- aun no tenemos ventas para el segundo trimestre.

SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Primer semestre' AS canal
    FROM ventas
    WHERE MONTH(fecha_venta) <= 6

    UNION ALL

    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Segundo semestre' AS canal
    FROM ventas
    WHERE MONTH(fecha_venta) > 6
) AS consolidado
GROUP BY canal;

SELECT SUM(cantidad * precio_unitario) AS total_general
FROM ventas;

