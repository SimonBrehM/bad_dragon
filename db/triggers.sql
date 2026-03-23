USE bad_dragon;
GO

-- Bitacora de Pedido

IF OBJECT_ID('dbo.BitacoraPedido', 'U') IS NOT NULL
  DROP TABLE dbo.BitacoraPedido;
GO

CREATE TABLE dbo.BitacoraPedido (
  idBitacoraPedido INT IDENTITY(1,1) NOT NULL,
  idPedido INT NOT NULL,
  accion VARCHAR(10) NOT NULL,
  fechaMovimiento DATETIME NOT NULL
    CONSTRAINT DF_BitacoraPedido_Fecha DEFAULT GETDATE(),
  usuarioBD VARCHAR(128) NOT NULL
    CONSTRAINT DF_BitacoraPedido_Usuario DEFAULT SUSER_SNAME(),
  datosAnteriores VARCHAR(600) NULL,
  datosNuevos VARCHAR(600) NULL,
  CONSTRAINT PK_BitacoraPedido PRIMARY KEY (idBitacoraPedido)
);
GO

IF OBJECT_ID('dbo.tr_BitacoraPedido', 'TR') IS NOT NULL
  DROP TRIGGER dbo.tr_BitacoraPedido;
GO

CREATE TRIGGER dbo.tr_BitacoraPedido
ON dbo.Pedido
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  -- Validar si la accion fue INSERT
  IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPedido (
      idPedido,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idPedido,
      'INSERT',
      NULL,
      CONCAT(
        'idCliente=', i.idCliente,
        ', idEmpleado=', i.idEmpleado,
        ', idMetodo=', i.idMetodo,
        ', idMesa=', i.idMesa,
        ', estado=', i.estado,
        ', fechaHoraPedido=', CONVERT(VARCHAR(19), i.fechaHoraPedido, 120)
      )
    FROM inserted i;
  END

  -- Validar si la accion fue UPDATE
  IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPedido (
      idPedido,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idPedido,
      'UPDATE',
      CONCAT(
        'idCliente=', d.idCliente,
        ', idEmpleado=', d.idEmpleado,
        ', idMetodo=', d.idMetodo,
        ', idMesa=', d.idMesa,
        ', estado=', d.estado,
        ', fechaHoraPedido=', CONVERT(VARCHAR(19), d.fechaHoraPedido, 120)
      ),
      CONCAT(
        'idCliente=', i.idCliente,
        ', idEmpleado=', i.idEmpleado,
        ', idMetodo=', i.idMetodo,
        ', idMesa=', i.idMesa,
        ', estado=', i.estado,
        ', fechaHoraPedido=', CONVERT(VARCHAR(19), i.fechaHoraPedido, 120)
      )
    FROM inserted i
    INNER JOIN deleted d
      ON i.idPedido = d.idPedido;
  END

  -- Validar si la accion fue DELETE
  IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPedido (
      idPedido,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      d.idPedido,
      'DELETE',
      CONCAT(
        'idCliente=', d.idCliente,
        ', idEmpleado=', d.idEmpleado,
        ', idMetodo=', d.idMetodo,
        ', idMesa=', d.idMesa,
        ', estado=', d.estado,
        ', fechaHoraPedido=', CONVERT(VARCHAR(19), d.fechaHoraPedido, 120)
      ),
      NULL
    FROM deleted d;
  END
END
GO


-- Bitacora de Factura

IF OBJECT_ID('dbo.BitacoraFactura', 'U') IS NOT NULL
  DROP TABLE dbo.BitacoraFactura;
GO

CREATE TABLE dbo.BitacoraFactura (
  idBitacoraFactura INT IDENTITY(1,1) NOT NULL,
  idFactura INT NOT NULL,
  accion VARCHAR(10) NOT NULL,
  fechaMovimiento DATETIME NOT NULL
    CONSTRAINT DF_BitacoraFactura_Fecha DEFAULT GETDATE(),
  usuarioBD VARCHAR(128) NOT NULL
    CONSTRAINT DF_BitacoraFactura_Usuario DEFAULT SUSER_SNAME(),
  datosAnteriores VARCHAR(600) NULL,
  datosNuevos VARCHAR(600) NULL,
  CONSTRAINT PK_BitacoraFactura PRIMARY KEY (idBitacoraFactura)
);
GO

IF OBJECT_ID('dbo.tr_BitacoraFactura', 'TR') IS NOT NULL
  DROP TRIGGER dbo.tr_BitacoraFactura;
GO

CREATE TRIGGER dbo.tr_BitacoraFactura
ON dbo.Factura
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  -- Validar si la accion fue INSERT
  IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraFactura (
      idFactura,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idFactura,
      'INSERT',
      NULL,
      CONCAT(
        'idPedido=', i.idPedido,
        ', numFactura=', i.numFactura,
        ', montoTotal=', i.montoTotal,
        ', NITCliente=', i.[NIT Cliente],
        ', razonSocial=', i.razonSocial,
        ', fechaFactura=', CONVERT(VARCHAR(10), i.fechaFactura, 120)
      )
    FROM inserted i;
  END

  -- Validar si la accion fue UPDATE
  IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraFactura (
      idFactura,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idFactura,
      'UPDATE',
      CONCAT(
        'idPedido=', d.idPedido,
        ', numFactura=', d.numFactura,
        ', montoTotal=', d.montoTotal,
        ', NITCliente=', d.[NIT Cliente],
        ', razonSocial=', d.razonSocial,
        ', fechaFactura=', CONVERT(VARCHAR(10), d.fechaFactura, 120)
      ),
      CONCAT(
        'idPedido=', i.idPedido,
        ', numFactura=', i.numFactura,
        ', montoTotal=', i.montoTotal,
        ', NITCliente=', i.[NIT Cliente],
        ', razonSocial=', i.razonSocial,
        ', fechaFactura=', CONVERT(VARCHAR(10), i.fechaFactura, 120)
      )
    FROM inserted i
    INNER JOIN deleted d
      ON i.idFactura = d.idFactura;
  END

  -- Validar si la accion fue DELETE
  IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraFactura (
      idFactura,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      d.idFactura,
      'DELETE',
      CONCAT(
        'idPedido=', d.idPedido,
        ', numFactura=', d.numFactura,
        ', montoTotal=', d.montoTotal,
        ', NITCliente=', d.[NIT Cliente],
        ', razonSocial=', d.razonSocial,
        ', fechaFactura=', CONVERT(VARCHAR(10), d.fechaFactura, 120)
      ),
      NULL
    FROM deleted d;
  END
END
GO


-- Bitacora de Cliente

IF OBJECT_ID('dbo.BitacoraCliente', 'U') IS NOT NULL
  DROP TABLE dbo.BitacoraCliente;
GO

CREATE TABLE dbo.BitacoraCliente (
  idBitacoraCliente INT IDENTITY(1,1) NOT NULL,
  idCliente INT NOT NULL,
  accion VARCHAR(10) NOT NULL,
  fechaMovimiento DATETIME NOT NULL
    CONSTRAINT DF_BitacoraCliente_Fecha DEFAULT GETDATE(),
  usuarioBD VARCHAR(128) NOT NULL
    CONSTRAINT DF_BitacoraCliente_Usuario DEFAULT SUSER_SNAME(),
  datosAnteriores VARCHAR(600) NULL,
  datosNuevos VARCHAR(600) NULL,
  CONSTRAINT PK_BitacoraCliente PRIMARY KEY (idBitacoraCliente)
);
GO

IF OBJECT_ID('dbo.tr_BitacoraCliente', 'TR') IS NOT NULL
  DROP TRIGGER dbo.tr_BitacoraCliente;
GO

CREATE TRIGGER dbo.tr_BitacoraCliente
ON dbo.Cliente
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  -- Validar si la accion fue INSERT
  IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraCliente (
      idCliente,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idCliente,
      'INSERT',
      NULL,
      CONCAT(
        'idCiudad=', i.idCiudad,
        ', nombre=', i.nombre,
        ', apellidos=', i.apellidos,
        ', numCarnet=', i.numCarnet,
        ', telefono=', ISNULL(i.telefono, 'NULL'),
        ', correo=', ISNULL(i.correo, 'NULL')
      )
    FROM inserted i;
  END

  -- Validar si la accion fue UPDATE
  IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraCliente (
      idCliente,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idCliente,
      'UPDATE',
      CONCAT(
        'idCiudad=', d.idCiudad,
        ', nombre=', d.nombre,
        ', apellidos=', d.apellidos,
        ', numCarnet=', d.numCarnet,
        ', telefono=', ISNULL(d.telefono, 'NULL'),
        ', correo=', ISNULL(d.correo, 'NULL')
      ),
      CONCAT(
        'idCiudad=', i.idCiudad,
        ', nombre=', i.nombre,
        ', apellidos=', i.apellidos,
        ', numCarnet=', i.numCarnet,
        ', telefono=', ISNULL(i.telefono, 'NULL'),
        ', correo=', ISNULL(i.correo, 'NULL')
      )
    FROM inserted i
    INNER JOIN deleted d
      ON i.idCliente = d.idCliente;
  END

  -- Validar si la accion fue DELETE
  IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraCliente (
      idCliente,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      d.idCliente,
      'DELETE',
      CONCAT(
        'idCiudad=', d.idCiudad,
        ', nombre=', d.nombre,
        ', apellidos=', d.apellidos,
        ', numCarnet=', d.numCarnet,
        ', telefono=', ISNULL(d.telefono, 'NULL'),
        ', correo=', ISNULL(d.correo, 'NULL')
      ),
      NULL
    FROM deleted d;
  END
END
GO


-- Bitacora de Plato

IF OBJECT_ID('dbo.BitacoraPlato', 'U') IS NOT NULL
  DROP TABLE dbo.BitacoraPlato;
GO

CREATE TABLE dbo.BitacoraPlato (
  idBitacoraPlato INT IDENTITY(1,1) NOT NULL,
  idPlato INT NOT NULL,
  accion VARCHAR(10) NOT NULL,
  fechaMovimiento DATETIME NOT NULL
    CONSTRAINT DF_BitacoraPlato_Fecha DEFAULT GETDATE(),
  usuarioBD VARCHAR(128) NOT NULL
    CONSTRAINT DF_BitacoraPlato_Usuario DEFAULT SUSER_SNAME(),
  datosAnteriores VARCHAR(600) NULL,
  datosNuevos VARCHAR(600) NULL,
  CONSTRAINT PK_BitacoraPlato PRIMARY KEY (idBitacoraPlato)
);
GO

IF OBJECT_ID('dbo.tr_BitacoraPlato', 'TR') IS NOT NULL
  DROP TRIGGER dbo.tr_BitacoraPlato;
GO

CREATE TRIGGER dbo.tr_BitacoraPlato
ON dbo.Plato
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;

  -- Validar si la accion fue INSERT
  IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPlato (
      idPlato,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idPlato,
      'INSERT',
      NULL,
      CONCAT(
        'idCategoria=', i.idCategoria,
        ', nombre=', i.nombre,
        ', descripcion=', i.descripcion,
        ', precio=', i.precio
      )
    FROM inserted i;
  END

  -- Validar si la accion fue UPDATE
  IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPlato (
      idPlato,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      i.idPlato,
      'UPDATE',
      CONCAT(
        'idCategoria=', d.idCategoria,
        ', nombre=', d.nombre,
        ', descripcion=', d.descripcion,
        ', precio=', d.precio
      ),
      CONCAT(
        'idCategoria=', i.idCategoria,
        ', nombre=', i.nombre,
        ', descripcion=', i.descripcion,
        ', precio=', i.precio
      )
    FROM inserted i
    INNER JOIN deleted d
      ON i.idPlato = d.idPlato;
  END

  -- Validar si la accion fue DELETE
  IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
  BEGIN
    INSERT INTO dbo.BitacoraPlato (
      idPlato,
      accion,
      datosAnteriores,
      datosNuevos
    )
    SELECT
      d.idPlato,
      'DELETE',
      CONCAT(
        'idCategoria=', d.idCategoria,
        ', nombre=', d.nombre,
        ', descripcion=', d.descripcion,
        ', precio=', d.precio
      ),
      NULL
    FROM deleted d;
  END
END
GO
