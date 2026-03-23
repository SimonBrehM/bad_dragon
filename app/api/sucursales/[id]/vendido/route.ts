import { getPool } from "@/lib/db";
import { GetTopPlatoResponse } from "@/lib/types";
import sql from "mssql";

export const runtime = "nodejs";

export async function GET(req: Request, context: { params: { id: string } }): Promise<Response> {
  const { searchParams } = new URL(req.url);
  const startDate = searchParams.get("start");
  const endDate = searchParams.get("end");

  if (startDate === null || endDate === null) {
    return Response.json({ error: "Missing endDate or startDate." }, { status: 400 });
  }

  const { id } = await context.params;
  const idSucursal = Number(id);

  const pool = await getPool();
  try {
    const result = await pool
      .request()
      .input("fechaInicio", sql.Date, startDate)
      .input("fechaFin", sql.Date, endDate)
      .input("idSucursal", sql.Int, idSucursal)
      .execute("sp_TotalVendidoPorSucursal");

    const response: GetTopPlatoResponse = {
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
