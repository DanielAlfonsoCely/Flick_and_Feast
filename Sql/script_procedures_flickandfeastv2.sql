-- Procedures

-- boleta




-- procedimiento para saber si hay sillas disponibles dada una funcion

DELIMITER $$
CREATE PROCEDURE sp_GetAvailableSeats(
  IN p_funId_Funcion INT
)
BEGIN
  DECLARE p_sede VARCHAR(45);
  DECLARE p_numSala INT;
  -- Se obtienen los datos de la función (sede y número de sala)
  SELECT funNombre, funNumero_Sala 
    INTO p_sede, p_numSala 
    FROM funcion 
   WHERE funId_Funcion = p_funId_Funcion;
  -- Se listan los asientos que aún no han sido ocupados en boleta para esa función
  SELECT silId_Silla, silTipo_silla, silPrecio_Silla
  FROM silla
  WHERE silNumero_Sala = p_numSala 
    AND silNombre_Sede = p_sede
    AND silId_Silla NOT IN (
        SELECT bolId_Silla 
        FROM boleta 
        WHERE bolId_Funcion = p_funId_Funcion
    );
END$$
DELIMITER ;

-- drop procedure sp_GetAvailableSeats;
call sp_GetAvailableSeats(129);

DELIMITER ;

select * from funcion;
select * from silla;


-- Registrar una Venta (Detalle de Venta) y Actualizar Puntos del Cliente
DELIMITER $$
CREATE PROCEDURE sp_InsertSale(
  IN p_detIdCliente INT,
  IN p_detIdEmpleado INT,
  IN p_detTipoServicio VARCHAR(45),
  IN p_detMetodoPago VARCHAR(45),
  IN p_detUnidadesBoleta INT,
  IN p_detPrecioTotal INT
)
BEGIN
  DECLARE new_id INT;
  SELECT IFNULL(MAX(detId_Detalle_Venta), 0) + 1 INTO new_id FROM detalle_venta;

  INSERT INTO detalle_venta(
    detId_Detalle_Venta,
    detId_Cliente,
    detId_Empleado,
    detTipo_Servicio,
    detMetodo_Pago,
    detUnidades_Boleta,
    detPrecioTotal
  )
  VALUES(new_id, p_detIdCliente, p_detIdEmpleado, p_detTipoServicio, p_detMetodoPago, p_detUnidadesBoleta, p_detPrecioTotal);
  UPDATE cliente 
  SET cliPuntos = IFNULL(cliPuntos, 0) + (p_detPrecioTotal / 10)
  WHERE cliId_Cliente = p_detIdCliente;
  
  SELECT new_id AS DetalleVentaID;
END$$

DELIMITER ;

-- Vista para que se vea la comida disponible y su info
CREATE VIEW vw_ListaComida AS
SELECT 'Alimento' AS Tipo,almNombre_Alimento AS Nombre, almNombre_Proveedor AS Proveedor, 
    almPrecio AS Precio, almTamaño AS Tamaño, almEmpaque AS Empaque, NULL AS Sabor
FROM alimento UNION ALL SELECT 
    'Bebida' AS Tipo, 
    bebNombre_Alimento AS Nombre, 
    bebNombre_Proveedor AS Proveedor, 
    NULL AS Precio, 
    NULL AS Tamaño, 
    NULL AS Empaque,
    bebSabor AS Sabor
FROM bebida;


DELIMITER $$

-- Procedimiento para generar Boleta
CREATE PROCEDURE sp_GenerarBoleta(
    IN p_idCliente INT, 
    IN p_idFuncion INT, 
    IN p_idSilla INT
)
BEGIN
    DECLARE new_id INT;
    DECLARE v_precio INT;
    DECLARE v_tipoBoleta VARCHAR(45);
    DECLARE v_nombreSede VARCHAR(45);
    DECLARE v_numeroSala INT;
    DECLARE v_detalleVenta INT;
    
    SELECT IFNULL(MAX(bolId_Boleta), 0) + 1 INTO new_id FROM Boleta;
    SELECT IFNULL(MAX(detId_Detalle_Venta), 0) INTO v_detalleVenta FROM Detalle_Venta;
    SELECT funNombre, funNumero_Sala INTO v_nombreSede, v_numeroSala FROM Funcion WHERE funId_Funcion = p_idFuncion;

    SELECT silTipo_Silla INTO v_tipoBoleta FROM Silla WHERE silId_Silla = p_idSilla AND silNumero_Sala = v_numeroSala AND silNombre_Sede = v_nombreSede;
    IF v_tipoBoleta = 'General' THEN
        SET v_precio = 15000;
    ELSEIF v_tipoBoleta = 'Preferencial' THEN
        SET v_precio = 20000;
    ELSE
        SET v_precio = 15000; -- Precio por defecto 
    END IF;
    
    INSERT INTO Boleta (
        bolId_Boleta,
        bolId_Detalle_Venta,
        bolId_Cliente, 
        bolId_Funcion, 
        bolNombre_Sede, 
        bolNumero_Sala, 
        bolId_Silla, 
        bolPrecio, 
        bolFechaCompra, 
        bolTipo
    )
    VALUES(new_id, v_detalleVenta, p_idCliente, p_idFuncion, v_nombreSede, v_numeroSala, p_idSilla, v_precio, NOW(), v_tipoBoleta);
    
    
    update detalle_venta set detPrecioTotal = detPrecioTotal + v_precio where detId_Detalle_Venta = v_detalleVenta;
END $$

DELIMITER ;

-- drop procedure sp_GenerarBoleta;
CALL sp_GenerarBoleta(1000, 109, 3);

-- Procedimiento para generar Pedido
DELIMITER $$
CREATE PROCEDURE sp_ProcesarPedido(
    IN p_idCliente INT, 
    IN p_nombreProducto VARCHAR(45), -- Nombre del producto
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio INT;
    DECLARE v_total INT;
    DECLARE v_detalleVenta INT;
    DECLARE v_proveedor VARCHAR(45);
    SELECT IFNULL(MAX(detId_Detalle_Venta), 0) INTO v_detalleVenta FROM Detalle_Venta;
    SELECT almPrecio, almNombre_Proveedor INTO v_precio, v_proveedor FROM Alimento WHERE almNombre_Alimento = p_nombreProducto;

    SET v_total = v_precio * p_cantidad;
    INSERT INTO Encargo_Alimento (
        encId_Detalle_Venta,
        encNombre_Alimento,
        encNombre_Proveedor,
        encUnidades,
        encPrecio
    ) 
    VALUES (v_detalleVenta, p_nombreProducto, v_proveedor, p_cantidad, v_total);
    update detalle_venta set detPrecioTotal = detPrecioTotal + v_total where detId_Detalle_Venta = v_detalleVenta;
END $$

DELIMITER ;
-- drop procedure sp_ProcesarPedido;

call sp_ProcesarPedido(1000,"Cheetos Queso",1);

DELIMITER $$

-- crear cliente
CREATE PROCEDURE sp_CrearCliente(
    IN p_idCliente INT, -- Cedula del cliente
    IN p_nombre VARCHAR(45),
    IN p_correo VARCHAR(45),
    IN p_direccion VARCHAR(100)
)
BEGIN
    INSERT INTO Cliente (
        cliId_Cliente,
        cliNombre,
        cliCorreo,
        cliDireccion,
        cliPuntos
    )
    VALUES (p_idCliente, p_nombre, p_correo, p_direccion, 0);
END $$
DELIMITER ;
-- drop procedure sp_CrearCliente;
CALL sp_CrearCliente(123456, 'Juan Sarmiento', 'juan.sarmiento@email.com', 'Calle 97, Ciudad');

-- actualizar cliente

DELIMITER $$

CREATE PROCEDURE sp_ActualizarCliente(
    IN p_idCliente INT, 
    IN p_campo VARCHAR(45), 
    IN p_nuevoValor VARCHAR(100)
)
BEGIN
    IF p_campo = 'cliNombre' THEN
        UPDATE Cliente SET cliNombre = p_nuevoValor WHERE cliId_Cliente = p_idCliente;
    ELSEIF p_campo = 'cliCorreo' THEN
        UPDATE Cliente SET cliCorreo = p_nuevoValor WHERE cliId_Cliente = p_idCliente;
    ELSEIF p_campo = 'cliDireccion' THEN
        UPDATE Cliente SET cliDireccion = p_nuevoValor WHERE cliId_Cliente = p_idCliente;
    ELSEIF p_campo = 'cliPuntos' THEN
        UPDATE Cliente SET cliPuntos = CAST(p_nuevoValor AS SIGNED) WHERE cliId_Cliente = p_idCliente;
    ELSEIF p_campo = 'cliTipo' THEN
        UPDATE Cliente SET cliTipo = p_nuevoValor WHERE cliId_Cliente = p_idCliente;
    END IF;
END $$

DELIMITER ;

CALL sp_ActualizarCliente(123456789, 'cliPuntos', '500');

-- Crear suscripcion
DELIMITER $$

CREATE PROCEDURE sp_CrearSuscripcion(
    IN p_idCliente INT,
    IN p_nombreMembresia VARCHAR(45)
)
BEGIN
    DECLARE v_fechaInicio DATETIME;
    DECLARE v_fechaExpiracion DATETIME;
    SET v_fechaInicio = NOW();
    IF p_nombreMembresia = 'Basic' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 100 YEAR);
    ELSEIF p_nombreMembresia = 'Advanced' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 3 YEAR);
    ELSEIF p_nombreMembresia = 'VIP' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 1 YEAR);
    END IF;

    INSERT INTO Suscripcion (
        susId_Cliente,
        susNombre_Membresia,
        susFecha_Inicio,
        susFecha_Expiracion
    )
    VALUES (p_idCliente, p_nombreMembresia, v_fechaInicio, v_fechaExpiracion);

END $$

DELIMITER ;
-- drop procedure sp_CrearSuscripcion;
CALL sp_CrearSuscripcion(1019, 'Basic');
select * from suscripcion;
-- Procedure que actualiza suscripcion
DELIMITER $$
CREATE PROCEDURE sp_ActualizarSuscripcion(
    IN p_idCliente INT,
    IN p_nombreMembresia VARCHAR(45)
)
BEGIN
    DECLARE v_fechaInicio DATE;
    DECLARE v_fechaExpiracion DATE;
    SET v_fechaInicio = CURDATE();
    IF p_nombreMembresia = 'Basic' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 100 YEAR);
    ELSEIF p_nombreMembresia = 'Advanced' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 3 YEAR);
    ELSEIF p_nombreMembresia = 'VIP' THEN
        SET v_fechaExpiracion = DATE_ADD(v_fechaInicio, INTERVAL 1 YEAR);
    END IF;
    UPDATE Suscripcion
    SET susNombre_Membresia = p_nombreMembresia, susFecha_Inicio = v_fechaInicio, susFecha_Expiracion = v_fechaExpiracion
    WHERE susId_Cliente = p_idCliente;
END $$
DELIMITER ;
-- drop procedure sp_ActualizarSuscripcion;
CALL sp_ActualizarSuscripcion(123456789, 'Basic');


-- Procedure que da la seleccion de clientes con suscripcion basic

DELIMITER $$
CREATE PROCEDURE sp_ObtenerClientesBasic()
BEGIN
    SELECT * FROM Cliente WHERE cliTipo = 'Basic';
END $$
DELIMITER ;
call sp_ObtenerClientesBasic();




select * from boletas_alimentos;


