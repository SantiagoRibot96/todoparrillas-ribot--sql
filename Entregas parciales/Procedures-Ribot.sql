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
        fecha_entrega DATE,
	FOREIGN KEY(id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY(id_chofer) REFERENCES Choferes(id_chofer))
    ENGINE = InnoDB;

-- -----------------------------------------------------
-- Insercion de DATOS.
-- -----------------------------------------------------

INSERT INTO Proveedores VALUES 	(1, 'Hierro CORT', 1129584723, 'Av. Marcelo T. de Alvear 2295', 'Daniel. Perfileria de hierro. No trabajan Acero Inoxidable.'), 
								(2, 'Indartubo', 1195827406, 'Av. San Martin 991', 'Martin. Tubos más barato. Demora en la entrega. Pago 30/60.'),
								(3, 'Aceros Mitre', 1143569286, 'Av. Mitre 2351', 'Alberto. Chapa de disponibilidad rapida. Pago al contado.'),
								(4, 'FAMIC', 1194623531, 'Av. Alvarez Thomas 1200', 'Javier. Chapa y perfileria de Inoxidable. Caro pero entrega al momento.'),
								(5, 'Chatarra Lopez', 1192835241, 'Av. Hipolito Irigoyen 941', 'Roberto. Compra venta de chatarra. Suele tener buen material');

INSERT INTO Clientes VALUES		(1, 'Roman Martinez', 1192846371, 'Irigoyen 2456 dpto A'),
								(2, 'Gary Medel', 1184750236, 'Nahuel Huapi 234 SIN TIMBRE'),
								(3, 'Gabriel Batistuta', 1182751209, 'Sanabria 2834'),
								(4, 'Facundo Arana', 1184624859, 'Carlos Carranza 2483'),
								(5, 'Gabriela Mistral', 1184362542, 'Cesar Diaz 2244 timbre abajo');
                            
INSERT INTO Productos VALUES	(1, 'Barbacoa Argentina', 10000, 5),
								(2, 'Flama Asador', 15000, 10),
								(3, 'Portatil Clasica', 8000, 26),
                                (4, 'QBO', 25000, 3),
                                (5, 'Gas', 24550, 13);
                                
INSERT INTO Ventas VALUES		(1, 399, 2, 50000, 'Pendiente de Pago'),
								(2, 394, 1, 41000, 'Paga Contraentrega'),
								(3, 378, 4, 32900, 'Pagado Targeta de Credito'),
								(4, 389, 5, 20000, 'Pagado Efectivo'),
                                (5, 391, 3, 21000, 'Pendiente de Pago');

INSERT INTO Choferes VAlUES		(1, 'Fabian Quintero', 1192845721, 'Pedro Lozano 2294', 'Ford F100 roja modelo 1998', 'BAE293'),
								(2, 'Ricardo Montaner', 1182743819, 'Av. Alvarez Jonte 1233', 'Fiat Fiorino blanca modelo 2007', 'HEA856'),
                                (3, 'Benito Flores', 1192848392, 'Colombo 2389', 'Ford CAM F4000 blanca modelo 2018', 'MAM294'),
                                (4, 'Antonio Gonzales', 1192843719, 'Emilio Mitre 1294', 'Ford Transit blanca modelo 1983', 'RAP923'),
                                (5, 'Roberto Carlos', 1198285923, 'Av. Roca 1463', 'Citroen Berlingo gris modelo 2005', 'DAO259');
                                
INSERT INTO Entregas VALUES		(1, 4, 3, '2023-08-15'),
								(2, 3, 5, '2023-08-18'),
                                (3, 1, 2, '2023-08-22'),
                                (4, 2, 1, '2023-08-25'),
                                (5, 5, 4, '2023-08-28');
                                
-- -----------------------------------------------------
-- Vistas.
-- -----------------------------------------------------

-- ------- Vista de ventas pagadas -----------
create or replace view VW_Ventas as
(
select *
from ventas
where estado_pago like '%Pagado%'
);

select * from VW_Ventas;

-- ------- Vista de clientes deudores -----------
create or replace view VW_Clientes_Deudores as
(
select nombre, telefono, direccion, numero_factura, total
from ventas join clientes
on clientes.id_cliente = ventas.id_cliente
where estado_pago not like '%Pagado%'
);

select * from VW_Clientes_Deudores;

-- ------- Vista de proveedores de chapa -----------
create or replace view VW_Proveedores_Chapa as
(
select *
from proveedores
where comentario like '%Chapa%'
);

select * from VW_Proveedores_Chapa;

-- ------- Vista de productos con stock igual o menor a 5 -----------
create or replace view VW_Productos_Stock_Critico as
(
select *
from productos
where stock <= 5
);

select * from VW_Productos_Stock_Critico;

-- ------- Vista de entregas impagas -----------
create or replace view VW_Entregas_Impagas as
(
select id_entrega, id_chofer, fecha_entrega, total
from entregas join ventas
on ventas.id_venta = entregas.id_venta
where estado_pago not like '%Pagado%'
);

select * from VW_Entregas_Impagas;

-- -----------------------------------------------------
-- Funciones.
-- -----------------------------------------------------

-- ------- Funcion que calcula cuanto iva se pago -----------
drop function if exists  fn_IVA_Pagado ;

delimiter $$ 
	 create function fn_IVA_Pagado (iva decimal(4,2), id_venta int)
	 returns int 
	 deterministic 
	 begin
		 declare iva_Pagado int ;
		 set iva_Pagado =  
				(	
				select distinct total * iva 
				from ventas
				where ventas.id_venta = id_venta
				);
		return  iva_Pagado;   
	end$$ 
delimiter ;
 
select fn_IVA_Pagado(0.21, 3) as iva_Pagado;


drop function if exists  fn_Nombre_Cliente ;

delimiter $$ 
	 create function fn_Nombre_Cliente (id_cliente int)
	 returns VARCHAR(255) 
	 deterministic 
	 begin
		 declare nombre_cliente VARCHAR(255) ;
		 set nombre_cliente =  
				(	
				select nombre
				from clientes
				where clientes.id_cliente = id_cliente
				);
		return  nombre_cliente;
	end$$ 
delimiter ;

select fn_Nombre_Cliente(3) as nombre_cliente;

-- -----------------------------------------------------
-- Creación de Procedimientos.
-- -----------------------------------------------------

-- ------- Procedimiento que ordena clientes -----------
drop procedure if exists sp_Procedimiento_Orden;
DELIMITER //
	create procedure sp_Procedimiento_Orden (
												in columna VARCHAR(50),
												in orden VARCHAR(10),
												out p_Id_Cliente INT,
												out p_Nombre VARCHAR(255),
												out p_Telefono INT,
												out p_Direccion VARCHAR(255),
                                                out p_Mensaje VARCHAR(255)
											)
	begin
		if orden = 'desc' then
			select * 
			into p_Id_Cliente, p_Nombre, p_Telefono, p_Direccion
			from clientes
			order by columna desc
            limit 1;
            
			elseif orden = 'asc' then
				select id_cliente, nombre, telefono, direccion
				into p_Id_Cliente, p_Nombre, p_Telefono, p_Direccion
				from clientes
				order by columna asc
                limit 1;
                
			else
				set p_Mensaje = CONCAT('ERROR: el tipo de ordenamiento',orden,' no forma parte de lo posible.');
		end if;
	end//
delimiter ;

call sp_Procedimiento_Orden('id_cliente', 'asc', @p_Id_Cliente, @p_Nombre, @p_Telefono, @p_Direccion, @p_Mensaje);
select @p_Id_Cliente, @p_Nombre, @p_Telefono, @p_Direccion, @p_Mensaje;

-- sp_Procedimiento_Orden recibe como parametro la columna de la tabla clientes que se desee ordenar y si es 'asc' o 'desc'. Luego arroja a travez de p_Id_Cliente, p_Nombre, p_Telefono y p_Direccion el primer registro. p_Mensaje muestra en caso de error

-- NOTA: No se como mostrar mas de una fila por columna, por eso limite a 1 la salida como en los ejemplos de clase

-- ------- Procedimiento que inserta nuevos clientes ----------
drop procedure if exists sp_Insertar;
DELIMITER //
	create procedure sp_Insertar (
										in p_Id_Cliente INT,
										in p_Nombre VARCHAR(255),
										in p_Telefono INT,
										in p_Direccion VARCHAR(255),
										out p_Mensaje VARCHAR(255)
									)
	begin
		if p_Id_Cliente = null or p_Nombre = '' or p_Telefono = null or p_direccion = '' then
			set p_Mensaje = CONCAT('ERROR: Faltan datos. Recuerde que el orden de insert es id_cliente, nombre, telefono y direccion');
            
			else
				insert into clientes values (p_Id_Cliente, p_Nombre, p_Telefono, p_Direccion);
		end if;
	end//
delimiter ;

call sp_Insertar(7, 'Alberto', 12365482, 'Av Siempre viva', @p_Mensaje);
select @p_Mensaje;

-- sp_insertar recibe como parametro id_cliente, nombre, telefono y direccion y lo inserta dentro de la tabla clientes. En caso de que algun parametro sea null arroja un mensaje de error atravez de la salida p_Mensaje