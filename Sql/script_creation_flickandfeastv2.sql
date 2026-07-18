DROP SCHEMA IF EXISTS flickandfeastv2;

CREATE SCHEMA IF NOT EXISTS flickandfeastv2;

USE flickandfeastv2;
DROP TABLE IF EXISTS suscripcion;
DROP TABLE IF EXISTS boleta;
DROP TABLE IF EXISTS funcion;
DROP TABLE IF EXISTS silla;
DROP TABLE IF EXISTS sala;
DROP TABLE IF EXISTS membresia;
DROP TABLE IF EXISTS pelicula;
DROP TABLE IF EXISTS telefono;
DROP TABLE IF EXISTS encargo_alimento;
DROP TABLE IF EXISTS detalle_venta;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS sede;
DROP TABLE IF EXISTS gerente;
DROP TABLE IF EXISTS horario;
DROP TABLE IF EXISTS trabajador;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS bebida;
DROP TABLE IF EXISTS snack;
DROP TABLE IF EXISTS alimento;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS proveedor;



CREATE TABLE proveedor(
 proNombre_Proveedor VARCHAR(45) PRIMARY KEY,
 proDireccion VARCHAR(45) NOT NULL,
 proCorreo VARCHAR(45) NOT NULL
);

CREATE TABLE cargo(
 carId_Cargo VARCHAR(45) PRIMARY KEY,
 carSueldo INT NOT NULL
);

CREATE TABLE alimento(
 almNombre_Alimento VARCHAR(45),
 almNombre_Proveedor VARCHAR(45),
 almPrecio INT NOT NULL,
 almTamaño VARCHAR(45) NOT NULL,
 almEmpaque VARCHAR(45) NOT NULL,
 PRIMARY KEY (almNombre_Alimento, almNombre_Proveedor),
 FOREIGN KEY (almNombre_Proveedor) REFERENCES proveedor(proNombre_Proveedor)
);

CREATE TABLE snack(
 snaNombre_Alimento VARCHAR(45),
 snaNombre_Proveedor VARCHAR(45),
 snaTipo VARCHAR(45) NOT NULL,
 PRIMARY KEY (snaNombre_Alimento, snaNombre_Proveedor),
 FOREIGN KEY (snaNombre_Alimento) REFERENCES alimento(almNombre_Alimento),
 FOREIGN KEY (snaNombre_Proveedor) REFERENCES alimento(almNombre_Proveedor)
);

CREATE TABLE bebida(
 bebNombre_Alimento VARCHAR(45),
 bebNombre_Proveedor VARCHAR(45),
 bebSabor VARCHAR(45) NOT NULL,
 PRIMARY KEY (bebNombre_Alimento, bebNombre_Proveedor),
 FOREIGN KEY (bebNombre_Alimento) REFERENCES alimento(almNombre_Alimento),
 FOREIGN KEY (bebNombre_Proveedor) REFERENCES alimento(almNombre_Proveedor)
);

CREATE TABLE cliente(
 cliId_Cliente INT PRIMARY KEY,
 cliNombre VARCHAR(45) NULL,
 cliCorreo VARCHAR(45) NULL,
 cliDireccion VARCHAR(45) NULL,
 cliPuntos INT NULL,
 cliTipo VARCHAR(45) NULL
);

CREATE TABLE trabajador(
 traId_Trabajador INT PRIMARY KEY,
 traId_Cargo VARCHAR(45) NOT NULL,
 traNombre VARCHAR(45) NOT NULL,
 traApellido VARCHAR(45) NOT NULL,
 traDireccion VARCHAR(45) NOT NULL,
 FOREIGN KEY (traId_Cargo) REFERENCES cargo(carId_Cargo)
);

CREATE TABLE horario(
 horId_Trabajador INT,
 horDia VARCHAR(45),
 horEntrada TIME NOT NULL,
 horSalida TIME NOT NULL,
 PRIMARY KEY (horId_Trabajador, horDia),
 FOREIGN KEY (horId_Trabajador) REFERENCES trabajador(traId_Trabajador)
);

CREATE TABLE gerente(
 gerId_Gerente INT PRIMARY KEY,
 gerNumero_Empleados_Encargados INT NOT NULL,
 FOREIGN KEY (gerId_Gerente) REFERENCES trabajador(traId_Trabajador)
);

CREATE TABLE sede(
 sedNombre_Sede VARCHAR(45) PRIMARY KEY,
 sedUbicacion VARCHAR(45) NOT NULL,
 sedCapacidad INT NOT NULL,
 sedId_Gerente INT NOT NULL,
 FOREIGN KEY (sedId_Gerente) REFERENCES gerente(gerId_Gerente)
);

CREATE TABLE empleado(
 empId_Empleado INT PRIMARY KEY,
 empId_Gerente INT NOT NULL,
 empSeccion_Encargada VARCHAR(45) NOT NULL,
 FOREIGN KEY (empId_Gerente) REFERENCES gerente(gerId_Gerente)
);

CREATE TABLE detalle_venta(
 detId_Detalle_Venta INT PRIMARY KEY,
 detId_Cliente INT NOT NULL,
 detId_Empleado INT NOT NULL,
 detTipo_Servicio VARCHAR(45) NOT NULL,
 detMetodo_Pago VARCHAR(45) NOT NULL,
 detUnidades_Boleta INT NOT NULL,
 detPrecioTotal INT NOT NULL,
 FOREIGN KEY (detId_Cliente) REFERENCES cliente(cliId_Cliente),
 FOREIGN KEY (detId_Empleado) REFERENCES empleado(empId_Empleado)
);

CREATE TABLE encargo_alimento(
 encId_Detalle_Venta INT,
 encNombre_Alimento VARCHAR(45),
 encNombre_Proveedor VARCHAR(45),
 encUnidades INT NOT NULL,
 encPrecio INT NOT NULL,
 PRIMARY KEY (encId_Detalle_Venta, encNombre_Alimento, encNombre_Proveedor),
 FOREIGN KEY (encId_Detalle_Venta) REFERENCES detalle_venta(detId_Detalle_Venta),
 FOREIGN KEY (encNombre_Alimento) REFERENCES alimento(almNombre_Alimento),
 FOREIGN KEY (encNombre_Proveedor) REFERENCES alimento(almNombre_Proveedor)
);

CREATE TABLE telefono(
 telNumero BIGINT PRIMARY KEY,
 telTipo VARCHAR(45) NULL,
 telId_Cliente INT NULL,
 telId_Trabajador INT NULL,
 telNombre_Sede VARCHAR(45) NULL,
 telNombre_Proveedor VARCHAR(45) NULL,
 FOREIGN KEY (telId_Cliente) REFERENCES cliente(cliId_Cliente),
 FOREIGN KEY (telId_Trabajador) REFERENCES trabajador(traId_Trabajador),
 FOREIGN KEY (telNombre_Sede) REFERENCES sede(sedNombre_Sede),
 FOREIGN KEY (telNombre_Proveedor) REFERENCES proveedor(proNombre_Proveedor)
);

CREATE TABLE pelicula(
 pelNombre_Pelicula VARCHAR(45) PRIMARY KEY,
 pelGenero VARCHAR(45) NOT NULL,
 pelDuracion TIME NOT NULL,
 pelClasificacion VARCHAR(45) NOT NULL,
 pelFechaLanzamiento DATE NOT NULL
);

CREATE TABLE membresia(
 memNombre_Membresia VARCHAR(45) PRIMARY KEY,
 memBeneficio VARCHAR(45) NOT NULL,
 memPrecio_Anual INT NOT NULL
);

CREATE TABLE sala(
 salNumero_Sala INT,
 salNombre_Sede VARCHAR(45),
 salCapacidadGeneral INT NOT NULL,
 salCapacidadPreferencial INT NOT NULL,
 salCapacidadTotal INT NOT NULL,
 salTipo VARCHAR(45) NOT NULL,
 PRIMARY KEY(salNumero_Sala, salNombre_Sede),
 FOREIGN KEY (salNombre_Sede) REFERENCES sede(sedNombre_Sede),
 CHECK (salCapacidadTotal = salCapacidadGeneral + salCapacidadPreferencial)
);

CREATE TABLE silla(
 silId_Silla INT,
 silNumero_Sala INT,
 silNombre_Sede VARCHAR(45),
 silTipo_silla VARCHAR(45) NOT NULL,
 silPrecio_Silla INT NOT NULL,
 PRIMARY KEY(silId_Silla, silNumero_Sala, silNombre_Sede),
 FOREIGN KEY (silNumero_Sala) REFERENCES sala(salNumero_Sala),
 FOREIGN KEY (silNombre_Sede) REFERENCES sede(sedNombre_Sede)
);

CREATE TABLE funcion(
 funId_Funcion INT PRIMARY KEY,
 funNombre_Pelicula VARCHAR(45) NOT NULL,
 funNumero_Sala INT NOT NULL,
 funNombre VARCHAR(45) NOT NULL,
 funHoraInicio TIME NOT NULL,
 funHoraFin TIME NOT NULL,
 funDuracion TIME NOT NULL,
 funFecha DATETIME NOT NULL,
 FOREIGN KEY (funNombre_Pelicula) REFERENCES pelicula(pelNombre_Pelicula),
 FOREIGN KEY (funNumero_Sala) REFERENCES sala(salNumero_Sala),
 FOREIGN KEY (funNombre) REFERENCES sala(salNombre_Sede)
);

CREATE TABLE boleta(
 bolId_Boleta INT PRIMARY KEY,
 bolId_Detalle_Venta INT NOT NULL,
 bolId_Cliente INT NOT NULL,
 bolId_Funcion INT NOT NULL,
 bolNombre_Sede VARCHAR(45) NOT NULL,
 bolNumero_Sala INT NOT NULL,
 bolId_Silla INT NOT NULL,
 bolPrecio INT NOT NULL,
 bolFechaCompra DATETIME NOT NULL,
 bolTipo VARCHAR(45) NOT NULL,
 FOREIGN KEY (bolId_Detalle_Venta) REFERENCES detalle_venta(detId_Detalle_Venta),
 FOREIGN KEY (bolId_Cliente) REFERENCES cliente(cliId_Cliente),
 FOREIGN KEY (bolId_Funcion) REFERENCES funcion(funId_Funcion),
 FOREIGN KEY (bolNombre_Sede) REFERENCES silla(silNombre_Sede),
 FOREIGN KEY (bolNumero_Sala) REFERENCES silla(silNumero_Sala),
 FOREIGN KEY (bolId_Silla) REFERENCES silla(silId_Silla)
);

CREATE TABLE suscripcion(
 susId_Cliente INT PRIMARY KEY,
 susNombre_Membresia VARCHAR(45) NOT NULL,
 susFecha_Inicio DATE NOT NULL,
 susFecha_Expiracion DATE NOT NULL,
 FOREIGN KEY (susId_Cliente) REFERENCES cliente(cliId_Cliente),
 FOREIGN KEY (susNombre_Membresia) REFERENCES membresia(memNombre_Membresia)
);


