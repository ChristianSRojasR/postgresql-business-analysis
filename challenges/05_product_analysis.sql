-- =========================================
-- DESAFÍO 05 — RANKING DE PRODUCTOS Y PARTICIPACIÓN EN VENTAS
-- =========================================



/*
 El área comercial quiere identificar qué productos generan mayor facturación y
  qué porcentaje representan sobre las ventas totales.

Debes construir una consulta que entregue:
1. Nombre del producto.
2. Categoría.
3. Unidades vendidas.
4. Venta total por producto.
5. Porcentaje de participación sobre la venta total.
6. Ranking de productos según facturación.
Condiciones:
- Considerar únicamente pedidos entregados.
- Utilizar al menos una CTE.
- Utilizar RANK() o DENSE_RANK().
- Utilizar una función de ventana para calcular la participación porcentual.
- Ordenar de mayor a menor facturación.
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
        venta_producto * 100.0 / SUM(venta_producto) OVER (),
        2
    ) AS participacion_porcentual,
    RANK() OVER (ORDER BY venta_producto DESC) AS ranking
FROM ventas_productos
ORDER BY venta_producto DESC;