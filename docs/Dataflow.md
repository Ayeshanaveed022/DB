# Milestone 3: Dataflow Description

## 1. System Data Architecture
The Expense Tracker System follows a linear data flow architecture where user actions trigger state changes in the database. The system is designed to maintain high integrity through strict foreign key constraints.

## 2. Data Flow Map

### Step A: User Authentication (Entry Point)
- **Source**: User Registration/Login UI.
- **Process**: `username`, `email`, and `password_hash` are captured.
- **Destination**: `users` table.
- **Output**: A unique `user_id` is generated, which acts as the anchor for all subsequent data.

### Step B: Category Definition (Structural Layer)
- **Source**: User settings or default templates.
- **Process**: User defines names (e.g., "Salary", "Rent") and types ('INCOME' or 'EXPENSE').
- **Constraint**: Each category is tied to a specific `user_id`.
- **Destination**: `categories` table.

### Step C: Transaction Ledger (Execution Layer)
- **Source**: Expense/Income input forms.
- **Process**: User inputs `amount`, `date`, and selects a `category_id`.
- **Logic**: 
  - If the selected category is 'EXPENSE', the transaction acts as a debit from the user's implicit balance.
  - If 'INCOME', it acts as a credit.
- **Destination**: `transactions` table.

### Step D: Budgeting & Monitoring (Analytical Layer)
- **Source**: Budget planning form.
- **Process**: User sets an `amount` and `period` for a specific `category_id`.
- **Destination**: `budgets` table.
- **Validation**: System checks if a budget already exists for that category (1:1 relationship).

## 3. Data Transformation Summary
| Action | Input Data | Transformation | Output Table |
|--------|------------|----------------|--------------|
| Register | Raw Strings | Hash Password | `users` |
| Add Income | Amount, Source | Link to Category | `transactions` |
| Add Expense | Amount, Category | Link to Category | `transactions` |
| Set Budget | Amount, Period | Map to Category | `budgets` |

## 4. Export/Import Strategy
- Data is exported as CSV for archival or bulk analysis.
- The `LOAD DATA INFILE` command is used for bulk population of the database, ensuring that `users` are imported first, followed by `categories`, and finally `transactions` and `budgets` to satisfy foreign key dependencies.
