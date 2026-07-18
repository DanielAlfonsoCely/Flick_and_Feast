-- Historial compras cliente (Cliente)

DROP VIEW IF EXISTS Historial_Compra_Cliente;
DROP VIEW IF EXISTS Funciones_Disponibles;
DROP VIEW IF EXISTS Boletas_Alimentos;
DROP VIEW IF EXISTS Funciones_Mayor_Recaudacion;
DROP VIEW IF EXISTS Clientes_Suscripciones;
DROP VIEW IF EXISTS Tendencia_Ventas;

CREATE VIEW Historial_Compra_Cliente AS
SELECT 
    Boleta.bolFechaCompra AS fecha_compra, Pelicula.pelNombre_Pelicula AS pelicula,
    Funcion.funNombre AS nombre_funcion, Funcion.funNumero_Sala AS sala,
    Silla.silID_Silla AS asiento, SUM(Boleta.bolPrecio) AS total_boletos,
    SUM(Encargo_Alimento.encPrecio) AS total_confiteria, 
    SUM(Boleta.bolPrecio) + SUM(Encargo_Alimento.encPrecio) AS total_gastado
FROM Boleta
JOIN Funcion ON Boleta.bolId_Funcion = Funcion.funId_Funcion
JOIN Pelicula ON Funcion.funNombre_Pelicula = Pelicula.pelNombre_Pelicula
JOIN Silla ON Boleta.bolID_Silla = Silla.silID_Silla
LEFT JOIN Detalle_Venta ON Boleta.bolId_Detalle_venta = Detalle_Venta.detId_Detalle_venta
LEFT JOIN Encargo_Alimento ON Detalle_Venta.detId_Detalle_venta = Encargo_Alimento.encId_Detalle_venta
GROUP BY Boleta.bolFechaCompra, Pelicula.pelNombre_Pelicula, 
         Funcion.funNombre, Funcion.funNumero_Sala, Silla.silID_Silla
ORDER BY Boleta.bolFechaCompra DESC;

-- Funciones disponibles con precios (Cliente)
CREATE VIEW Funciones_Disponibles AS
SELECT 
    Funcion.funId_Funcion AS id_funcion, Pelicula.pelNombre_Pelicula AS pelicula,
    Funcion.funNombre AS nombre_funcion, Funcion.funNumero_Sala AS sala,
    Funcion.funHoraInicio AS hora_funcion, 
    (Sala.salCapacidadTotal - COUNT(Boleta.bolId_Boleta)) AS asientos_disponibles,
    Sala.salCapacidadGeneral AS precio_asiento_general, 
    Sala.salCapacidadPreferencial AS precio_asiento_preferencial
FROM Funcion
JOIN Pelicula ON Funcion.funNombre_Pelicula = Pelicula.pelNombre_Pelicula
JOIN Sala ON Funcion.funNumero_Sala = Sala.salNumero_Sala 
          AND Funcion.funNombre = Sala.salNombre_Sede
LEFT JOIN Boleta ON Funcion.funId_Funcion = Boleta.bolId_Funcion
GROUP BY Funcion.funId_Funcion, Pelicula.pelNombre_Pelicula, 
         Funcion.funNombre, Funcion.funNumero_Sala, 
         Funcion.funHoraInicio, Sala.salCapacidadTotal, 
         Sala.salCapacidadGeneral, Sala.salCapacidadPreferencial
HAVING asientos_disponibles > 0
ORDER BY Funcion.funHoraInicio ASC;

-- Boletas y precios de alimentos (Empleado Taquilla)
CREATE VIEW Boletas_Alimentos AS
SELECT 
    Funcion.funId_Funcion AS id_funcion, Pelicula.pelNombre_Pelicula AS pelicula,
    Funcion.funNombre AS nombre_funcion, Funcion.funNumero_Sala AS sala,
    (Sala.salCapacidadTotal - COUNT(Boleta.bolId_Boleta)) AS asientos_disponibles,
    Sala.salCapacidadGeneral AS precio_asiento_general, 
    Sala.salCapacidadPreferencial AS precio_asiento_preferencial,
    Alimento.almNombre_Alimento AS nombre_alimento, Alimento.almPrecio AS precio_alimento
FROM Funcion
JOIN Pelicula ON Funcion.funNombre_Pelicula = Pelicula.pelNombre_Pelicula
JOIN Sala ON Funcion.funNumero_Sala = Sala.salNumero_Sala 
          AND Funcion.funNombre = Sala.salNombre_Sede
LEFT JOIN Boleta ON Funcion.funId_Funcion = Boleta.bolId_Funcion
LEFT JOIN Alimento ON 1=1 -- Se usa para obtener la lista de alimentos sin relación directa
GROUP BY Funcion.funId_Funcion, Pelicula.pelNombre_Pelicula, 
         Funcion.funNombre, Funcion.funNumero_Sala, 
         Sala.salCapacidadTotal, Sala.salCapacidadGeneral, 
         Sala.salCapacidadPreferencial, Alimento.almNombre_Alimento, 
         Alimento.almPrecio
HAVING asientos_disponibles > 0
ORDER BY Funcion.funHoraInicio ASC;

-- Funciones con más ingresos (Gerente Sede)
CREATE VIEW Funciones_Mayor_Recaudacion AS
SELECT 
    Funcion.funId_Funcion AS id_funcion, Pelicula.pelNombre_Pelicula AS pelicula,
    Funcion.funNombre AS nombre_funcion, Funcion.funNumero_Sala AS sala,
    SUM(Boleta.bolPrecio) AS ingresos_boletas, 
    SUM(Encargo_Alimento.encPrecio) AS ingresos_confiteria,
    (SUM(Boleta.bolPrecio) + SUM(Encargo_Alimento.encPrecio)) AS ingresos_totales
FROM Funcion
JOIN Pelicula ON Funcion.funNombre_Pelicula = Pelicula.pelNombre_Pelicula
LEFT JOIN Boleta ON Funcion.funId_Funcion = Boleta.bolId_Funcion
LEFT JOIN Detalle_Venta ON Boleta.bolId_Detalle_venta = Detalle_Venta.detId_Detalle_venta
LEFT JOIN Encargo_Alimento ON Detalle_Venta.detId_Detalle_venta = Encargo_Alimento.encId_Detalle_venta
GROUP BY Funcion.funId_Funcion, Pelicula.pelNombre_Pelicula, 
         Funcion.funNombre, Funcion.funNumero_Sala
ORDER BY ingresos_totales DESC;


-- Clientes con suscripciones (Call Center)
CREATE VIEW Clientes_Suscripciones AS
SELECT 
    Cliente.cliId_Cliente AS id_cliente, Cliente.cliNombre AS nombre_cliente,
    Cliente.cliCorreo AS correo_cliente, 
    IFNULL(Suscripcion.susNombre_Membresia, 'Sin Suscripción') AS tipo_suscripcion,
    IFNULL(Membresia.memNombre_Membresia, 'Sin Membresía') AS tipo_membresia
FROM Cliente
LEFT JOIN Suscripcion ON Cliente.cliId_Cliente = Suscripcion.susId_Cliente
LEFT JOIN Membresia ON Suscripcion.susNombre_Membresia = Membresia.memNombre_Membresia
ORDER BY Cliente.cliNombre ASC;


-- Ventas de boletas y alimentos últimos 6 meses (Analista Marketing)
CREATE VIEW Tendencia_Ventas AS
SELECT 
    YEAR(Boleta.bolFechaCompra) AS año, MONTH(Boleta.bolFechaCompra) AS mes,
    COUNT(Boleta.bolId_Boleta) AS total_boletas, 
    SUM(Encargo_Alimento.encUnidades) AS total_productos
FROM Boleta
LEFT JOIN Detalle_Venta ON Boleta.bolId_Detalle_venta = Detalle_Venta.detId_Detalle_venta
LEFT JOIN Encargo_Alimento ON Detalle_Venta.detId_Detalle_venta = Encargo_Alimento.encId_Detalle_venta
WHERE Boleta.bolFechaCompra >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY año, mes
ORDER BY año DESC, mes DESC;

create view vw_posiblesClientes as SELECT 
    c.cliNombre AS Nombre_Cliente,
    c.cliCorreo AS Correo,
    COUNT(b.bolId_Boleta) AS Total_Compras,
    IFNULL(m.memNombre_Membresia, 'Sin Membresía') AS Tipo_Membresía
FROM cliente c
JOIN boleta b ON c.cliId_Cliente = b.bolId_Cliente
LEFT JOIN suscripcion s ON c.cliId_Cliente = s.susId_Cliente
LEFT JOIN membresia m ON s.susNombre_Membresia = m.memNombre_Membresia
WHERE b.bolFechaCompra >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY c.cliId_Cliente, c.cliNombre, c.cliCorreo, m.memNombre_Membresia
HAVING COUNT(b.bolId_Boleta) > 3
ORDER BY Total_Compras DESC;

select * from vw_posiblesClientes;


