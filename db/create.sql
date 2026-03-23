USE master;
GO

IF DB_ID('bad_dragon') IS NOT NULL
BEGIN
  ALTER DATABASE bad_dragon SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE bad_dragon;
END
GO

CREATE DATABASE bad_dragon;
GO

USE bad_dragon;
GO


-- TABLA Ciudad
CREATE TABLE dbo.Ciudad (
  idCiudad INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Ciudad PRIMARY KEY (idCiudad)
);
GO

-- TABLA Cargo
CREATE TABLE dbo.Cargo (
  idCargo INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  CONSTRAINT PK_Cargo PRIMARY KEY (idCargo)
);
GO

-- TABLA Categoria
CREATE TABLE dbo.Categoria (
  idCategoria INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  CONSTRAINT PK_Categoria PRIMARY KEY (idCategoria),
  CONSTRAINT UQ_Categoria_Nombre UNIQUE (nombre)
);
GO

-- TABLA MetodoPago
CREATE TABLE dbo.MetodoPago (
  idMetodo INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(30) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  CONSTRAINT PK_MetodoPago PRIMARY KEY (idMetodo)
);
GO

-- TABLA Sucursal
CREATE TABLE dbo.Sucursal (
  idSucursal INT IDENTITY(1,1) NOT NULL,
  idCiudad INT NOT NULL,
  nombreComercial VARCHAR(50) NOT NULL,
  direccion VARCHAR(150) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  CONSTRAINT PK_Sucursal PRIMARY KEY (idSucursal),
  CONSTRAINT FK_Sucursal_Ciudad FOREIGN KEY (idCiudad)
    REFERENCES dbo.Ciudad(idCiudad),
  CONSTRAINT CK_Sucursal_Telefono
    CHECK (telefono NOT LIKE '%[^0-9]%' AND LEN(telefono) BETWEEN 7 AND 15)
);
GO

-- TABLA Cliente
CREATE TABLE dbo.Cliente (
  idCliente INT IDENTITY(1,1) NOT NULL,
  idCiudad INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellidos VARCHAR(150) NOT NULL,
  numCarnet VARCHAR(15) NOT NULL,
  telefono VARCHAR(15) NULL,
  correo VARCHAR(30) NULL,
  CONSTRAINT PK_Cliente PRIMARY KEY (idCliente),
  CONSTRAINT FK_Cliente_Ciudad FOREIGN KEY (idCiudad)
    REFERENCES dbo.Ciudad(idCiudad),
  CONSTRAINT UQ_Cliente_NumCarnet UNIQUE (numCarnet),
  CONSTRAINT CK_Cliente_Telefono
    CHECK (
      telefono IS NULL OR
      (telefono NOT LIKE '%[^0-9]%' AND LEN(telefono) BETWEEN 7 AND 15)
    ),
  CONSTRAINT CK_Cliente_Correo
    CHECK (
      correo IS NULL OR
      correo LIKE '%_@_%._%'
    )
);
GO

-- TABLA Mesa
CREATE TABLE dbo.Mesa (
  idMesa INT IDENTITY(1,1) NOT NULL,
  idSucursal INT NOT NULL,
  numMesa INT NOT NULL,
  capacidad INT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT PK_Mesa PRIMARY KEY (idMesa),
  CONSTRAINT FK_Mesa_Sucursal FOREIGN KEY (idSucursal)
    REFERENCES dbo.Sucursal(idSucursal),
  CONSTRAINT UQ_Mesa_Sucursal_NumMesa UNIQUE (idSucursal, numMesa),
  CONSTRAINT CK_Mesa_NumMesa CHECK (numMesa > 0),
  CONSTRAINT CK_Mesa_Capacidad CHECK (capacidad > 0),
  CONSTRAINT CK_Mesa_Estado CHECK (estado IN ('Libre','Ocupada','Reservada','Mantenimiento'))
);
GO

-- TABLA Empleado
CREATE TABLE dbo.Empleado (
  idEmpleado INT IDENTITY(1,1) NOT NULL,
  idCargo INT NOT NULL,
  idSucursal INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  numCarnet VARCHAR(15) NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  CONSTRAINT PK_Empleado PRIMARY KEY (idEmpleado),
  CONSTRAINT FK_Empleado_Cargo FOREIGN KEY (idCargo)
    REFERENCES dbo.Cargo(idCargo),
  CONSTRAINT FK_Empleado_Sucursal FOREIGN KEY (idSucursal)
    REFERENCES dbo.Sucursal(idSucursal),
  CONSTRAINT UQ_Empleado_NumCarnet UNIQUE (numCarnet),
  CONSTRAINT CK_Empleado_Salario CHECK (salario >= 0)
);
GO

-- TABLA Plato
CREATE TABLE dbo.Plato (
  idPlato INT IDENTITY(1,1) NOT NULL,
  idCategoria INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  CONSTRAINT PK_Plato PRIMARY KEY (idPlato),
  CONSTRAINT FK_Plato_Categoria FOREIGN KEY (idCategoria)
    REFERENCES dbo.Categoria(idCategoria),
  CONSTRAINT CK_Plato_Precio CHECK (precio >= 0)
);
GO

-- TABLA Pedido
CREATE TABLE dbo.Pedido (
  idPedido INT IDENTITY(1,1) NOT NULL,
  idCliente INT NOT NULL,
  idEmpleado INT NOT NULL,
  idMetodo INT NOT NULL,
  idMesa INT NOT NULL,
  estado VARCHAR(15) NOT NULL,
  fechaHoraPedido DATETIME NOT NULL,
  CONSTRAINT PK_Pedido PRIMARY KEY (idPedido),
  CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (idCliente)
    REFERENCES dbo.Cliente(idCliente),
  CONSTRAINT FK_Pedido_Empleado FOREIGN KEY (idEmpleado)
    REFERENCES dbo.Empleado(idEmpleado),
  CONSTRAINT FK_Pedido_MetodoPago FOREIGN KEY (idMetodo)
    REFERENCES dbo.MetodoPago(idMetodo),
  CONSTRAINT FK_Pedido_Mesa FOREIGN KEY (idMesa)
    REFERENCES dbo.Mesa(idMesa),
  CONSTRAINT CK_Pedido_Estado CHECK (estado IN ('Pendiente','Entregado','Cancelado'))
);
GO

-- TABLA Factura
CREATE TABLE dbo.Factura (
  idFactura INT IDENTITY(1,1) NOT NULL,
  idPedido INT NOT NULL,
  numFactura INT NOT NULL,
  montoTotal DECIMAL(10,2) NOT NULL,
  [NIT Cliente] INT NOT NULL,
  razonSocial VARCHAR(100) NOT NULL,
  fechaFactura DATE NOT NULL,
  CONSTRAINT PK_Factura PRIMARY KEY (idFactura),
  CONSTRAINT FK_Factura_Pedido FOREIGN KEY (idPedido)
    REFERENCES dbo.Pedido(idPedido),
  CONSTRAINT UQ_Factura_NumFactura UNIQUE (numFactura),
  CONSTRAINT UQ_Factura_IdPedido UNIQUE (idPedido),
  CONSTRAINT CK_Factura_MontoTotal CHECK (montoTotal >= 0),
  CONSTRAINT CK_Factura_NITCliente CHECK ([NIT Cliente] >= 0)
);
GO

-- TABLA DetallePedido
CREATE TABLE dbo.DetallePedido (
  idPlato INT NOT NULL,
  idPedido INT NOT NULL,
  cantidad INT NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  CONSTRAINT PK_DetallePedido PRIMARY KEY (idPlato, idPedido),
  CONSTRAINT FK_DetallePedido_Plato FOREIGN KEY (idPlato)
    REFERENCES dbo.Plato(idPlato),
  CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (idPedido)
    REFERENCES dbo.Pedido(idPedido),
  CONSTRAINT CK_DetallePedido_Cantidad CHECK (cantidad > 0),
  CONSTRAINT CK_DetallePedido_Precio CHECK (precio >= 0)
);
GO
