"use client";

import {
  Users,
  Wrench,
  CalendarDays,
  MessageSquare,
  UserPlus,
  AlertTriangle,
  ArrowRight,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  dashboardStats,
  mentenante,
  mesaje,
  maintenanceTypeLabels,
} from "@/lib/data";
import Link from "next/link";

const statCards = [
  {
    label: "Total Clienti",
    value: dashboardStats.totalClienti,
    icon: Users,
    color: "text-blue-600",
    bg: "bg-blue-50",
  },
  {
    label: "Mentenante Luna Aceasta",
    value: dashboardStats.mentenanteLuna,
    icon: Wrench,
    color: "text-emerald-600",
    bg: "bg-emerald-50",
  },
  {
    label: "Programari Azi",
    value: dashboardStats.programariAzi,
    icon: CalendarDays,
    color: "text-violet-600",
    bg: "bg-violet-50",
  },
  {
    label: "Mesaje Trimise",
    value: dashboardStats.mesajeTrimise,
    icon: MessageSquare,
    color: "text-amber-600",
    bg: "bg-amber-50",
  },
  {
    label: "Clienti Noi",
    value: dashboardStats.clientiNoi,
    icon: UserPlus,
    color: "text-cyan-600",
    bg: "bg-cyan-50",
  },
  {
    label: "Mentenante Restante",
    value: dashboardStats.mentenanteRestante,
    icon: AlertTriangle,
    color: "text-red-600",
    bg: "bg-red-50",
  },
];

function StatusBadge({ status }: { status: string }) {
  const variants: Record<string, string> = {
    programat: "bg-blue-100 text-blue-800",
    in_lucru: "bg-amber-100 text-amber-800",
    finalizat: "bg-emerald-100 text-emerald-800",
    anulat: "bg-gray-100 text-gray-800",
  };
  const labels: Record<string, string> = {
    programat: "Programat",
    in_lucru: "In Lucru",
    finalizat: "Finalizat",
    anulat: "Anulat",
  };
  return (
    <Badge variant="outline" className={variants[status]}>
      {labels[status]}
    </Badge>
  );
}

export default function DashboardPage() {
  const upcomingMaintenance = mentenante
    .filter((m) => m.status === "programat" || m.status === "in_lucru")
    .sort((a, b) => a.data.localeCompare(b.data))
    .slice(0, 5);

  const recentMessages = mesaje.slice(0, 4);

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <p className="text-muted-foreground mt-1">
          Bine ai venit! Iata o privire de ansamblu.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {statCards.map((stat) => (
          <Card key={stat.label}>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground">{stat.label}</p>
                  <p className="text-3xl font-bold mt-1">{stat.value}</p>
                </div>
                <div
                  className={`w-12 h-12 rounded-lg ${stat.bg} flex items-center justify-center`}
                >
                  <stat.icon className={`w-6 h-6 ${stat.color}`} />
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-lg">Mentenante Urmatoare</CardTitle>
            <Link href="/mentenanta">
              <Button variant="ghost" size="sm">
                Vezi toate <ArrowRight className="w-4 h-4 ml-1" />
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {upcomingMaintenance.map((m) => (
                <div
                  key={m.id}
                  className="flex items-center justify-between p-3 rounded-lg bg-muted/50"
                >
                  <div className="space-y-1">
                    <p className="font-medium">{m.clientNume}</p>
                    <p className="text-sm text-muted-foreground">
                      {maintenanceTypeLabels[m.tip]} &middot; {m.tehnician}
                    </p>
                  </div>
                  <div className="text-right space-y-1">
                    <p className="text-sm font-medium">{m.data}</p>
                    <p className="text-sm text-muted-foreground">{m.ora}</p>
                  </div>
                  <div className="ml-3">
                    <StatusBadge status={m.status} />
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-lg">Mesaje Recente</CardTitle>
            <Link href="/mesaje">
              <Button variant="ghost" size="sm">
                Vezi toate <ArrowRight className="w-4 h-4 ml-1" />
              </Button>
            </Link>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {recentMessages.map((msg) => (
                <div
                  key={msg.id}
                  className="p-3 rounded-lg bg-muted/50 space-y-2"
                >
                  <div className="flex items-center justify-between">
                    <p className="font-medium text-sm">{msg.clientNume}</p>
                    <Badge
                      variant="outline"
                      className={
                        msg.status === "citit"
                          ? "bg-emerald-100 text-emerald-800"
                          : msg.status === "livrat"
                            ? "bg-blue-100 text-blue-800"
                            : msg.status === "trimis"
                              ? "bg-amber-100 text-amber-800"
                              : "bg-red-100 text-red-800"
                      }
                    >
                      {msg.status === "citit"
                        ? "Citit"
                        : msg.status === "livrat"
                          ? "Livrat"
                          : msg.status === "trimis"
                            ? "Trimis"
                            : "Esuat"}
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {msg.continut}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {msg.dataTrimitere}
                  </p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
