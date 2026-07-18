-- Trigger para ajustar la capacidad total de las salas

DELIMITER $$
CREATE TRIGGER trg_AutoCapacidadSala
BEFORE INSERT ON Sala
FOR EACH ROW
BEGIN
    SET NEW.salCapacidadTotal = NEW.salCapacidadGeneral + NEW.salCapacidadPreferencial;
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trg_AutoCalcularDuracion
BEFORE INSERT ON Funcion
FOR EACH ROW
BEGIN
    SET NEW.funDuracion = TIMEDIFF(NEW.funHoraFin, NEW.funHoraInicio);
END $$
DELIMITER ;
INSERT INTO funcion VALUES (138, "The GodFather", 4, "Campo Alegre", '16:30:00', '19:05:00', '0:15:00', '2025-02-23 16:30:00');

-- trigger que actualiza tipo de membresia del cliente al crear una suscripcion
DELIMITER $$
CREATE TRIGGER trg_ActualizarMembresia
AFTER INSERT ON Suscripcion
FOR EACH ROW
BEGIN
    UPDATE Cliente
    SET cliTipo = NEW.susNombre_Membresia
    WHERE cliId_Cliente = NEW.susId_Cliente;
END $$
DELIMITER ;

-- Trigger que evita crear 2 suscripciones a un mismo cliente
DELIMITER $$  
CREATE TRIGGER trg_PrevenirDuplicadoSuscripcion  
BEFORE INSERT ON Suscripcion  
FOR EACH ROW  
BEGIN  
    IF (SELECT COUNT(*) FROM Suscripcion WHERE susId_Cliente = NEW.susId_Cliente) > 0 THEN  
        SIGNAL SQLSTATE '45000'  
        SET MESSAGE_TEXT = 'El cliente ya tiene una suscripción activa';  
    END IF;  
END $$  
DELIMITER ;

-- Evitar que una funcion acabe despues de la media noche
DELIMITER $$  
CREATE TRIGGER trg_LimitarHoraFinFuncion  
BEFORE INSERT ON Funcion  
FOR EACH ROW  
BEGIN  
    IF NEW.funHoraFin > '23:59:59' THEN  
        SET NEW.funHoraFin = '23:59:59';  
    END IF;  
END $$  
DELIMITER ;


-- Evitar que una boleta sea duplicada para la misma silla y función 
DELIMITER $$  
CREATE TRIGGER trg_PrevenirBoletaDuplicada  
BEFORE INSERT ON Boleta  
FOR EACH ROW  
BEGIN  
    IF EXISTS (SELECT 1 FROM Boleta WHERE bolId_Funcion = NEW.bolId_Funcion AND bolId_Silla = NEW.bolId_Silla) THEN  
        SIGNAL SQLSTATE '45000'  
        SET MESSAGE_TEXT = 'Esta silla ya ha sido reservada para esta función';  
    END IF;  
END $$  
DELIMITER ;

-- Evitar que un pedido de alimentos tenga 0 unidades
DELIMITER $$  
CREATE TRIGGER trg_VerificarCantidadPedido  
BEFORE INSERT ON Encargo_Alimento  
FOR EACH ROW  
BEGIN  
    IF NEW.encUnidades <= 0 THEN  
        SIGNAL SQLSTATE '45000'  
        SET MESSAGE_TEXT = 'El pedido debe tener al menos una unidad';  
    END IF;  
END $$  
DELIMITER ;

DELIMITER $$

DELIMITER $$


CREATE TRIGGER trg_AumentarPuntosBoleta
AFTER INSERT ON Boleta
FOR EACH ROW
BEGIN
    UPDATE Cliente
    SET cliPuntos = IFNULL(cliPuntos, 0) + (NEW.bolPrecio / 10)
    WHERE cliId_Cliente = NEW.bolId_Cliente;
END $$

DELIMITER $$

CREATE TRIGGER trg_AumentarPuntosEncargo
AFTER INSERT ON Encargo_Alimento
FOR EACH ROW
BEGIN
    UPDATE Cliente
    SET cliPuntos = IFNULL(cliPuntos, 0) + (NEW.encPrecio / 10)
    WHERE cliId_Cliente = (SELECT susId_Cliente FROM Suscripcion WHERE susId_Cliente = NEW.encId_Detalle_Venta LIMIT 1);
END $$

DELIMITER ;


-- CALL sp_GenerarBoleta(1001, 107, 9);
-- call sp_ProcesarPedido(1000,"Freskaleche",2);
-- insert into Boleta values(36,18,1000,108,"El Bosque",2,9,10000,"2025-02-28 23:34:38","Preferencial");

