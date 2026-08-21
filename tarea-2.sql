-- Lista 2 - Creación, carga de datos y consultas
create database lista2;

use lista2;

CREATE TABLE Cliente (
    cod_cli INT PRIMARY KEY,
    nome_cli VARCHAR(45) NOT NULL,
    endereco VARCHAR(45),
    cidade VARCHAR(45) NOT NULL,
    cep VARCHAR(45),
    uf VARCHAR(45) NOT NULL
);

CREATE TABLE Vendedor (
    cod_vend INT PRIMARY KEY,
    nome_vend VARCHAR(45) NOT NULL,
    sal_fixo FLOAT NOT NULL,
    faixa_comiss VARCHAR(1) NOT NULL
);

CREATE TABLE Produto (
    cod_prod INT PRIMARY KEY,
    unid_prod CHAR(2) NOT NULL,
    desc_prod VARCHAR(45) NOT NULL,
    val_unit FLOAT NOT NULL
);

CREATE TABLE Pedido (
    num_ped INT PRIMARY KEY,
    prazo_ent VARCHAR(45) NOT NULL,
    cd_cli INT NOT NULL,
    cd_vend INT NOT NULL,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cd_cli) REFERENCES Cliente(cod_cli),
    CONSTRAINT fk_pedido_vendedor
        FOREIGN KEY (cd_vend) REFERENCES Vendedor(cod_vend)
);

CREATE TABLE Item_Pedido (
    no_ped INT NOT NULL,
    cd_prod INT NOT NULL,
    qtd_ped INT NOT NULL,
    PRIMARY KEY (no_ped, cd_prod),
    CONSTRAINT fk_item_pedido
        FOREIGN KEY (no_ped) REFERENCES Pedido(num_ped),
    CONSTRAINT fk_item_produto
        FOREIGN KEY (cd_prod) REFERENCES Produto(cod_prod)
);

INSERT INTO Cliente (cod_cli, nome_cli, endereco, cidade, cep, uf) VALUES
    (101,  'Joao da Silva',      'Rua das Flores, 10',   'Sao Paulo',      '01001-000', 'SP'),
    (205,  'Maria Oliveira',     'Av. Atlantica, 200',   'Rio de Janeiro', '22021-001', 'RJ'),
    (330,  'Ricardo Almeida',    'Rua Moreira, 15',      'Niterói',        '24020-125', 'RJ'),
    (415,  'Carla Souza',        'Rua Bahia, 80',        'Belo Horizonte', '30160-011', 'MG'),
    (1001, 'Renata Lima',        'Rua Augusta, 350',     'Sao Paulo',      '01305-000', 'SP'),
    (1002, 'Roberto Costa',      'Av. Amaral Peixoto, 7','Niterói',        '24020-070', 'RJ'),
    (1003, 'Rosa Martins',       'Rua das Laranjeiras',  'Rio de Janeiro', '22240-003', 'RJ'),
    (1004, 'Paulo Santos',       NULL,                   'Curitiba',       '80010-000', 'PR');

INSERT INTO Vendedor (cod_vend, nome_vend, sal_fixo, faixa_comiss) VALUES
    (1, 'Carlos Alberto', 1800.00, 'A'),
    (2, 'Bruno Souza',    2200.00, 'B'),
    (3, 'Amanda Lima',    1950.00, 'C'),
    (4, 'Ana Cristina',   2500.00, 'C'),
    (5, 'Marcos Paulo',   3100.00, 'A'),
    (6, 'Beatriz Ramos',  1600.00, 'B');

INSERT INTO Produto (cod_prod, unid_prod, desc_prod, val_unit) VALUES
    (1, 'KG', 'Areia',          0.50),
    (2, 'SC', 'Cimento',        2.75),
    (3, 'L',  'Tinta',          4.50),
    (4, 'UN', 'Chapa de Aco',  18.90),
    (5, 'M',  'Cabo Eletrico',  1.20),
    (6, 'L',  'Solvente',       7.80),
    (7, 'KG', 'Argamassa',      3.00),
    (8, 'UN', 'Parafuso',       0.10);

INSERT INTO Pedido (num_ped, prazo_ent, cd_cli, cd_vend) VALUES
    (100, '3',  101,  1),
    (101, '7',  205,  1),
    (102, '10', 330,  2),
    (103, '20', 1001, 4),
    (104, '18', 1002, 4),
    (105, '25', 1003, 5),
    (106, '5',  1004, 5),
    (107, '12', 415,  3),
    (108, '30', 205,  4),
    (109, '8',  1002, 1),
    (110, '16', 330,  4),
    (111, '4',  1001, 5);

INSERT INTO Item_Pedido (no_ped, cd_prod, qtd_ped) VALUES
    (100, 2, 500),
    (100, 5, 100),
    (101, 1, 500),
    (101, 3, 20),
    (102, 2, 300),
    (103, 4, 40),
    (103, 2, 700),
    (104, 4, 60),
    (104, 6, 15),
    (105, 4, 35),
    (106, 8, 500),
    (107, 7, 250),
    (108, 4, 80),
    (108, 2, 200),
    (109, 5, 500),
    (110, 4, 25),
    (110, 1, 900),
    (111, 3, 10);

-- 1. Nombres de los clientes, ciudades y estados donde están ubicados.
SELECT nome_cli, cidade, uf
FROM Cliente;

-- 2. Número del pedido, producto y cantidad de los artículos cuya cantidad es igual a 500.
SELECT no_ped, cd_prod, qtd_ped
FROM Item_Pedido
WHERE qtd_ped = 500;

-- 3. Clientes ubicados en Niterói.
SELECT *
FROM Cliente
WHERE cidade = 'Niterói';

-- 4. Nombres de los clientes que no pertenecen al estado de SP.
SELECT nome_cli
FROM Cliente
WHERE uf <> 'SP';

-- 5. Pedidos del vendedor 1 con un plazo superior a 5 días.
SELECT *
FROM Pedido
WHERE cd_vend = 1
  AND CAST(prazo_ent AS UNSIGNED) > 5;

-- 6. Clientes de RJ que no pertenecen a la ciudad de Río de Janeiro.
SELECT nome_cli
FROM Cliente
WHERE uf = 'RJ'
  AND cidade <> 'Rio de Janeiro';

-- 7. Descripción y valor de los productos vendidos por litro o con un valor diferente de 4,50.
SELECT desc_prod, val_unit
FROM Produto
WHERE unid_prod = 'L'
   OR val_unit <> 4.50;

-- 8. Pedidos de clientes con código mayor que 1000, realizados por los vendedores 4 o 5.
SELECT *
FROM Pedido
WHERE cd_cli > 1000
  AND cd_vend IN (4, 5);

-- 9. Productos con valor unitario entre R$ 0,10 y R$ 3,00 (inclusive).
SELECT cod_prod, desc_prod
FROM Produto
WHERE val_unit BETWEEN 0.10 AND 3.00;

-- 10. Productos cuya unidad comienza con K.
SELECT *
FROM Produto
WHERE unid_prod LIKE 'K%';

-- 11. Vendedores cuyos nombres no comienzan con A.
SELECT *
FROM Vendedor
WHERE nome_vend NOT LIKE 'A%';

-- 12. Clientes sin dirección registrada.
SELECT *
FROM Cliente
WHERE endereco IS NULL;

-- 13. Vendedores y salarios fijos en orden alfabético.
SELECT nome_vend, sal_fixo
FROM Vendedor
ORDER BY nome_vend ASC;

-- 14. Clientes de SP o RJ cuyo nombre comienza con R, ordenados por CEP descendente.
SELECT nome_cli, endereco
FROM Cliente
WHERE uf IN ('SP', 'RJ')
  AND nome_cli LIKE 'R%'
ORDER BY cep DESC;

-- 15. Nuevo salario de los vendedores de la categoría C: aumento del 75% más R$ 120,00.
SELECT
    cod_vend,
    nome_vend,
    sal_fixo AS salario_atual,
    ROUND(sal_fixo * 1.75 + 120.00, 2) AS novo_salario
FROM Vendedor
WHERE faixa_comiss = 'C';

-- 16. Menor y mayor salario entre los vendedores.
SELECT
    MIN(sal_fixo) AS menor_salario,
    MAX(sal_fixo) AS maior_salario
FROM Vendedor;

-- 17. Cantidad total solicitada del producto Cemento, código 2.
SELECT SUM(qtd_ped) AS quantidade_total_cimento
FROM Item_Pedido
WHERE cd_prod = 2;

-- 18. Total de la nómina salarial de los vendedores.
SELECT SUM(sal_fixo) AS total_folha_salarial
FROM Vendedor;

-- 19. Promedio de los salarios fijos de los vendedores.
SELECT AVG(sal_fixo) AS media_salarios
FROM Vendedor;

-- 20. Cantidad de vendedores con salario fijo superior a R$ 2.000,00.
SELECT COUNT(*) AS quantidade_vendedores
FROM Vendedor
WHERE sal_fixo > 2000.00;

-- 21. Unión de clientes y pedidos.
SELECT
    c.nome_cli,
    c.cod_cli,
    p.num_ped
FROM Cliente AS c
INNER JOIN Pedido AS p ON p.cd_cli = c.cod_cli;

-- 22. Clientes de SP o RJ con pedidos cuyo plazo supera los 15 días.
SELECT DISTINCT
    c.cod_cli,
    c.nome_cli,
    c.cidade,
    c.uf
FROM Cliente AS c
INNER JOIN Pedido AS p ON p.cd_cli = c.cod_cli
WHERE CAST(p.prazo_ent AS UNSIGNED) > 15
  AND c.uf IN ('SP', 'RJ');

-- 23. Clientes, pedidos y plazos, del mayor al menor plazo.
SELECT
    c.nome_cli,
    p.num_ped,
    p.prazo_ent
FROM Cliente AS c
INNER JOIN Pedido AS p ON p.cd_cli = c.cod_cli
ORDER BY CAST(p.prazo_ent AS UNSIGNED) DESC;

-- 24. Clientes de RJ con pedidos de Chapa de Acero y plazo superior a 15 días.
SELECT DISTINCT
    c.nome_cli,
    p.num_ped,
    p.prazo_ent
FROM Cliente AS c
INNER JOIN Pedido AS p ON p.cd_cli = c.cod_cli
INNER JOIN Item_Pedido AS ip ON ip.no_ped = p.num_ped
INNER JOIN Produto AS pr ON pr.cod_prod = ip.cd_prod
WHERE c.uf = 'RJ'
  AND pr.desc_prod = 'Chapa de Aco'
  AND CAST(p.prazo_ent AS UNSIGNED) > 15
ORDER BY c.nome_cli ASC;

-- 25. Cantidad de clientes que realizaron pedidos con la vendedora Ana Cristina.
SELECT COUNT(DISTINCT p.cd_cli) AS quantidade_clientes
FROM Pedido AS p
INNER JOIN Vendedor AS v ON v.cod_vend = p.cd_vend
WHERE v.nome_vend = 'Ana Cristina';
