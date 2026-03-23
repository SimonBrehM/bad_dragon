import { getPool } from "@/lib/db";
import { PostPedido } from "@/lib/types";
import sql from "mssql";

export async function POST(req: Request) {
  const data = (await req.json()) as PostPedido;
  const {
    idCliente,
    idEmpleado,
    idMetodo,
    idMesa,
    estado,
    numFactura,
    NITCliente,
    razonSocial,
    idPlatos,
  } = data;
  console.log(idPlatos);

  const pool = await getPool();
  try {
    const detalle = new sql.Table("TipoDetallePedido");
    detalle.columns.add("idPlato", sql.Int);
    detalle.columns.add("cantidad", sql.Int);

    for (const idPlato of idPlatos) {
      detalle.rows.add(idPlato, 1);
    }

    await pool
      .request()
      .input("idCliente", sql.Int, idCliente)
      .input("idEmpleado", sql.Int, idEmpleado)
      .input("idMetodo", sql.Int, idMetodo)
      .input("idMesa", sql.Int, idMesa)
      .input("estado", sql.VarChar(15), estado)
      .input("fechaHoraPedido", sql.DateTime2, new Date())
      .input("numFactura", sql.Int, numFactura)
      .input("NITCliente", sql.Int, NITCliente)
      .input("razonSocial", sql.VarChar(100), razonSocial)
      .input("detalle", detalle)
      .execute("sp_RegistrarPedidoCompleto");

    return Response.json({ success: true });
  } catch (err: any) {
    if (err.number >= 50029 && err.number <= 50042) {
      return Response.json({ error: err.message }, { status: 400 });
    }

    console.log(err.message);
    return Response.json(
      { error: "Internal database error : ".concat(err.number) },
      { status: 500 },
    );
  }
}
