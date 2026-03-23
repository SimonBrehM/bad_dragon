// API

// /sucursales
export type Sucursal = {
  idSucursal: number;
  nombreComercial: string;
};

export type GetSucursalesReponse = {
  data: Sucursal[];
};

export type Cliente = {
  idCliente: number;
  nombreCliente: string;
  totalPedidos: number;
};

export type GetTopClienteResponse = {
  data: Cliente[];
};

export type Plato = {
  idPlato: number;
  nombre: string;
  cantidadVendida: number;
  totalRecaudado: number;
};

export type GetTopPlatoResponse = {
  data: Plato[];
};

export type DetalleSucursal = {
  idSucursal: number;
  ciudad: string;
  direccion: string;
  telefono: string;
};

export type GetDetalleSucursal = {
  data: DetalleSucursal;
};

export type TotalVendido = {
  idSucursal: string;
  nombreComercial: string;
  totalVendido: string;
};

export type GetTotalVendido = {
  data: TotalVendido;
};

export type PostCliente = {
  nombre: string;
  apellidos: string;
  numCarnet: string;
  telefono: string | null;
  correo: string | null;
  idCiudad: number;
};

export type PostPlato = {
  nombre: string;
  descripcion: string;
  precio: number;
  idCategoria: number;
};

export type PostPedido = {
  idCliente: number;
  idEmpleado: number;
  idMetodo: number;
  idMesa: number;
  estado: string;
  numFactura: number;
  NITCliente: number;
  razonSocial: string;
  idPlatos: number[];
};

// Page

export enum ModalState {
  Hidden,
  Sucursal,
  Cliente,
  Plato,
  Pedido,
}
