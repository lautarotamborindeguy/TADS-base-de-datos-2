-- EJERCICIO 1
-- Vista con información de los pedidos

CREATE VIEW vw_info_pedidos AS
SELECT
    p.num_ped,
    p.prazo_entr,
    c.nome_cli,
    v.nome_vend
FROM pedido p
INNER JOIN cliente c ON p.cd_cli = c.cod_cli
INNER JOIN vendedor v ON p.cd_vend = v.cod_vend;


-- EJERCICIO 2
-- Función para calcular el valor total de un artículo

CREATE FUNCTION fn_calcular_total_item(
    quantidade NUMERIC,
    valor_unitario NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN quantidade * valor_unitario;
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 3
-- Vista con la facturación total por estado

CREATE VIEW vw_faturamento_por_estado AS
SELECT
    c.uf,
    SUM(ip.qtd_ped * pr.val_unit) AS faturamento_total
FROM cliente c
INNER JOIN pedido p ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip ON p.num_ped = ip.no_ped
INNER JOIN produto pr ON ip.cd_prod = pr.cod_prod
GROUP BY c.uf;


-- EJERCICIO 4
-- Función para clasificar el plazo de entrega

CREATE FUNCTION fn_classificar_prazo(
    prazo INTEGER
)
RETURNS VARCHAR AS $$
BEGIN
    IF prazo <= 15 THEN
        RETURN 'Entrega Expressa';
    ELSE
        RETURN 'Entrega Padrão';
    END IF;
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 5
-- Consulta utilizando la vista de pedidos y la función de clasificación

SELECT
    num_ped,
    nome_cli,
    fn_classificar_prazo(prazo_entr) AS classificacao
FROM vw_info_pedidos;


-- EJERCICIO 6
-- Función para calcular una comisión del 5%

CREATE FUNCTION fn_calcular_comissao(
    valor_total NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN valor_total * 0.05;
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 7
-- Vista con el desempeño de los vendedores y sus supervisores

CREATE VIEW vw_desempenho_vendedores AS
SELECT
    v.nome_vend,
    COALESCE(s.nome_vend, 'Sem Supervisor') AS supervisor,
    COALESCE(SUM(ip.qtd_ped * pr.val_unit), 0) AS total_vendido
FROM vendedor v
LEFT JOIN vendedor s ON v.cd_supervisor = s.cod_vend
LEFT JOIN pedido p ON v.cod_vend = p.cd_vend
LEFT JOIN item_pedido ip ON p.num_ped = ip.no_ped
LEFT JOIN produto pr ON ip.cd_prod = pr.cod_prod
GROUP BY v.cod_vend, v.nome_vend, s.nome_vend;


-- EJERCICIO 8
-- Consulta de comisiones de los vendedores, ordenadas de mayor a menor

SELECT
    nome_vend,
    total_vendido,
    fn_calcular_comissao(total_vendido) AS comissao
FROM vw_desempenho_vendedores
ORDER BY comissao DESC;


-- EJERCICIO 9
-- Vista con los productos que nunca fueron vendidos

CREATE VIEW vw_produtos_sem_giro AS
SELECT
    p.cod_prod,
    p.desc_prod,
    p.val_unit
FROM produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM item_pedido ip
    WHERE ip.cd_prod = p.cod_prod
);


-- EJERCICIO 10
-- Pedidos cuyo valor total supera el salario promedio de los vendedores

SELECT
    c.nome_cli,
    p.num_ped,
    SUM(fn_calcular_total_item(ip.qtd_ped, pr.val_unit)) AS total_pedido
FROM cliente c
INNER JOIN pedido p ON c.cod_cli = p.cd_cli
INNER JOIN item_pedido ip ON p.num_ped = ip.no_ped
INNER JOIN produto pr ON ip.cd_prod = pr.cod_prod
GROUP BY c.nome_cli, p.num_ped
HAVING SUM(fn_calcular_total_item(ip.qtd_ped, pr.val_unit)) > (
    SELECT AVG(sal_fixo)
    FROM vendedor
);
