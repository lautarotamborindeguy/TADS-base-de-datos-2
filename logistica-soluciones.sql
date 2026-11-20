-- EJERCICIO 1: pedidos de los ultimos 30 dias e indice B-Tree.

SELECT id_pedido, valor_frete
FROM pedido_logistica
WHERE data_postagem >= NOW() - INTERVAL '30 days'
  AND data_postagem <= NOW();

-- B-Tree admite comparaciones por rango; es el tipo de indice predeterminado.
CREATE INDEX idx_pedido_logistica_data_postagem
    ON pedido_logistica USING BTREE (data_postagem);


-- EJERCICIO 2: indice Hash para busquedas por igualdad exacta.

CREATE INDEX idx_cliente_corp_cpf_cnpj_hash
    ON cliente_corp USING HASH (cpf_cnpj);

-- EJERCICIO 3: crear un pedido junto con su primer registro de historial.
-- Se eligen como ejemplo un flete de 75.00 y la ciudad de Montevideo.
-- Ejecutar el bloque completo en la misma conexion.

BEGIN;

INSERT INTO pedido_logistica (
    id_cliente,
    valor_frete,
    data_postagem,
    cidade_destino
)
VALUES (1, 75.00, NOW(), 'Montevideo');

-- SERIAL crea la secuencia pedido_logistica_id_pedido_seq en el DDL dado.
-- currval obtiene el ultimo ID generado por esa secuencia en esta conexion;
-- las inserciones de otras conexiones no cambian este valor.
INSERT INTO historico_entrega (
    id_pedido,
    status,
    data_atualizacao,
    observacao
)
VALUES (
    currval('pedido_logistica_id_pedido_seq'),
    'Postado',
    NOW(),
    'Primer registro del pedido.'
);

-- Las dos instrucciones forman una sola transaccion: todo o nada.
-- Si todo termina correctamente, confirmar:
COMMIT;

-- Ante un error, ejecutar la siguiente instruccion EN LUGAR de COMMIT:
-- ROLLBACK;


-- EJERCICIO 4: registrar un extravio y poner el flete en cero.

BEGIN;

SELECT id_pedido, valor_frete
FROM pedido_logistica
WHERE id_pedido = 50
FOR UPDATE;

UPDATE pedido_logistica
SET valor_frete = 0.00
WHERE id_pedido = 50;

INSERT INTO historico_entrega (
    id_pedido,
    status,
    data_atualizacao,
    observacao
)
VALUES (
    50,
    'Extraviado',
    NOW(),
    'Paquete extraviado; flete ajustado a cero para auditoria.'
);

COMMIT;

-- Ante un error, ejecutar ROLLBACK; en lugar de COMMIT.
-- El bloqueo de la fila se libera al terminar la transaccion.
