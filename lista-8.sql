/* Ejercicio 1 */
SELECT
    c.nome_cli,
    (
        SELECT COUNT(*)
        FROM pedido p
        WHERE p.cd_cli = c.cod_cli
    ) AS qtd_pedidos
FROM cliente c
ORDER BY c.cod_cli;


/* Ejercicio 2 */
SELECT
    desc_prod,
    val_unit
FROM produto
WHERE val_unit > (
    SELECT AVG(val_unit)
    FROM produto
)
ORDER BY val_unit;


/* Ejercicio 3 */
SELECT
    nome_vend
FROM vendedor
WHERE cod_vend IN (
    SELECT cd_vend
    FROM pedido
    WHERE prazo_entr > 15
)
ORDER BY cod_vend;


/* Ejercicio 4 */
SELECT
    faixa_comiss,
    qtd_vendedores
FROM (
    SELECT
        faixa_comiss,
        COUNT(*) AS qtd_vendedores
    FROM vendedor
    GROUP BY faixa_comiss
) AS resumo
WHERE qtd_vendedores > 3;


/* Ejercicio 5 */
SELECT
    c.nome_cli
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cd_cli = c.cod_cli
)
ORDER BY c.cod_cli;


/* Ejercicio 6 */
SELECT
    pr.desc_prod
FROM produto pr
WHERE NOT EXISTS (
    SELECT 1
    FROM item_pedido ip
    WHERE ip.cd_prod = pr.cod_prod
)
ORDER BY pr.cod_prod;


/* Ejercicio 7 */
SELECT
    nome_vend,
    sal_fixo
FROM vendedor
WHERE sal_fixo < ANY (
    SELECT sal_fixo
    FROM vendedor
    WHERE faixa_comiss = 'a'
)
ORDER BY sal_fixo;


/* Ejercicio 8 */
SELECT
    desc_prod,
    val_unit
FROM produto
WHERE val_unit > ALL (
    SELECT val_unit
    FROM produto
    WHERE unid_prod = 'CX'
)
ORDER BY val_unit;
