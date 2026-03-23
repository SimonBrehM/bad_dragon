import { JSX } from "react";

interface ItemProps {
  name: string;
  color?: string;
  width?: string;
  onClick?: () => void;
}

export default function Item({ name, color, width, onClick }: ItemProps): JSX.Element {
  return (
    <button
      className={`btn ${color === undefined ? "bg-background" : color} text-typography ${width === undefined ? "w-100" : width} h-20 text-xl text-right`}
      onClick={onClick}
    >
      {name}
    </button>
  );
}
