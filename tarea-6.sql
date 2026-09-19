/* Ejercicio 1 */
SELECT
    c.nome_cli,
    p.prazo_entr,
    v.nome_vend
FROM pedido p
INNER JOIN cliente c
    ON p.cd_cli = c.cod_cli
INNER JOIN vendedor v
    ON p.cd_vend = v.cod_vend;


/* Ejercicio 2 */
SELECT 
    c.nome_cli,
    p.num_ped
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli;


/* Ejercicio 3 */
SELECT 
    c.nome_cli
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
WHERE p.num_ped IS NULL;


/* Ejercicio 4 */
SELECT 
    v.nome_vend,
    COUNT(p.num_ped) AS quantidade_pedidos
FROM vendedor v
LEFT JOIN pedido p
    ON v.cod_vend = p.cd_vend
GROUP BY v.cod_vend, v.nome_vend
ORDER BY v.cod_vend;


/* Ejercicio 5 */
SELECT 
    c.nome_cli,
    COUNT(p.num_ped) AS quantidade_pedidos
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
GROUP BY c.cod_cli, c.nome_cli
ORDER BY c.cod_cli;


/* Ejercicio 6 */
SELECT 
    c.nome_cli,
    SUM(ip.qtd_ped) AS total_itens
FROM cliente c
INNER JOIN pedido p
    ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
GROUP BY c.cod_cli, c.nome_cli
ORDER BY c.cod_cli;


/* Ejercicio 7 */
SELECT DISTINCT
    c.nome_cli
FROM cliente c
INNER JOIN pedido p
    ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
INNER JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
WHERE pr.desc_prod = 'Piso Cerâmico';


/* Ejercicio 8 */
SELECT 
    pr.desc_prod,
    COALESCE(SUM(ip.qtd_ped), 0) AS quantidade_vendida
FROM produto pr
LEFT JOIN item_pedido ip
    ON pr.cod_prod = ip.cd_prod
GROUP BY pr.cod_prod, pr.desc_prod
ORDER BY pr.cod_prod;


/* Ejercicio 9 */
SELECT 
    c.nome_cli,
    p.num_ped
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
WHERE c.uf = 'SP'
ORDER BY c.cod_cli, p.num_ped;


/* Ejercicio 10 */
SELECT 
    p.num_ped,
    c.nome_cli,
    v.nome_vend,
    pr.desc_prod
FROM pedido p
INNER JOIN cliente c
    ON p.cd_cli = c.cod_cli
INNER JOIN vendedor v
    ON p.cd_vend = v.cod_vend
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
INNER JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
ORDER BY p.num_ped;


/* Ejercicio 11 */
SELECT 
    v.nome_vend,
    COUNT(p.num_ped) AS quantidade_pedidos
FROM vendedor v
INNER JOIN pedido p
    ON v.cod_vend = p.cd_vend
GROUP BY v.cod_vend, v.nome_vend
ORDER BY quantidade_pedidos DESC
LIMIT 1;
