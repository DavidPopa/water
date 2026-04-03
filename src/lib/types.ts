export type ClientStatus = "activ" | "inactiv" | "nou";
export type MaintenanceStatus = "programat" | "in_lucru" | "finalizat" | "anulat";
export type FilterType = "osmoza_inversa" | "carbon_activ" | "sediment" | "ultrafiltrare";
export type MessageStatus = "trimis" | "livrat" | "citit" | "esuat";

export interface Client {
  id: string;
  nume: string;
  telefon: string;
  email: string;
  adresa: string;
  oras: string;
  status: ClientStatus;
  dataContract: string;
  tipFiltru: FilterType;
  ultimaMentenanta: string;
  urmatoareaMentenanta: string;
  notite: string;
}

export interface Maintenance {
  id: string;
  clientId: string;
  clientNume: string;
  data: string;
  ora: string;
  tip: "schimb_filtru" | "verificare" | "instalare" | "reparatie";
  status: MaintenanceStatus;
  tehnician: string;
  notite: string;
  durata: number; // minutes
}

export interface Message {
  id: string;
  clientId: string;
  clientNume: string;
  telefon: string;
  continut: string;
  dataTrimitere: string;
  status: MessageStatus;
  tip: "reminder" | "confirmare" | "urmarire";
}

export interface DashboardStats {
  totalClienti: number;
  mentenanteLuna: number;
  programariAzi: number;
  mesajeTrimise: number;
  clientiNoi: number;
  mentenanteRestante: number;
}
