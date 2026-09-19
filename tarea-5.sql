/* Ejercicio 1 */
SELECT cd_cli
FROM pedido
GROUP BY cd_cli
HAVING COUNT(*) > 1

INTERSECT

SELECT cod_cli
FROM cliente
WHERE uf = 'RJ';

/* Ejercicio 2 */
SELECT cod_vend
FROM vendedor
WHERE sal_fixo > 1500

EXCEPT

SELECT cd_vend
FROM pedido
GROUP BY cd_vend
HAVING COUNT(*) > 2;

/* Ejercicio 3 */
SELECT cd_prod
FROM item_pedido
WHERE qtd_ped >= 300

INTERSECT

SELECT cd_prod
FROM item_pedido
WHERE qtd_ped <= 500

ORDER BY cd_prod DESC
LIMIT 2;
