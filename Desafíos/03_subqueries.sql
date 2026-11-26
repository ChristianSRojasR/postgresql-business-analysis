-- =========================================
-- DESAFÍO 03 — ANÁLISIS DE COMPORTAMIENTO DE CLIENTES
-- =========================================


/*Contexto empresarial

El gerente comercial quiere identificar clientes que tienen un comportamiento de compra superior al promedio de la compañía.

Necesita encontrar clientes cuya venta total acumulada sea superior a la venta promedio por cliente.
Requerimientos
Construye una consulta que muestre:
1. ID del cliente.
2. Nombre del cliente.
3. Región.
4. Venta total acumulada.
5. Venta promedio por pedido.
6. Diferencia entre la venta total del cliente y la venta promedio por cliente de toda la compañía.
Condiciones
- Considerar únicamente pedidos Entregado.
- Excluir pedidos pendientes y cancelados.
- Agrupar las ventas por cliente.
- Mostrar solamente clientes cuya venta total sea superior al promedio de ventas totales por cliente.
- Ordenar de mayor a menor venta total.
 */

SELECT
	c.customer_id,
	c.customer_name,
	c.region,
	SUM(oi.quantity * oi.unit_price) AS venta_total,
	SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id)::NUMERIC
        AS promedio_venta_pedido,
    SUM(oi.quantity * oi.unit_price) - (
            SELECT AVG(venta_cliente)
            FROM (
                SELECT
                    o2.customer_id,
                    SUM(oi2.quantity * oi2.unit_price)
                        AS venta_cliente
                FROM orders o2
                INNER JOIN order_items oi2
                    ON o2.order_id = oi2.order_id
                WHERE o2.status = 'Entregado'
                GROUP BY o2.customer_id
            ) AS ventas_clientes
        ) AS diferencia_promedio
FROM order_items oi
INNER JOIN orders o
	ON (oi.order_id = o.order_id)
INNER JOIN customers c
	ON (o.customer_id = c.customer_id)
WHERE o.status = 'Entregado'
GROUP BY
	c.customer_id,
    c.customer_name,
    c.region
HAVING
    SUM(oi.quantity * oi.unit_price) >
    (
        SELECT AVG(venta_cliente)
        FROM (
            SELECT
                o2.customer_id,
                SUM(oi2.quantity * oi2.unit_price)
                    AS venta_cliente
            FROM orders o2
            INNER JOIN order_items oi2
                ON o2.order_id = oi2.order_id
            WHERE o2.status = 'Entregado'
            GROUP BY o2.customer_id
        ) AS ventas_clientes
    )
ORDER BY venta_total desc;