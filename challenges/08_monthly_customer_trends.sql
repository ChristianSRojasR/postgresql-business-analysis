-- =========================================
-- DESAFÍO 08 — EVOLUCIÓN DE VENTAS Y DETECCIÓN DE CLIENTES EN RIESGO
-- =========================================


/*
Contexto de negocio
El área comercial quiere identificar clientes cuyas compras están disminuyendo. Para ello, necesita 
comparar las ventas de cada cliente entre meses consecutivos y detectar posibles señales de pérdida de 
actividad comercial.
Objetivo
Construir una consulta que entregue:
1. ID del cliente.
2. Nombre del cliente.
3. Mes de venta.
4. Venta mensual del cliente.
5. Venta del mes anterior.
6. Diferencia absoluta entre ambos meses.
7. Variación porcentual respecto del mes anterior.
8. Clasificación del comportamiento: Aumentó, Disminuyó, Sin variación o Primera compra.
 */

WITH ventas_mes AS
		(SELECT
			c.customer_id,
			c.customer_name,
			DATE_TRUNC('month',o.order_date)::DATE AS fecha,
			SUM(oi.quantity * oi.unit_price) AS venta
		FROM customers c
		INNER JOIN orders o 
			ON o.customer_id = c.customer_id
		INNER JOIN order_items oi
			ON oi.order_id = o.order_id
		WHERE o.status = 'Entregado'
		GROUP BY 
			c.customer_id,
			c.customer_name,
			fecha
),
comparacion AS(
    SELECT
        customer_id,
        customer_name,
        fecha,
        venta,
        LAG(venta) OVER (
            PARTITION BY customer_id
            ORDER BY fecha
        ) AS venta_mes_ant
    FROM ventas_mes
)
SELECT 
	customer_id,
	customer_name,
	fecha,
	venta,
	venta_mes_ant,
	venta - venta_mes_ant AS dif,
	ROUND(
	(venta - venta_mes_ant)*100
	/ NULLIF(venta_mes_ant,0),
	2) AS var_porcentual,
	(CASE
		WHEN venta_mes_ant IS NULL THEN 'Primera compra'
		WHEN venta>venta_mes_ant THEN 'Aumentó'
		WHEN venta<venta_mes_ant THEN 'Disminuyó'
		ELSE 'Sin variación'
	END)
FROM comparacion
ORDER BY customer_id, fecha;