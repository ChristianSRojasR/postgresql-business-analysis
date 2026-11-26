-- =========================================
-- DESAFÍO 07 — ANÁLISIS DE CLIENTES Y CONCENTRACIÓN DE VENTAS
-- =========================================

/*
Contexto: la gerencia comercial quiere identificar qué clientes concentran la
facturación de la empresa y evaluar la dependencia comercial respecto de los principales compradores.

Construye una consulta que entregue:
1. ID del cliente.
2. Nombre del cliente.
3. Región.
4. Venta total del cliente.
5. Participación porcentual sobre las ventas totales.
6. Ranking de clientes según facturación.
7. Participación acumulada de ventas según el ranking.
 */

WITH ventas AS(
	SELECT
		c.customer_id,
		c.customer_name,
		c.region,
		SUM(oi.quantity*oi.unit_price) AS venta
	FROM orders o
	INNER JOIN order_items oi
		ON (o.order_id = oi.order_id)
	INNER JOIN customers c
		ON(o.customer_id = c.customer_id)
	WHERE o.status = 'Entregado'
	GROUP BY
		c.customer_id,
		c.customer_name,
		c.region
)
SELECT
	customer_id,
	customer_name,
	region,
	venta,
	ROUND(venta*100/SUM(venta) OVER (),2) AS porc_total,
	RANK() OVER (ORDER BY venta desc) AS ranking,
	ROUND(SUM (venta) OVER 
		(ORDER BY venta DESC --Puedes usar más de 1 orden si se repiten casos
		ROWS BETWEEN --definir qué filas participan en el cálculo.
		UNBOUNDED PRECEDING --comenzar desde la primera fila de la ventana.
		AND CURRENT ROW --terminar en la fila actual.
		) * 100 / SUM(venta) OVER(),2) AS suma_acum
FROM ventas;