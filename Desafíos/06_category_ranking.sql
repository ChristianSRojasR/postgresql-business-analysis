-- =========================================
-- DESAFÍO 06 — RANKING DE PRODUCTOS POR CATEGORÍA
-- =========================================

/*
 Contexto de negocio: el área comercial quiere identificar los productos 
 más relevantes dentro de cada categoría. No basta con saber cuáles venden 
 más en términos generales; necesita conocer cuáles lideran dentro de su propia categoría.

Tu objetivo es construir una consulta SQL que entregue:
1. Nombre del producto.
2. Categoría.
3. Unidades vendidas.
4. Facturación total.
5. Participación porcentual del producto dentro de su categoría.
6. Ranking del producto dentro de su categoría.
 */


WITH ventas_productos AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS unidades_vendidas,
        SUM(oi.quantity * oi.unit_price) AS venta_producto
    FROM order_items oi
    INNER JOIN orders o
        ON oi.order_id = o.order_id
    INNER JOIN products p
        ON p.product_id = oi.product_id
    WHERE o.status = 'Entregado'
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
)
SELECT
    product_id,
    product_name,
    category,
    unidades_vendidas,
    venta_producto,
    ROUND(
        venta_producto * 100.0 / SUM(venta_producto) OVER (PARTITION BY category),
        2
    ) AS participacion_porcentual,
    RANK() OVER (PARTITION BY category ORDER BY venta_producto DESC) AS ranking
FROM ventas_productos
ORDER BY category desc, ranking asc;

