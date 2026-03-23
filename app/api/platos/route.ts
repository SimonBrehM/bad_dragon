import { getPool } from "@/lib/db";
import { GetTopPlatoResponse, PostPlato } from "@/lib/types";
import sql from "mssql";

export const runtime = "nodejs";

export async function GET(req: Request): Promise<Response> {
  const { searchParams } = new URL(req.url);
  const idSucursalRaw = searchParams.get("idSucursal");
  const countRaw = searchParams.get("count");
  const startDate = searchParams.get("start");
  const endDate = searchParams.get("end");

  if (idSucursalRaw === null || startDate === null || endDate === null) {
    return Response.json({ error: "Missing idSucursal or endDate or startDate." }, { status: 400 });
  }

  const idSucursal = Number(idSucursalRaw);
  const count = countRaw != null ? Number(countRaw) : null;

  const pool = await getPool();
  try {
    const result = await pool
      .request()
      .input("fechaInicio", sql.Date, startDate)
      .input("fechaFin", sql.Date, endDate)
      .input("idSucursal", sql.Int, idSucursal)
      .input("numeroPlatos", sql.Int, count)
      .execute("sp_TopPlatosMasVendidos");

    const response: GetTopPlatoResponse = {
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
  const data = (await req.json()) as PostPlato;
  const { nombre, descripcion, precio, idCategoria } = data;

  const pool = await getPool();
  try {
    await pool
      .request()
      .input("nombre", sql.VarChar(50), nombre)
      .input("descripcion", sql.VarChar(150), descripcion)
      .input("precio", sql.Decimal(10, 2), precio)
      .input("idCategoria", sql.Int, idCategoria)
      .execute("sp_RegistrarPlato");

    return Response.json({ success: true });
  } catch (err: any) {
    if (err.number >= 50001 && err.number <= 50004) {
      return Response.json({ error: err.message }, { status: 400 });
    }

    console.log(err.message);
    return Response.json(
      { error: "Internal database error : ".concat(err.number) },
      { status: 500 },
    );
  }
}
