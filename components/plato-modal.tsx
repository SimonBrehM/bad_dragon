import { useRef, useState } from "react";
import FormInput from "./form-input";
import { z } from "zod";
import { PostPlato } from "@/lib/types";
import { postPlato } from "@/lib/data";

const schema = z.object({
  nombre: z.string(),
  descripcion: z.string(),
  precio: z.coerce.number(),
  idCategoria: z.coerce.number(),
});

export default function PlatoModal() {
  const [errMessage, setErrMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const formRef = useRef<HTMLFormElement>(null);

  async function createUser(formData: FormData) {
    setSuccessMessage(null);

    const parsed = schema.safeParse({
      nombre: formData.get("nombre"),
      descripcion: formData.get("descripcion"),
      precio: formData.get("precio"),
      idCategoria: formData.get("idCategoria"),
    });

    if (!parsed.success) {
      setErrMessage(parsed.error.issues.map((e) => `${e.path.join(".")}: ${e.message}`).join("\n"));
      return;
    }
    setErrMessage(null);

    const data: PostPlato = {
      nombre: parsed.data.nombre,
      descripcion: parsed.data.descripcion,
      precio: parsed.data.precio,
      idCategoria: parsed.data.idCategoria,
    };

    const err = await postPlato(data);
    if (err != null) setErrMessage(err);
    else {
      formRef.current?.reset();
      setSuccessMessage("Plato creado.");
    }
  }

  return (
    <div className="text-background p-4">
      <h1 className="text-4xl font-bold text-center">Crear Plato</h1>

      <form
        onSubmit={(e) => {
          e.preventDefault();
          createUser(new FormData(e.currentTarget));
        }}
        ref={formRef}
        className="flex flex-col gap-4  mt-10"
      >
        <FormInput name="Nombre" type="text" id="nombre" />
        <FormInput name="Descripcion" type="text" id="descripcion" />
        <FormInput name="Precio" type="number" id="precio" />
        <FormInput name="ID Categoria" type="number" id="idCategoria" />
        <input type="submit" className="mt-10 btn bg-background text-typography" value="Crear" />
      </form>
      {errMessage != null && <h3 className="bg-background p-2 text-foreground">{errMessage}</h3>}
      {successMessage != null && (
        <h3 className="bg-background p-2 text-green-500">{successMessage}</h3>
      )}
    </div>
  );
}
