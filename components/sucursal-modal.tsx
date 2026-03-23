"use client";

import { JSX, useEffect, useState } from "react";
import DateInput from "./date-input";
import { Sucursal } from "@/lib/types";
import { getDetalleSucursal, getTotalVendido } from "@/lib/data";

interface SucursalModalProps {
  sucursal: Sucursal;
}

export default function SucursalModal({ sucursal }: SucursalModalProps): JSX.Element {
  const { nombreComercial, idSucursal } = sucursal;
  const defaultStartDate = new Date("2026-01-01");
  const defaultEndDate = new Date();

  const [startDate, setStartDate] = useState<Date | undefined>(defaultStartDate);
  const [endDate, setEndDate] = useState<Date | undefined>(defaultEndDate);
  const [ciudad, setCiudad] = useState<string>("");
  const [direccion, setDireccion] = useState<string>("");
  const [telefono, setTelefono] = useState<string>("");

  const [resultSales, setResultSales] = useState<string>("");

  useEffect(() => {
    getDetalleSucursal(idSucursal).then((detallesSucursal) => {
      setCiudad(detallesSucursal.ciudad);
      setDireccion(detallesSucursal.direccion);
      setTelefono(detallesSucursal.telefono);
    });
  }, [idSucursal]);

  useEffect(() => {
    if (startDate === undefined || endDate === undefined) return;
    getTotalVendido(
      startDate.toISOString().split("T")[0],
      endDate.toISOString().split("T")[0],
      idSucursal,
    ).then((totalVendido) => {
      setResultSales(totalVendido.totalVendido);
    });
  }, [startDate, endDate, idSucursal]);

  return (
    <div className="text-background p-4">
      <h1 className="text-4xl font-bold text-center">{nombreComercial}</h1>
      <h2 className="text-2xl font-bold mt-15">Informaciones</h2>
      <ul className="ml-10 mt-2">
        <li>Ciudad : {ciudad}</li>
        <li>Direccion : {direccion}</li>
        <li>Telefono : {telefono}</li>
      </ul>
      <h2 className="text-2xl font-bold mt-15">Total vendido en periodo</h2>
      <div className="flex w-full justify-around mt-5">
        <div>
          <h3 className="w-full text-center">Fecha inicio</h3>
          <DateInput date={startDate} setDate={setStartDate} />
        </div>
        <div>
          <h3 className="w-full text-center">Fecha fin</h3>
          <DateInput date={endDate} setDate={setEndDate} />
        </div>
      </div>
      <div className="flex justify-center items-center gap-2 text-xl mt-5">
        <h3>Resulto:</h3>
        <div className="py-1 px-2 bg-background text-typography rounded-sm">{resultSales}</div>
      </div>
    </div>
  );
}
