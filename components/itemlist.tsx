import { Dispatch, JSX, SetStateAction } from "react";
import Item from "@/components/item";

interface ItemListProps {
  name: string;
  content: string[];
  selected?: number[];
  selector?: (selected: number) => void;
  count?: number;
  setCount?: Dispatch<SetStateAction<number>>;
  addAction?: () => void;
  increment?: number;
}

export default function ItemList({
  name,
  content,
  selected,
  selector,
  count,
  setCount,
  addAction,
  increment,
}: ItemListProps): JSX.Element {
  if (!selected) selected = [];

  return (
    <div className="h-160">
      <h2 className="text-2xl text-foreground text-center">{name}</h2>
      <div className="flex flex-col h-full p-2 gap-2 bg-foreground overflow-y-scroll scroll-smooth rounded-md">
        {addAction && <Item name="Crear" onClick={addAction} color="bg-blue-400" />}
        {content.map((item, idx) => (
          <Item
            name={item}
            key={idx}
            color={selected.includes(idx) ? "bg-green-500" : undefined}
            onClick={selector ? () => selector(idx) : undefined}
          />
        ))}
        {count != undefined && setCount != undefined && (
          <Item
            name="Mas"
            onClick={() => setCount(count + (increment ? increment : 3))}
            color="bg-gray-400"
          />
        )}
      </div>
    </div>
  );
}
