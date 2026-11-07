-- EJERCICIO 1

CREATE OR REPLACE FUNCTION fn_calcular_bonus_mensal(
    p_cod_vend INT
)
RETURNS NUMERIC AS $$
DECLARE
    v_salario NUMERIC;
    v_faixa CHAR(1);
BEGIN
    SELECT sal_fixo, faixa_comiss
    INTO v_salario, v_faixa
    FROM vendedor
    WHERE cod_vend = p_cod_vend;

    IF UPPER(v_faixa) = 'A' THEN
        RETURN v_salario * 0.10;
    ELSIF UPPER(v_faixa) = 'B' THEN
        RETURN v_salario * 0.05;
    ELSIF UPPER(v_faixa) = 'C' THEN
        RETURN v_salario * 0.02;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 2

CREATE OR REPLACE FUNCTION fn_valor_total_pedido(
    p_num_ped INT
)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT SUM(ip.qtd_ped * pr.val_unit)
    INTO v_total
    FROM item_pedido ip
    INNER JOIN produto pr ON ip.cd_prod = pr.cod_prod
    WHERE ip.no_ped = p_num_ped;

    RETURN COALESCE(v_total, 0);
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 3

CREATE OR REPLACE FUNCTION fn_verificar_cliente_ativo(
    p_cod_cli INT
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM pedido
        WHERE cd_cli = p_cod_cli
    );
END;
$$ LANGUAGE plpgsql;


-- EJERCICIO 4

CREATE OR REPLACE PROCEDURE sp_atualizar_salario_vendedor(
    p_cod_vend INT,
    p_percentual NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE vendedor
    SET sal_fixo = sal_fixo + (sal_fixo * p_percentual / 100)
    WHERE cod_vend = p_cod_vend;
END;
$$;


-- EJERCICIO 5

CREATE OR REPLACE PROCEDURE sp_transferir_carteira(
    p_vend_antigo INT,
    p_vend_novo INT
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE pedido
    SET cd_vend = p_vend_novo
    WHERE cd_vend = p_vend_antigo;
END;
$$;


-- EJERCICIO 6

CREATE OR REPLACE PROCEDURE sp_obter_resumo_produto(
    IN p_cod_prod INT,
    OUT p_descricao VARCHAR,
    OUT p_valor_unitario NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    SELECT desc_prod, val_unit
    INTO p_descricao, p_valor_unitario
    FROM produto
    WHERE cod_prod = p_cod_prod;
END;
$$;


-- EJERCICIO 7

CREATE OR REPLACE PROCEDURE sp_excluir_cliente_seguro(
    p_cod_cli INT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF fn_verificar_cliente_ativo(p_cod_cli) THEN
        RAISE NOTICE 'El cliente tiene pedidos y no puede eliminarse.';
    ELSE
        DELETE FROM cliente
        WHERE cod_cli = p_cod_cli;

        RAISE NOTICE 'Operación de eliminación ejecutada.';
    END IF;
END;
$$;
