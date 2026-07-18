CREATE USER 'cliente'@'localhost' IDENTIFIED BY '12345';
CREATE USER 'empleado_taquilla'@'localhost' IDENTIFIED BY '12345';
CREATE USER 'gerente_sede'@'localhost' IDENTIFIED BY '12345';
CREATE USER 'call_center'@'localhost' IDENTIFIED BY '12345';
CREATE USER 'marketing'@'localhost' IDENTIFIED BY '12345';
CREATE USER 'administrador'@'localhost' IDENTIFIED BY '12345';


GRANT SELECT ON Boleta TO 'cliente'@'localhost';
GRANT SELECT ON Detalle_Venta TO 'cliente'@'localhost';
GRANT SELECT ON Silla TO 'cliente'@'localhost';
GRANT SELECT ON Funcion TO 'cliente'@'localhost';
GRANT SELECT ON Pelicula TO 'cliente'@'localhost';

GRANT SELECT, INSERT, UPDATE ON Boleta TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Detalle_Venta TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Cliente TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Suscripcion TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Membresia TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Encargo_Alimento TO 'empleado_taquilla'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Alimento TO 'empleado_taquilla'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON Trabajador TO 'gerente_sede'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Sede TO 'gerente_sede'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Sala TO 'gerente_sede'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Proveedor TO 'gerente_sede'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Detalle_Venta TO 'gerente_sede'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Funcion TO 'gerente_sede'@'localhost';

GRANT SELECT, UPDATE ON Telefono TO 'call_center'@'localhost';
GRANT SELECT, UPDATE ON Cliente TO 'call_center'@'localhost';
GRANT SELECT, UPDATE ON Membresia TO 'call_center'@'localhost';
GRANT SELECT, UPDATE ON Suscripcion TO 'call_center'@'localhost';

GRANT SELECT ON Detalle_Venta TO 'marketing'@'localhost';
GRANT SELECT ON Funcion TO 'marketing'@'localhost';
GRANT SELECT ON Pelicula TO 'marketing'@'localhost';
GRANT SELECT ON Encargo_Alimento TO 'marketing'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'administrador'@'localhost';

-- VISTAS
GRANT SELECT ON Historial_Compra_Cliente TO 'cliente'@'localhost';
GRANT SELECT ON Funciones_Disponibles TO 'cliente'@'localhost';
GRANT SELECT ON Boletas_Alimentos TO 'empleado_taquilla'@'localhost';
GRANT SELECT ON Funciones_Mayor_Recaudacion TO 'gerente_sede'@'localhost';
GRANT SELECT ON Clientes_Suscripciones TO 'call_center'@'localhost';
GRANT SELECT ON Tendencia_Ventas TO 'marketing'@'localhost';
GRANT ALL PRIVILEGES ON Historial_Compra_Cliente TO 'administrador'@'localhost';
GRANT ALL PRIVILEGES ON Funciones_Disponibles TO 'administrador'@'localhost';
GRANT ALL PRIVILEGES ON Boletas_Alimentos TO 'administrador'@'localhost';
GRANT ALL PRIVILEGES ON Funciones_Mayor_Recaudacion TO 'administrador'@'localhost';
GRANT ALL PRIVILEGES ON Clientes_Suscripciones TO 'administrador'@'localhost';
GRANT ALL PRIVILEGES ON Tendencia_Ventas TO 'administrador'@'localhost';
