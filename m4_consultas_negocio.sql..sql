-- Consulta 1: Resumen ejecutivo mensual
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)

    -- Consulta 2: Ranking de productos (Top 5)
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM 
    ventas
GROUP BY 
    id_producto
ORDER BY 
    total_generado DESC;
ORDER BY 
    mes ASC;

    -- Consulta 3: Clientes recurrentes
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1
ORDER BY 
    cantidad_pedidos DESC;

    -- Consulta 4: Meses por encima/por debajo del promedio general
WITH FacturacionMensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM 
        ventas
    GROUP BY 
        MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM FacturacionMensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM 
    FacturacionMensual
ORDER BY 
    mes ASC;


