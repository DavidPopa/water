"use client";

import { useState } from "react";
import { Send, Filter } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { mesaje as initialMesaje, clienti } from "@/lib/data";
import type { Message, MessageStatus } from "@/lib/types";

const statusConfig: Record<
  MessageStatus,
  { label: string; className: string }
> = {
  trimis: { label: "Trimis", className: "bg-amber-500/20 text-amber-300 border-amber-500/30" },
  livrat: { label: "Livrat", className: "bg-blue-500/20 text-blue-300 border-blue-500/30" },
  citit: { label: "Citit", className: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30" },
  esuat: { label: "Esuat", className: "bg-red-500/20 text-red-300 border-red-500/30" },
};

const tipLabels: Record<string, string> = {
  reminder: "Reminder",
  confirmare: "Confirmare",
  urmarire: "Urmarire",
};

const templates: Record<string, string> = {
  reminder:
    "Buna ziua, va reamintim ca aveti programata mentenanta filtrului de apa pe data de [DATA], ora [ORA]. Va rugam sa confirmati disponibilitatea.",
  confirmare:
    "Buna ziua! Va confirmam programarea mentenantei pe data de [DATA], ora [ORA]. Tehnicianul nostru va va contacta cu 30 min inainte.",
  urmarire:
    "Buna ziua, dorim sa va informam ca este timpul pentru mentenanta periodica a filtrului de apa. Va rugam sa ne contactati la 0800 123 456 pentru programare.",
};

export default function MesajePage() {
  const [mesaje, setMesaje] = useState<Message[]>(initialMesaje);
  const [filterTip, setFilterTip] = useState<string>("all");
  const [showSendDialog, setShowSendDialog] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState<string>("reminder");
  const [messageText, setMessageText] = useState(templates.reminder);

  const filtered = mesaje.filter(
    (m) => filterTip === "all" || m.tip === filterTip
  );

  const handleTemplateChange = (template: string) => {
    setSelectedTemplate(template);
    setMessageText(templates[template] || "");
  };

  const handleSend = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const clientId = formData.get("clientId") as string;
    const client = clienti.find((c) => c.id === clientId);
    if (!client) return;

    const newMessage: Message = {
      id: `msg${mesaje.length + 1}`,
      clientId,
      clientNume: client.nume,
      telefon: client.telefon,
      continut: messageText,
      dataTrimitere: new Date().toISOString().split("T")[0],
      status: "trimis",
      tip: selectedTemplate as Message["tip"],
    };
    setMesaje([newMessage, ...mesaje]);
    setShowSendDialog(false);
    setMessageText(templates.reminder);
    setSelectedTemplate("reminder");
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Mesaje</h1>
          <p className="text-muted-foreground mt-1">
            Trimite notificari si remindere clientilor
          </p>
        </div>
        <Dialog open={showSendDialog} onOpenChange={setShowSendDialog}>
          <DialogTrigger
            render={
              <Button>
                <Send className="w-4 h-4 mr-2" /> Trimite Mesaj
              </Button>
            }
          />
          <DialogContent className="max-w-md">
            <DialogHeader>
              <DialogTitle>Mesaj Nou</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleSend} className="space-y-4">
              <div className="space-y-2">
                <Label>Client</Label>
                <Select name="clientId" required>
                  <SelectTrigger>
                    <SelectValue placeholder="Selecteaza client" />
                  </SelectTrigger>
                  <SelectContent>
                    {clienti
                      .filter((c) => c.status !== "inactiv")
                      .map((c) => (
                        <SelectItem key={c.id} value={c.id}>
                          {c.nume} — {c.telefon}
                        </SelectItem>
                      ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Tip Mesaj</Label>
                <Select
                  value={selectedTemplate}
                  onValueChange={(v) => handleTemplateChange(v ?? "reminder")}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="reminder">Reminder</SelectItem>
                    <SelectItem value="confirmare">Confirmare</SelectItem>
                    <SelectItem value="urmarire">Urmarire</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Mesaj</Label>
                <Textarea
                  value={messageText}
                  onChange={(e) => setMessageText(e.target.value)}
                  rows={5}
                  required
                />
              </div>
              <Button type="submit" className="w-full">
                <Send className="w-4 h-4 mr-2" /> Trimite
              </Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4 items-center">
        <Select value={filterTip} onValueChange={(v) => setFilterTip(v ?? "all")}>
          <SelectTrigger className="w-48">
            <Filter className="w-4 h-4 mr-2" />
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Toate</SelectItem>
            <SelectItem value="reminder">Remindere</SelectItem>
            <SelectItem value="confirmare">Confirmari</SelectItem>
            <SelectItem value="urmarire">Urmariri</SelectItem>
          </SelectContent>
        </Select>
        <p className="text-sm text-muted-foreground">
          {filtered.length} mesaje
        </p>
      </div>

      <div className="space-y-3">
        {filtered.map((msg) => (
          <Card key={msg.id}>
            <CardContent className="p-4">
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1 space-y-2">
                  <div className="flex items-center gap-3">
                    <p className="font-semibold">{msg.clientNume}</p>
                    <Badge variant="secondary" className="text-xs">
                      {tipLabels[msg.tip]}
                    </Badge>
                    <Badge
                      variant="outline"
                      className={statusConfig[msg.status].className}
                    >
                      {statusConfig[msg.status].label}
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {msg.telefon}
                  </p>
                  <p className="text-sm">{msg.continut}</p>
                </div>
                <p className="text-sm text-muted-foreground whitespace-nowrap">
                  {msg.dataTrimitere}
                </p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filtered.length === 0 && (
        <div className="text-center py-12 text-muted-foreground">
          Niciun mesaj gasit.
        </div>
      )}
    </div>
  );
}
