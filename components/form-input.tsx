import { JSX } from "react";

interface FormInputProps {
  type: string;
  name: string;
  id: string;
}

export default function FormInput({ type, name, id }: FormInputProps): JSX.Element {
  return (
    <div className="flex items-center gap-4 justify-between">
      <h2 className="text-xl font-bold">{name}</h2>
      <input type={type} name={id} className="input bg-background text-typography" />
    </div>
  );
}
