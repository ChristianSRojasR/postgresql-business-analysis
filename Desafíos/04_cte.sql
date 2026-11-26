-- =========================================
-- DESAFÍO 04 — CTE (COMMON TABLE EXPRESSIONS)
-- =========================================



/* El gerente de planificación necesita un reporte mensual de ventas que permita 
comparar el desempeño comercial entre meses y detectar tendencias.

Aprenderás a utilizar:
- WITH
- Múltiples CTE.
- DATE_TRUNC().
- Agregaciones temporales.
- Comparaciones entre períodos.

Objetivo: construir un reporte que incluya:
1. Fecha (mes).
2. Venta total del mes.
3. Venta del mes anterior.
4. Diferencia absoluta respecto al mes anterior.
5. Variación porcentual respecto al mes anterior.
*/

WITH ventas_mensuales AS (
	SELECT
		DATE_TRUNC ('month',order_date)::DATE AS fecha,
		SUM(oi.quantity * oi.unit_price) AS venta_total
	FROM orders o
	JOIN order_items oi
		ON (o.order_id = oi.order_id)
	WHERE o.status = 'Entregado'
	GROUP BY fecha)
SELECT fecha,
	venta_total,
	LAG (venta_total) OVER (ORDER BY fecha asc) AS venta_mes_ant,
	venta_total-LAG (venta_total) OVER (ORDER BY fecha asc) AS dif_abs,
	ROUND(
	(venta_total-LAG (venta_total) OVER (ORDER BY fecha asc))*100
	/NULLIF(LAG (venta_total) OVER (ORDER BY fecha asc),0),2) AS Var_porcentual
FROM ventas_mensuales
ORDER BY fecha ASC;