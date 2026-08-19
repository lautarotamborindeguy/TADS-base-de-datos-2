-- 1. Quantidade de clientes cadastrados por estado (UF)
SELECT
    uf,
    COUNT(*) AS quantidade_clientes
FROM Cliente
GROUP BY uf;


-- 2. Média salarial dos vendedores por faixa de comissão
SELECT
    faixa_comiss,
    AVG(sal_fixo) AS media_salarial
FROM Vendedor
GROUP BY faixa_comiss;


-- 3. Maior e menor salário fixo para cada faixa de comissão
SELECT
    faixa_comiss,
    MAX(sal_fixo) AS maior_salario,
    MIN(sal_fixo) AS menor_salario
FROM Vendedor
GROUP BY faixa_comiss;


-- 4. Quantidade de pedidos por vendedor, do que mais vendeu ao que menos vendeu
SELECT
    cd_vend AS codigo_vendedor,
    COUNT(*) AS quantidade_pedidos
FROM Pedido
GROUP BY cd_vend
ORDER BY quantidade_pedidos DESC;


-- 5. Valor médio dos produtos por unidade, da unidade mais cara para a mais barata
SELECT
    unid_prod,
    AVG(val_unit) AS valor_medio
FROM Produto
GROUP BY unid_prod
ORDER BY valor_medio DESC;


-- 6. Quantidade de clientes por cidade, considerando somente o estado do RJ
SELECT
    cidade,
    COUNT(*) AS quantidade_clientes
FROM Cliente
WHERE uf = 'RJ'
GROUP BY cidade;


-- 7. Estados que possuem mais de dois clientes cadastrados
SELECT
    uf,
    COUNT(*) AS quantidade_clientes
FROM Cliente
GROUP BY uf
HAVING COUNT(*) > 2;


-- 8. Clientes que realizaram dois ou mais pedidos
SELECT
    cd_cli AS codigo_cliente,
    COUNT(*) AS quantidade_pedidos
FROM Pedido
GROUP BY cd_cli
HAVING COUNT(*) >= 2;


-- 9. Produtos cuja quantidade total pedida é superior a 1000 unidades
SELECT
    cd_prod AS codigo_produto,
    SUM(qtd_ped) AS quantidade_total
FROM Item_Pedido
GROUP BY cd_prod
HAVING SUM(qtd_ped) > 1000;


-- 10. Faixas de comissão cuja folha salarial total é superior a R$ 2.000,00
SELECT
    faixa_comiss,
    SUM(sal_fixo) AS total_folha_salarial
FROM Vendedor
GROUP BY faixa_comiss
HAVING SUM(sal_fixo) > 2000;


-- 11. Soma das quantidades por pedido, exibindo somente totais superiores a 800
SELECT
    no_ped AS codigo_pedido,
    SUM(qtd_ped) AS quantidade_total
FROM Item_Pedido
GROUP BY no_ped
HAVING SUM(qtd_ped) > 800;


-- 12. Pedidos que possuem mais de dois produtos diferentes registrados
SELECT
    no_ped AS codigo_pedido,
    COUNT(DISTINCT cd_prod) AS quantidade_itens_diferentes
FROM Item_Pedido
GROUP BY no_ped
HAVING COUNT(DISTINCT cd_prod) > 2;