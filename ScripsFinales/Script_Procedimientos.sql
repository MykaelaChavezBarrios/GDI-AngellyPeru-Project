USE AngellyPeru_Fact_Bol;
-- muestra todos los datos de los articulos
DELIMITER //
CREATE PROCEDURE sp_datos_articulos() BEGIN
	SELECT * from articulo;
END//
DELIMITER ;
-- busca por codigo
DELIMITER //
CREATE PROCEDURE sp_busca_articulo_codigo(in codigo varchar(12)) BEGIN
	SELECT *
	FROM Articulo
	WHERE Codigo_Articulo Like codigo;
END//
DELIMITER ;
-- busca por descripcion
DELIMITER //
CREATE PROCEDURE sp_busca_articulo_descripcion(in descripcion varchar(100)) BEGIN
	SELECT *
	FROM Articulo
	WHERE Descripcion = descripcion;
END//
DELIMITER ;
-- busca por stock
DELIMITER //
CREATE PROCEDURE sp_busca_articulo_stock(in stock INT) BEGIN
	SELECT *
	FROM Articulo
	WHERE Stock <= stock;
END //
DELIMITER ;
-- insertar articulo
DELIMITER //
CREATE PROCEDURE  sp_inserta_articulo(
	in Codigo_Articulo varchar(12),
	in Descripcion varchar(100),
	in Precio_Unitario FLOAT,
	in Empaque INT,
	in Medida varchar(6),
	in Stock INT
) BEGIN
	INSERT INTO Articulo VALUES(Codigo_Articulo,Descripcion,Precio_Unitario,Empaque,Medida,Stock);
END //
DELIMITER ;	
-- si ingresa un num negativo lo pone en 0 al stock
DELIMITER //
CREATE TRIGGER validar_stock_insertar  BEFORE INSERT ON Articulo FOR EACH ROW BEGIN
	IF (NEW.stock < 0)  then
		set NEW.stock = 0;
    END IF;
END //
DELIMITER; 
-- editar articulo por codigo
DELIMITER //
CREATE PROCEDURE  sp_actualiza_articulo (
	in Cod varchar(12),
	in Des varchar(100),
	in Pre FLOAT,
	in Emp INT,
	in Med varchar(6),
	in Sto INT
) BEGIN
	UPDATE Articulo SET Descripcion=Des,
						Precio_Unitario=Pre, Empaque=Emp, Medida=Med, Stock=Sto
					WHERE Codigo_Articulo LIKE Cod;
END //
DELIMITER ;
-- si stock cambia a un num negativo lo pone en 0
DELIMITER //
CREATE TRIGGER validar_stock_actualizar BEFORE UPDATE ON Articulo FOR EACH ROW BEGIN
	IF (NEW.stock < 0)  then
		set NEW.stock = 0;
    END IF;
END //
DELIMITER; 

-- muestre todos los datos de todos los clientes
DELIMITER //
CREATE PROCEDURE sp_datos_clientesn() BEGIN
	SELECT * from Cliente_natural;
END//
DELIMITER ;
-- busque por dni
DELIMITER //
CREATE PROCEDURE sp_busca_clienten_dni(in codigo char(8)) BEGIN
	SELECT *
	FROM Cliente_natural
	WHERE DNI = codigo;
END //
DELIMITER ;
-- busque por apellido y nombre
DELIMITER //
CREATE PROCEDURE sp_busca_clienten_nya(
in oldnombre VARCHAR(20),
in oldapellido VARCHAR(20)
) BEGIN
	SELECT *
	FROM Cliente_natural
	WHERE (Nombre = oldnombre) AND (Apellido = oldapellido);
END //
DELIMITER ;
-- insertar cliente natural
DELIMITER //
CREATE PROCEDURE  sp_inserta_clienten (
in dni_nuevo CHAR(8),
in nom varchar(20),
in ape varchar(20),
in dir varchar(30)
) BEGIN
INSERT INTO Cliente_natural VALUES(dni_nuevo,nom,ape,dir);
END //
DELIMITER ;
-- Si no se ingresa direccion se pone -
DELIMITER //
CREATE TRIGGER validar_direccion_insertar BEFORE INSERT ON cliente_natural FOR EACH ROW BEGIN
	IF (NEW.Direccion is null)  then
		set NEW.Direccion = '-';
    END IF;
END //
DELIMITER ; 
-- editar cliente 
DELIMITER //
CREATE PROCEDURE sp_actualiza_clienten(
in dni_nuevo char(8),
	in nom varchar(20),
	in ape varchar(20),
	in dir varchar(30)
) BEGIN
	UPDATE cliente_natural SET Nombre=nom,
						Apellido=ape, Direccion=dir
					WHERE DNI LIKE dni_nuevo;
END //
DELIMITER ;
-- si no se ingresa direccion
DELIMITER //
CREATE TRIGGER validar_direccion_actualizar BEFORE UPDATE ON cliente_natural FOR EACH ROW BEGIN
	IF (NEW.Direccion is null)  then
		set NEW.Direccion = '-';
    END IF;
END //
DELIMITER ; 
-- muestre todos los datos de todos los clientes
DELIMITER //
CREATE PROCEDURE sp_datos_clientesj() BEGIN
	SELECT * from Cliente_juridico;
END //
DELIMITER ;
-- busque por RUC
DELIMITER //
CREATE PROCEDURE sp_busca_clientej_ruc(in codigo char(11)) BEGIN
	SELECT *
	FROM Cliente_juridico
	WHERE RUC LIKE codigo;
END //
DELIMITER ;
-- busque por razon social
DELIMITER //
CREATE PROCEDURE sp_busca_clientej_razons(
in oldrazonsocial VARCHAR(80)
) BEGIN
	SELECT *
	FROM Cliente_juridico
	WHERE Razon_Social LIKE oldrazonsocial;
END //
DELIMITER ;
-- insertar con los valores necesarios
DELIMITER //
CREATE PROCEDURE  sp_inserta_clientej 
(
in ruc_nueva CHAR(11),
in rzs VARCHAR(80),
in dif VARCHAR(100)
) BEGIN
INSERT INTO Cliente_juridico VALUES(ruc_nueva,rzs,dif);
END //
DELIMITER ;
-- si no se ingresa direccion poner cadena "-" trigger
DELIMITER //
CREATE TRIGGER validar_direccionfiscal_insertar 	BEFORE INSERT ON cliente_juridico FOR EACH ROW BEGIN
	IF (NEW.Direccion_Fiscal is null)  then
		set NEW.Direccion_Fiscal = '-';
    END IF;
END //
DELIMITER ; 
-- editar cliente juridico
DELIMITER //
CREATE PROCEDURE sp_actualiza_clientej(
in ruc_nueva CHAR(11),
in rzs VARCHAR(80),
in dif VARCHAR(100)
) BEGIN
	UPDATE cliente_juridico SET Razon_Social=rzs,
						Direccion_Fiscal=dif
					WHERE RUC LIKE ruc_nueva;
END //
DELIMITER ;
-- si direccion es null poner -
DELIMITER //
CREATE TRIGGER validar_direccionfiscal_actualizar BEFORE UPDATE ON cliente_juridico FOR EACH ROW BEGIN
	IF (NEW.Direccion_Fiscal is null)  then
		set NEW.Direccion_Fiscal = '-';
    END IF;
END //
DELIMITER ; 
-- procedimiento de calculo valor venta cuando se ingresa un articulo al detalle de boleta
DELIMITER //
CREATE PROCEDURE sp_inserta_articant_Bo(
	in Num_Boleta CHAR(7),
	in Cod_art VARCHAR(12),
    in Cant INT,
	in Descuento_B FLOAT
    ) BEGIN
	DECLARE valor_venta_calculado float;
    SELECT Articulo.Precio_Unitario*Cant INTO valor_venta_calculado FROM Articulo WHERE Codigo_Articulo LIKE Cod_art;
	INSERT INTO Detalle_Boleta VALUES (Num_Boleta,Cod_art,Cant,Descuento_B,valor_venta_calculado);
END //
DELIMITER ;

DELIMITER //
-- listar historial boletas
CREATE PROCEDURE sp_listar_boleta() BEGIN
SELECT Boleta.Num_Boleta, Boleta.Dia_B, Boleta.Mes_B, Boleta.Año_B, Boleta.DNI, Cliente_Natural.Nombre, Cliente_Natural.Apellido, Boleta.Total_B
FROM boleta INNER JOIN cliente_natural ON cliente_natural.DNI LIKE boleta.DNI;
END //
DELIMITER ;
-- listar historial facturas
DELIMITER //
CREATE PROCEDURE sp_listar_factura() BEGIN
SELECT Factura.Num_Factura, Factura.Dia_F, Factura.Mes_F, Factura.Año_F, Factura.RUC, Cliente_Juridico.Razon_Social,Factura.Total_F
FROM Factura INNER JOIN Cliente_Juridico ON Cliente_Juridico.RUC LIKE Factura.RUC;
END //
DELIMITER ;
-- mostrar cabecera de una boleta
DELIMITER //
CREATE PROCEDURE sp_detallar_boleta(in num_bol CHAR(7) ) BEGIN
SELECT Boleta.Num_Boleta, Cliente_Natural.Nombre, Cliente_Natural.Apellido, 
Cliente_Natural.DNI, Cliente_Natural.Direccion, Boleta.Dia_B, 
Boleta.Mes_B, Boleta.Año_B, Boleta.ICBPER_B, Boleta.OP_Gravadas_B, Boleta.IGV_Total_B, Total_B
FROM Boleta INNER JOIN Cliente_Natural ON cliente_natural.DNI LIKE boleta.DNI
WHERE Num_Boleta LIKE num_bol ;
END //
DELIMITER ;

DELIMITER //
-- mostrar detalle de una boleta
CREATE PROCEDURE sp_detalle_boleta_fin(in num_bol CHAR(7)) BEGIN
	SELECT articulo.Codigo_Articulo, articulo.Descripcion, articulo.Precio_unitario, detalle_boleta.Cantidad_B, detalle_boleta.Descuento_B, detalle_boleta.Valor_Venta_B
    FROM detalle_boleta INNER JOIN articulo ON articulo.Codigo_Articulo LIKE detalle_boleta.Codigo_Articulo
    WHERE Num_Boleta LIKE num_bol;
END //
DELIMITER ;

DELIMITER //
-- listar articulos que estan asociados a una boleta
CREATE PROCEDURE sp_art_detalle(in num_bol CHAR(7)) BEGIN
SELECT Codigo_Articulo FROM detalle_boleta WHERE Num_Boleta LIKE num_bol; 
END //
DELIMITER ;
-- detallar cabecera de factura
DELIMITER //
CREATE PROCEDURE sp_detallar_factura(in num_fact CHAR(7) ) BEGIN
SELECT factura.Num_factura, cliente_juridico.Razon_Social, cliente_juridico.RUC,
cliente_juridico.direccion_fiscal, factura.Dia_F, 
factura.Mes_F, factura.Año_F, factura.ICBPER_F, factura.OP_Gravadas_F, factura.IGV_Total_F, Total_F
FROM Factura INNER JOIN cliente_juridico ON cliente_juridico.RUC LIKE factura.RUC
WHERE Num_factura LIKE num_fact ;
END //
DELIMITER ;
-- detallar cuerpo de factura
DELIMITER //
CREATE PROCEDURE sp_detalle_factura_fin(in num_fact CHAR(7), in art_cod VARCHAR(12)) BEGIN
	SELECT articulo.Codigo_Articulo, detalle_factura.Cantidad_F, articulo.Medida, articulo.Descripcion, articulo.Precio_unitario, detalle_factura.Descuento_F, detalle_factura.Valor_Venta_F
    FROM detalle_factura INNER JOIN articulo ON articulo.Codigo_Articulo LIKE art_cod
    WHERE Num_Factura LIKE num_fact AND Codigo_Articulo LIKE art_cod;
END //
DELIMITER ;
-- listar articulos asociados a una factura
DELIMITER //
CREATE PROCEDURE sp_art_detallef(in num_fact CHAR(7)) BEGIN
SELECT Codigo_Articulo FROM detalle_factura WHERE Num_Factura LIKE num_fact; 
END //
DELIMITER ;
-- mostrar toda la información de la boleta*/
DELIMITER //
CREATE PROCEDURE sp_datos_boleta() BEGIN
	SELECT * from boleta;
END //
DELIMITER ;
-- mostrar toda la información de la factura 
DELIMITER //
CREATE PROCEDURE sp_datos_factura() BEGIN
	SELECT * from factura;
END //
DELIMITER ;
-- buscar una boleta por su numB
DELIMITER //
CREATE PROCEDURE sp_searchB_xNum (IN numB CHAR(7)) BEGIN
	SELECT * FROM Boleta
    WHERE Num_Boleta = numB;
END //
DELIMITER ;
-- buscar una boleta por su dni cliente
DELIMITER //
CREATE PROCEDURE sp_searchB_xDNI (IN cod CHAR(8)) BEGIN
	SELECT * FROM BOLETA
    WHERE DNI = cod;
END //
DELIMITER ;
-- buscar una boleta por su nombre
DELIMITER //
CREATE PROCEDURE sp_searchB_xName (IN oldNomb VARCHAR(20)) BEGIN
	SELECT * 
	FROM boleta INNER JOIN cliente_natural
	WHERE nombre = oldNomb;
END //
DELIMITER ;
-- buscar una boleta por su apellido
DELIMITER //
CREATE PROCEDURE sp_searchB_xApe (IN oldApe VARCHAR(20)) BEGIN
	SELECT * 
	FROM boleta INNER JOIN cliente_natural
	WHERE apellido = oldApe;
END //
DELIMITER ;
 -- buscar una boleta por su fecha
DELIMITER //
CREATE PROCEDURE sp_searchB_xFecha (IN diaB CHAR(2), IN mesB CHAR(2),IN añoB CHAR(4)) BEGIN
	SELECT * FROM Boleta
    WHERE (Dia_B = diaB) AND
    (Mes_B = mesB) AND
    (Año_B = añoB);
END //
DELIMITER ;
-- buscar una factura por su num
DELIMITER //
 CREATE PROCEDURE sp_searchF_xNum (IN numF CHAR(7)) BEGIN
	SELECT * FROM Factura
    WHERE Num_Factura = numF;
END //
DELIMITER ;
-- buscar una factura por su ruc cliente
DELIMITER //
 CREATE PROCEDURE sp_searchF_xRuc (IN oldRuc CHAR(11)) BEGIN
	SELECT * FROM Factura
    WHERE RUC = oldRuc;
END //
DELIMITER ;
-- buscar una factura por su razon social
DELIMITER //
 CREATE PROCEDURE sp_searchF_xRaSo (IN oldRaSo VARCHAR(80)) BEGIN
	SELECT * 
	FROM factura INNER JOIN cliente_juridico
	WHERE Razon_Social = oldRaSo;
END //
DELIMITER ;
 -- buscar una factura por su fecha
DELIMITER //
CREATE PROCEDURE sp_searchF_xFecha (IN diaF CHAR(2), IN mesF CHAR(2),IN año_F CHAR(4)) BEGIN
	SELECT * FROM factura
    WHERE (Dia_F = diaF) AND
    (Mes_F = mesF) AND
    (Año_F = año_F);
END //
DELIMITER ;
-- muestra una tabla con los datos de num boleta, dni, nombre del cliente, fecha, total
DELIMITER //
CREATE PROCEDURE  sp_tBoleta(IN oldCod CHAR(7)) BEGIN
SELECT BOLETA.Num_Boleta, Boleta.DNI, Cliente_Natural.Nombre, Boleta.Dia_B, Boleta.Mes_B, Boleta.Año_B, Boleta.Total_B
FROM BOLETA
INNER JOIN cliente_natural
on Boleta.dni = Cliente_Natural.dni
WHERE Num_Boleta = oldCod;
END //
DELIMITER ;
-- muestra una tabla con los datos de num factura, ruc, razon social, fecha, total
DELIMITER //
CREATE PROCEDURE  sp_tFactura(IN oldCodF CHAR(7)) BEGIN
SELECT Factura.Num_Factura, Cliente_Juridico.RUC, Cliente_Juridico.Razon_Social,Factura.Dia_F,Factura.Mes_F,Factura.Año_F, Factura.Total_F
FROM Factura
INNER JOIN cliente_juridico
on Factura.RUC = cliente_juridico.RUC
WHERE Num_Factura = oldCodF;
END //
DELIMITER ;
-- insertar un nuevo articulo con la cantidad y descuento, calcular el valor venta
DELIMITER //
CREATE PROCEDURE sp_inserta_articant_B(
	in Num_Boleta CHAR(7),
	in Cod_art VARCHAR(12),
    in Cant INT,
	in Descuento_B FLOAT
    ) BEGIN
	DECLARE valor_venta_calculado float;
    SELECT (Articulo.Precio_Unitario*Cant - (Articulo.Precio_Unitario*Cant*Descuento_B)) INTO valor_venta_calculado FROM Articulo WHERE Codigo_Articulo LIKE Cod_art;
	INSERT INTO Detalle_Boleta VALUES (Num_Boleta,Cod_art,Cant,Descuento_B,valor_venta_calculado);
END //
DELIMITER ;
-- eliminar un articulo ya seleccionado
delimiter //
CREATE PROCEDURE  sp_elimina_boleta (
in codigo1 CHAR(7),
in codigo2 varchar(12)
) BEGIN
DELETE FROM Detalle_Boleta
WHERE num_Boleta = codigo1 and codigo_articulo = codigo2;
END //
delimiter ;
-- editar
delimiter //
CREATE PROCEDURE  sp_edita_dboleta (
	in codigob CHAR(7),
	in codigoa VARCHAR(12),
    in Cantidad_B INT,
	in Descuento_B FLOAT,
    in Valor_Venta_B FLOAT
) BEGIN
UPDATE Detalle_Boleta SET Num_Boleta=codigob, Codigo_Articulo=codigoa,
					Cantidad_B=Cantidad_B, Descuento_B=Descuento_B, Valor_Venta_B=Valor_Venta_B
					WHERE Num_Boleta=codigob and Codigo_Articulo = codigoa;
END //
delimiter ;
-- insertar un nuevo articulo con la cantidad y descuento, calcular el valor venta
DELIMITER //
CREATE PROCEDURE sp_inserta_articant_F(
	in Num_Factura CHAR(11),
	in Cod_art VARCHAR(12),
    in Cant INT,
	in Descuento_F FLOAT
    ) BEGIN
	DECLARE valor_venta_calculado float;
    SELECT Articulo.Precio_Unitario*Cant INTO valor_venta_calculado FROM Articulo WHERE Codigo_Articulo LIKE Cod_art;
	INSERT INTO Detalle_Factura VALUES (Num_Factura,Cod_art,Cant,Descuento_F,valor_venta_calculado);
END //
DELIMITER ;
-- eliminar un articulo ya seleccionado
delimiter //
CREATE PROCEDURE  sp_elimina_factura (
in codigo1 CHAR(11),
in codigo2 varchar(12)
) BEGIN
DELETE FROM Detalle_Factura
WHERE num_Factura = codigo1 and codigo_articulo = codigo2;
END //
delimiter ;
-- editar
delimiter //
CREATE PROCEDURE  sp_edita_dfactura (
	in codigof CHAR(7),
	in codigoa VARCHAR(12),
    in Cantidad_F INT,
	in Descuento_F FLOAT,
    in Valor_Venta_F FLOAT
) BEGIN
UPDATE Detalle_Factura SET Num_Boleta=codigof, Codigo_Articulo=codigoa,
					Cantidad_F=Cantidad_F, Descuento_F=Descuento_F, Valor_Venta_F=Valor_Venta_F
					WHERE Num_Factura=codigof and Codigo_Articulo = codigoa;
END //
delimiter ;
-- ingresar ICBPER
delimiter //
CREATE PROCEDURE  sp_inserta_ICBPER_B(
in ICBPER_B FLOAT

) BEGIN
INSERT INTO Boleta(ICBPER_B) VALUES(ICBPER_B);
END //
delimiter ;
-- calcular el total con la suma de los campos de valor venta de detalle boleta, icbper, igv
delimiter //
CREATE PROCEDURE sp_total_B(
	in codigo char(7)
) BEGIN

SELECT Boleta.Num_Boleta, sum(ICBPER_B+IGV_Total_B+Valor_Venta_B) AS Total_Venta FROM Boleta  inner join Detalle_Boleta ON Boleta.Num_boleta = Detalle_Boleta.Num_boleta
	where Boleta.num_boleta = codigo;
END //
delimiter ;
-- calcular operaciones gravadas como suma de detalles de valor venta
DELIMITER //
CREATE PROCEDURE sp_calculo_opgrav_B(
	in codigo char(7)
) BEGIN
SELECT Detalle_Boleta.Num_Boleta, sum(Valor_Venta_B) AS Operaciones_Gravadas from Detalle_Boleta
	where Detalle_Boleta.Num_Boleta = codigo;
END //
delimiter ;
-- calcular igv como 18% de operaciones gravadas
DELIMITER //
CREATE PROCEDURE sp_calculo_igv_B(
	in codigo char(7)
) BEGIN
SELECT Boleta.Num_Boleta, sum(OP_Gravadas_B*0.18) AS IGV FROM Boleta
	where Boleta.Num_Boleta = codigo;
END //
DELIMITER ;
-- ingresar ICBPER
DELIMITER //
CREATE PROCEDURE  sp_inserta_ICBPER_F (
in ICBPER_F FLOAT
) BEGIN
INSERT INTO Factura(ICBPER_F) VALUES(ICBPER_F);
END //
delimiter ;
-- calcular el total con la suma de los campos de valor venta de detalle factura, icbper, igv
DELIMITER //
CREATE PROCEDURE sp_total_F(
	in codigo char(11)
) BEGIN
SELECT Factura.Num_Factura, sum(ICBPER_F+IGV_Total_F+Valor_Venta_F) FROM Factura  inner join Detalle_Factura ON Factura.Num_factura = Detalle_Factura.Num_factura
	where Factura.num_factura = codigo;
END //
delimiter ;
-- calcular operaciones gravadas como suma de detalles de valor venta
DELIMITER //
CREATE PROCEDURE sp_calculo_opgrav_F(
	in codigo char(11)
) BEGIN
SELECT Detalle_Factura.Num_Factura, sum(Valor_Venta_F) AS Operaciones_Gravadas from Detalle_Factura
	where Detalle_Factura.Num_Factura = codigo;
END //
DELIMITER ;
-- calcular igv como 18% de operaciones gravadas
DELIMITER //
CREATE PROCEDURE sp_calculo_igv_F(
	in codigo char(11)
) begin

SELECT Factura.Num_Factura, sum(OP_Gravadas_F*0.18) AS IGV FROM Factura
	where Factura.Num_Factura = codigo;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_boleta_cabecera_in(in num CHAR(7), in dia CHAR(2), in mes CHAR(2), in anio CHAR(4), in dni_cli CHAR(8)) BEGIN
	INSERT INTO Boleta VALUES(num, dia, mes, anio, 0, 0, 0, 0,dni_cli);
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE sp_boleta_cabecera_mostrar(in num CHAR(7)) BEGIN
SELECT Num_Boleta, Dia_B, Mes_B, Año_B, Cliente_Natural.DNI, Cliente_Natural.Nombre, Cliente_Natural.Apellido, Cliente_Natural.Direccion 
FROM Boleta INNER JOIN Cliente_Natural ON Boleta.DNI LIKE Cliente_Natural.DNI
WHERE Num_Boleta LIKE num;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE sp_boleta_final(in num CHAR(7)) BEGIN 
SELECT Boleta.Num_Boleta, Boleta.Dia_B, Boleta.Mes_B, Boleta.Año_B, 
Cliente_Natural.DNI, Cliente_Natural.Nombre, Cliente_Natural.Apellido, Cliente_Natural.Direccion,
articulo.Codigo_Articulo, articulo.Descripcion, articulo.Precio_unitario, 
detalle_boleta.Cantidad_B, detalle_boleta.Descuento_B, detalle_boleta.Valor_Venta_B,
Boleta.ICBPER_B, Boleta.OP_Gravadas_B, Boleta.IGV_Total_B,Boleta.Total_B
FROM Boleta
INNER JOIN Cliente_Natural ON Cliente_Natural.DNI LIKE Boleta.DNI
INNER JOIN Detalle_Boleta ON Detalle_Boleta.Num_Boleta LIKE Boleta.Num_Boleta
INNER JOIN Articulo ON Articulo.Codigo_Articulo LIKE Detalle_Boleta.Codigo_Articulo
WHERE Boleta.Num_Boleta LIKE num;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_boleta_pie(in num CHAR(7)) BEGIN
 SELECT Boleta.ICBPER_B, Boleta.OP_Gravadas_B, Boleta.IGV_Total_B,Boleta.Total_B FROM boleta 
 WHERE Boleta.Num_Boleta LIKE num;
 END //
DELIMITER ;



-- calcular el total con la suma de los campos de valor venta de detalle boleta, icbper, igv
delimiter //
CREATE TRIGGER totales AFTER INSERT ON Detalle_Boleta FOR EACH ROW BEGIN
 declare op float;
 SELECT sum(Valor_Venta_B)  INTO op FROM Detalle_Boleta INNER JOIN Boleta ON Boleta.Num_Boleta LIKE Detalle_Boleta.Num_Boleta
 WHERE Boleta.Num_Boleta LIKE New.Num_Boleta;
 UPDATE BOLETA
	set OP_Gravadas_B = op;
 UPDATE BOLETA
    set IGV_Total_B = op*0.18;
UPDATE BOLETA
	set Total_B = IGV_Total_B+OP_Gravadas_B;
END //
delimiter ;











