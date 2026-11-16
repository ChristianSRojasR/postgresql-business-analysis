/*
=========================================
DESAFÍO 02 — ANÁLISIS COMERCIAL MEDIANTE JOIN
=========================================
Contexto empresarial

El gerente comercial necesita conocer cuánto está vendiendo cada cliente y cuál 
es su participación dentro de las ventas totales de la compañía.

Debes construir un reporte que contenga:
1. ID del cliente.
2. Nombre del cliente.
3. Región.
4. Cantidad total de pedidos realizados.
5. Cantidad total de unidades compradas.
6. Venta total acumulada por cliente.
Nuevas condiciones:
- Considerar solamente pedidos con estado Entregado.
- Excluir pedidos cancelados y pendientes.
- Mostrar clientes cuya venta acumulada sea superior a $30.000.
- Ordenar por venta total descendente.
- No duplicar clientes en el resultado.


*/
SELECT
	c.customer_id,
	c.customer_name,
	c.region,
	COUNT(DISTINCT oi.order_id) AS total_pedidos,
	SUM(oi.quantity) AS total_unidades,
	SUM(oi.quantity * oi.unit_price) AS venta_total
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
HAVING SUM(oi.quantity * oi.unit_price) >30000
ORDER BY venta_total desc;