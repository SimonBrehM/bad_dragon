import { useRef, useState } from "react";
import FormInput from "./form-input";
import { z } from "zod";
import { PostCliente } from "@/lib/types";
import { postCliente } from "@/lib/data";

const schema = z.object({
  nombre: z.string(),
  apellidos: z.string(),
  numCarnet: z.string(),
  telefono: z
    .string()
    .transform((v) => (v === "" ? undefined : v))
    .optional(),
  correo: z
    .string()
    .transform((v) => (v === "" ? undefined : v))
    .optional(),
  idCiudad: z.coerce.number(),
});

export default function ClienteModal() {
  const [errMessage, setErrMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const formRef = useRef<HTMLFormElement>(null);

  async function createUser(formData: FormData) {
    setSuccessMessage(null);

    const parsed = schema.safeParse({
      nombre: formData.get("nombre"),
      apellidos: formData.get("apellidos"),
      numCarnet: formData.get("numCarnet"),
      telefono: formData.get("telefono"),
      correo: formData.get("correo"),
      idCiudad: formData.get("idCiudad"),
    });

    if (!parsed.success) {
      setErrMessage(parsed.error.issues.map((e) => `${e.path.join(".")}: ${e.message}`).join("\n"));
      return;
    }
    setErrMessage(null);

    const data: PostCliente = {
      nombre: parsed.data.nombre,
      apellidos: parsed.data.apellidos,
      numCarnet: parsed.data.numCarnet,
      telefono: parsed.data.telefono == undefined ? null : parsed.data.telefono,
      correo: parsed.data.correo == undefined ? null : parsed.data.correo,
      idCiudad: parsed.data.idCiudad,
    };

    const err = await postCliente(data);
    if (err != null) setErrMessage(err);
    else {
      formRef.current?.reset();
      setSuccessMessage("Cliente creado.");
    }
  }

  return (
    <div className="text-background p-4">
      <h1 className="text-4xl font-bold text-center">Crear Cliente</h1>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          createUser(new FormData(e.currentTarget));
        }}
        ref={formRef}
        className="flex flex-col gap-4  mt-10"
      >
        <FormInput name="Nombre" type="text" id="nombre" />
        <FormInput name="Apellidos" type="text" id="apellidos" />
        <FormInput name="Numero Carnet" type="text" id="numCarnet" />
        <FormInput name="Telefono" type="text" id="telefono" />
        <FormInput name="Correo" type="text" id="correo" />
        <FormInput name="ID Ciudad" type="number" id="idCiudad" />
        <input type="submit" className="mt-10 btn bg-background text-typography" value="Crear" />
      </form>
      {errMessage != null && <h3 className="bg-background p-2 text-foreground">{errMessage}</h3>}
      {successMessage != null && (
        <h3 className="bg-background p-2 text-green-500">{successMessage}</h3>
      )}
    </div>
  );
}
