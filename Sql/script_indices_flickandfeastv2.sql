-- Índice para la Consulta 1: Historial de compras detallado con precios y asientos
CREATE INDEX idx_boleta_cliente ON boleta(bolId_Cliente);
CREATE INDEX idx_boleta_funcion ON boleta(bolId_Funcion);
CREATE INDEX idx_boleta_silla ON boleta(bolId_Silla);

-- Índice para la Consulta 2: Clientes con más de 3 compras en el último mes y su tipo de membresía
CREATE INDEX idx_boleta_cliente_fecha ON boleta(bolId_Cliente, bolFechaCompra);
CREATE INDEX idx_cliente_id ON cliente(cliId_Cliente);
CREATE INDEX idx_suscripcion_cliente ON suscripcion(susId_Cliente);

-- Índice para la Consulta 3: Productos más vendidos en la confitería según categoría
CREATE INDEX idx_encargo_alimento_fecha ON encargo_alimento(encId_Detalle_Venta);
CREATE INDEX idx_alimento_nombre ON alimento(almNombre_Alimento);
CREATE INDEX idx_detalle_venta_fecha ON detalle_venta(detId_Detalle_Venta);
CREATE INDEX idx_boleta_fecha ON boleta(bolFechaCompra);

-- Índice para la Consulta 4: Nombre, correo e información de suscripción y membresía de cada cliente
-- CREATE INDEX idx_cliente_id ON cliente(cliId_Cliente);
-- CREATE INDEX idx_suscripcion_cliente ON suscripcion(susId_Cliente);
CREATE INDEX idx_detalle_venta_cliente ON detalle_venta(detId_Cliente);

-- Índice para la Consulta 5: Nombre del alimento junto con su tipo de snack o sabor de bebida
CREATE INDEX idx_encargo_alimento_nombre ON encargo_alimento(encNombre_Alimento);
-- CREATE INDEX idx_alimento_nombre ON alimento(almNombre_Alimento);
CREATE INDEX idx_snack_nombre ON snack(snaNombre_Alimento);
CREATE INDEX idx_bebida_nombre ON bebida(bebNombre_Alimento);

-- Índice para la Consulta 6: Funciones de cine con mayor % de ocupación
CREATE INDEX idx_funcion_funcion_id ON funcion(funId_Funcion);
-- CREATE INDEX idx_boleta_funcion ON boleta(bolId_Funcion);
CREATE INDEX idx_sala_funcion ON sala(salNumero_Sala, salNombre_Sede);

-- Índice para la Consulta 7: Empleados con más ventas registradas
CREATE INDEX idx_detalle_venta_empleado ON detalle_venta(detId_Empleado);
CREATE INDEX idx_empleado_id ON empleado(empId_Empleado);

-- Índice para la Consulta 8: Total de ventas por año y mes de los últimos 6 meses
-- CREATE INDEX idx_boleta_fecha ON boleta(bolFechaCompra);
-- CREATE INDEX idx_detalle_venta_fecha ON detalle_venta(detId_Detalle_Venta);
-- CREATE INDEX idx_encargo_alimento_fecha ON encargo_alimento(encId_Detalle_Venta);

-- Índice para la Consulta 9: Historial de compras de un cliente
-- CREATE INDEX idx_boleta_cliente ON boleta(bolId_Cliente);
-- CREATE INDEX idx_funcion_id ON funcion(funId_Funcion);
CREATE INDEX idx_pelicula_nombre ON pelicula(pelNombre_Pelicula);
CREATE INDEX idx_silla_id ON silla(silID_Silla);


-- Índice para la Consulta 10: Funciones con más ingresos generados por sede
-- CREATE INDEX idx_funcion_id ON funcion(funId_Funcion);
-- CREATE INDEX idx_boleta_funcion ON boleta(bolId_Funcion);
-- CREATE INDEX idx_detalle_venta_id ON detalle_venta(detId_Detalle_Venta);
-- CREATE INDEX idx_encargo_alimento_id ON encargo_alimento(encId_Detalle_Venta);

-- NOTA: se definieron los indices que sirven para cada consulta. Los que están seleccionados como comentarios es porque ya están previamente declarados; es decir, sirven para varias consultas y se tachan para que no de error la ejecucion del script

-- Justificaciones:
-- 1. Historial de compras detallado con precios y asientos: Indexar 'boleta' en 'bolId_Cliente', 'bolId_Funcion', y 'bolId_Silla' acelerará las uniones y el filtrado.
-- 2. Clientes con más de 3 compras en el último mes y su tipo de membresía: Indexar 'boleta' en 'bolId_Cliente' y 'bolFechaCompra', junto con indexar 'cliente' y 'suscripcion' en sus IDs, acelerará el filtrado y las uniones.
-- 3. Productos más vendidos en la confitería según categoría: Indexar 'encargo_alimento' en 'encId_Detalle_Venta', 'alimento' en 'almNombre_Alimento', y 'detalle_venta' y 'boleta' en sus respectivos IDs acelerará las uniones y el filtrado necesarios.
-- 4. Nombre, correo e información de suscripción y membresía de cada cliente: Indexar 'cliente', 'suscripcion' y 'detalle_venta' en las claves foráneas relevantes acelerará las uniones.
-- 5. Nombre del alimento junto con su tipo de snack o sabor de bebida: Indexar 'encargo_alimento', 'alimento', 'snack' y 'bebida' en sus respectivos nombres acelerará las uniones y el agrupamiento.
-- 6. Funciones de cine con mayor % de ocupación: Indexar 'funcion', 'boleta' y 'sala' en sus claves foráneas acelerará las uniones y el agrupamiento.
-- 7. Empleados con más ventas registradas: Indexar 'detalle_venta' en 'detId_Empleado' y 'empleado' en 'empId_Empleado' acelerará las uniones y las agregaciones.
-- 8. Total de ventas por año y mes de los últimos 6 meses: Indexar 'boleta', 'detalle_venta' y 'encargo_alimento' en sus respectivas columnas de fecha acelerará el filtrado y el agrupamiento.
-- 9. Historial de compras de un cliente: Indexar 'boleta' en 'bolId_Cliente', 'funcion' en 'funId_Funcion', 'pelicula' en 'pelNombre_Pelicula', 'silla' en 'silID_Silla', 'detalle_venta' en 'detId_Detalle_Venta', y 'encargo_alimento' en 'encId_Detalle_Venta' acelerará las uniones y las agregaciones complejas.
-- 10. Funciones con más ingresos generados por sede: Indexar 'funcion', 'boleta', 'detalle_venta' y 'encargo_alimento' en sus respectivas claves foráneas acelerará las uniones y las agregaciones.
