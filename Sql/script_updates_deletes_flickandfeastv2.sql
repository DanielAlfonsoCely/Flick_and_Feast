-- actualizaciones

UPDATE cargo
SET carSueldo = 1600000
WHERE carId_Cargo = 'Seguridad';

UPDATE cliente
SET cliCorreo = 'nuevo_correo@example.com'
WHERE cliId_Cliente = 1001;

UPDATE silla
SET silTipo_silla = 'VIP'
WHERE silNumero_Sala = 1 AND silNombre_Sede = 'Salitre';

UPDATE proveedor
SET proDireccion = 'Nueva Calle 123'
WHERE proNombre_Proveedor = 'Pepsico';

UPDATE pelicula
SET pelDuracion = '02:30:00'
WHERE pelNombre_Pelicula = 'Inception';

UPDATE horario
SET horEntrada = '09:00:00', horSalida = '18:00:00'
WHERE horId_Trabajador = 1050 AND horDia = 'Lunes';

UPDATE alimento
SET almPrecio = 4500
WHERE almNombre_Alimento = 'Chocolate Jumbo' AND almNombre_Proveedor = 'Pepsico';

UPDATE suscripcion
SET susNombre_Membresia = 'Gold'
WHERE susId_Cliente = 1001;


-- borrados

DELETE FROM telefono
WHERE telNumero = 3011234567;

DELETE FROM suscripcion
WHERE susId_Cliente = 1001 AND susNombre_Membresia = 'Basic';

DELETE FROM boleta
WHERE bolId_Boleta = 1;

DELETE FROM funcion
WHERE funId_Funcion = 101;