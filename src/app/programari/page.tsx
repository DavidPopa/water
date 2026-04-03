"use client";

import { useState } from "react";
import { Calendar } from "@/components/ui/calendar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { mentenante, maintenanceTypeLabels } from "@/lib/data";
import type { MaintenanceStatus } from "@/lib/types";

const statusConfig: Record<
  MaintenanceStatus,
  { label: string; className: string }
> = {
  programat: { label: "Programat", className: "bg-blue-500/20 text-blue-300 border-blue-500/30" },
  in_lucru: { label: "In Lucru", className: "bg-amber-500/20 text-amber-300 border-amber-500/30" },
  finalizat: {
    label: "Finalizat",
    className: "bg-emerald-500/20 text-emerald-300 border-emerald-500/30",
  },
  anulat: { label: "Anulat", className: "bg-gray-500/20 text-gray-300 border-gray-500/30" },
};

export default function ProgramariPage() {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(
    new Date()
  );

  const selectedDateStr = selectedDate
    ? selectedDate.toISOString().split("T")[0]
    : "";

  const dayMaintenance = mentenante.filter((m) => m.data === selectedDateStr);

  const datesWithMaintenance = new Set(mentenante.map((m) => m.data));

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Programari</h1>
        <p className="text-muted-foreground mt-1">
          Calendar de programari si mentenanta
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg">Calendar</CardTitle>
          </CardHeader>
          <CardContent className="flex justify-center">
            <Calendar
              mode="single"
              selected={selectedDate}
              onSelect={setSelectedDate}
              modifiers={{
                hasMaintenance: (date) =>
                  datesWithMaintenance.has(
                    date.toISOString().split("T")[0]
                  ),
              }}
              modifiersClassNames={{
                hasMaintenance:
                  "bg-primary/20 text-primary font-bold rounded-full",
              }}
              className="rounded-md"
            />
          </CardContent>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="text-lg">
              Programari pentru{" "}
              {selectedDate
                ? selectedDate.toLocaleDateString("ro-RO", {
                    weekday: "long",
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })
                : "..."}
            </CardTitle>
          </CardHeader>
          <CardContent>
            {dayMaintenance.length > 0 ? (
              <div className="space-y-4">
                {dayMaintenance
                  .sort((a, b) => a.ora.localeCompare(b.ora))
                  .map((m) => (
                    <div
                      key={m.id}
                      className="flex items-start gap-4 p-4 rounded-lg border"
                    >
                      <div className="text-center min-w-[60px]">
                        <p className="text-2xl font-bold text-primary">
                          {m.ora.split(":")[0]}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          :{m.ora.split(":")[1]}
                        </p>
                      </div>
                      <div className="flex-1 space-y-2">
                        <div className="flex items-center justify-between">
                          <h3 className="font-semibold">{m.clientNume}</h3>
                          <Badge
                            variant="outline"
                            className={statusConfig[m.status].className}
                          >
                            {statusConfig[m.status].label}
                          </Badge>
                        </div>
                        <div className="flex gap-4 text-sm text-muted-foreground">
                          <span>{maintenanceTypeLabels[m.tip]}</span>
                          <span>&middot;</span>
                          <span>{m.tehnician}</span>
                          <span>&middot;</span>
                          <span>{m.durata} min</span>
                        </div>
                        {m.notite && (
                          <p className="text-sm text-muted-foreground bg-muted p-2 rounded">
                            {m.notite}
                          </p>
                        )}
                      </div>
                    </div>
                  ))}
              </div>
            ) : (
              <div className="text-center py-12 text-muted-foreground">
                Nicio programare pentru aceasta zi.
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
