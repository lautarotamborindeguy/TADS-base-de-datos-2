-- Proyecto de Base de Datos II | Tienda | MySQL 8.0
--
-- Objetivo. Registrar ventas, resumir el desempeño por categoría, detectar
-- productos sin ventas y guardar un historial de los cambios de precio.
--
-- Cómo ejecutar en MySQL Workbench
-- 1. Abrir este archivo en una conexión a MySQL 8.0.
-- 2. Ejecutarlo completo una vez para crear bd2_proyecto_tienda y cargar los datos.
-- 3. Revisar las tres cuadrículas de resultados al final del archivo.
-- 4. Para probar un rechazo, descomentar y ejecutar solo la sentencia elegida.
--
-- Modelo
-- categorias (1) ---- (N) productos
-- clientes   (1) ---- (N) ventas (N) ---- (1) productos
-- productos  (1) ---- (N) log_precios
--
-- ventas implementa la relación N:M entre clientes y productos. Cada venta
-- registra un solo producto, con una o más unidades. El mismo cliente puede
-- volver a comprar el mismo producto y cada operación tiene su propio id_venta.

CREATE DATABASE bd2_proyecto_tienda;
USE bd2_proyecto_tienda;

-- 1. Estructura
-- PRIMARY KEY identifica cada fila. FOREIGN KEY exige que el registro
-- relacionado exista, por ejemplo, que el cliente de una venta esté registrado.

-- Personas que pueden realizar compras.
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Grupos del catálogo usados en el reporte gerencial.
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL
);

-- Catálogo. El precio actual se usa al registrar una nueva venta.
-- DECIMAL(10, 2) guarda importes con dos posiciones decimales.
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio_actual DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla asociativa. El precio unitario se guarda al vender para que
-- un cambio posterior en el catálogo no modifique los importes históricos.
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Historial de cambios de precio. Puede haber varias entradas por producto.
-- Cada fila conserva el valor anterior, el usuario de MySQL y la fecha del cambio.
CREATE TABLE log_precios (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior DECIMAL(10, 2) NOT NULL,
    usuario VARCHAR(288) NOT NULL,
    fecha_cambio DATETIME NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- 2. Vistas gerenciales
-- Las vistas consultan los datos actuales cada vez que se ejecuta un SELECT.

-- Resumen de ventas por categoría.
CREATE VIEW vw_resumo_desempenho AS
-- SELECT elige las columnas del resultado. AS permite darles un alias.
SELECT c.id_categoria,
       c.nombre AS categoria,
       -- COUNT(*) cuenta las ventas del grupo. Cada fila unida es una venta.
       COUNT(*) AS cantidad_ventas,
       -- SUM suma las unidades de todas las ventas del grupo.
       SUM(v.cantidad) AS unidades_vendidas,
       -- SUM suma los importes del grupo. Cada importe es cantidad por precio.
       SUM(v.cantidad * v.precio_unitario) AS importe_total
-- FROM parte de categorías. c, p y v son alias para referirse a las tablas.
FROM categorias AS c
-- INNER JOIN conserva las coincidencias. ON indica qué claves deben coincidir.
INNER JOIN productos AS p ON p.id_categoria = c.id_categoria
INNER JOIN ventas AS v ON v.id_producto = p.id_producto
-- GROUP BY forma un grupo por ID y nombre de categoría. El resultado tiene
-- una fila por grupo. Por ejemplo, Teclado y Ratón se resumen en Periféricos.
GROUP BY c.id_categoria, c.nombre;

-- Productos que todavía no registran ventas.
CREATE VIEW vw_dados_criticos AS
-- SELECT muestra el ID, el nombre y el precio actual de cada producto.
SELECT p.id_producto, p.nombre, p.precio_actual
FROM productos AS p
-- WHERE NOT EXISTS conserva el producto si la subconsulta no encuentra ventas.
WHERE NOT EXISTS (
    -- SELECT 1 se usa porque solo importa si existe una fila.
    SELECT 1
    FROM ventas AS v
    -- El WHERE interno busca ventas del producto que se está evaluando.
    WHERE v.id_producto = p.id_producto
);

-- 3. Procedimiento y gatillos
-- En MySQL, SIGNAL SQLSTATE '45000' genera el error de negocio que la consigna
-- expresa con RAISE EXCEPTION en PostgreSQL.
-- DELIMITER $$ indica al cliente que espere hasta $$ para enviar cada
-- definición completa, aunque el bloque tenga puntos y comas internos.

DELIMITER $$

-- Uso. CALL sp_registrar_venta(id_cliente, id_producto, cantidad);
-- Los tres parámetros IN son datos de entrada. Si las validaciones pasan,
-- se registra una venta con la fecha actual y el precio leído del catálogo.
CREATE PROCEDURE sp_registrar_venta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10, 2);

    -- SELECT lee el precio del catálogo y WHERE busca el ID recibido.
    -- La subconsulta devuelve NULL si el producto no existe.
    SET v_precio = (
        SELECT precio_actual
        FROM productos
        WHERE id_producto = p_id_producto
    );

    -- Validar los datos de entrada antes de llegar al INSERT.
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad debe ser mayor que cero.';
    -- NOT EXISTS detecta que no hay ningún cliente con el ID recibido.
    ELSEIF NOT EXISTS (
        SELECT 1 FROM clientes WHERE id_cliente = p_id_cliente
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe.';
    ELSEIF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto no existe.';
    ELSE
        -- El INSERT también pasa por tr_validar_venta.
        INSERT INTO ventas (id_cliente, id_producto, fecha, cantidad, precio_unitario)
        VALUES (p_id_cliente, p_id_producto, CURRENT_DATE, p_cantidad, v_precio);
    END IF;
END$$

-- Auditoría. Se ejecuta después de actualizar cada fila de productos.
-- OLD contiene la fila anterior y NEW la fila actualizada. Solo se escribe
-- en el log cuando ambos precios son distintos. USER() devuelve el usuario
-- y el host de la conexión que ejecutó el UPDATE.
CREATE TRIGGER tr_auditar_precio
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio_actual <> NEW.precio_actual THEN
        INSERT INTO log_precios (id_producto, precio_anterior, usuario, fecha_cambio)
        VALUES (OLD.id_producto, OLD.precio_actual, USER(), CURRENT_TIMESTAMP);
    END IF;
END$$

-- Bloqueo. Se ejecuta antes de insertar cada venta, también con INSERT directo.
-- NEW contiene los valores propuestos. Si la cantidad o el precio unitario
-- es menor o igual a cero, SIGNAL detiene la inserción con un mensaje.
CREATE TRIGGER tr_validar_venta
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad debe ser mayor que cero.';
    ELSEIF NEW.precio_unitario <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El precio unitario debe ser mayor que cero.';
    END IF;
END$$

-- Volver al delimitador normal para las sentencias de carga y consulta.
DELIMITER ;

-- 4. Datos de prueba
-- Cargar primero clientes y categorías, después productos y por último ventas.
-- Así existen todas las filas referenciadas por las claves foráneas.

INSERT INTO clientes (id_cliente, nombre) VALUES
    (1, 'Ana Silva'),
    (2, 'Bruno Costa'),
    (3, 'Camila Pereira'),
    (4, 'Diego Almeida'),
    (5, 'Elena Santos');

INSERT INTO categorias (id_categoria, nombre) VALUES
    (1, 'Periféricos'),
    (2, 'Papelería'),
    (3, 'Audio'),
    (4, 'Redes'),
    (5, 'Almacenamiento');

INSERT INTO productos (id_producto, id_categoria, nombre, precio_actual) VALUES
    (1, 1, 'Teclado', 30.00),
    (2, 1, 'Ratón', 15.00),
    (3, 2, 'Cuaderno', 4.00),
    (4, 3, 'Auriculares', 40.00),
    (5, 4, 'Cable de red', 8.00);

-- Estas seis ventas usan los precios originales. El teclado aparece en ventas
-- de dos clientes y Ana compra dos productos distintos, lo que muestra la N:M.
INSERT INTO ventas (id_cliente, id_producto, fecha, cantidad, precio_unitario) VALUES
    (1, 1, '2026-10-01', 2, 30.00),
    (1, 2, '2026-10-02', 1, 15.00),
    (2, 1, '2026-10-02', 1, 30.00),
    (3, 3, '2026-10-03', 3, 4.00),
    (4, 2, '2026-10-03', 2, 15.00),
    (5, 3, '2026-10-04', 2, 4.00);

-- Cambiar los cinco precios produce cinco INSERT en log_precios por el gatillo.
-- Por ejemplo, el teclado pasa de 30.00 a 35.00 y el log conserva 30.00.
UPDATE productos
SET precio_actual = precio_actual + 5.00
WHERE id_producto IN (1, 2, 3, 4, 5);

-- 5. Prueba del procedimiento y verificación

-- Bruno (2) compra dos unidades del teclado (1) a 35.00 cada una.
-- Esta séptima venta agrega 70.00 al total de Periféricos.
CALL sp_registrar_venta(2, 1, 2);

-- SELECT * muestra todas las columnas. ORDER BY ordena por la columna
-- indicada, de menor a mayor por defecto.
-- Primera cuadrícula. Periféricos tiene 5 ventas, 8 unidades e importe de 205.00.
-- Papelería tiene 2 ventas, 5 unidades e importe de 20.00. Se ordena por ID de categoría.
SELECT * FROM vw_resumo_desempenho ORDER BY id_categoria;

-- Segunda cuadrícula. Auriculares y Cable de red siguen sin ventas.
-- Se muestran en orden de ID de producto.
SELECT * FROM vw_dados_criticos ORDER BY id_producto;

-- Tercera cuadrícula. Cinco cambios con su precio anterior, usuario y fecha.
-- Se muestran por ID de auditoría, del primero registrado al último.
SELECT * FROM log_precios ORDER BY id_log;

-- 6. Pruebas de rechazo
-- Descomentar y ejecutar una sentencia por vez, con bd2_proyecto_tienda activa.
-- Cada prueba debe producir el error 1644 (SQLSTATE 45000). Al terminar,
-- deben seguir existiendo 7 ventas si solo se ejecutó la carga inicial.

-- Cantidad igual a cero. Debe mostrar «La cantidad debe ser mayor que cero».
-- CALL sp_registrar_venta(1, 1, 0);

-- Cliente inexistente. Debe mostrar «El cliente no existe».
-- CALL sp_registrar_venta(99, 1, 1);

-- Producto inexistente. Debe mostrar «El producto no existe».
-- CALL sp_registrar_venta(1, 99, 1);

-- Precio negativo en un INSERT directo. Descomentar las dos líneas de la prueba.
-- Debe mostrar «El precio unitario debe ser mayor que cero».
-- INSERT INTO ventas (id_cliente, id_producto, fecha, cantidad, precio_unitario)
-- VALUES (1, 1, CURRENT_DATE, 1, -10.00);
