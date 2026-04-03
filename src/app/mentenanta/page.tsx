"use client";

import { useState } from "react";
import { Plus, Filter } from "lucide-react";
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
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  mentenante as initialMentenante,
  clienti,
  tehnicieni,
  maintenanceTypeLabels,
} from "@/lib/data";
import type { Maintenance, MaintenanceStatus } from "@/lib/types";

const statusConfig: Record<
  MaintenanceStatus,
  { label: string; className: string }
> = {
  programat: { label: "Programat", className: "bg-blue-100 text-blue-800" },
  in_lucru: { label: "In Lucru", className: "bg-amber-100 text-amber-800" },
  finalizat: {
    label: "Finalizat",
    className: "bg-emerald-100 text-emerald-800",
  },
  anulat: { label: "Anulat", className: "bg-gray-100 text-gray-800" },
};

export default function MentenantaPage() {
  const [mentenante, setMentenante] =
    useState<Maintenance[]>(initialMentenante);
  const [filterStatus, setFilterStatus] = useState<string>("all");
  const [showAddDialog, setShowAddDialog] = useState(false);

  const filtered = mentenante.filter(
    (m) => filterStatus === "all" || m.status === filterStatus
  );

  const handleAdd = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const clientId = formData.get("clientId") as string;
    const client = clienti.find((c) => c.id === clientId);
    const newMaintenance: Maintenance = {
      id: `m${mentenante.length + 1}`,
      clientId,
      clientNume: client?.nume || "",
      data: formData.get("data") as string,
      ora: formData.get("ora") as string,
      tip: formData.get("tip") as Maintenance["tip"],
      status: "programat",
      tehnician: formData.get("tehnician") as string,
      notite: formData.get("notite") as string,
      durata: parseInt(formData.get("durata") as string) || 60,
    };
    setMentenante([...mentenante, newMaintenance]);
    setShowAddDialog(false);
  };

  const updateStatus = (id: string, newStatus: MaintenanceStatus) => {
    setMentenante(
      mentenante.map((m) => (m.id === id ? { ...m, status: newStatus } : m))
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Mentenanta</h1>
          <p className="text-muted-foreground mt-1">
            Toate interventiile de mentenanta
          </p>
        </div>
        <Dialog open={showAddDialog} onOpenChange={setShowAddDialog}>
          <DialogTrigger
            render={
              <Button>
                <Plus className="w-4 h-4 mr-2" /> Programeaza Mentenanta
              </Button>
            }
          />
          <DialogContent className="max-w-md">
            <DialogHeader>
              <DialogTitle>Mentenanta Noua</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleAdd} className="space-y-4">
              <div className="space-y-2">
                <Label>Client</Label>
                <Select name="clientId" required>
                  <SelectTrigger>
                    <SelectValue placeholder="Selecteaza client" />
                  </SelectTrigger>
                  <SelectContent>
                    {clienti.map((c) => (
                      <SelectItem key={c.id} value={c.id}>
                        {c.nume}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Data</Label>
                  <Input name="data" type="date" required />
                </div>
                <div className="space-y-2">
                  <Label>Ora</Label>
                  <Input name="ora" type="time" required />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Tip</Label>
                  <Select name="tip" defaultValue="schimb_filtru">
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {Object.entries(maintenanceTypeLabels).map(
                        ([key, label]) => (
                          <SelectItem key={key} value={key}>
                            {label}
                          </SelectItem>
                        )
                      )}
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Durata (min)</Label>
                  <Input
                    name="durata"
                    type="number"
                    defaultValue="60"
                    required
                  />
                </div>
              </div>
              <div className="space-y-2">
                <Label>Tehnician</Label>
                <Select name="tehnician" defaultValue={tehnicieni[0]}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {tehnicieni.map((t) => (
                      <SelectItem key={t} value={t}>
                        {t}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Notite</Label>
                <Textarea name="notite" rows={2} />
              </div>
              <Button type="submit" className="w-full">
                Programeaza
              </Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4 items-center">
        <Select value={filterStatus} onValueChange={(v) => setFilterStatus(v ?? "all")}>
          <SelectTrigger className="w-48">
            <Filter className="w-4 h-4 mr-2" />
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toate</SelectItem>
            <SelectItem value="programat">Programate</SelectItem>
            <SelectItem value="in_lucru">In Lucru</SelectItem>
            <SelectItem value="finalizat">Finalizate</SelectItem>
            <SelectItem value="anulat">Anulate</SelectItem>
          </SelectContent>
        </Select>
        <p className="text-sm text-muted-foreground">
          {filtered.length} interventii
        </p>
      </div>

      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Client</TableHead>
                <TableHead>Data</TableHead>
                <TableHead>Ora</TableHead>
                <TableHead>Tip</TableHead>
                <TableHead>Tehnician</TableHead>
                <TableHead>Durata</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Actiuni</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.map((m) => (
                <TableRow key={m.id}>
                  <TableCell className="font-medium">{m.clientNume}</TableCell>
                  <TableCell>{m.data}</TableCell>
                  <TableCell>{m.ora}</TableCell>
                  <TableCell>{maintenanceTypeLabels[m.tip]}</TableCell>
                  <TableCell>{m.tehnician}</TableCell>
                  <TableCell>{m.durata} min</TableCell>
                  <TableCell>
                    <Badge
                      variant="outline"
                      className={statusConfig[m.status].className}
                    >
                      {statusConfig[m.status].label}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {m.status === "programat" && (
                      <div className="flex gap-1">
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => updateStatus(m.id, "in_lucru")}
                        >
                          Incepe
                        </Button>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="text-destructive"
                          onClick={() => updateStatus(m.id, "anulat")}
                        >
                          Anuleaza
                        </Button>
                      </div>
                    )}
                    {m.status === "in_lucru" && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => updateStatus(m.id, "finalizat")}
                      >
                        Finalizeaza
                      </Button>
                    )}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {filtered.length === 0 && (
        <div className="text-center py-12 text-muted-foreground">
          Nicio interventie gasita.
        </div>
      )}
    </div>
  );
}
