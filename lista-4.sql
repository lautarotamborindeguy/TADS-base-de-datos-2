-- 1. Três vendedores com os maiores salários
SELECT nome_vend, sal_fixo
FROM Vendedor
ORDER BY sal_fixo DESC
LIMIT 3;


-- 2. Cinco produtos mais baratos
SELECT desc_prod, val_unit
FROM Produto
ORDER BY val_unit ASC
LIMIT 5;


-- 3. Quatro primeiros clientes cadastrados, ordenados pelo código
SELECT cod_cli, nome_cli
FROM Cliente
ORDER BY cod_cli ASC
LIMIT 4;


-- 4. Três pedidos com o menor prazo de entrega
SELECT num_ped, prazo_entr
FROM Pedido
ORDER BY CAST(prazo_entr AS UNSIGNED) ASC
LIMIT 3;


-- 5. Vendedor que possui o menor salário
SELECT nome_vend, sal_fixo
FROM Vendedor
ORDER BY sal_fixo ASC
LIMIT 1;


-- 6. Nomes dos clientes unidos aos nomes dos vendedores
SELECT nome_cli AS nome_pessoa
FROM Cliente

UNION

SELECT nome_vend AS nome_pessoa
FROM Vendedor;


-- 7. Clientes com pedidos cujo prazo é maior que 15 dias
--    unidos aos clientes do estado de SP
SELECT cd_cli AS codigo_cliente
FROM Pedido
WHERE CAST(prazo_entr AS UNSIGNED) > 15

UNION

SELECT cod_cli AS codigo_cliente
FROM Cliente
WHERE uf = 'SP';


-- 8. Mesma consulta, preservando códigos repetidos
SELECT cd_cli AS codigo_cliente
FROM Pedido
WHERE CAST(prazo_entr AS UNSIGNED) > 15

UNION ALL

SELECT cod_cli AS codigo_cliente
FROM Cliente
WHERE uf = 'SP';


-- 9. Valores dos produtos unidos aos salários dos vendedores
SELECT val_unit AS valores_financeiros
FROM Produto

UNION

SELECT sal_fixo AS valores_financeiros
FROM Vendedor;


-- 10. Clientes do RJ unidos aos clientes de SP,
--     ordenados alfabeticamente pelo nome
SELECT nome_cli AS nome, uf
FROM Cliente
WHERE uf = 'RJ'

UNION

SELECT nome_cli AS nome, uf
FROM Cliente
WHERE uf = 'SP'

ORDER BY nome ASC;