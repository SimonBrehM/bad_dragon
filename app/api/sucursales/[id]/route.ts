import { getPool } from "@/lib/db";
import { GetDetalleSucursal, GetTopPlatoResponse } from "@/lib/types";
import sql from "mssql";

export const runtime = "nodejs";

export async function GET(req: Request, context: { params: { id: string } }): Promise<Response> {
  const { id } = await context.params;
  const idSucursal = Number(id);

  const pool = await getPool();
  try {
    const result = await pool
      .request()
      .input("idSucursal", sql.Int, idSucursal)
      .execute("sp_MostarDetalleSucursal");

    const response: GetDetalleSucursal = {
      data: result.recordset[0],
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
