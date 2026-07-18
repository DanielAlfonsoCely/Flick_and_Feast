-- 1. Historial de compras detallado con precios y asientos:(Cliente) Mostrar todas las compras de un cliente, incluyendo la película, la sala, la función, el número de asiento y el precio pagado.
 
SELECT DISTINCT 
    c.cliNombre AS Nombre_Cliente,
    p.pelNombre_Pelicula AS Película,
    f.funNombre AS Sede,
    f.funNumero_Sala AS Sala,
    s.silID_Silla AS Silla,
    f.funHoraInicio AS Hora_Función,
    b.bolPrecio AS Precio_Boleta,
    b.bolFechaCompra AS Fecha_Compra
FROM boleta b
JOIN cliente c ON b.bolId_Cliente = c.cliId_Cliente
JOIN funcion f ON b.bolId_Funcion = f.funId_Funcion
JOIN pelicula p ON f.funNombre_Pelicula = p.pelNombre_Pelicula
JOIN silla s ON b.bolID_Silla = s.silID_Silla
ORDER BY b.bolFechaCompra DESC;


-- 2. Clientes con más de 3 compras en el último mes y su tipo de membresía:(Empleado taquilla)  Obtener los clientes que han comprado más de 3 boletos en el último mes, junto con su tipo de membresía (si tienen). Esto ayuda al empleado de taquilla a identificar clientes frecuentes y ofrecerles beneficios.

SELECT 
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




-- 3. Productos más vendidos en la confitería según categoría (bebida/snack):  Obtener los productos de confitería más vendidos en el último mes, agrupados por tipo (bebida o snack), ordenados de mayor a menor cantidad vendida.


SELECT 
    a.almNombre_Alimento AS nombre_producto,
    s.snaNombre_Alimento AS snack,
    b.bebNombre_Alimento AS bebida,
    SUM(e.encUnidades) AS total_vendido
FROM encargo_alimento e
JOIN alimento a ON e.encNombre_Alimento = a.almNombre_Alimento 
                AND e.encNombre_Proveedor = a.almNombre_Proveedor
LEFT JOIN snack s ON a.almNombre_Alimento = s.snaNombre_Alimento
LEFT JOIN bebida b ON a.almNombre_Alimento = b.bebNombre_Alimento
JOIN detalle_venta d ON e.encId_Detalle_venta = d.detId_Detalle_venta
JOIN boleta bl ON d.detId_Detalle_venta = bl.bolId_Detalle_venta
WHERE bl.bolFechaCompra >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY a.almNombre_Alimento, s.snaNombre_Alimento, b.bebNombre_Alimento
ORDER BY total_vendido DESC;


-- 4. Nombre, correo e información de suscripción y membresía de cada cliente junto con el número de compras totales

SELECT 	
    c.cliNombre AS nombre_cliente,
    c.cliCorreo AS correo_cliente,
    
    IFNULL(s.susNombre_Membresia, 'Sin Suscripción') AS tipo_suscripcion,
    COUNT(d.detId_Detalle_venta) AS total_compras
FROM cliente c
LEFT JOIN suscripcion s ON c.cliId_Cliente = s.susId_Cliente
LEFT JOIN membresia m ON s.susNombre_Membresia = m.memNombre_Membresia
LEFT JOIN detalle_venta d ON c.cliId_Cliente = d.detId_Cliente
GROUP BY c.cliId_Cliente, c.cliNombre, c.cliCorreo, m.memNombre_Membresia, s.susNombre_Membresia
ORDER BY total_compras DESC;



-- 5. Nombre del alimento junto con su tipo de snack o sabor de bebida, el numero total de veces que ha sido comprado, y su respectivo precio, ordenando por el mayor numero de compras al menor: (analista de Marketing)

SELECT 
    a.almNombre_Alimento AS nombre_alimento,
    s.snaTipo AS tipo_alimento_snack,
    b.bebSabor AS tipo_alimento_bebida,
    SUM(e.encUnidades) AS total_compras,
    a.almPrecio AS precio
FROM encargo_alimento e
JOIN alimento a ON e.encNombre_Alimento = a.almNombre_Alimento 
                AND e.encNombre_Proveedor = a.almNombre_Proveedor
LEFT JOIN snack s ON a.almNombre_Alimento = s.snaNombre_Alimento
LEFT JOIN bebida b ON a.almNombre_Alimento = b.bebNombre_Alimento
WHERE s.snaNombre_Alimento IS NOT NULL OR b.bebNombre_Alimento IS NOT NULL
GROUP BY a.almNombre_Alimento, s.snaTipo, b.bebNombre_Alimento, a.almPrecio, b.bebSabor
ORDER BY total_compras DESC;


-- 6. Funciones de cine con mayor % de ocupación, comparando boletos vendidos con la capacidad de la sala (analista de marketing)

SELECT 
    f.funId_Funcion AS id_funcion,
    f.funNombre_Pelicula AS pelicula,
    f.funNombre AS sede,
    f.funNumero_Sala AS sala,
    COUNT(b.bolId_Boleta) AS boletos_vendidos,
    s.salCapacidadTotal AS capacidad_sala,
    (COUNT(b.bolId_Boleta) * 100.0 / s.salCapacidadTotal) AS porcentaje_ocupacion
FROM funcion f
JOIN boleta b ON f.funId_Funcion = b.bolId_Funcion
JOIN sala s ON f.funNumero_Sala = s.salNumero_Sala AND f.funNombre = s.salNombre_Sede
GROUP BY f.funId_Funcion, f.funNombre_Pelicula, f.funNombre, f.funNumero_Sala, s.salCapacidadTotal
ORDER BY porcentaje_ocupacion DESC;




-- 7. Empleados con más ventas Registradas (gerente)
SELECT 
    e.empId_Empleado AS id_empleado,
    t.traNombre AS nombre,
    t.traApellido AS apellido,
    COUNT(d.detId_Detalle_venta) AS total_ventas,
    SUM(d.detPrecioTotal) AS total_dinero_generado
FROM detalle_venta d
JOIN empleado e ON d.detId_Empleado = e.empId_Empleado
JOIN trabajador t ON e.empId_Empleado = t.traId_Trabajador
WHERE d.detUnidades_Boleta > 0 
GROUP BY e.empId_Empleado, t.traNombre, t.traApellido
ORDER BY total_dinero_generado DESC;



-- 8. Total de ventas por año y mes de los últimos 6 meses conparando el total de ventas de boletería y de confitería (analista de marketing)
SELECT 
    YEAR(b.bolFechaCompra) AS año,
    MONTH(b.bolFechaCompra) AS mes,
    COUNT(b.bolId_Boleta) AS total_boletas,
    SUM(e.encUnidades) AS total_productos
FROM boleta b
LEFT JOIN detalle_venta d ON b.bolId_Detalle_venta = d.detId_Detalle_venta
LEFT JOIN encargo_alimento e ON d.detId_Detalle_venta = e.encId_Detalle_venta
WHERE b.bolFechaCompra >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY año, mes
ORDER BY año DESC, mes DESC;


-- 9. Historial de compras de un cliente con detalles de la función y cuánto gastó en total en boletería y confitería (cliente)
SELECT 
    b.bolFechaCompra AS fecha_compra,
    p.pelNombre_Pelicula AS pelicula,
    f.funNombre AS sede,
    f.funNumero_Sala AS sala,
    s.silID_Silla AS asiento,
    SUM(b.bolPrecio) AS total_boletos,
    SUM(e.encPrecio) AS total_confiteria,
    SUM(b.bolPrecio) + SUM(e.encPrecio) AS total_gastado
FROM boleta b
JOIN funcion f ON b.bolId_Funcion = f.funId_Funcion
JOIN pelicula p ON f.funNombre_Pelicula = p.pelNombre_Pelicula
JOIN silla s ON b.bolID_Silla = s.silID_Silla
LEFT JOIN detalle_venta d ON b.bolId_Detalle_venta = d.detId_Detalle_venta
LEFT JOIN encargo_alimento e ON d.detId_Detalle_venta = e.encId_Detalle_venta
WHERE b.bolId_Cliente = 1003 -- Este ID cambia dependiendo de que cliente busque su historial
GROUP BY b.bolFechaCompra, p.pelNombre_Pelicula, f.funNombre, f.funNumero_Sala, s.silID_Silla
ORDER BY b.bolFechaCompra DESC;




-- 10. Funciones con más ingresos generados por sede (gerente Sede)
SELECT 
    f.funId_Funcion AS id_funcion,
    f.funNombre_Pelicula AS pelicula,
    f.funNombre AS sede,
    f.funNumero_Sala AS sala,
    SUM(b.bolPrecio) AS ingresos_boletas,
    SUM(e.encPrecio) AS ingresos_confiteria,
    (SUM(b.bolPrecio) + SUM(e.encPrecio)) AS ingresos_totales
FROM funcion f
LEFT JOIN boleta b ON f.funId_Funcion = b.bolId_Funcion
LEFT JOIN detalle_venta d ON b.bolId_Detalle_venta = d.detId_Detalle_venta
LEFT JOIN encargo_alimento e ON d.detId_Detalle_venta = e.encId_Detalle_venta
GROUP BY f.funId_Funcion, f.funNombre_Pelicula, f.funNombre, f.funNumero_Sala
ORDER BY ingresos_totales DESC;




