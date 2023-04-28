USE AngellyPeru_Fact_Bol;
-- Primera consulta
SELECT a.Codigo_Articulo, a.Descripcion, db.Num_Boleta, db.Cantidad_b   FROM Articulo AS a 
        INNER JOIN Detalle_Boleta AS db ON db.Codigo_Articulo = a.Codigo_Articulo;

-- Segunda consulta
SELECT cn.dni, cn.Nombre, cn.Apellido, cn.Direccion, b.Num_Boleta, b.Dia_B, b.Mes_B, b.Año_B, b.Total_B FROM Cliente_Natural AS cn
	INNER JOIN Boleta  AS b ON cn.dni = b.dni;
    
-- Tercera consulta
SELECT f.Num_Factura, f.Total_F, cj.RUC, cj.Razon_Social FROM Factura as f
	INNER JOIN Cliente_Juridico AS cj ON f.RUC = cj.RUC;
    
-- Cuarta consulta
SELECT b.num_boleta, b.dni , db.Valor_Venta_B FROM Boleta AS b
	INNER JOIN Detalle_Boleta AS db ON b.Num_Boleta = db.Num_Boleta 
    WHERE db.Valor_Venta_B > 500;
    
-- Quinta consulta
SELECT *, f.Total_F FROM Cliente_Juridico AS cj
	INNER JOIN Factura AS f ON cj.RUC = f.RUC
    WHERE f.Total_F >= 200;

-- Sexta consulta
SELECT a.Descripcion, a.Stock FROM Articulo AS a 
	WHERE a.Stock < 10;
    
-- Septima consulta
SELECT cn.dni, cn.nombre, cn.apellido, db.Num_Boleta, db.Valor_Venta_B, b.total_B FROM Cliente_Natural AS cn
	INNER JOIN Boleta AS b ON cn.dni = b.dni 
    INNER JOIN Detalle_Boleta AS db ON b.Num_Boleta = db.Num_Boleta;
    
-- Octava consulta    
SELECT cj.RUC, cj.Razon_Social, df.Num_Factura, df.Valor_Venta_F, f.total_F FROM Cliente_Juridico AS cj
	INNER JOIN Factura AS f ON cj.RUC = f.RUC
    INNER JOIN Detalle_Factura AS df ON f.Num_Factura = df.Num_Factura;
    
-- Novena consulta   
SELECT DISTINCT a.medida FROM Articulo AS a;
 
 -- Decima consulta
SELECT MAX(Total_B) FROM Boleta;

SELECT MIN(Total_B) FROM Boleta;

SELECT MAX(Total_F) FROM Factura;

SELECT MIN(Total_F) FROM Factura;