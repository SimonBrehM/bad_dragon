"use client";

import ItemList from "@/components/itemlist";
import DateInput from "@/components/date-input";
import { getClientes, getPlatos, getSucursales } from "@/lib/data";
import { Cliente, ModalState, Plato, Sucursal } from "@/lib/types";
import { useEffect, useState } from "react";
import Modal from "@/components/modal";
import SucursalModal from "@/components/sucursal-modal";
import ClienteModal from "@/components/cliente-modal";
import PlatoModal from "@/components/plato-modal";
import PedidoModal from "@/components/pedido-modal";

export default function Home() {
  const [sucursal, setSucursal] = useState<Sucursal | null>(null);
  const [sucursales, setSucursales] = useState<Sucursal[]>([]);

  const [clientes, setClientes] = useState<Cliente[]>([]);
  const [clientesCount, setClientesCount] = useState<number>(3);

  const [platos, setPlatos] = useState<Plato[]>([]);
  const [platoCount, setPlatoCount] = useState<number>(10);
  const defaultStartDate = new Date("2026-01-01");
  const [startDatePlatos, setStartDatePlatos] = useState<Date | undefined>(defaultStartDate);
  const defaultEndDate = new Date();
  const [endDatePlatos, setEndDatePlatos] = useState<Date | undefined>(defaultEndDate);

  const [modalState, setModalState] = useState<ModalState>(ModalState.Hidden);

  const [selectedCliente, setSelectedCliente] = useState<number>(-1);
  const [selectedPlatos, setSelectedPlatos] = useState<number[]>([]);

  useEffect(() => {
    getSucursales().then((sucusales) => {
      setSucursales(sucusales);
    });
  }, []);

  useEffect(() => {
    if (sucursal === null) return;
    getClientes(sucursal.idSucursal, clientesCount).then((clientes) => {
      setClientes(clientes);
    });
  }, [sucursal, clientesCount]);

  useEffect(() => {
    if (sucursal === null || !startDatePlatos || !endDatePlatos) return;

    getPlatos(
      startDatePlatos.toISOString().split("T")[0],
      endDatePlatos.toISOString().split("T")[0],
      sucursal.idSucursal,
      platoCount,
    ).then(setPlatos);
  }, [startDatePlatos, endDatePlatos, sucursal, platoCount]);

  return (
    <div>
      <header className="h-fit w-full px-2 py-5 bg-foreground">
        <h1 className="text-2xl text-background font-bold">Bad Dragon</h1>
      </header>
      <main className="bg-background">
        <section className="flex p-4 gap-4 items-center">
          <h2 className="text-xl text-foreground">Surcursal : </h2>

          <select
            defaultValue="Seleccionar sucursal"
            className="select bg-background text-typography border-s-2 border-foreground"
            onChange={(e) => {
              const selected = sucursales.find((s) => s.idSucursal === Number(e.target.value));
              setSucursal(selected ?? null);
              setClientesCount(3);
              setPlatoCount(10);
            }}
          >
            {sucursal === null && <option value="">Seleccionar sucursal</option>}
            {sucursales.map((sucursal) => (
              <option key={sucursal.idSucursal} value={sucursal.idSucursal}>
                {sucursal.nombreComercial}
              </option>
            ))}
          </select>

          {sucursal != null && (
            <button
              className="btn border-none flex justify-center items-center w-8 h-8 rounded-full bg-blue-400"
              onClick={() => setModalState(ModalState.Sucursal)}
            >
              <h3 className="text-background font-bold">i</h3>
            </button>
          )}
        </section>

        {sucursal != null && (
          <section className="w-full flex gap-4 py-1 ml-2 justify-center pr-100">
            {/* Client selection */}
            <ItemList
              name="Clientes"
              content={clientes.map(
                (cliente) => `${cliente.nombreCliente}: ${cliente.totalPedidos} pedidos`,
              )}
              selected={[selectedCliente]}
              selector={(selected: number) => {
                if (selected === selectedCliente) setSelectedCliente(-1);
                else setSelectedCliente(selected);
              }}
              count={clientesCount}
              setCount={setClientesCount}
              addAction={() => setModalState(ModalState.Cliente)}
            />

            {/* Item Selection (multiple) */}
            <div className="flex flex-col gap-10">
              <ItemList
                name="Platos"
                content={platos.map(
                  (plato) => `${plato.nombre}: ${plato.cantidadVendida} vendidos`,
                )}
                selected={selectedPlatos}
                selector={(selected: number) => {
                  if (selectedPlatos.includes(selected))
                    setSelectedPlatos(selectedPlatos.filter((plato) => !(plato === selected)));
                  else setSelectedPlatos(selectedPlatos.concat(selected));
                }}
                count={platoCount}
                setCount={setPlatoCount}
                addAction={() => {
                  setModalState(ModalState.Plato);
                }}
              />
              <div className="flex w-full justify-between px-5">
                <div>
                  <h3 className="w-full text-center">Fecha inicio filtro</h3>
                  <DateInput date={startDatePlatos} setDate={setStartDatePlatos} />
                </div>
                <div>
                  <h3 className="w-full text-center">Fecha fin filtro</h3>
                  <DateInput date={endDatePlatos} setDate={setEndDatePlatos} />
                </div>
              </div>
            </div>

            <button
              className="btn bg-background text-typography mt-10"
              onClick={() => {
                if (selectedCliente === -1 || selectedPlatos.length === 0) return;
                setModalState(ModalState.Pedido);
              }}
            >
              Pedir
            </button>
          </section>
        )}
        {sucursal != null && modalState != ModalState.Hidden && (
          <Modal setModalState={setModalState}>
            {modalState === ModalState.Sucursal && <SucursalModal sucursal={sucursal} />}
            {modalState === ModalState.Cliente && <ClienteModal />}
            {modalState === ModalState.Plato && <PlatoModal />}
            {modalState === ModalState.Pedido && (
              <PedidoModal
                idCliente={clientes[selectedCliente].idCliente}
                idPlatos={selectedPlatos.map((idx) => platos[idx].idPlato)}
              />
            )}
          </Modal>
        )}
      </main>
    </div>
  );
}
