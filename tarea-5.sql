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

/* Ejercicio 4 */
SELECT no_ped
FROM item_pedido
GROUP BY no_ped
HAVING COUNT(DISTINCT cd_prod) > 2

EXCEPT

SELECT no_ped
FROM item_pedido
GROUP BY no_ped
HAVING SUM(qtd_ped) > 1000;

/* Ejercicio 5 */
SELECT cd_vend
FROM pedido
GROUP BY cd_vend
HAVING AVG(prazo_entr) > 10

INTERSECT

SELECT cd_vend
FROM pedido
GROUP BY cd_vend
HAVING COUNT(*) > 1;

/* Ejercicio 6 */
SELECT cidade, uf
FROM cliente

EXCEPT

SELECT cidade, uf
FROM cliente
WHERE cod_cli IN (1,2,3)

ORDER BY cidade;

/* Ejercicio 7 */
SELECT cd_cli
FROM pedido
WHERE prazo_entr < 15

INTERSECT

SELECT cd_cli
FROM pedido
GROUP BY cd_cli
HAVING COUNT(*) >= 2;

/* Ejercicio 8 */
SELECT cod_prod
FROM produto
WHERE val_unit > 2

EXCEPT

SELECT cd_prod
FROM item_pedido;

/* Ejercicio 9 */
SELECT cod_cli
FROM cliente
WHERE uf IN ('RJ', 'SP')

INTERSECT

SELECT cd_cli
FROM pedido

ORDER BY cod_cli
LIMIT 3;

/* Ejercicio 10 */
SELECT cod_vend
FROM vendedor
WHERE faixa_comiss = 'a'

UNION

SELECT cod_vend
FROM vendedor
WHERE faixa_comiss = 'b'

EXCEPT

SELECT cd_vend
FROM pedido
WHERE prazo_entr = 30

ORDER BY cod_vend;
