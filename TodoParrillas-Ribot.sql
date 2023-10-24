-- -----------------------------------------------------
-- Creación de la BASE.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS TodoParrillas;
USE TodoParrillas;

-- -----------------------------------------------------
-- Creación de las TABLAS.
-- -----------------------------------------------------

-- --------Tabla PROVEEDORES ---------
CREATE TABLE IF NOT EXISTS Proveedores(
	id_proveedor INT NOT NULL PRIMARY KEY,
		nombre VARCHAR(255) NOT NULL,
        telefono INT,
        direccion VARCHAR(255) NOT NULL,
        comentario VARCHAR(255))
	ENGINE = InnoDB;
    
-- -------Tabla CLIENTES -----------    
CREATE TABLE IF NOT EXISTS Clientes(
	id_cliente INT NOT NULL PRIMARY KEY,
		nombre VARCHAR(255) NOT NULL,
        telefono INT NOT NULL,
        direccion VARCHAR(255) NOT NULL)
	ENGINE = InnoDB;

-- -------Tabla PRODUCTOS -----------
CREATE TABLE IF NOT EXISTS Productos(
	id_producto INT NOT NULL PRIMARY KEY,
		nombre VARCHAR(255) NOT NULL,
        precio INT NOT NULL,
        stock INT)
	ENGINE = InnoDB;
    
-- -------Tabla VENTAS -----------
CREATE TABLE IF NOT EXISTS Ventas(
	id_venta INT NOT NULL PRIMARY KEY,
		numero_factura INT NOT NULL,
        id_cliente INT NOT NULL,
        total INT,
        estado_pago VARCHAR(255) NOT NULL,
	FOREIGN KEY(id_cliente) REFERENCES Clientes(id_cliente))
	ENGINE = InnoDB;

-- -------Tabla CHOFERES -----------
CREATE TABLE IF NOT EXISTS Choferes(
	id_chofer INT NOT NULL PRIMARY KEY,
		nombre VARCHAR(255) NOT NULL,
        telefono INT NOT NULL,
        direccion VARCHAR(255),
        vehiculo VARCHAR(255),
        patente VARCHAR(255))
	ENGINE = InnoDB;

-- -------Tabla ENTREGAS -----------
CREATE TABLE IF NOT EXISTS Entregas(
	id_entrega INT NOT NULL PRIMARY KEY,
		id_venta INT NOT NULL,
        id_chofer INT NOT NULL,
        fecha_entrega TIME,
	FOREIGN KEY(id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY(id_chofer) REFERENCES Choferes(id_chofer))
    ENGINE = InnoDB;