"use client";

import { useState } from "react";
import { DollarSign, ChevronLeft, ChevronRight } from "lucide-react";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogClose,
} from "@/components/calendar-parts/dialog";
import { Badge } from "@/components/calendar-parts/badge";
import { Button } from "@/components/calendar-parts/button";
import AddTransactionsBtn from "@/components/calendar-parts/addTransactionsBtn";

const DAYS_OF_WEEK = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

const SAMPLE_SPENDING_DATA: Record<string, any>[] = [
  {
    date: "2025-06-02",
    budget: 2000,
    total: 410.5,
    transactions: [
      { category: "Groceries", amount: 130.0, description: "Grocery shopping" },
      { category: "Entertainment", amount: 150.0, description: "Concert tickets" },
      { category: "Transportation", amount: 130.5, description: "Bus pass" },
    ],
  },
  {
    date: "2025-06-03",
    budget: 2000,
    total: 765.5,
    transactions: [
      { category: "Rent", amount: 600.0, description: "Monthly rent payment" },
      { category: "Entertainment", amount: 120.0, description: "Concert tickets" },
      { category: "Dining Out", amount: 45.5, description: "Dinner with friends" },
    ],
  },
  {
    date: "2025-06-04",
    budget: 2000,
    total: 140.5,
    transactions: [
      { category: "Transportation", amount: 75.5, description: "Gas and tolls" },
      { category: "Entertainment", amount: 35.0, description: "Movie tickets" },
      { category: "Personal Care", amount: 30.0, description: "Haircut" },
    ],
  },
];

const getFirstDayOfMonth = (year: number, month: number) =>
  new Date(year, month, 1).getDay();

const getDaysInMonth = (year: number, month: number) =>
  new Date(year, month + 1, 0).getDate();

const getDateKey = (year: number, month: number, day: number) =>
  `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;

const MonthCalendar = () => {
  const today = new Date();
  const [currentMonth, setCurrentMonth] = useState(today.getMonth());
  const [currentYear, setCurrentYear] = useState(today.getFullYear());
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [spendingData, setSpendingData] = useState(SAMPLE_SPENDING_DATA);

  const daysInMonth = getDaysInMonth(currentYear, currentMonth);
  const firstDayOfWeek = getFirstDayOfMonth(currentYear, currentMonth);

  const handleAddTransaction = (newTx: {
    date: string;
    category: string;
    description: string;
    amount: number;
  }) => {
    setSpendingData(prev => {
      const idx = prev.findIndex(entry => entry.date === newTx.date);
      if (idx !== -1) {
        const updated = [...prev];
        updated[idx] = {
          ...updated[idx],
          total: updated[idx].total + newTx.amount,
          transactions: [...updated[idx].transactions, newTx],
        };
        return updated;
      } else {
        return [
          ...prev,
          {
            date: newTx.date,
            budget: 0,
            total: newTx.amount,
            transactions: [newTx],
          },
        ];
      }
    });
  };

  return (
    <>
      <div className="w-full px-4 pt-2 pb-4">
        <div className="flex justify-between items-center mb-2">
          <h2 className="text-3xl font-bold text-green-700 flex items-center gap-2">
            <DollarSign className="w-6 h-6" /> June 2025
          </h2>
          <div className="text-lg font-semibold">
            Monthly Total: <span className="text-black">${spendingData.reduce((sum, d) => sum + d.total, 0).toFixed(2)}</span> &nbsp; | &nbsp;
            Budget: <span className="text-black">$2500.00</span>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => {
              if (currentMonth === 0) {
                setCurrentYear(y => y - 1);
                setCurrentMonth(11);
              } else {
                setCurrentMonth(m => m - 1);
              }
            }}>
              <ChevronLeft />
            </Button>
            <Button variant="outline" onClick={() => {
              if (currentMonth === 11) {
                setCurrentYear(y => y + 1);
                setCurrentMonth(0);
              } else {
                setCurrentMonth(m => m + 1);
              }
            }}>
              <ChevronRight />
            </Button>
          </div>
        </div>

        <div className="grid grid-cols-7 text-center font-medium mb-2 text-gray-600">
          {["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].map(d => (
            <div key={d}>{d}</div>
          ))}
        </div>

        <div className="grid grid-cols-7 gap-px rounded-md border overflow-hidden">
          {[...Array(firstDayOfWeek)].map((_, i) => (
            <div key={`empty-${i}`} className="bg-gray-100 h-24" />
          ))}
          {[...Array(daysInMonth)].map((_, i) => {
            const day = i + 1;
            const key = getDateKey(currentYear, currentMonth, day);
            const entry = spendingData.find(e => e.date === key);

            return (
              <button
                key={key}
                onClick={() => setSelectedDate(key)}
                className="bg-white h-24 p-1 relative border hover:bg-gray-50"
              >
                <div className="font-semibold text-sm">{day}</div>
                {entry && (
                  <>
                    <Badge
                      variant={
                        entry.total < 500 ? "default" :
                        entry.total < 700 ? "outline" :
                        "destructive"
                      }
                      className="absolute bottom-6 left-1 text-[10px]"
                    >
                      ${entry.total.toFixed(2)}
                    </Badge>
                    <div className="absolute bottom-1 left-1 text-[10px] text-gray-500">
                      {entry.transactions.length} transactions
                    </div>
                  </>
                )}
              </button>
            );
          })}
        </div>
      </div>

      <Dialog open={!!selectedDate} onOpenChange={() => setSelectedDate(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-xl">
              <DollarSign className="w-5 h-5" />
              {selectedDate}
            </DialogTitle>
            <DialogClose />
          </DialogHeader>

          {selectedDate && (
            <>
              <div className="flex justify-center mb-4">
                <AddTransactionsBtn
                  date={selectedDate}
                  onAdd={handleAddTransaction}
                />
              </div>

              <div className="text-center text-lg font-semibold mb-2">
                Total Spending: $
                {spendingData.find(e => e.date === selectedDate)?.total.toFixed(2) ?? "0.00"}
              </div>

              <div className="space-y-3">
                {spendingData
                  .find(e => e.date === selectedDate)
                  ?.transactions.map((tx, idx) => (
                    <div
                      key={idx}
                      className="border rounded p-3 flex justify-between items-center"
                    >
                      <div>
                        <p className="font-semibold">{tx.description}</p>
                        <p className="text-sm text-gray-600">{tx.category}</p>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold">${tx.amount.toFixed(2)}</span>
                        <button className="bg-green-500 text-white text-xs px-2 py-1 rounded">Edit</button>
                        <button className="bg-green-500 text-white text-xs px-2 py-1 rounded">Delete</button>
                      </div>
                    </div>
                  ))}
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </>
  );
};

export default MonthCalendar;
