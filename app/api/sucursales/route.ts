import { getPool } from "@/lib/db";
import { Sucursal, GetSucursalesReponse } from "@/lib/types";

export const runtime = "nodejs";

export async function GET(): Promise<Response> {
  const pool = await getPool();

  try {
    const result = await pool.request().query<Sucursal>("EXEC sp_MostrarSucursales;");
    const response: GetSucursalesReponse = {
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
