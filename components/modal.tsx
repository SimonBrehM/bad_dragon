import { ModalState } from "@/lib/types";
import { Dispatch, JSX, SetStateAction } from "react";

interface ModalProps {
  children?: React.ReactNode;
  setModalState: Dispatch<SetStateAction<ModalState>>;
}

export default function Modal({ children, setModalState }: ModalProps): JSX.Element {
  return (
    <>
      <div className="w-screen h-screen fixed top-0 left-0 bg-gray-700 opacity-80" />
      <div className="top-0 left-0 absolute w-screen h-screen flex justify-center items-center">
        <div className="w-160 h-200 absolute bg-foreground rounded-4xl">
          <div className="flex w-full justify-end">
            <button
              className="btn text-typography bg-background font-bold text-xl w-10 h-10 rounded-full"
              onClick={() => setModalState(ModalState.Hidden)}
            >
              X
            </button>
          </div>
          {children}
        </div>
      </div>
    </>
  );
}
