/* Ejercicio 1 */
SELECT
    pr.desc_prod,
    ip.no_ped
FROM item_pedido ip
RIGHT JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
ORDER BY pr.cod_prod;


/* Ejercicio 2 */
SELECT
    c.nome_cli,
    p.num_ped
FROM cliente c
FULL OUTER JOIN pedido p
    ON c.cod_cli = p.cd_cli
ORDER BY c.cod_cli, p.num_ped;


/* Ejercicio 3 */
SELECT
    v.nome_vend AS vendedor,
    s.nome_vend AS supervisor
FROM vendedor v
LEFT JOIN vendedor s
    ON v.cd_supervisor = s.cod_vend
ORDER BY v.cod_vend;


/* Ejercicio 4 */
SELECT
    p.num_ped,
    c.nome_cli,
    v.nome_vend,
    SUM(ip.qtd_ped * pr.val_unit) AS valor_total
FROM pedido p
INNER JOIN cliente c
    ON p.cd_cli = c.cod_cli
INNER JOIN vendedor v
    ON p.cd_vend = v.cod_vend
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
INNER JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
GROUP BY
    p.num_ped,
    c.nome_cli,
    v.nome_vend
ORDER BY p.num_ped;


/* Ejercicio 5 */
SELECT
    s.nome_vend AS supervisor,
    COUNT(v.cod_vend) AS quantidade_vendedores
FROM vendedor s
INNER JOIN vendedor v
    ON s.cod_vend = v.cd_supervisor
GROUP BY
    s.cod_vend,
    s.nome_vend
HAVING COUNT(v.cod_vend) >= 2;


/* Ejercicio 6 */
SELECT
    c.nome_cli,
    pr.desc_prod,
    SUM(ip.qtd_ped) AS quantidade_total
FROM cliente c
INNER JOIN pedido p
    ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
INNER JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
WHERE
    c.uf = 'SP'
    AND pr.unid_prod = 'KG'
GROUP BY
    c.cod_cli,
    c.nome_cli,
    pr.cod_prod,
    pr.desc_prod
ORDER BY c.nome_cli, pr.desc_prod;


/* Ejercicio 7 */
SELECT
    v.nome_vend,
    COUNT(p.num_ped) AS quantidade_pedidos
FROM pedido p
RIGHT JOIN vendedor v
    ON p.cd_vend = v.cod_vend
GROUP BY
    v.cod_vend,
    v.nome_vend
ORDER BY v.cod_vend;


/* Ejercicio 8 */
SELECT
    c.nome_cli,
    COALESCE(
        CAST(p.num_ped AS VARCHAR),
        'Sem Pedido'
    ) AS pedido
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
ORDER BY c.cod_cli;


/* Ejercicio 9 */
SELECT
    AVG(sal_fixo) AS media_salario
FROM vendedor;

SELECT
    c.nome_cli,
    SUM(ip.qtd_ped * pr.val_unit) AS valor_total_gasto
FROM cliente c
INNER JOIN pedido p
    ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
INNER JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
GROUP BY
    c.cod_cli,
    c.nome_cli
HAVING SUM(ip.qtd_ped * pr.val_unit) > 2144.11
ORDER BY valor_total_gasto DESC;


/* Ejercicio 10 */
SELECT
    p.num_ped,
    c.nome_cli,
    v.nome_vend AS vendedor,
    s.nome_vend AS supervisor,
    SUM(ip.qtd_ped * pr.val_unit) AS valor_total
FROM pedido p
LEFT JOIN cliente c
    ON p.cd_cli = c.cod_cli
LEFT JOIN vendedor v
    ON p.cd_vend = v.cod_vend
LEFT JOIN vendedor s
    ON v.cd_supervisor = s.cod_vend
LEFT JOIN item_pedido ip
    ON p.num_ped = ip.no_ped
LEFT JOIN produto pr
    ON ip.cd_prod = pr.cod_prod
GROUP BY
    p.num_ped,
    c.nome_cli,
    v.nome_vend,
    s.nome_vend
ORDER BY valor_total DESC;
