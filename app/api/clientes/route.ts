import { getPool } from "@/lib/db";
import { GetTopClienteResponse, PostCliente } from "@/lib/types";
import sql from "mssql";

export const runtime = "nodejs";

export async function GET(req: Request): Promise<Response> {
  const { searchParams } = new URL(req.url);
  const idSucursalRaw = searchParams.get("idSucursal");
  const countRaw = searchParams.get("count");

  if (idSucursalRaw === null) {
    return Response.json({ error: "Missing idSucursal." }, { status: 400 });
  }

  const idSucursal = Number(idSucursalRaw);
  const count = countRaw != null ? Number(countRaw) : null;

  const pool = await getPool();
  try {
    const result = await pool
      .request()
      .input("idSucursal", sql.Int, idSucursal)
      .input("numeroClientes", sql.Int, count)
      .execute("sp_TopClientesFrecuentesPorSucursal");
    const response: GetTopClienteResponse = {
      data: result.recordset,
    };

    return Response.json(response);
  } catch (err: any) {
    console.log(err.message);
    return Response.json(
      { error: "Internal database error : ".concat(err.number) },
      { status: 500 },
    );
  }
}

export async function POST(req: Request) {
  const data = (await req.json()) as PostCliente;
  const { nombre, apellidos, numCarnet, telefono, correo, idCiudad } = data;

  const pool = await getPool();
  try {
    await pool
      .request()
      .input("nombre", sql.VarChar(50), nombre)
      .input("apellidos", sql.VarChar(150), apellidos)
      .input("numCarnet", sql.VarChar(15), numCarnet)
      .input("telefono", sql.VarChar(15), telefono)
      .input("correo", sql.VarChar(30), correo)
      .input("idCiudad", sql.Int, idCiudad)
      .execute("sp_RegistrarCliente");

    return Response.json({ success: true });
  } catch (err: any) {
    if (err.number >= 50020 && err.number <= 50025) {
      return Response.json({ error: err.message }, { status: 400 });
    }

    console.log(err.message);
    return Response.json(
      { error: "Internal database error : ".concat(err.number) },
      { status: 500 },
    );
  }
}
