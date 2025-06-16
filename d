Here’s your **minimally modified and fully integrated version** that:

* Keeps your existing calendar/transaction modal structure
* Allows you to add a transaction from the modal
* Immediately reflects the new transaction on the calendar

---

### ✅ `MonthCalendar.tsx`

Make these changes to your existing file (no need to delete the rest):

```tsx
import { useState } from "react";
import { DollarSign, TrendingUp } from "lucide-react";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogClose,
} from "@/components/calendar-parts/dialog";
import { Button } from "@/components/calendar-parts/button";
import AddTransactionsBtn from "@/components/calendar-parts/addTransactionsBtn"; // ✅ ensure path is correct

const SAMPLE_SPENDING_DATA: Record<string, any>[] = [
  {
    date: "2025-06-02",
    budget: 2000,
    total: 410.5,
    transactions: [
      {
        category: "Groceries",
        amount: 130.0,
        description: "Grocery shopping",
      },
      {
        category: "Entertainment",
        amount: 150.0,
        description: "Concert tickets",
      },
      {
        category: "Transportation",
        amount: 130.5,
        description: "Bus pass",
      },
    ],
  },
  {
    date: "2025-06-03",
    budget: 2000,
    total: 765.5,
    transactions: [
      {
        category: "Rent",
        amount: 600.0,
        description: "Monthly rent payment",
      },
      {
        category: "Entertainment",
        amount: 120.0,
        description: "Concert tickets",
      },
      {
        category: "Dining Out",
        amount: 45.5,
        description: "Dinner with friends",
      },
    ],
  },
  {
    date: "2025-06-04",
    budget: 2000,
    total: 140.5,
    transactions: [
      {
        category: "Transportation",
        amount: 75.5,
        description: "Gas and tolls",
      },
      {
        category: "Entertainment",
        amount: 35.0,
        description: "Movie tickets",
      },
      {
        category: "Personal Care",
        amount: 30.0,
        description: "Haircut",
      },
    ],
  },
];

const MonthCalendar = () => {
  const [spendingData, setSpendingData] = useState(SAMPLE_SPENDING_DATA); // ✅ state-based
  const [selectedDate, setSelectedDate] = useState<string | null>(null);

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
      {/* your calendar rendering logic remains unchanged */}

      <Dialog open={!!selectedDate} onOpenChange={() => setSelectedDate(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              <div className="flex gap-2 items-center text-lg">
                <DollarSign className="w-5 h-5" />
                {selectedDate}
              </div>
            </DialogTitle>
          </DialogHeader>

          {/* ✅ Hook in the button with props */}
          {selectedDate && (
            <AddTransactionsBtn
              date={selectedDate}
              onAdd={handleAddTransaction}
            />
          )}

          <div className="mt-4">
            <p className="font-semibold">Transactions</p>
            {selectedDate &&
              spendingData
                .find(d => d.date === selectedDate)
                ?.transactions.map((tx, i) => (
                  <div key={i} className="border p-2 rounded mt-2 flex justify-between">
                    <div>
                      <p className="font-medium">{tx.description}</p>
                      <p className="text-sm">{tx.category}</p>
                    </div>
                    <p className="font-semibold">${tx.amount.toFixed(2)}</p>
                  </div>
                ))}
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default MonthCalendar;
```

---

### ✅ `addTransactionsBtn.tsx`

Minimal changes to add transaction and call the handler you passed in:

```tsx
import { Button } from "@/components/calendar-parts/button";

const AddTransactionsBtn = ({
  date,
  onAdd,
}: {
  date: string;
  onAdd: (tx: {
    date: string;
    category: string;
    description: string;
    amount: number;
  }) => void;
}) => {
  const addTransactions = () => {
    const category = prompt("Type in category");
    const transactionName = prompt("Type in the transaction name");
    const transactionPrice = Number(prompt("Type in transaction price"));

    if (!category || !transactionName || isNaN(transactionPrice)) {
      alert("Invalid input. Please try again.");
      return;
    }

    const newTransaction = {
      date,
      category,
      amount: transactionPrice,
      description: transactionName ?? "",
    };

    onAdd(newTransaction); // ✅ Call the handler
  };

  return (
    <div className="flex justify-center">
      <Button onClick={addTransactions}>Add Transaction</Button>
    </div>
  );
};

export default AddTransactionsBtn;
```

---

This update will:

* Keep all your existing structure and styling
* Immediately update the cell (amount + transaction count) when a transaction is added
* Work with your current modal without rewriting how things are displayed

Let me know if you want edit/delete handling next.
