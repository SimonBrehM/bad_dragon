import {
  Cliente,
  DetalleSucursal,
  GetDetalleSucursal,
  GetSucursalesReponse,
  GetTopClienteResponse,
  GetTopPlatoResponse,
  GetTotalVendido,
  Plato,
  PostCliente,
  PostPedido,
  PostPlato,
  Sucursal,
  TotalVendido,
} from "./types";

export async function getSucursales(): Promise<Sucursal[]> {
  const res = await fetch("/api/sucursales", {
    method: "GET",
    headers: {
      Accept: "application/json",
    },
  });

  if (!res.ok) throw new Error("HTTP error " + res.status);

  const json: GetSucursalesReponse = await res.json();
  const sucursales = json.data;
  return sucursales;
}

export async function getClientes(
  idSucursal: number,
  count: number | null = null,
): Promise<Cliente[]> {
  const res = await fetch(
    `/api/clientes?idSucursal=${idSucursal}${count != null ? `&count=${count}` : ""}`,
    {
      method: "GET",
      headers: {
        Accept: "application/json",
      },
    },
  );

  if (!res.ok) throw new Error("HTTP error " + res.status);

  const json: GetTopClienteResponse = await res.json();
  const clientes = json.data;
  return clientes;
}

export async function getPlatos(
  startDate: string,
  endDate: string,
  idSucursal: number,
  count: number | null = null,
): Promise<Plato[]> {
  const res = await fetch(
    `/api/platos?start=${startDate}&end=${endDate}&idSucursal=${idSucursal}${count != null ? `&count=${count}` : ""}`,
    {
      method: "GET",
      headers: {
        Accept: "application/json",
      },
    },
  );

  if (!res.ok) throw new Error("HTTP error " + res.status);

  const json: GetTopPlatoResponse = await res.json();
  const platos = json.data;
  return platos;
}

export async function getDetalleSucursal(idSucursal: number): Promise<DetalleSucursal> {
  const res = await fetch(`/api/sucursales/${idSucursal}`, {
    method: "GET",
    headers: {
      Accept: "application/json",
    },
  });

  if (!res.ok) throw new Error("HTTP error " + res.status);

  const json: GetDetalleSucursal = await res.json();
  const detallesSucursal = json.data;
  return detallesSucursal;
}

export async function getTotalVendido(
  startDate: string,
  endDate: string,
  idSucursal: number,
): Promise<TotalVendido> {
  const res = await fetch(
    `/api/sucursales/${idSucursal}/vendido?start=${startDate}&end=${endDate}`,
    {
      method: "GET",
      headers: {
        Accept: "application/json",
      },
    },
  );

  if (!res.ok) throw new Error("HTTP error " + res.status);

  const json: GetTotalVendido = await res.json();
  const detallesSucursal = json.data;
  return detallesSucursal;
}

export async function postCliente(data: PostCliente): Promise<string | null> {
  const res = await fetch("/api/clientes", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  });

  const json = await res.json();

  if (!res.ok) return json.error as string;

  return null;
}

export async function postPlato(data: PostPlato): Promise<string | null> {
  const res = await fetch("/api/platos", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  });

  const json = await res.json();

  if (!res.ok) return json.error as string;

  return null;
}

export async function postPedido(data: PostPedido): Promise<string | null> {
  const res = await fetch("/api/pedidos", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  });

  const json = await res.json();

  if (!res.ok) return json.error as string;

  return null;
}
