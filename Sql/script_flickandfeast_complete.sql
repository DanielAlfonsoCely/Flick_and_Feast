DROP SCHEMA IF EXISTS flickandfeastv2;
-- Creacion
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


-- Insercion

-- Proveedores:
SELECT * FROM proveedor;
INSERT INTO proveedor VALUES ("Pepsico", "Calle 69 #19-69", "Colombia.fritolay@pepsico.com");
INSERT INTO proveedor VALUES ("Maiz Kernel", "Calle 17 A 68 D 44" ,"contacto@maizkernel.co");

-- Cargos:
SELECT * FROM cargo;
INSERT INTO cargo VALUES ("Seguridad", "1423500");
INSERT INTO cargo VALUES ("Vigilancia", "1423500");
INSERT INTO cargo VALUES ("Aseo", "1423500");
INSERT INTO cargo VALUES ("Mantenimiento", 2300000);
INSERT INTO cargo VALUES ("Cocineria", 3000000);
INSERT INTO cargo VALUES ("Cajero", "1600000");
INSERT INTO cargo VALUES ("Gerencia", 7000000);
INSERT INTO cargo VALUES ("Administrador", 4000000);


-- Alimentos:
SELECT * FROM alimento;
INSERT INTO alimento VALUES ("Chocolate Jumbo", "Pepsico", "4000", "Pequeño", "Plástico");
INSERT INTO alimento VALUES ("Doritos Nacho", "Pepsico", "5000", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Gatorade Limón", "Pepsico", "6000", "Grande", "Plástico");
INSERT INTO alimento VALUES ("Cheetos Queso", "Pepsico", "4500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Pepsi", "Pepsico", "2500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("7UP", "Pepsico", "2500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Ruffles", "Pepsico", "5000", "Grande", "Plástico");
INSERT INTO alimento VALUES ("Popetas Dulces", "Maiz Kernel", "3000", "Pequeño", "Plástico");
INSERT INTO alimento VALUES ("Maíz Pira Natural", "Maiz Kernel", "3500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Maíz Pira Queso", "Maiz Kernel", "4000", "Grande", "Plástico");
INSERT INTO alimento VALUES ("Choclitos BBQ", "Maiz Kernel", "3500", "Mediano", "Plástico");

INSERT INTO alimento VALUES ("Agua Mineral", "Pepsico", "2000", "Pequeño", "Plástico");
INSERT INTO alimento VALUES ("Lipton Té", "Pepsico", "3500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Mountain Dew", "Pepsico", "4500", "Grande", "Plástico");
INSERT INTO alimento VALUES ("Aquafina", "Pepsico", "1500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Mirinda", "Pepsico", "2500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Sierra Mist", "Pepsico", "2500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Té Lipton Limón", "Pepsico", "3500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Agua Tónica", "Pepsico", "3000", "Pequeño", "Plástico");
INSERT INTO alimento VALUES ("Pepsi Light", "Pepsico", "2500", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Jugos Kapo Naranja", "Maiz Kernel", "3000", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Jugos Kapo Mango", "Maiz Kernel", "3000", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Jugos Kapo Fresa", "Maiz Kernel", "3000", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Jugos Kapo Uva", "Maiz Kernel", "3000", "Mediano", "Plástico");
INSERT INTO alimento VALUES ("Freskaleche", "Maiz Kernel", "2500", "Pequeño", "Plástico");
INSERT INTO alimento VALUES ("Leche Saborizada", "Maiz Kernel", "3500", "Mediano", "Plástico");

-- Snacks:
SELECT * FROM snack;
INSERT INTO snack VALUES ("Chocolate Jumbo", "Pepsico", "Dulce");
INSERT INTO snack VALUES ("Doritos Nacho", "Pepsico", "Salado");
INSERT INTO snack VALUES ("Cheetos Queso", "Pepsico", "Salado");
INSERT INTO snack VALUES ("Ruffles", "Pepsico", "Salado");
INSERT INTO snack VALUES ("Popetas Dulces", "Maiz Kernel", "Dulce");
INSERT INTO snack VALUES ("Maíz Pira Natural", "Maiz Kernel", "Salado");
INSERT INTO snack VALUES ("Maíz Pira Queso", "Maiz Kernel", "Salado");
INSERT INTO snack VALUES ("Choclitos BBQ", "Maiz Kernel", "Salado");

-- Bebidas:
SELECT * FROM bebida;
INSERT INTO bebida VALUES ("Gatorade Limón", "Pepsico", "Limón");
INSERT INTO bebida VALUES ("Pepsi", "Pepsico", "Cola");
INSERT INTO bebida VALUES ("7UP", "Pepsico", "Limonada");
INSERT INTO bebida VALUES ("Agua Mineral", "Pepsico", "Mineral");
INSERT INTO bebida VALUES ("Lipton Té", "Pepsico", "Té");
INSERT INTO bebida VALUES ("Mountain Dew", "Pepsico", "Cítricos");
INSERT INTO bebida VALUES ("Aquafina", "Pepsico", "Agua");
INSERT INTO bebida VALUES ("Mirinda", "Pepsico", "Naranja");
INSERT INTO bebida VALUES ("Sierra Mist", "Pepsico", "Limonada");
INSERT INTO bebida VALUES ("Té Lipton Limón", "Pepsico", "Limón");
INSERT INTO bebida VALUES ("Agua Tónica", "Pepsico", "Tónica");
INSERT INTO bebida VALUES ("Pepsi Light", "Pepsico", "Cola Light");
INSERT INTO bebida VALUES ("Jugos Kapo Naranja", "Maiz Kernel", "Naranja");
INSERT INTO bebida VALUES ("Jugos Kapo Mango", "Maiz Kernel", "Mango");
INSERT INTO bebida VALUES ("Jugos Kapo Fresa", "Maiz Kernel", "Fresa");
INSERT INTO bebida VALUES ("Jugos Kapo Uva", "Maiz Kernel", "Uva");
INSERT INTO bebida VALUES ("Freskaleche", "Maiz Kernel", "Leche");
INSERT INTO bebida VALUES ("Leche Saborizada", "Maiz Kernel", "Leche Saborizada");

-- Clientes:
SELECT * FROM cliente;
INSERT INTO cliente VALUES ("1000", "Juan Diego Rozo", "jurozoa@unal.edu.co", "Calle 7 #5-51", null, null);

INSERT INTO cliente VALUES (1001, 'Juan Perez', NULL, NULL, NULL, NULL);
INSERT INTO cliente VALUES (1002, 'Maria Lopez', 'maria.lopez@example.com', 'Avenida Siempre Viva 456', 200, 'VIP');
INSERT INTO cliente VALUES (1003, 'Carlos Gomez', NULL, NULL, NULL, 'Basic');
INSERT INTO cliente VALUES (1004, 'Ana Torres', 'ana.torres@example.com', NULL, 180, 'General');
INSERT INTO cliente VALUES (1005, 'Luis Martinez', NULL, 'Calle Las Flores 101', 220, 'Advanced');
INSERT INTO cliente VALUES (1006, 'Laura Sanchez', 'laura.sanchez@example.com', NULL, 250, 'VIP');
INSERT INTO cliente VALUES (1007, 'Jose Ramirez', NULL, NULL, NULL, NULL);
INSERT INTO cliente VALUES (1008, 'Elena Hernandez', 'elena.hernandez@example.com', 'Plaza Mayor 202', NULL, 'Basic');
INSERT INTO cliente VALUES (1009, 'Miguel Jimenez', 'miguel.jimenez@example.com', NULL, 130, 'General');
INSERT INTO cliente VALUES (1036, 'Natalia Castillo', NULL, 'Calle del Sol 303', 110, 'VIP');
INSERT INTO cliente VALUES (1011, 'Diego Moreno', 'diego.moreno@example.com', NULL, NULL, 'Advanced');
INSERT INTO cliente VALUES (1012, 'Andrea Vega', NULL, NULL, NULL, NULL);
INSERT INTO cliente VALUES (1013, 'Ricardo Luna', 'ricardo.luna@example.com', 'Boulevard de la Paz 505', NULL, 'General');
INSERT INTO cliente VALUES (1014, 'Paula Ortega', 'paula.ortega@example.com', NULL, 190, 'VIP');
INSERT INTO cliente VALUES (1015, 'Fernando Aguilar', NULL, NULL, NULL, NULL);
INSERT INTO cliente VALUES (1016, 'Cristina Gutierrez', 'cristina.gutierrez@example.com', NULL, 210, 'Advanced');
INSERT INTO cliente VALUES (1017, 'Jorge Delgado', NULL, NULL, NULL, NULL);
INSERT INTO cliente VALUES (1018, 'Sofia Reyes', 'sofia.reyes@example.com', 'Calle San Juan 808', 230, 'VIP');
INSERT INTO cliente VALUES (1019, 'Manuel Cabrera', NULL, NULL, 170, 'General');
INSERT INTO cliente VALUES (1037, 'Gabriela Marquez', 'gabriela.marquez@example.com', 'Plaza San Miguel 909', 140, 'Basic');
INSERT INTO cliente VALUES (1021, 'Roberto Paredes', NULL, 'Calle del Rio 1010', 120, 'General');
INSERT INTO cliente VALUES (1022, 'Valentina Ruiz', 'valentina.ruiz@example.com', NULL, 240, 'VIP');
INSERT INTO cliente VALUES (1023, 'Hector Salazar', NULL, 'Avenida Central 1111', 260, 'Advanced');
INSERT INTO cliente VALUES (1024, 'Isabel Campos', 'isabel.campos@example.com', NULL, NULL, 'General');
INSERT INTO cliente VALUES (1025, 'Emilio Fuentes', NULL, 'Calle Angosta 1313', 130, 'VIP');
INSERT INTO cliente VALUES (1026, 'Monica Espinosa', 'monica.espinosa@example.com', NULL, NULL, 'General');
INSERT INTO cliente VALUES (1027, 'Vicente Castro', NULL, 'Avenida del Lago 1414', 150, 'Basic');
INSERT INTO cliente VALUES (1028, 'Teresa Romero', 'teresa.romero@example.com', 'Calle Alta 1515', NULL, 'VIP');
INSERT INTO cliente VALUES (1029, 'Alberto Peña', NULL, 'Boulevard Norte 1616', 140, 'Advanced');
INSERT INTO cliente VALUES (1038, 'Patricia Rivas', 'patricia.rivas@example.com', NULL, 220, 'Basic');
INSERT INTO cliente VALUES (1031, 'Enrique Campos', NULL, 'Calle Baja 1717', 160, 'General');
INSERT INTO cliente VALUES (1032, 'Marta Ortiz', 'marta.ortiz@example.com', NULL, 180, 'VIP');
INSERT INTO cliente VALUES (1033, 'Federico Chavez', NULL, 'Avenida del Mar 1818', 200, 'Advanced');
INSERT INTO cliente VALUES (1034, 'Angela Velez', 'angela.velez@example.com', 'Plaza Mayor 1919', NULL, 'General');
INSERT INTO cliente VALUES (1035, 'Raul Mendoza', NULL, 'Boulevard de las Rosas 2020', 210, 'VIP');



-- Trabajadores:
SELECT * FROM trabajador;
INSERT INTO trabajador  VALUES ("1010", "Gerencia", "Gustavo Adolfo", "Nieto Clavijo", "Calle 198 #7-15");
INSERT INTO trabajador  VALUES ("1020", "Gerencia", "Pedro", "Perez", "Calle 8 #74-5");
INSERT INTO trabajador  VALUES ("1030", "Gerencia", "María", "Rodríguez", "Calle 18 #3-75");
INSERT INTO trabajador  VALUES ("1040", "Gerencia", "Juan", "Gonzales", "Calle 98 #79-1");
INSERT INTO trabajador  VALUES ("1050", "Gerencia", "Edwin", "Velasquez", "Calle 99 %73-21 B");
INSERT INTO trabajador  VALUES (1041, "Administrador", "José", "Fuentes", "Carrera 260 #270-280");
INSERT INTO trabajador  VALUES (1042, "Administrador", "Camila", "León", "Avenida 130 #140-150");
INSERT INTO trabajador  VALUES (1043, "Seguridad", "Alberto", "Mendoza", "Calle 270 #280-290");
INSERT INTO trabajador  VALUES (1044, "Vigilancia", "Beatriz", "Herrera", "Carrera 280 #290-300");
INSERT INTO trabajador  VALUES (1045, "Aseo", "César", "Aguilar", "Avenida 140 #150-160");
INSERT INTO trabajador  VALUES (1046, "Mantenimiento", "Diana", "Paredes", "Calle 290 #300-310");
INSERT INTO trabajador  VALUES (1047, "Cocineria", "Eduardo", "Cabrera", "Carrera 300 #310-320");
INSERT INTO trabajador  VALUES (1048, "Cajero", "Fabiola", "Peña", "Avenida 150 #160-170");
INSERT INTO trabajador  VALUES (1049, "Administrador", "Gerardo", "Cárdenas", "Calle 310 #320-330");
INSERT INTO trabajador  VALUES (1051, "Cajero", "Lorena", "Gómez", "Calle 11 #21-31");
INSERT INTO trabajador  VALUES (1052, "Cajero", "Ricardo", "López", "Carrera 16 #26-36");
INSERT INTO trabajador  VALUES (1053, "Cajero", "Fernanda", "Martínez", "Avenida 6 #13-46");
INSERT INTO trabajador  VALUES (1054, "Cajero", "Oscar", "Rodríguez", "Calle 21 #31-41");
INSERT INTO trabajador  VALUES (1055, "Cajero", "Lucía", "Hernández", "Carrera 26 #36-51");
INSERT INTO trabajador  VALUES (1056, "Cajero", "Julián", "Díaz", "Avenida 11 #16-26");
INSERT INTO trabajador  VALUES (1057, "Cajero", "Valeria", "Sánchez", "Calle 31 #41-51");
INSERT INTO trabajador  VALUES (1058, "Cajero", "Mateo", "Fernández", "Carrera 41 #51-61");
INSERT INTO trabajador  VALUES (1059, "Cajero", "Daniela", "García", "Avenida 21 #26-36");
INSERT INTO trabajador  VALUES (1060, "Cajero", "Santiago", "Pérez", "Calle 51 #61-71");
INSERT INTO trabajador  VALUES (1061, "Cajero", "Mariana", "Torres", "Carrera 61 #71-81");
INSERT INTO trabajador  VALUES (1062, "Cajero", "Alejandro", "Ruiz", "Avenida 31 #41-51");
INSERT INTO trabajador  VALUES (1063, "Cocineria", "Carmen", "Jiménez", "Calle 71 #81-91");
INSERT INTO trabajador  VALUES (1064, "Cocineria", "Roberto", "Moreno", "Carrera 81 #91-101");
INSERT INTO trabajador  VALUES (1065, "Cocineria", "Patricia", "Álvarez", "Avenida 41 #51-61");
INSERT INTO trabajador  VALUES (1066, "Cocineria", "Felipe", "Romero", "Calle 91 #101-111");
INSERT INTO trabajador  VALUES (1067, "Cocineria", "Adriana", "Navarro", "Carrera 101 #111-121");
INSERT INTO trabajador  VALUES (1068, "Cocineria", "Diego", "Molina", "Avenida 51 #61-71");
INSERT INTO trabajador  VALUES (1069, "Cocineria", "Gabriela", "Ortega", "Calle 111 #121-131");
INSERT INTO trabajador  VALUES (1070, "Cocineria", "Jorge", "Delgado", "Carrera 121 #131-141");
INSERT INTO trabajador  VALUES (1071, "Cocineria", "Sofía", "Castro", "Avenida 61 #71-81");
INSERT INTO trabajador  VALUES (1072, "Cocineria", "Luis", "Vargas", "Calle 131 #141-151");
INSERT INTO trabajador  VALUES (1073, "Mantenimiento", "Ana", "Reyes", "Carrera 141 #151-161");
INSERT INTO trabajador  VALUES (1074, "Mantenimiento", "Carlos", "Guerrero", "Avenida 71 #81-91");
INSERT INTO trabajador  VALUES (1075, "Mantenimiento", "Marta", "Luna", "Calle 151 #161-171");
INSERT INTO trabajador  VALUES (1076, "Mantenimiento", "Pedro", "Ríos", "Carrera 161 #171-181");
INSERT INTO trabajador  VALUES (1077, "Mantenimiento", "Lucía", "Méndez", "Avenida 81 #91-101");
INSERT INTO trabajador  VALUES (1078, "Mantenimiento", "Raúl", "Cortés", "Calle 171 #181-191");
INSERT INTO trabajador  VALUES (1079, "Mantenimiento", "Elena", "Santos", "Carrera 181 #191-201");
INSERT INTO trabajador  VALUES (1080, "Mantenimiento", "Miguel", "Cruz", "Avenida 91 #101-111");
INSERT INTO trabajador  VALUES (1081, "Aseo", "Juan", "Ortiz", "Calle 191 #201-211");
INSERT INTO trabajador  VALUES (1082, "Aseo", "María", "Gutiérrez", "Carrera 201 #211-221");
INSERT INTO trabajador  VALUES (1083, "Aseo", "David", "Ramos", "Avenida 101 #111-121");
INSERT INTO trabajador  VALUES (1084, "Aseo", "Laura", "Flores", "Calle 211 #221-231");
INSERT INTO trabajador  VALUES (1085, "Aseo", "Pablo", "Silva", "Carrera 221 #231-241");
INSERT INTO trabajador  VALUES (1086, "Aseo", "Isabel", "Chávez", "Avenida 111 #121-131");
INSERT INTO trabajador  VALUES (1087, "Aseo", "Andrés", "Rojas", "Calle 231 #241-251");
INSERT INTO trabajador  VALUES (1088, "Aseo", "Patricia", "Campos", "Carrera 241 #251-261");
INSERT INTO trabajador  VALUES (1089, "Seguridad", "Fernando", "Miranda", "Avenida 121 #131-141");
INSERT INTO trabajador  VALUES (1090, "Seguridad", "Sara", "Vega", "Calle 251 #261-271");

-- Horarios:
SELECT * FROM horario;
INSERT INTO horario VALUES (1050, 'Lunes', '08:00', '17:00');
INSERT INTO horario VALUES (1050, 'Miércoles', '09:00', '18:00');
INSERT INTO horario VALUES (1050, 'Viernes', '10:00', '19:00');
INSERT INTO horario VALUES (1030, 'Lunes', '08:30', '17:30');
INSERT INTO horario VALUES (1030, 'Miércoles', '09:30', '18:30');
INSERT INTO horario VALUES (1030, 'Viernes', '10:30', '19:30');
INSERT INTO horario VALUES (1040, 'Lunes', '07:00', '16:00');
INSERT INTO horario VALUES (1040, 'Miércoles', '08:00', '17:00');
INSERT INTO horario VALUES (1040, 'Viernes', '09:00', '18:00');
INSERT INTO horario VALUES (1010, 'Lunes', '09:00', '18:00');
INSERT INTO horario VALUES (1010, 'Miércoles', '10:00', '19:00');
INSERT INTO horario VALUES (1010, 'Viernes', '11:00', '20:00');
INSERT INTO horario VALUES (1020, 'Lunes', '08:00', '17:00');
INSERT INTO horario VALUES (1020, 'Miércoles', '09:00', '18:00');
INSERT INTO horario VALUES (1020, 'Viernes', '10:00', '19:00');
INSERT INTO horario VALUES (1041, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1041, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1041, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1042, 'Martes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1042, 'Jueves', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1042, 'Sábado', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1043, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1043, 'Miércoles', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1043, 'Viernes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1044, 'Martes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1044, 'Jueves', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1044, 'Sábado', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1045, 'Lunes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1045, 'Miércoles', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1045, 'Viernes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1046, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1046, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1046, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1047, 'Lunes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1047, 'Miércoles', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1047, 'Viernes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1048, 'Martes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1048, 'Jueves', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1048, 'Sábado', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1049, 'Lunes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1049, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1049, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1050, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1050, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1050, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1051, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1051, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1051, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1052, 'Martes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1052, 'Jueves', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1052, 'Sábado', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1053, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1053, 'Miércoles', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1053, 'Viernes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1054, 'Martes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1054, 'Jueves', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1054, 'Sábado', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1055, 'Lunes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1055, 'Miércoles', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1055, 'Viernes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1056, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1056, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1056, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1057, 'Lunes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1057, 'Miércoles', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1057, 'Viernes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1058, 'Martes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1058, 'Jueves', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1058, 'Sábado', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1059, 'Lunes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1059, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1059, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1060, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1060, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1060, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1061, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1061, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1061, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1062, 'Martes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1062, 'Jueves', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1062, 'Sábado', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1063, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1063, 'Miércoles', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1063, 'Viernes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1064, 'Martes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1064, 'Jueves', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1064, 'Sábado', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1065, 'Lunes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1065, 'Miércoles', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1065, 'Viernes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1066, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1066, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1066, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1067, 'Lunes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1067, 'Miércoles', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1067, 'Viernes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1068, 'Martes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1068, 'Jueves', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1068, 'Sábado', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1069, 'Lunes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1069, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1069, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1070, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1070, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1070, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1071, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1071, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1071, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1072, 'Martes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1072, 'Jueves', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1072, 'Sábado', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1073, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1073, 'Miércoles', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1073, 'Viernes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1074, 'Martes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1074, 'Jueves', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1074, 'Sábado', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1075, 'Lunes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1075, 'Miércoles', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1075, 'Viernes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1076, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1076, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1076, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1077, 'Lunes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1077, 'Miércoles', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1077, 'Viernes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1078, 'Martes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1078, 'Jueves', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1078, 'Sábado', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1079, 'Lunes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1079, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1079, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1080, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1080, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1080, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1081, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1081, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1081, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1082, 'Martes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1082, 'Jueves', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1082, 'Sábado', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1083, 'Lunes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1083, 'Miércoles', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1083, 'Viernes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1084, 'Martes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1084, 'Jueves', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1084, 'Sábado', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1085, 'Lunes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1085, 'Miércoles', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1085, 'Viernes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1086, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1086, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1086, 'Sábado', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1087, 'Lunes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1087, 'Miércoles', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1087, 'Viernes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1088, 'Martes', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1088, 'Jueves', '07:00:00', '15:00:00');
INSERT INTO horario VALUES (1088, 'Sábado', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1089, 'Lunes', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1089, 'Miércoles', '09:00:00', '17:00:00');
INSERT INTO horario VALUES (1089, 'Viernes', '07:30:00', '15:30:00');
INSERT INTO horario VALUES (1090, 'Martes', '08:00:00', '16:00:00');
INSERT INTO horario VALUES (1090, 'Jueves', '08:30:00', '16:30:00');
INSERT INTO horario VALUES (1090, 'Sábado', '09:00:00', '17:00:00');





-- Gerentes:
SELECT * FROM gerente;
INSERT INTO gerente VALUES ("1010", "20");
INSERT INTO gerente VALUES ("1020", "7");
INSERT INTO gerente VALUES ("1030", "9");
INSERT INTO gerente VALUES ("1040", "12");
INSERT INTO gerente VALUES ("1050", "30");

-- Sedes:
SELECT * FROM sede;
INSERT INTO sede VALUES ("El Libertador", "Calle 9 #10-23", "2100", 1010);
INSERT INTO sede VALUES ("Salitre", "Calle 35 #18-23", "1200", 1020);
INSERT INTO sede VALUES ("Campo Alegre", "Calle 106 #8-39", "3400", 1030);
INSERT INTO sede VALUES ("El Bosque", "Calle 198 #7-23", "2500", 1040);
INSERT INTO sede VALUES ("Ciudad Empirica", "Calle 221 #01-01", "5000", 1050);


-- Empleados:
SELECT * FROM empleado;
-- Gerente con más empleados a cargo (1050)
INSERT INTO empleado VALUES (1041, 1050, 'Sección A');
INSERT INTO empleado VALUES (1042, 1050, 'Sección B');
INSERT INTO empleado VALUES (1043, 1050, 'Sección C');
INSERT INTO empleado VALUES (1044, 1050, 'Sección D');
INSERT INTO empleado VALUES (1045, 1050, 'Sección E');
INSERT INTO empleado VALUES (1046, 1050, 'Sección F');
INSERT INTO empleado VALUES (1047, 1050, 'Sección G');
INSERT INTO empleado VALUES (1048, 1050, 'Sección H');
INSERT INTO empleado VALUES (1049, 1050, 'Sección I');
INSERT INTO empleado VALUES (1050, 1050, 'Sección J');
INSERT INTO empleado VALUES (1051, 1050, 'Sección K');
INSERT INTO empleado VALUES (1052, 1030, 'Sección L');
INSERT INTO empleado VALUES (1053, 1030, 'Sección M');
INSERT INTO empleado VALUES (1054, 1030, 'Sección N');
INSERT INTO empleado VALUES (1055, 1030, 'Sección O');
INSERT INTO empleado VALUES (1056, 1030, 'Sección P');
INSERT INTO empleado VALUES (1057, 1030, 'Sección Q');
INSERT INTO empleado VALUES (1058, 1030, 'Sección R');
INSERT INTO empleado VALUES (1059, 1030, 'Sección S');
INSERT INTO empleado VALUES (1060, 1040, 'Sección T');
INSERT INTO empleado VALUES (1061, 1040, 'Sección U');
INSERT INTO empleado VALUES (1062, 1040, 'Sección V');
INSERT INTO empleado VALUES (1063, 1040, 'Sección W');
INSERT INTO empleado VALUES (1064, 1040, 'Sección X');
INSERT INTO empleado VALUES (1065, 1040, 'Sección Y');
INSERT INTO empleado VALUES (1066, 1040, 'Sección Z');
INSERT INTO empleado VALUES (1067, 1010, 'Sección AA');
INSERT INTO empleado VALUES (1068, 1010, 'Sección BB');
INSERT INTO empleado VALUES (1069, 1010, 'Sección CC');
INSERT INTO empleado VALUES (1070, 1010, 'Sección DD');
INSERT INTO empleado VALUES (1071, 1010, 'Sección EE');
INSERT INTO empleado VALUES (1072, 1020, 'Sección FF');
INSERT INTO empleado VALUES (1073, 1020, 'Sección GG');
INSERT INTO empleado VALUES (1074, 1020, 'Sección HH');
INSERT INTO empleado VALUES (1075, 1020, 'Sección II');
INSERT INTO empleado VALUES (1076, 1020, 'Sección JJ');
INSERT INTO empleado VALUES (1077, 1020, 'Sección KK');
INSERT INTO empleado VALUES (1078, 1020, 'Sección LL');
INSERT INTO empleado VALUES (1079, 1020, 'Sección MM');
INSERT INTO empleado VALUES (1080, 1020, 'Sección NN');
INSERT INTO empleado VALUES (1081, 1020, 'Sección OO');
INSERT INTO empleado VALUES (1082, 1020, 'Sección PP');
INSERT INTO empleado VALUES (1083, 1020, 'Sección QQ');
INSERT INTO empleado VALUES (1084, 1020, 'Sección RR');
INSERT INTO empleado VALUES (1085, 1020, 'Sección SS');
INSERT INTO empleado VALUES (1086, 1020, 'Sección TT');
INSERT INTO empleado VALUES (1087, 1020, 'Sección UU');
INSERT INTO empleado VALUES (1088, 1020, 'Sección VV');
INSERT INTO empleado VALUES (1089, 1020, 'Sección WW');
INSERT INTO empleado VALUES (1090, 1020, 'Sección XX');



-- Detalles de venta:
SELECT * FROM detalle_venta;
-- Insertar registros en detalle_venta
INSERT INTO detalle_venta VALUES (1, 1001, 1050, 'Servicio A', 'Tarjeta de Crédito', 3, 12000);
INSERT INTO detalle_venta VALUES (2, 1002, 1051, 'Servicio B', 'Efectivo', 2, 25000);
INSERT INTO detalle_venta VALUES (3, 1003, 1052, 'Servicio C', 'Tarjeta de Débito', 4, 24000);
INSERT INTO detalle_venta VALUES (4, 1004, 1053, 'Servicio A', 'Transferencia Bancaria', 5, 9000);
INSERT INTO detalle_venta VALUES (5, 1005, 1054, 'Servicio B', 'Tarjeta de Crédito', 1, 12500);
INSERT INTO detalle_venta VALUES (6, 1006, 1055, 'Servicio C', 'Efectivo', 3, 7500);
INSERT INTO detalle_venta VALUES (7, 1007, 1056, 'Servicio A', 'Tarjeta de Débito', 2, 20000);
INSERT INTO detalle_venta VALUES (8, 1008, 1057, 'Servicio B', 'Transferencia Bancaria', 4, 9000);
INSERT INTO detalle_venta VALUES (9, 1009, 1058, 'Servicio C', 'Tarjeta de Crédito', 5, 7000);
INSERT INTO detalle_venta VALUES (10, 1016, 1059, 'Servicio A', 'Efectivo', 3, 20000);
INSERT INTO detalle_venta VALUES (11, 1011, 1060, 'Servicio B', 'Tarjeta de Débito', 2, 14000);
INSERT INTO detalle_venta VALUES (12, 1012, 1050, 'Servicio C', 'Transferencia Bancaria', 1, 9000);
INSERT INTO detalle_venta VALUES (13, 1013, 1051, 'Servicio A', 'Tarjeta de Crédito', 3, 17500);
INSERT INTO detalle_venta VALUES (14, 1014, 1052, 'Servicio B', 'Efectivo', 2, 13500);
INSERT INTO detalle_venta VALUES (15, 1015, 1053, 'Servicio C', 'Tarjeta de Débito', 5, 6000);


-- Encargos Alimentos:
SELECT * FROM encargo_alimento;
-- Insertar registros en encargo_alimento
INSERT INTO encargo_alimento VALUES (1, 'Chocolate Jumbo', 'Pepsico', 3, 12000);
INSERT INTO encargo_alimento VALUES (2, 'Doritos Nacho', 'Pepsico', 5, 25000);
INSERT INTO encargo_alimento VALUES (3, 'Gatorade Limón', 'Pepsico', 4, 24000);
INSERT INTO encargo_alimento VALUES (4, 'Cheetos Queso', 'Pepsico', 2, 9000);
INSERT INTO encargo_alimento VALUES (5, 'Pepsi', 'Pepsico', 5, 12500);
INSERT INTO encargo_alimento VALUES (6, '7UP', 'Pepsico', 3, 7500);
INSERT INTO encargo_alimento VALUES (7, 'Ruffles', 'Pepsico', 4, 20000);
INSERT INTO encargo_alimento VALUES (8, 'Popetas Dulces', 'Maiz Kernel', 3, 9000);
INSERT INTO encargo_alimento VALUES (9, 'Maíz Pira Natural', 'Maiz Kernel', 2, 7000);
INSERT INTO encargo_alimento VALUES (10, 'Maíz Pira Queso', 'Maiz Kernel', 5, 20000);
INSERT INTO encargo_alimento VALUES (11, 'Choclitos BBQ', 'Maiz Kernel', 4, 14000);
INSERT INTO encargo_alimento VALUES (12, 'Jugos Kapo Naranja', 'Maiz Kernel', 3, 9000);
INSERT INTO encargo_alimento VALUES (13, 'Lipton Té', 'Pepsico', 5, 17500);
INSERT INTO encargo_alimento VALUES (14, 'Mountain Dew', 'Pepsico', 3, 13500);
INSERT INTO encargo_alimento VALUES (15, 'Aquafina', 'Pepsico', 4, 6000);

-- Telefonos:
SELECT * FROM telefono;

INSERT INTO telefono VALUES (3011234567, 'Móvil', 1001, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3022345678, 'Móvil', 1002, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3033456789, 'Móvil', 1003, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3044567890, 'Móvil', 1004, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3055678901, 'Móvil', 1005, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3066789012, 'Móvil', 1006, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3077890123, 'Móvil', 1007, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3088901234, 'Móvil', 1008, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3099012345, 'Móvil', 1009, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3100123456, 'Móvil', 1036, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3111234567, 'Móvil', 1011, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3122345678, 'Móvil', 1012, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3133456789, 'Móvil', 1013, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3144567890, 'Móvil', 1014, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3155678901, 'Móvil', 1015, NULL, NULL, NULL);
INSERT INTO telefono VALUES (3166789012, 'Móvil', NULL, 1041, NULL, NULL);
INSERT INTO telefono VALUES (3177890123, 'Móvil', NULL, 1042, NULL, NULL);
INSERT INTO telefono VALUES (3188901234, 'Móvil', NULL, 1043, NULL, NULL);
INSERT INTO telefono VALUES (3199012345, 'Móvil', NULL, 1044, NULL, NULL);
INSERT INTO telefono VALUES (3200123456, 'Móvil', NULL, 1045, NULL, NULL);
INSERT INTO telefono VALUES (3211234567, 'Móvil', NULL, 1046, NULL, NULL);
INSERT INTO telefono VALUES (3222345678, 'Móvil', NULL, 1047, NULL, NULL);
INSERT INTO telefono VALUES (3233456789, 'Móvil', NULL, 1048, NULL, NULL);
INSERT INTO telefono VALUES (3244567890, 'Móvil', NULL, 1049, NULL, NULL);
INSERT INTO telefono VALUES (3255678901, 'Móvil', NULL, 1050, NULL, NULL);
INSERT INTO telefono VALUES (3266789012, 'Móvil', NULL, 1051, NULL, NULL);
INSERT INTO telefono VALUES (3277890123, 'Móvil', NULL, 1052, NULL, NULL);
INSERT INTO telefono VALUES (3288901234, 'Móvil', NULL, 1053, NULL, NULL);
INSERT INTO telefono VALUES (3299012345, 'Móvil', NULL, 1054, NULL, NULL);
INSERT INTO telefono VALUES (3300123456, 'Móvil', NULL, 1055, NULL, NULL);
INSERT INTO telefono VALUES (3311234567, 'Móvil', NULL, 1056, NULL, NULL);
INSERT INTO telefono VALUES (3322345678, 'Móvil', NULL, 1057, NULL, NULL);
INSERT INTO telefono VALUES (3333456789, 'Móvil', NULL, 1058, NULL, NULL);
INSERT INTO telefono VALUES (3344567890, 'Móvil', NULL, 1059, NULL, NULL);
INSERT INTO telefono VALUES (3355678901, 'Móvil', NULL, 1060, NULL, NULL);
INSERT INTO telefono VALUES (3366789012, 'Móvil', NULL, 1061, NULL, NULL);
INSERT INTO telefono VALUES (3377890123, 'Móvil', NULL, 1062, NULL, NULL);
INSERT INTO telefono VALUES (3388901234, 'Móvil', NULL, 1063, NULL, NULL);
INSERT INTO telefono VALUES (3399012345, 'Móvil', NULL, 1064, NULL, NULL);
INSERT INTO telefono VALUES (3400123456, 'Móvil', NULL, 1065, NULL, NULL);
INSERT INTO telefono VALUES (3411234567, 'Móvil', NULL, 1066, NULL, NULL);
INSERT INTO telefono VALUES (3422345678, 'Móvil', NULL, 1067, NULL, NULL);
INSERT INTO telefono VALUES (3433456789, 'Móvil', NULL, 1068, NULL, NULL);
INSERT INTO telefono VALUES (3444567890, 'Móvil', NULL, 1069, NULL, NULL);
INSERT INTO telefono VALUES (3455678901, 'Móvil', NULL, 1070, NULL, NULL);
INSERT INTO telefono VALUES (3466789012, 'Móvil', NULL, 1071, NULL, NULL);
INSERT INTO telefono VALUES (3477890123, 'Móvil', NULL, 1072, NULL, NULL);
INSERT INTO telefono VALUES (3488901234, 'Móvil', NULL, 1073, NULL, NULL);
INSERT INTO telefono VALUES (3499012345, 'Móvil', NULL, 1074, NULL, NULL);
INSERT INTO telefono VALUES (3500123456, 'Móvil', NULL, 1075, NULL, NULL);
INSERT INTO telefono VALUES (3511234567, 'Móvil', NULL, 1076, NULL, NULL);
INSERT INTO telefono VALUES (3522345678, 'Móvil', NULL, 1077, NULL, NULL);
INSERT INTO telefono VALUES (3533456789, 'Móvil', NULL, 1078, NULL, NULL);
INSERT INTO telefono VALUES (3544567890, 'Móvil', NULL, 1079, NULL, NULL);
INSERT INTO telefono VALUES (3555678901, 'Móvil', NULL, 1080, NULL, NULL);
INSERT INTO telefono VALUES (3566789012, 'Móvil', NULL, 1081, NULL, NULL);
INSERT INTO telefono VALUES (3577890123, 'Móvil', NULL, 1082, NULL, NULL);
INSERT INTO telefono VALUES (3588901234, 'Móvil', NULL, 1083, NULL, NULL);
INSERT INTO telefono VALUES (3599012345, 'Móvil', NULL, 1084, NULL, NULL);
INSERT INTO telefono VALUES (3600123456, 'Móvil', NULL, 1085, NULL, NULL);
INSERT INTO telefono VALUES (3611234567, 'Móvil', NULL, 1086, NULL, NULL);
INSERT INTO telefono VALUES (3622345678, 'Móvil', NULL, 1087, NULL, NULL);
INSERT INTO telefono VALUES (3633456789, 'Móvil', NULL, 1088, NULL, NULL);
INSERT INTO telefono VALUES (3644567890, 'Móvil', NULL, 1089, NULL, NULL);
INSERT INTO telefono VALUES (3655678901, 'Móvil', NULL, 1090, NULL, NULL);
INSERT INTO telefono VALUES (3666789012, 'Móvil', NULL, 1010, NULL, NULL);
INSERT INTO telefono VALUES (3677890123, 'Móvil', NULL, 1020, NULL, NULL);
INSERT INTO telefono VALUES (3688901234, 'Móvil', NULL, 1030, NULL, NULL);
INSERT INTO telefono VALUES (3699012345, 'Móvil', NULL, 1040, NULL, NULL);
INSERT INTO telefono VALUES (3700123456, 'Móvil', NULL, 1050, NULL, NULL);
INSERT INTO telefono VALUES (3710123456, 'Móvil', NULL, NULL, NULL, "Pepsico");
INSERT INTO telefono VALUES (3712123456, 'Móvil', NULL, NULL, NULL, "Maiz Kernel");
INSERT INTO telefono VALUES (3701234567, 'Móvil', NULL, 1010, 'El Libertador', NULL);
INSERT INTO telefono VALUES (3712345678, 'Móvil', NULL, 1020, 'Salitre', NULL);
INSERT INTO telefono VALUES (3723456789, 'Móvil', NULL, 1030, 'Campo Alegre', NULL);
INSERT INTO telefono VALUES (3734567890, 'Móvil', NULL, 1040, 'El Bosque', NULL);
INSERT INTO telefono VALUES (3745678901, 'Móvil', NULL, 1050, 'Ciudad Empirica', NULL);





-- Peliculas:
SELECT * FROM pelicula;
INSERT INTO pelicula VALUES ("The Substance", "Horror", "2:20", "R", "2024-09-26");
INSERT INTO pelicula VALUES ("Inception", "Sci-Fi", "2:28:00", "PG-13", "2010-07-16");
INSERT INTO pelicula VALUES ("The Godfather", "Crime", "2:55:00", "R", "1972-03-24");
INSERT INTO pelicula VALUES ("Titanic", "Romance", "3:14:00", "PG-13", "1997-12-19");
INSERT INTO pelicula VALUES ("The Dark Knight", "Action", "2:32:00", "PG-13", "2008-07-18");
INSERT INTO pelicula VALUES ("Forrest Gump", "Drama", "2:22:00", "PG-13", "1994-07-06");
INSERT INTO pelicula VALUES ("Avengers: Endgame", "Action", "3:01:00", "PG-13", "2019-04-26");
INSERT INTO pelicula VALUES ("Parasite", "Thriller", "2:12:00", "R", "2019-05-30");
INSERT INTO pelicula VALUES ("The Shawshank Redemption", "Drama", "2:22:00", "R", "1994-09-23");
INSERT INTO pelicula VALUES ("Pulp Fiction", "Crime", "2:34:00", "R", "1994-10-14");
INSERT INTO pelicula VALUES ("Star Wars: Episode IV", "Sci-Fi", "2:01:00", "PG", "1977-05-25");
INSERT INTO pelicula VALUES ("The Matrix", "Sci-Fi", "2:16:00", "R", "1999-03-31");
INSERT INTO pelicula VALUES ("Jurassic Park", "Adventure", "2:07:00", "PG-13", "1993-06-11");
INSERT INTO pelicula VALUES ("Gladiator", "Action", "2:35:00", "R", "2000-05-05");
INSERT INTO pelicula VALUES ("The Avengers", "Action", "2:23:00", "PG-13", "2012-05-04");
INSERT INTO pelicula VALUES ("Fight Club", "Drama", "2:19:00", "R", "1999-10-15");
INSERT INTO pelicula VALUES ("Interstellar", "Sci-Fi", "2:49:00", "PG-13", "2014-11-07");
INSERT INTO pelicula VALUES ("Back to the Future", "Sci-Fi", "1:56:00", "PG", "1985-07-03");
INSERT INTO pelicula VALUES ("The Lord of the Rings", "Fantasy", "2:58:00", "PG-13", "2001-12-19");
INSERT INTO pelicula VALUES ("The Lion King", "Animation", "1:28:00", "G", "1994-06-24");
INSERT INTO pelicula VALUES ("Saving Private Ryan", "War", "2:49:00", "R", "1998-07-24");
INSERT INTO pelicula VALUES ("Schindler's List", "Drama", "3:15:00", "R", "1993-12-15");
INSERT INTO pelicula VALUES ("Braveheart", "War", "2:58:00", "R", "1995-05-24");
INSERT INTO pelicula VALUES ("The Social Network", "Drama", "2:00:00", "PG-13", "2010-10-01");
INSERT INTO pelicula VALUES ("Toy Story", "Animation", "1:21:00", "G", "1995-11-22");


-- Membresias:
SELECT * FROM membresia;
-- Insertar membresías
INSERT INTO membresia VALUES ('Basic', 'Acceso limitado a recursos', 50000);
INSERT INTO membresia VALUES ('Advanced', 'Acceso premium a recursos', 100000);
INSERT INTO membresia VALUES ('VIP', 'Acceso total a todos los recursos', 150000);

-- Suscripciones:
SELECT * FROM suscripcion;
-- Crear suscripciones
INSERT INTO suscripcion VALUES (1001, 'Basic', '2023-01-01', '2023-12-31');
INSERT INTO suscripcion VALUES (1002, 'VIP', '2023-02-01', '2024-01-31');
INSERT INTO suscripcion VALUES (1003, 'Advanced', '2023-03-01', '2024-02-29');
INSERT INTO suscripcion VALUES (1004, 'Basic', '2023-04-01', '2024-03-31');
INSERT INTO suscripcion VALUES (1005, 'VIP', '2023-05-01', '2024-04-30');
INSERT INTO suscripcion VALUES (1006, 'Advanced', '2023-06-01', '2024-05-31');
INSERT INTO suscripcion VALUES (1007, 'Basic', '2023-07-01', '2024-06-30');
INSERT INTO suscripcion VALUES (1008, 'VIP', '2023-08-01', '2024-07-31');
INSERT INTO suscripcion VALUES (1009, 'Advanced', '2023-09-01', '2024-08-31');
INSERT INTO suscripcion VALUES (1036, 'Basic', '2023-10-01', '2024-09-30');
INSERT INTO suscripcion VALUES (1011, 'VIP', '2023-11-01', '2024-10-31');
INSERT INTO suscripcion VALUES (1012, 'Advanced', '2023-12-01', '2024-11-30');
INSERT INTO suscripcion VALUES (1013, 'Basic', '2024-01-01', '2024-12-31');
INSERT INTO suscripcion VALUES (1014, 'VIP', '2024-02-01', '2025-01-31');
INSERT INTO suscripcion VALUES (1015, 'Advanced', '2024-03-01', '2025-02-28');
INSERT INTO suscripcion VALUES (1016, 'Basic', '2024-04-01', '2025-03-31');
INSERT INTO suscripcion VALUES (1017, 'VIP', '2024-05-01', '2025-04-30');
INSERT INTO suscripcion VALUES (1018, 'Advanced', '2024-06-01', '2025-05-31');

-- Salas:
SELECT * FROM sala;
INSERT INTO sala VALUES ("1","Salitre","100","40","140","2D");
INSERT INTO sala VALUES ("2","Salitre","100","40","140","2D");
INSERT INTO sala VALUES ("3","Salitre","100","40","140","2D");
INSERT INTO sala VALUES ("4","Salitre","50","50","100","3D");
INSERT INTO sala VALUES ("1","El Bosque","200","80","280","2D");
INSERT INTO sala VALUES ("2","El Bosque","200","80","280","2D");
INSERT INTO sala VALUES ("3","El Bosque","200","80","280","2D");
INSERT INTO sala VALUES ("4","El Bosque","150","80","230","3D");
INSERT INTO sala VALUES ("1","El Libertador","120","50","170","2D");
INSERT INTO sala VALUES ("2","El Libertador","120","50","170","2D");
INSERT INTO sala VALUES ("3","El Libertador","120","50","170","2D");
INSERT INTO sala VALUES ("4","El Libertador","80","50","130","3D");
INSERT INTO sala VALUES ("1","Campo Alegre","150","60","210","2D");
INSERT INTO sala VALUES ("2","Campo Alegre","150","60","210","2D");
INSERT INTO sala VALUES ("3","Campo Alegre","150","60","210","2D");
INSERT INTO sala VALUES ("4","Campo Alegre","100","60","160","3D");
INSERT INTO sala VALUES ("1","Ciudad Empirica","180","70","250","2D");
INSERT INTO sala VALUES ("2","Ciudad Empirica","180","70","250","2D");
INSERT INTO sala VALUES ("3","Ciudad Empirica","180","70","250","2D");
INSERT INTO sala VALUES ("4","Ciudad Empirica","120","70","190","3D");


-- Sillas:
SELECT * FROM silla;

INSERT INTO silla VALUES (1, 1, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 1, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 1, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 1, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 1, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 2, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 2, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 2, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 2, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 2, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 3, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 3, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 3, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 3, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 3, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 4, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 4, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 4, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 4, 'Salitre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 4, 'Salitre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 1, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (2, 1, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (3, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 1, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (7, 1, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (8, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 1, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 2, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (2, 2, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (3, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 2, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (7, 2, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (8, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 2, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 3, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (2, 3, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (3, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 3, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (7, 3, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (8, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 3, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 4, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (2, 4, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (3, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 4, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (7, 4, 'El Bosque', 'Regular', 12000);
INSERT INTO silla VALUES (8, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 4, 'El Bosque', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 1, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (2, 1, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (3, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 1, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (7, 1, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (8, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 1, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 2, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (2, 2, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (3, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 2, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (7, 2, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (8, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 2, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 3, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (2, 3, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (3, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 3, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (7, 3, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (8, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 3, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 4, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (2, 4, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (3, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 4, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (7, 4, 'El Libertador', 'Regular', 12000);
INSERT INTO silla VALUES (8, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 4, 'El Libertador', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 1, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 1, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 1, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 1, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 1, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 2, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 2, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 2, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 2, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 2, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 3, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 3, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 3, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 3, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 3, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 4, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (2, 4, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (3, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 4, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (7, 4, 'Campo Alegre', 'Regular', 12000);
INSERT INTO silla VALUES (8, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 4, 'Campo Alegre', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 1, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (2, 1, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (3, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 1, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (7, 1, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (8, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 1, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 2, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (2, 2, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (3, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 2, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (7, 2, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (8, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 2, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 3, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (2, 3, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (3, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 3, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (7, 3, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (8, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 3, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (1, 4, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (2, 4, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (3, 4, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (4, 4, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (5, 4, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (6, 4, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (7, 4, 'Ciudad Empirica', 'Regular', 12000);
INSERT INTO silla VALUES (8, 4, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (9, 4, 'Ciudad Empirica', 'Preferencial', 15000);
INSERT INTO silla VALUES (10, 4, 'Ciudad Empirica', 'Preferencial', 15000);


-- Funciones:

SELECT * FROM funcion;
INSERT INTO funcion VALUES ("101","The Godfather","1","Salitre",'14:30:00','16:30:00','01:47:00','2025-02-10');
INSERT INTO funcion VALUES (102, "The Substance", 1, "Salitre", '10:00:00', '12:20:00', '2:20:00', '2025-02-15 10:00:00');
INSERT INTO funcion VALUES (103, "Inception", 2, "Salitre", '12:30:00', '15:00:00', '2:30:00', '2025-02-15 12:30:00');
INSERT INTO funcion VALUES (104, "The Godfather", 3, "Salitre", '15:30:00', '18:25:00', '2:55:00', '2025-02-15 15:30:00');
INSERT INTO funcion VALUES (105, "Titanic", 4, "Salitre", '18:30:00', '21:44:00', '3:14:00', '2025-02-15 18:30:00');
INSERT INTO funcion VALUES (106, "The Dark Knight", 1, "El Bosque", '10:00:00', '12:32:00', '2:32:00', '2025-02-16 10:00:00');
INSERT INTO funcion VALUES (107, "Forrest Gump", 2, "El Bosque", '12:30:00', '14:52:00', '2:22:00', '2025-02-16 12:30:00');
INSERT INTO funcion VALUES (108, "Avengers: Endgame", 3, "El Bosque", '15:00:00', '18:01:00', '3:01:00', '2025-02-16 15:00:00');
INSERT INTO funcion VALUES (109, "Parasite", 4, "El Bosque", '18:30:00', '20:42:00', '2:12:00', '2025-02-16 18:30:00');
INSERT INTO funcion VALUES (110, "The Shawshank Redemption", 1, "El Libertador", '10:00:00', '12:22:00', '2:22:00', '2025-02-17 10:00:00');
INSERT INTO funcion VALUES (111, "Pulp Fiction", 2, "El Libertador", '12:30:00', '15:04:00', '2:34:00', '2025-02-17 12:30:00');
INSERT INTO funcion VALUES (112, "Star Wars: Episode IV", 3, "El Libertador", '15:30:00', '17:31:00', '2:01:00', '2025-02-17 15:30:00');
INSERT INTO funcion VALUES (113, "The Matrix", 4, "El Libertador", '18:30:00', '20:46:00', '2:16:00', '2025-02-17 18:30:00');
INSERT INTO funcion VALUES (114, "The Lion King", 1, "Campo Alegre", '10:00:00', '11:28:00', '1:28:00', '2025-02-18 10:00:00');
INSERT INTO funcion VALUES (115, "Jurassic Park", 2, "Campo Alegre", '12:00:00', '14:07:00', '2:07:00', '2025-02-18 12:00:00');
INSERT INTO funcion VALUES (116, "Gladiator", 3, "Campo Alegre", '14:30:00', '17:05:00', '2:35:00', '2025-02-18 14:30:00');
INSERT INTO funcion VALUES (117, "The Avengers", 4, "Campo Alegre", '17:30:00', '19:53:00', '2:23:00', '2025-02-18 17:30:00');
INSERT INTO funcion VALUES (118, "Fight Club", 1, "Ciudad Empirica", '10:00:00', '12:19:00', '2:19:00', '2025-02-19 10:00:00');
INSERT INTO funcion VALUES (119, "Interstellar", 2, "Ciudad Empirica", '12:30:00', '15:19:00', '2:49:00', '2025-02-19 12:30:00');
INSERT INTO funcion VALUES (120, "Back to the Future", 3, "Ciudad Empirica", '15:30:00', '17:26:00', '1:56:00', '2025-02-19 15:30:00');
INSERT INTO funcion VALUES (121, "The Lord of the Rings", 4, "Ciudad Empirica", '18:00:00', '20:58:00', '2:58:00', '2025-02-19 18:00:00');
INSERT INTO funcion VALUES (122, "Saving Private Ryan", 1, "El Bosque", '10:00:00', '12:49:00', '2:49:00', '2025-02-20 10:00:00');
INSERT INTO funcion VALUES (123, "Schindler's List", 2, "El Bosque", '13:00:00', '16:15:00', '3:15:00', '2025-02-20 13:00:00');
INSERT INTO funcion VALUES (124, "Braveheart", 3, "El Bosque", '16:30:00', '19:28:00', '2:58:00', '2025-02-20 16:30:00');
INSERT INTO funcion VALUES (125, "The Social Network", 4, "El Bosque", '20:00:00', '22:00:00', '2:00:00', '2025-02-20 20:00:00');
INSERT INTO funcion VALUES (126, "Toy Story", 1, "Salitre", '10:00:00', '11:21:00', '1:21:00', '2025-02-21 10:00:00');
INSERT INTO funcion VALUES (127, "The Dark Knight", 2, "Salitre", '11:30:00', '14:02:00', '2:32:00', '2025-02-21 11:30:00');
INSERT INTO funcion VALUES (128, "Forrest Gump", 3, "Salitre", '14:30:00', '16:52:00', '2:22:00', '2025-02-21 14:30:00');
INSERT INTO funcion VALUES (129, "Avengers: Endgame", 4, "Salitre", '17:00:00', '20:01:00', '3:01:00', '2025-02-21 17:00:00');
INSERT INTO funcion VALUES (130, "Parasite", 1, "El Libertador", '10:00:00', '12:12:00', '2:12:00', '2025-02-22 10:00:00');
INSERT INTO funcion VALUES (131, "The Shawshank Redemption", 2, "El Libertador", '12:30:00', '14:52:00', '2:22:00', '2025-02-22 12:30:00');
INSERT INTO funcion VALUES (132, "Pulp Fiction", 3, "El Libertador", '15:00:00', '17:34:00', '2:34:00', '2025-02-22 15:00:00');
INSERT INTO funcion VALUES (133, "Star Wars: Episode IV", 4, "El Libertador", '18:00:00', '20:01:00', '2:01:00', '2025-02-22 18:00:00');
INSERT INTO funcion VALUES (134, "The Matrix", 1, "Campo Alegre", '10:00:00', '12:16:00', '2:16:00', '2025-02-23 10:00:00');
INSERT INTO funcion VALUES (135, "The Lion King", 2, "Campo Alegre", '12:30:00', '13:58:00', '1:28:00', '2025-02-23 12:30:00');
INSERT INTO funcion VALUES (136, "Jurassic Park", 3, "Campo Alegre", '14:00:00', '16:07:00', '2:07:00', '2025-02-23 14:00:00');
INSERT INTO funcion VALUES (137, "Gladiator", 4, "Campo Alegre", '16:30:00', '19:05:00', '2:35:00', '2025-02-23 16:30:00');



-- Boletas:
INSERT INTO boleta VALUES (1, 1, 1001, 101, 'Salitre', 1, 1, 15000, '2025-02-10 14:00:00', 'General');
INSERT INTO boleta VALUES (2, 2, 1002, 102, 'Salitre', 1, 2, 15000, '2025-02-15 10:00:00', 'VIP');
INSERT INTO boleta VALUES (3, 3, 1003, 103, 'Salitre', 2, 3, 15000, '2025-02-15 12:30:00', 'Basic');
INSERT INTO boleta VALUES (4, 4, 1004, 104, 'Salitre', 3, 4, 15000, '2025-02-15 15:30:00', 'General');
INSERT INTO boleta VALUES (5, 5, 1005, 105, 'Salitre', 4, 5, 15000, '2025-02-15 18:30:00', 'Advanced');
INSERT INTO boleta VALUES (6, 6, 1006, 106, 'El Bosque', 1, 6, 15000, '2025-02-16 10:00:00', 'VIP');
INSERT INTO boleta VALUES (7, 7, 1007, 107, 'El Bosque', 2, 7, 15000, '2025-02-16 12:30:00', 'General');
INSERT INTO boleta VALUES (8, 8, 1008, 108, 'El Bosque', 3, 8, 15000, '2025-02-16 15:00:00', 'Basic');
INSERT INTO boleta VALUES (9, 9, 1009, 109, 'El Bosque', 4, 9, 15000, '2025-02-16 18:30:00', 'General');
INSERT INTO boleta VALUES (10, 10, 1036, 110, 'El Libertador', 1, 10, 15000, '2025-02-17 10:00:00', 'VIP');
INSERT INTO boleta VALUES (11, 11, 1011, 111, 'El Libertador', 2, 1, 15000, '2025-02-17 12:30:00', 'Advanced');
INSERT INTO boleta VALUES (12, 12, 1012, 112, 'El Libertador', 3, 2, 15000, '2025-02-17 15:30:00', 'Basic');
INSERT INTO boleta VALUES (13, 13, 1013, 113, 'El Libertador', 4, 3, 15000, '2025-02-17 18:30:00', 'General');
INSERT INTO boleta VALUES (14, 14, 1014, 114, 'Campo Alegre', 1, 4, 15000, '2025-02-18 10:00:00', 'VIP');
INSERT INTO boleta VALUES (15, 15, 1015, 115, 'Campo Alegre', 2, 5, 15000, '2025-02-18 12:00:00', 'General');
insert into boleta values (39,15,1002,110,"El Bosque",1,1,10000,NOW(),"Preferencial");
insert into boleta values (40,15,1002,110,"El Bosque",1,2,10000,NOW(),"Preferencial");
insert into boleta values (41,15,1002,110,"El Bosque",1,3,10000,NOW(),"Preferencial");
insert into boleta values (42,15,1002,110,"El Bosque",1,4,10000,NOW(),"Preferencial");
insert into boleta values (43,15,1002,110,"El Bosque",1,5,10000,NOW(),"Preferencial");
insert into boleta values (44,15,1002,110,"El Bosque",1,6,10000,NOW(),"Preferencial");


insert into boleta values (45,15,1003,110,"El Bosque",1,7,10000,NOW(),"Preferencial");
insert into boleta values (46,15,1003,110,"El Bosque",1,8,10000,NOW(),"Preferencial");
insert into boleta values (47,15,1003,110,"El Bosque",1,9,10000,NOW(),"Preferencial");
insert into boleta values (49,15,1003,123,"El Bosque",2,1,10000,NOW(),"Preferencial");
insert into boleta values (50,15,1003,110,"El Bosque",2,2,10000,NOW(),"Preferencial");

insert into boleta values (51,15,1004,123,"El Bosque",2,2,10000,NOW(),"Preferencial");
insert into boleta values (52,15,1004,123,"El Bosque",2,3,10000,NOW(),"Preferencial");
insert into boleta values (53,15,1004,123,"El Bosque",2,4,10000,NOW(),"Preferencial");
insert into boleta values (54,15,1004,123,"El Bosque",2,5,10000,NOW(),"Preferencial");
insert into boleta values (55,15,1004,123,"El Bosque",2,6,10000,NOW(),"Preferencial");
insert into boleta values (56,15,1004,123,"El Bosque",2,7,10000,NOW(),"Preferencial");

insert into boleta values (57,15,1005,118,"El Bosque",1,2,10000,NOW(),"Preferencial");
insert into boleta values (58,15,1005,118,"El Bosque",1,3,10000,NOW(),"Preferencial");
insert into boleta values (59,15,1005,118,"El Bosque",1,4,10000,NOW(),"Preferencial");
insert into boleta values (60,15,1005,118,"El Bosque",1,5,10000,NOW(),"Preferencial");
insert into boleta values (61,15,1005,118,"El Bosque",1,6,10000,NOW(),"Preferencial");
insert into boleta values (62,15,1005,118,"El Bosque",1,7,10000,NOW(),"Preferencial");
insert into boleta values (63,15,1005,118,"El Bosque",1,1,10000,NOW(),"Preferencial");



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


-- Historial compras cliente (Cliente)

-- vistas

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



-- Procedures


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


-- Procedure que da la seleccion de clientes con suscripcion basic

DELIMITER $$
CREATE PROCEDURE sp_ObtenerClientesBasic()
BEGIN
    SELECT * FROM Cliente WHERE cliTipo = 'Basic';
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_RegistrarVentaYBoleta(
    IN p_detIdCliente INT,
    IN p_detIdEmpleado INT,
    IN p_detTipoServicio VARCHAR(45),
    IN p_detMetodoPago VARCHAR(45),
    IN p_detUnidadesBoleta INT,
    IN p_detPrecioTotal INT,
    IN p_idCliente INT,
    IN p_idFuncion INT,
    IN p_idSilla INT
)
BEGIN
    DECLARE v_error INT DEFAULT 0;

    -- Declarar un manejador de errores para capturar cualquier excepción
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_error = 1;

    -- Iniciar la transacción
    START TRANSACTION;

    -- Llamar al procedimiento sp_InsertSale para registrar la venta
    CALL sp_InsertSale(p_detIdCliente, p_detIdEmpleado, p_detTipoServicio, p_detMetodoPago, p_detUnidadesBoleta, p_detPrecioTotal);

    -- Llamar al procedimiento sp_GenerarBoleta para generar la boleta
    CALL sp_GenerarBoleta(p_idCliente, p_idFuncion, p_idSilla);

    -- Verificar si hubo algún error
    IF v_error = 1 THEN
        -- Si hubo error en cualquiera de los dos procedimientos, hacer un rollback
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la transacción, se ha deshecho todo';
    ELSE
        -- Si no hubo errores, hacer commit
        COMMIT;
    END IF;

END $$

DELIMITER ;
-- Triggers

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






