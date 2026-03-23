USE bad_dragon;
GO

-- TABLA Ciudad
INSERT INTO dbo.Ciudad (nombre)
VALUES
('Cochabamba'),
('La Paz'),
('Santa Cruz');
GO

-- TABLA Cargo
INSERT INTO dbo.Cargo (nombre)
VALUES
('Administrador'),
('Cajero'),
('Mesero'),
('Cocinero');
GO

-- TABLA MetodoPago
INSERT INTO dbo.MetodoPago (nombre, descripcion)
VALUES
('Efectivo', 'Pago en efectivo en caja'),
('Tarjeta', 'Pago con tarjeta de debito o credito'),
('QR', 'Pago mediante codigo QR');
GO

-- TABLA Categoria
INSERT INTO dbo.Categoria (nombre, descripcion)
VALUES
('Hamburguesas', 'Hamburguesas artesanales de la casa'),
('Pizzas', 'Pizzas personales y familiares'),
('Pastas', 'Pastas con diferentes salsas y acompanamientos'),
('Bebidas', 'Bebidas frias, calientes y especiales'),
('Postres', 'Postres artesanales'),
('Ensaladas', 'Ensaladas frescas y ligeras');
GO

-- TABLA Sucursal
INSERT INTO dbo.Sucursal (idCiudad, nombreComercial, direccion, telefono)
VALUES
(1, 'SubUrbano Cala Cala', 'Av. America Oeste #1023', '4401001'),
(1, 'SubUrbano Centro', 'Calle Espana #245', '4401002'),
(3, 'SubUrbano Equipetrol', 'Av. San Martin #1780', '3341003'),
(2, 'SubUrbano San Miguel', 'Av. Montenegro #890', '2241004'),
(3, 'SubUrbano Norte', 'Av. Banzer #3150', '3341005');
GO

-- TABLA Mesa
INSERT INTO dbo.Mesa (idSucursal, numMesa, capacidad, estado)
VALUES
(1, 1, 2, 'Libre'),
(1, 2, 4, 'Libre'),
(1, 3, 4, 'Ocupada'),
(1, 4, 6, 'Libre'),
(1, 5, 2, 'Reservada'),
(1, 6, 4, 'Libre'),
(1, 7, 6, 'Libre'),
(1, 8, 8, 'Mantenimiento'),

(2, 9, 2, 'Libre'),
(2,10, 4, 'Ocupada'),
(2,11, 4, 'Libre'),
(2,12, 6, 'Libre'),
(2,13, 2, 'Reservada'),
(2,14, 6, 'Libre'),

(3,15, 2, 'Libre'),
(3,16, 4, 'Libre'),
(3,17, 4, 'Ocupada'),
(3,18, 6, 'Libre'),
(3,19, 8, 'Reservada'),

(4,20, 2, 'Libre'),
(4,21, 4, 'Libre'),
(4,22, 4, 'Ocupada'),
(4,23, 6, 'Libre'),

(5,24, 2, 'Libre'),
(5,25, 4, 'Reservada'),
(5,26, 4, 'Libre'),
(5,27, 6, 'Ocupada'),
(5,28, 8, 'Libre');
GO

-- TABLA Empleado
INSERT INTO dbo.Empleado (idCargo, idSucursal, nombre, apellidos, numCarnet, salario)
VALUES
(3, 1, 'Carlos',    'Mendoza',   'EMP001', 4200.00),
(3, 1, 'Daniela',   'Rojas',     'EMP002', 4100.00),
(2, 1, 'Luis',      'Vargas',    'EMP003', 3900.00),
(3, 1, 'Mariana',   'Prieto',    'EMP004', 4050.00),
(2, 1, 'Jorge',     'Salinas',   'EMP005', 3950.00),

(3, 2, 'Andrea',    'Paredes',   'EMP006', 4000.00),
(3, 2, 'Diego',     'Quintana',  'EMP007', 3980.00),
(2, 2, 'Sofia',     'Rivera',    'EMP008', 3920.00),

(3, 3, 'Ricardo',   'Soto',      'EMP009', 4150.00),
(3, 3, 'Gabriela',  'Ruiz',      'EMP010', 4020.00),
(2, 3, 'Pablo',     'Flores',    'EMP011', 3880.00),

(3, 4, 'Valeria',   'Teran',     'EMP012', 4080.00),
(3, 4, 'Miguel',    'Arce',      'EMP013', 3990.00),

(3, 5, 'Fernanda',  'Velasco',   'EMP014', 4120.00),
(2, 5, 'Bruno',     'Aguilar',   'EMP015', 3940.00);
GO

-- TABLA Cliente
INSERT INTO dbo.Cliente (idCiudad, nombre, apellidos, numCarnet, telefono, correo)
VALUES
(1, 'Ana',       'Lopez',        'CB1001', '70710001', 'ana.lopez@mail.com'),
(1, 'Marco',     'Vega',         'CB1002', '70710002', 'marco.vega@mail.com'),
(1, 'Lucia',     'Rojas',        'CB1003', '70710003', 'lucia.rojas@mail.com'),
(1, 'Diego',     'Perez',        'CB1004', '70710004', NULL),
(1, 'Carla',     'Mendoza',      'CB1005', '70710005', 'carla.m@mail.com'),
(1, 'Jose',      'Herrera',      'CB1006', NULL,       'jose.h@mail.com'),
(1, 'Paula',     'Vargas',       'CB1007', '70710007', 'paula.v@mail.com'),
(1, 'Andres',    'Salinas',      'CB1008', '70710008', NULL),
(1, 'Sofia',     'Cespedes',     'CB1009', '70710009', 'sofia.c@mail.com'),
(1, 'Raul',      'Montano',      'CB1010', '70710010', 'raul.m@mail.com'),
(1, 'Maria',     'Quispe',       'CB1011', '70710011', NULL),
(1, 'Javier',    'Rocha',        'CB1012', '70710012', 'javier.r@mail.com'),
(1, 'Fernanda',  'Rios',         'CB1013', '70710013', 'fer.rios@mail.com'),
(1, 'Hugo',      'Camacho',      'CB1014', NULL,       NULL),
(1, 'Natalia',   'Paredes',      'CB1015', '70710015', 'nata.p@mail.com'),
(1, 'Mateo',     'Carrasco',     'CB1016', '70710016', 'mateo.c@mail.com'),
(1, 'Valeria',   'Guzman',       'CB1017', NULL,       'vale.g@mail.com'),
(1, 'Sergio',    'Navia',        'CB1018', '70710018', NULL),
(1, 'Camila',    'Torres',       'SC1019', '73120019', 'camila.t@mail.com'),
(1, 'Daniel',    'Blanco',       'SC1020', '73120020', 'daniel.b@mail.com'),

(3, 'Noelia',    'Mercado',      'SC1021', '73120021', 'noelia.m@mail.com'),
(3, 'Renzo',     'Tapia',        'SC1022', NULL,       'renzo.t@mail.com'),
(3, 'Jimena',    'Ortiz',        'SC1023', '73120023', 'jimena.o@mail.com'),
(3, 'Mauricio',  'Rocha',        'SC1024', '73120024', NULL),
(3, 'Gabriela',  'Pinto',        'SC1025', '73120025', 'gabi.p@mail.com'),
(3, 'Fabian',    'Vaca',         'SC1026', '73120026', 'fabian.v@mail.com'),
(3, 'Alessandra','Pena',         'SC1027', NULL,       'ale.p@mail.com'),
(3, 'Iker',      'Barrientos',   'SC1028', '73120028', NULL),
(3, 'Elena',     'Soria',        'SC1029', '73120029', 'elena.s@mail.com'),
(3, 'Rodrigo',   'Mendez',       'SC1030', '73120030', 'rodrigo.m@mail.com'),
(3, 'Mariana',   'Suarez',       'SC1031', '73120031', NULL),
(3, 'Pablo',     'Antelo',       'SC1032', '73120032', 'pablo.a@mail.com'),
(3, 'Julieta',   'Justiniano',   'SC1033', NULL,       'julieta.j@mail.com'),
(3, 'Cesar',     'Molina',       'SC1034', '73120034', NULL),
(3, 'Carolina',  'Parada',       'SC1035', '73120035', 'caro.p@mail.com'),

(2, 'Thiago',    'Roca',         'LP1036', '76530036', 'thiago.r@mail.com'),
(2, 'Daniela',   'Antelo',       'LP1037', '76530037', NULL),
(2, 'Samuel',    'Hurtado',      'LP1038', NULL,       'samuel.h@mail.com'),
(2, 'Karen',     'Villca',       'LP1039', '76530039', 'karen.v@mail.com'),
(2, 'Luis',      'Mamani',       'LP1040', '76530040', 'luis.m@mail.com'),
(2, 'Adriana',   'Choque',       'LP1041', NULL,       'adriana.c@mail.com'),
(2, 'Mateo',     'Condori',      'LP1042', '76530042', NULL),
(2, 'Briana',    'Flores',       'LP1043', '76530043', 'briana.f@mail.com'),
(2, 'Ruben',     'Quisbert',     'LP1044', '76530044', NULL),
(2, 'Paola',     'Nina',         'LP1045', '76530045', 'paola.n@mail.com'),
(2, 'Kevin',     'Achacollo',    'LP1046', NULL,       'kevin.a@mail.com'),
(2, 'Micaela',   'Tola',         'LP1047', '76530047', NULL),
(2, 'Benjamin',  'Claros',       'LP1048', '76530048', 'benjamin.c@mail.com'),
(2, 'Emilia',    'Cuellar',      'LP1049', NULL,       'emilia.c@mail.com'),
(2, 'Gael',      'Pedraza',      'LP1050', '76530050', NULL),
(2, 'Aitana',    'Montero',      'LP1051', '76530051', 'aitana.m@mail.com'),
(2, 'Martin',    'Vaca',         'LP1052', '76530052', NULL),
(2, 'Isidora',   'Prado',        'LP1053', '76530053', 'isidora.p@mail.com');
GO

-- TABLA Plato
INSERT INTO dbo.Plato (idCategoria, nombre, descripcion, precio)
VALUES
(1, 'Classic Burger',      'Hamburguesa clasica con queso',                    32.00),
(1, 'Bacon Burger',        'Hamburguesa con tocino y cheddar',                 38.00),
(1, 'Doble Burger',        'Doble carne con salsa especial',                   45.00),
(1, 'Chicken Burger',      'Hamburguesa de pollo apanado',                     34.00),
(1, 'BBQ Burger',          'Hamburguesa con salsa BBQ',                        39.00),
(1, 'Mushroom Burger',     'Hamburguesa con champinones salteados',            40.00),
(1, 'Spicy Burger',        'Hamburguesa picante con jalapenos',                37.00),
(1, 'Veggie Burger',       'Hamburguesa vegetariana de la casa',               35.00),

(2, 'Pizza Pepperoni',     'Pizza personal de pepperoni',                      42.00),
(2, 'Pizza Margarita',     'Pizza con tomate y albahaca',                      40.00),
(2, 'Pizza Hawaiana',      'Pizza con jamon y pina',                           43.00),
(2, 'Pizza Cuatro Quesos', 'Pizza con mezcla de quesos',                       46.00),
(2, 'Pizza Suprema',       'Pizza con carnes y vegetales',                     48.00),
(2, 'Pizza Vegetariana',   'Pizza con vegetales frescos',                      41.00),
(2, 'Pizza BBQ Chicken',   'Pizza con pollo y salsa BBQ',                      47.00),

(3, 'Spaghetti Bolognesa', 'Pasta larga con salsa bolognesa',                  36.00),
(3, 'Fettuccine Alfredo',  'Fettuccine en salsa cremosa',                      38.00),
(3, 'Lasagna Mixta',       'Lasagna de carne y pollo',                         44.00),
(3, 'Penne Arrabiata',     'Penne con salsa de tomate picante',                35.00),
(3, 'Ravioles Ricota',     'Ravioles rellenos de ricota',                      40.00),
(3, 'Mac and Cheese',      'Pasta cremosa con mezcla de quesos',               34.00),
(3, 'Tagliatelle Pesto',   'Tagliatelle con salsa pesto',                      39.00),

(4, 'Limonada',            'Limonada natural',                                 10.00),
(4, 'Limonada Hierbabuena','Limonada con hierbabuena',                         12.00),
(4, 'Refresco',            'Gaseosa personal',                                  9.00),
(4, 'Cafe Americano',      'Cafe americano caliente',                           8.00),
(4, 'Capuccino',           'Cafe capuccino',                                   14.00),
(4, 'Te Chai',             'Infusion chai especiada',                          13.00),
(4, 'Jugo Naranja',        'Jugo natural de naranja',                          11.00),
(4, 'Milkshake Vainilla',  'Batido de vainilla',                               16.00),

(5, 'Brownie',             'Brownie tibio con salsa de chocolate',             18.00),
(5, 'Cheesecake',          'Cheesecake clasico',                               20.00),
(5, 'Tiramisu',            'Postre italiano con cafe',                         22.00),
(5, 'Helado Artesanal',    'Copa de helado artesanal',                         15.00),
(5, 'Pie de Limon',        'Pie de limon de la casa',                          19.00),

(6, 'Ensalada Cesar',      'Lechuga, pollo, crutones y aderezo',               24.00),
(6, 'Ensalada Griega',     'Tomate, pepino, aceitunas y queso',                23.00),
(6, 'Ensalada Tropical',   'Mix de hojas, frutas y vinagreta',                 25.00),
(6, 'Ensalada de Atun',    'Ensalada fresca con atun',                         27.00),
(6, 'Ensalada Quinoa',     'Quinoa, vegetales y aderezo ligero',               26.00);
GO

-- TABLA Pedido
INSERT INTO dbo.Pedido (idCliente, idEmpleado, idMetodo, idMesa, estado, fechaHoraPedido)
VALUES
( 1, 1, 1,  1, 'Entregado', '2026-01-02T13:10:00'),
( 2, 1, 3,  2, 'Entregado', '2026-01-03T20:15:00'),
( 3, 2, 2,  3, 'Entregado', '2026-01-04T12:40:00'),
( 4, 1, 1,  4, 'Entregado', '2026-01-05T19:20:00'),
( 5, 2, 3,  5, 'Entregado', '2026-01-06T21:00:00'),
( 1, 1, 2,  1, 'Entregado', '2026-01-08T13:30:00'),
( 6, 3, 1,  6, 'Entregado', '2026-01-09T20:45:00'),
( 7, 2, 3,  7, 'Entregado', '2026-01-10T14:10:00'),
( 8, 1, 2,  2, 'Entregado', '2026-01-12T12:20:00'),
( 9, 4, 1,  8, 'Entregado', '2026-01-13T19:50:00'),
(10, 5, 3,  3, 'Entregado', '2026-01-15T21:10:00'),
( 2, 1, 1,  4, 'Entregado', '2026-01-16T13:00:00'),
( 3, 2, 2,  5, 'Entregado', '2026-01-18T20:05:00'),
(11, 3, 3,  6, 'Entregado', '2026-01-20T14:35:00'),
(12, 1, 2,  1, 'Entregado', '2026-01-22T19:25:00'),
( 4, 2, 1,  7, 'Entregado', '2026-01-24T21:20:00'),
(13, 1, 3,  2, 'Entregado', '2026-01-26T12:55:00'),
( 5, 4, 1,  8, 'Entregado', '2026-01-28T20:40:00'),
( 1, 1, 2,  3, 'Entregado', '2026-02-01T13:15:00'),
(14, 2, 3,  4, 'Entregado', '2026-02-03T19:45:00'),
(15, 1, 1,  5, 'Entregado', '2026-02-05T21:05:00'),
( 6, 3, 2,  6, 'Entregado', '2026-02-08T14:00:00'),
( 7, 1, 3,  1, 'Entregado', '2026-02-10T20:25:00'),
(16, 2, 1,  7, 'Entregado', '2026-02-12T13:50:00'),
(17, 1, 2,  2, 'Entregado', '2026-02-15T19:35:00'),
( 3, 5, 3,  8, 'Entregado', '2026-02-18T21:30:00'),
(18, 1, 1,  4, 'Entregado', '2026-02-22T12:45:00'),
( 2, 2, 2,  5, 'Entregado', '2026-02-26T20:10:00'),

(19, 6, 3,  9, 'Entregado', '2026-01-02T12:30:00'),
(20, 6, 1, 10, 'Entregado', '2026-01-05T20:10:00'),
(21, 7, 2, 11, 'Entregado', '2026-01-07T13:40:00'),
(22, 8, 3, 12, 'Entregado', '2026-01-11T19:15:00'),
(23, 6, 1, 13, 'Entregado', '2026-01-14T21:20:00'),
(24, 7, 2, 14, 'Entregado', '2026-01-17T14:05:00'),
(25, 6, 3,  9, 'Entregado', '2026-01-21T20:45:00'),
(19, 8, 1, 10, 'Entregado', '2026-01-25T13:15:00'),
(26, 7, 2, 11, 'Entregado', '2026-01-29T19:55:00'),
(20, 6, 3, 12, 'Entregado', '2026-02-02T21:25:00'),
(21, 7, 1, 13, 'Entregado', '2026-02-06T12:50:00'),
(27, 6, 2, 14, 'Entregado', '2026-02-09T20:00:00'),
(28, 8, 3,  9, 'Entregado', '2026-02-11T14:20:00'),
(22, 7, 1, 10, 'Entregado', '2026-02-14T19:30:00'),
(23, 6, 2, 11, 'Entregado', '2026-02-17T21:10:00'),
(24, 7, 3, 12, 'Entregado', '2026-02-20T13:05:00'),
(19, 6, 1, 13, 'Entregado', '2026-02-24T20:35:00'),
(25, 8, 2, 14, 'Entregado', '2026-02-27T19:40:00'),

(29, 9, 1, 15, 'Entregado', '2026-01-03T13:00:00'),
(30, 9, 3, 16, 'Entregado', '2026-01-06T20:20:00'),
(31,10, 2, 17, 'Entregado', '2026-01-10T14:15:00'),
(32,11, 1, 18, 'Entregado', '2026-01-13T19:10:00'),
(33, 9, 3, 19, 'Entregado', '2026-01-18T21:00:00'),
(29,10, 2, 15, 'Entregado', '2026-01-23T13:25:00'),
(34, 9, 1, 16, 'Entregado', '2026-01-27T20:50:00'),
(35,11, 3, 17, 'Entregado', '2026-02-04T12:35:00'),
(36, 9, 2, 18, 'Entregado', '2026-02-07T19:45:00'),
(37,10, 1, 19, 'Entregado', '2026-02-13T21:15:00'),
(38, 9, 3, 15, 'Entregado', '2026-02-16T13:10:00'),
(30,11, 2, 16, 'Entregado', '2026-02-19T20:05:00'),
(31,10, 1, 17, 'Entregado', '2026-02-23T14:00:00'),
(39, 9, 3, 18, 'Entregado', '2026-02-28T19:20:00'),

(40,12, 2, 20, 'Entregado', '2026-01-04T12:55:00'),
(41,12, 1, 21, 'Entregado', '2026-01-12T20:15:00'),
(42,13, 3, 22, 'Entregado', '2026-01-19T13:35:00'),
(43,12, 2, 23, 'Entregado', '2026-01-30T19:50:00'),
(44,12, 1, 20, 'Entregado', '2026-02-05T21:20:00'),
(45,13, 3, 21, 'Entregado', '2026-02-10T13:45:00'),
(46,12, 2, 22, 'Entregado', '2026-02-18T20:30:00'),
(47,13, 1, 23, 'Entregado', '2026-02-22T14:10:00'),
(40,12, 3, 20, 'Entregado', '2026-02-27T19:55:00'),

(48,14, 1, 24, 'Entregado', '2026-01-08T13:20:00'),
(49,14, 3, 25, 'Entregado', '2026-01-16T20:25:00'),
(50,15, 2, 26, 'Entregado', '2026-01-22T14:05:00'),
(51,14, 1, 27, 'Entregado', '2026-01-26T19:40:00'),
(52,15, 3, 28, 'Entregado', '2026-01-31T21:10:00'),
(48,14, 2, 24, 'Entregado', '2026-02-03T12:40:00'),
(53,15, 1, 25, 'Entregado', '2026-02-08T20:15:00'),
(49,14, 3, 26, 'Entregado', '2026-02-12T13:55:00'),
(50,14, 2, 27, 'Entregado', '2026-02-16T19:25:00'),
(51,15, 1, 28, 'Entregado', '2026-02-20T21:35:00'),
(52,14, 3, 24, 'Entregado', '2026-02-24T14:15:00'),
(53,14, 2, 25, 'Entregado', '2026-02-26T20:20:00'),
(48,15, 1, 26, 'Entregado', '2026-02-28T19:45:00');
GO

-- TABLA DetallePedido
;WITH N AS (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
),
LineasPorPedido AS (
    SELECT
        p.idPedido,
        CASE
            WHEN p.idPedido % 10 = 0 THEN 1
            WHEN p.idPedido % 10 IN (1,2,3) THEN 2
            WHEN p.idPedido % 10 IN (4,5,6) THEN 3
            WHEN p.idPedido % 10 IN (7,8) THEN 4
            ELSE 5
        END AS totalLineas
    FROM dbo.Pedido p
)
INSERT INTO dbo.DetallePedido (idPlato, idPedido, cantidad, precio)
SELECT
    ((lp.idPedido * 5 + n.n * 7) % 40) + 1 AS idPlato,
    lp.idPedido,
    ((lp.idPedido + n.n) % 3) + 1 AS cantidad,
    pl.precio
FROM LineasPorPedido lp
JOIN N
    ON n.n <= lp.totalLineas
JOIN dbo.Plato pl
    ON pl.idPlato = ((lp.idPedido * 5 + n.n * 7) % 40) + 1;
GO

-- TABLA Factura
INSERT INTO dbo.Factura (idPedido, numFactura, montoTotal, [NIT Cliente], razonSocial, fechaFactura)
SELECT
    p.idPedido,
    2026000 + p.idPedido AS numFactura,
    SUM(d.cantidad * d.precio) AS montoTotal,
    70000000 + c.idCliente AS [NIT Cliente],
    CONCAT(c.nombre, ' ', c.apellidos) AS razonSocial,
    CAST(p.fechaHoraPedido AS DATE) AS fechaFactura
FROM dbo.Pedido p
INNER JOIN dbo.Cliente c
    ON c.idCliente = p.idCliente
INNER JOIN dbo.DetallePedido d
    ON d.idPedido = p.idPedido
GROUP BY
    p.idPedido,
    c.idCliente,
    c.nombre,
    c.apellidos,
    CAST(p.fechaHoraPedido AS DATE);
GO