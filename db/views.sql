USE bad_dragon;
GO

-- Pedidos con fecha, estado, cliente, empleado, sucursal, mesa,
-- metodo de pago, cantidad total de items y monto total por pedido

IF OBJECT_ID('dbo.vw_PedidosResumen', 'V') IS NOT NULL
  DROP VIEW dbo.vw_PedidosResumen;
GO

CREATE VIEW dbo.vw_PedidosResumen
AS
SELECT
  p.idPedido,
  CAST(p.fechaHoraPedido AS DATE) AS fecha,
  p.estado,
  CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
  CONCAT(e.nombre, ' ', e.apellidos) AS empleado,
  s.nombreComercial AS sucursal,
  m.numMesa AS mesa,
  mp.nombre AS metodoPago,
  SUM(dp.cantidad) AS cantidadTotalItems,
  ISNULL(f.montoTotal, SUM(dp.cantidad * dp.precio)) AS montoTotalPedido
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
INNER JOIN dbo.DetallePedido dp
  ON p.idPedido = dp.idPedido
LEFT JOIN dbo.Factura f
  ON p.idPedido = f.idPedido
GROUP BY
  p.idPedido,
  CAST(p.fechaHoraPedido AS DATE),
  p.estado,
  c.nombre,
  c.apellidos,
  e.nombre,
  e.apellidos,
  s.nombreComercial,
  m.numMesa,
  mp.nombre,
  f.montoTotal;
GO

-- VISTA k. Total de ingresos generados de cada ciudad

IF OBJECT_ID('dbo.vw_TotalIngresosPorCiudad', 'V') IS NOT NULL
  DROP VIEW dbo.vw_TotalIngresosPorCiudad;
GO

CREATE VIEW dbo.vw_TotalIngresosPorCiudad
AS
SELECT
  c.idCiudad,
  c.nombre AS ciudad,
  COUNT(f.idFactura) AS totalFacturas,
  SUM(f.montoTotal) AS totalIngresos
FROM dbo.Factura f
INNER JOIN dbo.Pedido p
  ON f.idPedido = p.idPedido
INNER JOIN dbo.Mesa m
  ON p.idMesa = m.idMesa
INNER JOIN dbo.Sucursal s
  ON m.idSucursal = s.idSucursal
INNER JOIN dbo.Ciudad c
  ON s.idCiudad = c.idCiudad
GROUP BY
  c.idCiudad,
  c.nombre;
GO

-- VISTA l. Platos mas vendidos de cada sucursal

IF OBJECT_ID('dbo.vw_PlatosMasVendidosPorSucursal', 'V') IS NOT NULL
  DROP VIEW dbo.vw_PlatosMasVendidosPorSucursal;
GO

CREATE VIEW dbo.vw_PlatosMasVendidosPorSucursal
AS
WITH VentasPlatoSucursal AS
(
  SELECT
    s.idSucursal,
    s.nombreComercial AS sucursal,
    pl.idPlato,
    pl.nombre AS plato,
    SUM(dp.cantidad) AS cantidadVendida,
    SUM(dp.cantidad * dp.precio) AS totalRecaudado,
    RANK() OVER (
      PARTITION BY s.idSucursal
      ORDER BY SUM(dp.cantidad) DESC
    ) AS rankingVentas
  FROM dbo.DetallePedido dp
  INNER JOIN dbo.Pedido p
    ON dp.idPedido = p.idPedido
  INNER JOIN dbo.Mesa m
    ON p.idMesa = m.idMesa
  INNER JOIN dbo.Sucursal s
    ON m.idSucursal = s.idSucursal
  INNER JOIN dbo.Plato pl
    ON dp.idPlato = pl.idPlato
  GROUP BY
    s.idSucursal,
    s.nombreComercial,
    pl.idPlato,
    pl.nombre
)
SELECT
  idSucursal,
  sucursal,
  idPlato,
  plato,
  cantidadVendida,
  totalRecaudado,
  rankingVentas
FROM VentasPlatoSucursal
WHERE rankingVentas = 1;
GO

-- VISTA m. Detalles de factura de cada pedido por mes

IF OBJECT_ID('dbo.vw_DetalleFacturaPedidoPorMes', 'V') IS NOT NULL
  DROP VIEW dbo.vw_DetalleFacturaPedidoPorMes;
GO

CREATE VIEW dbo.vw_DetalleFacturaPedidoPorMes
AS
SELECT
  YEAR(f.fechaFactura) AS anio,
  MONTH(f.fechaFactura) AS mes,
  p.idPedido,
  f.idFactura,
  f.numFactura,
  f.fechaFactura,
  CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
  CONCAT(e.nombre, ' ', e.apellidos) AS empleado,
  s.nombreComercial AS sucursal,
  m.numMesa AS mesa,
  mp.nombre AS metodoPago,
  p.estado,
  SUM(dp.cantidad) AS cantidadTotalItems,
  f.montoTotal
FROM dbo.Factura f
INNER JOIN dbo.Pedido p
  ON f.idPedido = p.idPedido
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
INNER JOIN dbo.DetallePedido dp
  ON p.idPedido = dp.idPedido
GROUP BY
  YEAR(f.fechaFactura),
  MONTH(f.fechaFactura),
  p.idPedido,
  f.idFactura,
  f.numFactura,
  f.fechaFactura,
  c.nombre,
  c.apellidos,
  e.nombre,
  e.apellidos,
  s.nombreComercial,
  m.numMesa,
  mp.nombre,
  p.estado,
  f.montoTotal;
GO
