import { useRef, useState } from "react";
import FormInput from "./form-input";
import { z } from "zod";
import { PostPedido } from "@/lib/types";
import { postPedido } from "@/lib/data";

const schema = z.object({
  idEmpleado: z.coerce.number(),
  idMetodo: z.coerce.number(),
  idMesa: z.coerce.number(),
  estado: z.string(),
  NITCliente: z.coerce.number(),
  numFactura: z.coerce.number(),
  razonSocial: z.string(),
});

interface ClienteModalProps {
  idCliente: number;
  idPlatos: number[];
}

export default function PedidoModal({ idCliente, idPlatos }: ClienteModalProps) {
  const [errMessage, setErrMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const formRef = useRef<HTMLFormElement>(null);

  async function createUser(formData: FormData) {
    setSuccessMessage(null);

    const parsed = schema.safeParse({
      idEmpleado: formData.get("idEmpleado"),
      idMetodo: formData.get("idMetodo"),
      idMesa: formData.get("idMesa"),
      estado: formData.get("estado"),
      NITCliente: formData.get("NITCliente"),
      idCiudad: formData.get("idCiudad"),
      numFactura: formData.get("numFactura"),
      razonSocial: formData.get("razonSocial"),
    });

    if (!parsed.success) {
      setErrMessage(parsed.error.issues.map((e) => `${e.path.join(".")}: ${e.message}`).join("\n"));
      return;
    }
    setErrMessage(null);

    const data: PostPedido = {
      idCliente: idCliente,
      idEmpleado: parsed.data.idEmpleado,
      idMetodo: parsed.data.idMetodo,
      idMesa: parsed.data.idMesa,
      estado: parsed.data.estado,
      NITCliente: parsed.data.NITCliente,
      numFactura: parsed.data.numFactura,
      razonSocial: parsed.data.estado,
      idPlatos: idPlatos,
    };

    const err = await postPedido(data);
    if (err != null) setErrMessage(err);
    else {
      formRef.current?.reset();
      setSuccessMessage("Pedido creado.");
    }
  }

  return (
    <div className="text-background p-4">
      <h1 className="text-4xl font-bold text-center">Crear Pedido</h1>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          createUser(new FormData(e.currentTarget));
        }}
        ref={formRef}
        className="flex flex-col gap-4  mt-10"
      >
        <FormInput name="ID Empleado" type="number" id="idEmpleado" />
        <FormInput name="ID Metodo" type="number" id="idMetodo" />
        <FormInput name="ID Mesa" type="number" id="idMesa" />
        <FormInput name="Estado" type="text" id="estado" />
        <FormInput name="NIT Cliente" type="number" id="NITCliente" />
        <FormInput name="Numero Factura" type="number" id="numFactura" />
        <FormInput name="Razon Social" type="text" id="razonSocial" />
        <input type="submit" className="mt-10 btn bg-background text-typography" value="Crear" />
      </form>
      {errMessage != null && <h3 className="bg-background p-2 text-foreground">{errMessage}</h3>}
      {successMessage != null && (
        <h3 className="bg-background p-2 text-green-500">{successMessage}</h3>
      )}
    </div>
  );
}
