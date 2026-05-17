import csv
import random
import os
from datetime import datetime, timedelta

# Milestone 3 synthetic dataset configuration
# Minimum required by sir: 50 rows per table. This produces:
# users = 50, categories = 100, transactions = 100, budgets = 50
NUM_USERS = 50
CATEGORIES_PER_USER = 2  # 1 INCOME + 1 EXPENSE per user = 100 categories
TRANSACTIONS_PER_USER = 2  # 50 users * 2 = 100 transactions
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "data")

random.seed(42)
os.makedirs(OUTPUT_DIR, exist_ok=True)

users = []
categories = []
transactions = []
budgets = []

first_names = [
    "ayesha", "raween", "amna", "sara", "fatima", "zainab", "maria", "hina", "laiba", "iqra",
    "ali", "ahmed", "hassan", "usman", "hamza", "bilal", "umer", "saad", "zain", "danish",
    "maryam", "noor", "maha", "sania", "rabia", "alina", "eman", "ayla", "sana", "bisma",
    "jawad", "farhan", "arham", "talha", "rehan", "faizan", "asad", "waleed", "imran", "kamran",
    "nida", "sadia", "mahnoor", "komal", "mehak", "areeba", "asma", "saira", "nimra", "dua"
]

income_categories = ["Salary", "Freelance", "Bonus", "Investment", "Gift", "Refund"]
expense_categories = ["Groceries", "Rent", "Transport", "Utilities", "Dining", "Entertainment", "Shopping", "Health"]

# 1. Users: 50 rows
for i, name in enumerate(first_names, start=1):
    username = f"{name}_{i}"
    users.append({
        "user_id": i,
        "username": username,
        "email": f"{username}@example.com",
        "password_hash": f"hash_{username}_123",
        "created_at": "2026-01-01 10:00:00"
    })

# 2. Categories: 100 rows, exactly 2 categories per user
category_id = 1
expense_category_ids = []
for user in users:
    income_name = random.choice(income_categories)
    expense_name = random.choice(expense_categories)

    categories.append({
        "category_id": category_id,
        "user_id": user["user_id"],
        "category_name": income_name,
        "category_type": "INCOME"
    })
    income_cat_id = category_id
    category_id += 1

    categories.append({
        "category_id": category_id,
        "user_id": user["user_id"],
        "category_name": expense_name,
        "category_type": "EXPENSE"
    })
    expense_category_ids.append(category_id)
    category_id += 1

# 3. Transactions: 100 rows, 2 transactions per user
transaction_id = 1
start_date = datetime(2026, 1, 1)
for user in users:
    user_categories = [c for c in categories if c["user_id"] == user["user_id"]]
    for cat in user_categories:  # one income + one expense transaction
        if cat["category_type"] == "INCOME":
            amount = round(random.uniform(1500, 8000), 2)
        else:
            amount = round(random.uniform(100, 2500), 2)

        transaction_date = (start_date + timedelta(days=random.randint(0, 135))).strftime("%Y-%m-%d")
        transactions.append({
            "transaction_id": transaction_id,
            "category_id": cat["category_id"],
            "amount": amount,
            "transaction_date": transaction_date,
            "description": f"Transaction for {cat['category_name']}"
        })
        transaction_id += 1

# 4. Budgets: 50 rows, one budget for each expense category
budget_id = 1
for cat_id in expense_category_ids:
    budgets.append({
        "budget_id": budget_id,
        "category_id": cat_id,
        "amount": round(random.uniform(1000, 5000), 2),
        "period": "MONTHLY"
    })
    budget_id += 1

# Write CSV files WITHOUT headers because current LOAD DATA INFILE script does not use IGNORE 1 LINES
def write_csv(filename, rows, fieldnames):
    with open(os.path.join(OUTPUT_DIR, filename), "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writerows(rows)

write_csv("users.csv", users, ["user_id", "username", "email", "password_hash", "created_at"])
write_csv("categories.csv", categories, ["category_id", "user_id", "category_name", "category_type"])
write_csv("transactions.csv", transactions, ["transaction_id", "category_id", "amount", "transaction_date", "description"])
write_csv("budgets.csv", budgets, ["budget_id", "category_id", "amount", "period"])

print("Synthetic data generated successfully.")
print(f"users: {len(users)}")
print(f"categories: {len(categories)}")
print(f"transactions: {len(transactions)}")
print(f"budgets: {len(budgets)}")
