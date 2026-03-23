USE bad_dragon;
GO

-- -----------------
-- -- PA Clase -----
-- -----------------

-- Registrar Plato

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarPlato
  @idCategoria INT,
  @nombre VARCHAR(50),
  @descripcion VARCHAR(150),
  @precio DECIMAL(10,2)
AS
BEGIN
  IF @idCategoria IS NULL OR @nombre IS NULL OR @descripcion IS NULL OR @precio IS NULL
    THROW 50001, 'idCategoria, nombre, descripcion y precio son obligatorios y no pueden ser nulos.', 1;

  IF LEN(LTRIM(RTRIM(@nombre))) = 0
    OR LEN(LTRIM(RTRIM(@descripcion))) = 0
    THROW 50002, 'nombre y descripcion no pueden estar vacios.', 1;

  IF @precio < 0
    THROW 50003, 'El precio no puede ser negativo.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Categoria
    WHERE idCategoria = @idCategoria
  )
  THROW 50004, 'La categoria especificada no existe.', 1;

  INSERT INTO dbo.Plato (
    idCategoria,
    nombre,
    descripcion,
    precio
  )
  VALUES (
    @idCategoria,
    LTRIM(RTRIM(@nombre)),
    LTRIM(RTRIM(@descripcion)),
    @precio
  );
END
GO

-- Mostrar Pedidos por Cliente

CREATE OR ALTER PROCEDURE dbo.sp_MostrarPedidosPorCliente
  @idCliente INT
AS
BEGIN
  IF @idCliente IS NULL
    THROW 50005, 'El idCliente no puede ser nulo.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Cliente
    WHERE idCliente = @idCliente
  )
    THROW 50006, 'El cliente especificado no existe.', 1;

  SELECT
    p.idPedido,
    p.fechaHoraPedido,
    p.estado,
    CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
    CONCAT(e.nombre, ' ', e.apellidos) AS empleado,
    m.numMesa,
    s.nombreComercial AS sucursal,
    mp.nombre AS metodoPago,
    f.numFactura,
    f.montoTotal
  FROM dbo.Pedido p
  INNER JOIN dbo.Cliente c
    ON p.idCliente = c.idCliente
  INNER JOIN dbo.Empleado e
    ON p.idEmpleado = e.idEmpleado
  INNER JOIN dbo.Mesa m
    ON p.idMesa = m.idMesa
  INNER JOIN dbo.Sucursal s
    ON m.idSucursal = s.idSucursal
  INNER JOIN dbo.MetodoPago mp
    ON p.idMetodo = mp.idMetodo
  LEFT JOIN dbo.Factura f
    ON p.idPedido = f.idPedido
  WHERE p.idCliente = @idCliente
  ORDER BY p.fechaHoraPedido DESC;
END
GO

-- Total Vendido por Sucursal

CREATE OR ALTER PROCEDURE dbo.sp_TotalVendidoPorSucursal
    @idSucursal INT,
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
  IF @idSucursal IS NULL OR @fechaInicio IS NULL OR @fechaFin IS NULL
    THROW 50007, 'idSucursal, fechaInicio y fechaFin son obligatorios y no pueden ser nulos.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Sucursal
    WHERE idSucursal = @idSucursal
  )
    THROW 50008, 'La sucursal especificada no existe.', 1;

  IF @fechaInicio > @fechaFin
    THROW 50009, 'La fecha de inicio no puede ser mayor que la fecha final.', 1;

  SELECT
    s.idSucursal,
    s.nombreComercial,
    ISNULL(SUM(
      CASE
          WHEN f.fechaFactura BETWEEN @fechaInicio AND @fechaFin
          THEN f.montoTotal
          ELSE 0
      END
    ), 0) AS totalVendido
  FROM dbo.Sucursal s
  LEFT JOIN dbo.Mesa m
    ON s.idSucursal = m.idSucursal
  LEFT JOIN dbo.Pedido p
    ON m.idMesa = p.idMesa
  LEFT JOIN dbo.Factura f
    ON p.idPedido = f.idPedido
  WHERE s.idSucursal = @idSucursal
  GROUP BY
    s.idSucursal,
    s.nombreComercial;
END
GO

-- Top Platos Mas Vendidos por Sucursal

CREATE OR ALTER PROCEDURE dbo.sp_TopPlatosMasVendidos
  @fechaInicio DATE,
  @fechaFin DATE,
  @idSucursal INT,
  @numeroPlatos INT = 10
AS
BEGIN
  IF @fechaInicio IS NULL OR @fechaFin IS NULL OR @idSucursal IS NULL
    THROW 50010, 'fechaInicio y fechaFin y idSucursal son obligatorios y no pueden ser nulos.', 1;

  IF @fechaInicio > @fechaFin
    THROW 50011, 'La fecha de inicio no puede ser mayor que la fecha final.', 1;

  IF NOT EXISTS(
    SELECT 1
    FROM Sucursal
    WHERE idSucursal=@idSucursal
  )
    THROW 50026, 'idSucursal debe existir.', 1;

  SELECT TOP (@numeroPlatos)
    pl.idPlato,
    pl.nombre,
    SUM(dp.cantidad) AS cantidadVendida,
    SUM(dp.cantidad * dp.precio) AS totalRecaudado
  FROM dbo.DetallePedido dp
  INNER JOIN dbo.Pedido p
    ON dp.idPedido = p.idPedido
  INNER JOIN dbo.Mesa AS m
    ON p.idMesa = m.idMesa
  INNER JOIN dbo.Sucursal AS s
    ON m.idSucursal = s.idSucursal
  INNER JOIN dbo.Plato pl
    ON dp.idPlato = pl.idPlato
  WHERE CAST(p.fechaHoraPedido AS DATE) BETWEEN @fechaInicio AND @fechaFin
  AND s.idSucursal = @idSucursal
  GROUP BY
    pl.idPlato,
    pl.nombre
  ORDER BY
    SUM(dp.cantidad) DESC,
    SUM(dp.cantidad * dp.precio) DESC;
END
GO

-- Top Clientes por Sucursal

CREATE OR ALTER PROCEDURE dbo.sp_TopClientesFrecuentesPorSucursal
  @idSucursal INT,
  @numeroClientes INT = 3
AS
BEGIN
  IF @idSucursal IS NULL
    THROW 50012, 'El idSucursal no puede ser nulo.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Sucursal
    WHERE idSucursal = @idSucursal
  )
    THROW 50013, 'La sucursal especificada no existe.', 1;

  SELECT TOP (@numeroClientes)
    c.idCliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombreCliente,
    COUNT(p.idPedido) AS totalPedidos
  FROM dbo.Pedido p
  INNER JOIN dbo.Cliente c
    ON p.idCliente = c.idCliente
  INNER JOIN dbo.Mesa m
    ON p.idMesa = m.idMesa
  INNER JOIN dbo.Sucursal s
    ON m.idSucursal = s.idSucursal
  LEFT JOIN dbo.Factura f
    ON p.idPedido = f.idPedido
  WHERE s.idSucursal = @idSucursal
  GROUP BY
    c.idCliente,
    c.nombre,
    c.apellidos
  ORDER BY
    COUNT(p.idPedido) DESC;
END
GO

-- Registrar CLiente

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarCliente
  @idCiudad INT,
  @nombre VARCHAR(50),
  @apellidos VARCHAR(150),
  @numCarnet VARCHAR(15),
  @telefono VARCHAR(15) = NULL,
  @correo VARCHAR(30) = NULL
AS
BEGIN
  IF @idCiudad IS NULL OR @nombre IS NULL OR @apellidos IS NULL OR @numCarnet IS NULL
    THROW 50020, 'idCiudad, nombre, apellidos y numCarnet son obligatorios y no pueden ser nulos.', 1;

  IF LEN(LTRIM(RTRIM(@nombre))) = 0
  OR LEN(LTRIM(RTRIM(@apellidos))) = 0
  OR LEN(LTRIM(RTRIM(@numCarnet))) = 0
    THROW 50021, 'nombre, apellidos y numCarnet no pueden estar vacios.', 1;

  IF @telefono IS NOT NULL
  AND (@telefono LIKE '%[^0-9]%' OR LEN(@telefono) NOT BETWEEN 7 AND 15)
    THROW 50022, 'El telefono debe tener solo numeros y entre 7 y 15 digitos.', 1;

  IF @correo IS NOT NULL
  AND @correo NOT LIKE '%_@_%._%'
    THROW 50023, 'El correo no tiene un formato valido.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Ciudad
    WHERE idCiudad = @idCiudad
  )
    THROW 50024, 'La ciudad especificada no existe.', 1;

  IF EXISTS (
    SELECT 1
    FROM dbo.Cliente
    WHERE numCarnet = @numCarnet
  )
    THROW 50025, 'Ya existe un cliente con ese numero de carnet.', 1;

  INSERT INTO dbo.Cliente (
    idCiudad,
    nombre,
    apellidos,
    numCarnet,
    telefono,
    correo
  )
  VALUES (
    @idCiudad,
    LTRIM(RTRIM(@nombre)),
    LTRIM(RTRIM(@apellidos)),
    LTRIM(RTRIM(@numCarnet)),
    @telefono,
    @correo
  );
END
GO

-- Registrar Pedido

IF TYPE_ID('dbo.TipoDetallePedido') IS NOT NULL
    DROP TYPE dbo.TipoDetallePedido;
GO

CREATE TYPE dbo.TipoDetallePedido AS TABLE
(
    idPlato INT NOT NULL,
    cantidad INT NOT NULL
);
GO

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarPedidoCompleto
  @idCliente INT,
  @idEmpleado INT,
  @idMetodo INT,
  @idMesa INT,
  @estado VARCHAR(15),
  @fechaHoraPedido DATETIME,
  @numFactura INT,
  @NITCliente INT,
  @razonSocial VARCHAR(100),
  @detalle dbo.TipoDetallePedido READONLY
AS
BEGIN
  IF @idCliente IS NULL OR @idEmpleado IS NULL OR @idMetodo IS NULL OR @idMesa IS NULL
    OR @estado IS NULL OR @fechaHoraPedido IS NULL
    OR @numFactura IS NULL OR @NITCliente IS NULL OR @razonSocial IS NULL
    THROW 50029, 'Todos los datos del pedido y factura son obligatorios y no pueden ser nulos.', 1;

  IF LEN(LTRIM(RTRIM(@estado))) = 0
    OR LEN(LTRIM(RTRIM(@razonSocial))) = 0
    THROW 50030, 'estado y razonSocial no pueden estar vacios.', 1;

  IF @estado NOT IN ('Pendiente','Entregado','Cancelado')
    THROW 50031, 'El estado del pedido no es valido.', 1;

  IF @NITCliente < 0
    THROW 50032, 'El NIT del cliente no puede ser negativo.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Cliente
    WHERE idCliente = @idCliente
  )
    THROW 50033, 'El cliente especificado no existe.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Empleado
    WHERE idEmpleado = @idEmpleado
  )
    THROW 50034, 'El empleado especificado no existe.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.MetodoPago
    WHERE idMetodo = @idMetodo
  )
    THROW 50035, 'El metodo de pago especificado no existe.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM dbo.Mesa
    WHERE idMesa = @idMesa
  )
    THROW 50036, 'La mesa especificada no existe.', 1;

  IF EXISTS (
    SELECT 1
    FROM dbo.Factura
    WHERE numFactura = @numFactura
  )
    THROW 50037, 'El numero de factura ya existe.', 1;

  IF NOT EXISTS (
    SELECT 1
    FROM @detalle
  )
    THROW 50038, 'El detalle del pedido no puede estar vacio.', 1;

  IF EXISTS (
    SELECT 1
    FROM @detalle
    WHERE idPlato IS NULL OR cantidad IS NULL
  )
    THROW 50039, 'Cada linea del detalle debe tener idPlato y cantidad.', 1;

  IF EXISTS (
    SELECT 1
    FROM @detalle
    WHERE cantidad <= 0
  )
    THROW 50040, 'La cantidad de cada plato debe ser mayor a cero.', 1;

  IF EXISTS (
    SELECT 1
    FROM @detalle d
    LEFT JOIN dbo.Plato p
      ON d.idPlato = p.idPlato
    WHERE p.idPlato IS NULL
  )
    THROW 50041, 'Uno o mas platos del detalle no existen.', 1;

  IF EXISTS (
    SELECT idPlato
    FROM @detalle
    GROUP BY idPlato
    HAVING COUNT(*) > 1
  )
    THROW 50042, 'No se permiten platos repetidos en el detalle.', 1;

  BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @idPedido INT;
    DECLARE @montoTotal DECIMAL(10,2);

    INSERT INTO dbo.Pedido (
      idCliente,
      idEmpleado,
      idMetodo,
      idMesa,
      estado,
      fechaHoraPedido
    )
    VALUES (
      @idCliente,
      @idEmpleado,
      @idMetodo,
      @idMesa,
      @estado,
      @fechaHoraPedido
    );

    SET @idPedido = SCOPE_IDENTITY();

    INSERT INTO dbo.DetallePedido (
      idPlato,
      idPedido,
      cantidad,
      precio
    )
    SELECT
      d.idPlato,
      @idPedido,
      d.cantidad,
      p.precio
    FROM @detalle d
    INNER JOIN dbo.Plato p
      ON d.idPlato = p.idPlato;

    SELECT
      @montoTotal = SUM(d.cantidad * p.precio)
    FROM @detalle d
    INNER JOIN dbo.Plato p
      ON d.idPlato = p.idPlato;

    INSERT INTO dbo.Factura (
      idPedido,
      numFactura,
      montoTotal,
      [NIT Cliente],
      razonSocial,
      fechaFactura
    )
    VALUES (
      @idPedido,
      @numFactura,
      @montoTotal,
      @NITCliente,
      LTRIM(RTRIM(@razonSocial)),
      CAST(@fechaHoraPedido AS DATE)
    );

    COMMIT TRANSACTION;

    SELECT
      @idPedido AS idPedido,
      @numFactura AS numFactura,
      @montoTotal AS montoTotal;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;

    THROW;
  END CATCH
END
GO

-- -----------------
-- -- PA Bonus -----
-- -----------------

-- Mostrar Sucursales

CREATE OR ALTER PROCEDURE dbo.sp_MostrarSucursales
AS
BEGIN
  SELECT idSucursal, nombreComercial FROM Sucursal;
END;
GO

-- Mostrar Detalle Sucursal

CREATE OR ALTER PROCEDURE dbo.sp_MostarDetalleSucursal
  @idSucursal INT
AS
BEGIN
  IF @idSucursal IS NULL
    THROW 50027, 'idSucursal no puede ser NULL.', 1;

  IF NOT EXISTS(
    SELECT 1
    FROM Sucursal
    WHERE idSucursal=@idSucursal
  )
    THROW 50028, 'idSucursal debe existir en Sucursal.', 1;

  SELECT
    idSucursal,
    c.nombre AS ciudad,
    nombreComercial,
    direccion,
    telefono
  FROM Sucursal AS s
  INNER JOIN Ciudad AS c
    ON s.idCiudad = c.idCiudad
  WHERE idSucursal=@idSucursal;
END;
GO
