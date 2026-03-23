"use client";

import { Dispatch, SetStateAction, JSX, useId } from "react";
import { DayPicker } from "react-day-picker";

interface DateInputProps {
  date: Date | undefined;
  setDate: Dispatch<SetStateAction<Date | undefined>>;
}

export default function DateInput({ date, setDate }: DateInputProps): JSX.Element {
  const id = useId();

  return (
    <>
      <button
        popoverTarget={id}
        className="input input-border bg-background text-typography border-foreground w-25"
        style={{ anchorName: "--rdp" } as React.CSSProperties}
      >
        {date ? date.toISOString().split("T")[0] : "Pick a date"}
      </button>
      <div
        popover="auto"
        id={id}
        className="dropdown"
        style={{ positionAnchor: "--rdp" } as React.CSSProperties}
      >
        <DayPicker
          className="react-day-picker bg-foreground text-background border-gray-700"
          mode="single"
          selected={date}
          onSelect={(d) => d && setDate(d)}
        />
      </div>
    </>
  );
}
