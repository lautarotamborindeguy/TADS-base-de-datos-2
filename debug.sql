/* Ejercicio 1 */
SELECT
    c.nome_cli,
    p.num_ped
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
    AND p.prazo_entr > 10
ORDER BY c.cod_cli, p.num_ped;


/* Ejercicio 2 */
SELECT
    c.nome_cli,
    COUNT(p.num_ped) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
GROUP BY
    c.cod_cli,
    c.nome_cli
ORDER BY c.cod_cli;


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
    c.nome_cli,
    c.uf,
    MAX(p.prazo_entr) AS maior_prazo
FROM cliente c
LEFT JOIN pedido p
    ON c.cod_cli = p.cd_cli
GROUP BY
    c.cod_cli,
    c.nome_cli,
    c.uf
ORDER BY c.cod_cli;
