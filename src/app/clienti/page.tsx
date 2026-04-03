"use client";

import { useState } from "react";
import { Search, Plus, Phone, Mail, MapPin, Filter } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { clienti as initialClienti, filterTypeLabels } from "@/lib/data";
import type { Client, ClientStatus, FilterType } from "@/lib/types";

const statusConfig: Record<ClientStatus, { label: string; className: string }> =
  {
    activ: { label: "Activ", className: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30" },
    inactiv: { label: "Inactiv", className: "bg-gray-500/20 text-gray-300 border-gray-500/30" },
    nou: { label: "Nou", className: "bg-blue-500/20 text-blue-300 border-blue-500/30" },
  };

export default function ClientiPage() {
  const [clienti, setClienti] = useState<Client[]>(initialClienti);
  const [search, setSearch] = useState("");
  const [filterStatus, setFilterStatus] = useState<string>("all");
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);
  const [showAddDialog, setShowAddDialog] = useState(false);

  const filtered = clienti.filter((c) => {
    const matchesSearch =
      c.nume.toLowerCase().includes(search.toLowerCase()) ||
      c.telefon.includes(search) ||
      c.oras.toLowerCase().includes(search.toLowerCase());
    const matchesStatus =
      filterStatus === "all" || c.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const handleAddClient = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const newClient: Client = {
      id: `c${clienti.length + 1}`,
      nume: formData.get("nume") as string,
      telefon: formData.get("telefon") as string,
      email: formData.get("email") as string,
      adresa: formData.get("adresa") as string,
      oras: formData.get("oras") as string,
      status: "nou",
      dataContract: new Date().toISOString().split("T")[0],
      tipFiltru: formData.get("tipFiltru") as FilterType,
      ultimaMentenanta: "-",
      urmatoareaMentenanta: formData.get("urmatoareaMentenanta") as string,
      notite: formData.get("notite") as string,
    };
    setClienti([...clienti, newClient]);
    setShowAddDialog(false);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Clienti</h1>
          <p className="text-muted-foreground mt-1">
            Gestioneaza baza de clienti
          </p>
        </div>
        <Dialog open={showAddDialog} onOpenChange={setShowAddDialog}>
          <DialogTrigger
            render={
              <Button>
                <Plus className="w-4 h-4 mr-2" /> Adauga Client
              </Button>
            }
          />
          <DialogContent className="max-w-md">
            <DialogHeader>
              <DialogTitle>Client Nou</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleAddClient} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="nume">Nume</Label>
                <Input id="nume" name="nume" required />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="telefon">Telefon</Label>
                  <Input id="telefon" name="telefon" required />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input id="email" name="email" type="email" required />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="adresa">Adresa</Label>
                <Input id="adresa" name="adresa" required />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="oras">Oras</Label>
                  <Input id="oras" name="oras" required />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="tipFiltru">Tip Filtru</Label>
                  <Select name="tipFiltru" defaultValue="osmoza_inversa">
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {Object.entries(filterTypeLabels).map(([key, label]) => (
                        <SelectItem key={key} value={key}>
                          {label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="urmatoareaMentenanta">
                  Prima Mentenanta / Instalare
                </Label>
                <Input
                  id="urmatoareaMentenanta"
                  name="urmatoareaMentenanta"
                  type="date"
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="notite">Notite</Label>
                <Textarea id="notite" name="notite" rows={2} />
              </div>
              <Button type="submit" className="w-full">
                Salveaza
              </Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input
            placeholder="Cauta dupa nume, telefon sau oras..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-10"
          />
        </div>
        <Select value={filterStatus} onValueChange={(v) => setFilterStatus(v ?? "all")}>
          <SelectTrigger className="w-40">
            <Filter className="w-4 h-4 mr-2" />
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toti</SelectItem>
            <SelectItem value="activ">Activi</SelectItem>
            <SelectItem value="inactiv">Inactivi</SelectItem>
            <SelectItem value="nou">Noi</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
        {filtered.map((client) => (
          <Card
            key={client.id}
            className="cursor-pointer hover:shadow-md transition-shadow"
            onClick={() => setSelectedClient(client)}
          >
            <CardHeader className="pb-3">
              <div className="flex items-start justify-between">
                <CardTitle className="text-base">{client.nume}</CardTitle>
                <Badge
                  variant="outline"
                  className={statusConfig[client.status].className}
                >
                  {statusConfig[client.status].label}
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="space-y-2">
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <Phone className="w-3.5 h-3.5" />
                {client.telefon}
              </div>
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <Mail className="w-3.5 h-3.5" />
                {client.email}
              </div>
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <MapPin className="w-3.5 h-3.5" />
                {client.oras}
              </div>
              <div className="pt-2 border-t flex items-center justify-between text-sm">
                <span className="text-muted-foreground">
                  {filterTypeLabels[client.tipFiltru]}
                </span>
                <span className="text-muted-foreground">
                  Urm: {client.urmatoareaMentenanta}
                </span>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filtered.length === 0 && (
        <div className="text-center py-12 text-muted-foreground">
          Niciun client gasit.
        </div>
      )}

      <Dialog
        open={!!selectedClient}
        onOpenChange={() => setSelectedClient(null)}
      >
        <DialogContent className="max-w-lg">
          {selectedClient && (
            <>
              <DialogHeader>
                <DialogTitle className="flex items-center gap-3">
                  {selectedClient.nume}
                  <Badge
                    variant="outline"
                    className={statusConfig[selectedClient.status].className}
                  >
                    {statusConfig[selectedClient.status].label}
                  </Badge>
                </DialogTitle>
              </DialogHeader>
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-muted-foreground">Telefon</p>
                    <p className="font-medium">{selectedClient.telefon}</p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Email</p>
                    <p className="font-medium">{selectedClient.email}</p>
                  </div>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Adresa</p>
                  <p className="font-medium">
                    {selectedClient.adresa}, {selectedClient.oras}
                  </p>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-muted-foreground">Tip Filtru</p>
                    <p className="font-medium">
                      {filterTypeLabels[selectedClient.tipFiltru]}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">
                      Data Contract
                    </p>
                    <p className="font-medium">{selectedClient.dataContract}</p>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-muted-foreground">
                      Ultima Mentenanta
                    </p>
                    <p className="font-medium">
                      {selectedClient.ultimaMentenanta}
                    </p>
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">
                      Urmatoarea Mentenanta
                    </p>
                    <p className="font-medium">
                      {selectedClient.urmatoareaMentenanta}
                    </p>
                  </div>
                </div>
                {selectedClient.notite && (
                  <div>
                    <p className="text-sm text-muted-foreground">Notite</p>
                    <p className="text-sm bg-muted p-3 rounded-lg mt-1">
                      {selectedClient.notite}
                    </p>
                  </div>
                )}
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
