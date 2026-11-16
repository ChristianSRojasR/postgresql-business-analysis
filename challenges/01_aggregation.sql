/* 
=========================================
DESAFÍO 01 — IDENTIFICAR PEDIDOS DE ALTO VOLUMEN
=========================================

Contexto empresarial

Eres analista de datos de Distribuidora Andina. El área comercial necesita identificar los pedidos 
que representan un mayor volumen de venta para analizar el comportamiento de sus clientes.

El gerente solicita un reporte que contenga:
1. Identificador del pedido (order_id).
2. Cantidad total de unidades vendidas por pedido.
3. Valor total de venta por pedido.
4. Mostrar únicamente pedidos que tengan más de 20 unidades.
5. Ordenar los resultados desde el pedido con mayor valor de venta hasta el menor.*/

SELECT
	order_id,
	SUM(quantity) AS total_unidades,
	SUM(quantity * unit_price) AS venta_total
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) > 20
ORDER BY venta_total DESC;