import csv
import sys
import os
from datetime import datetime
from decimal import Decimal

# Add backend to path so we can import from app
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

from app.db.session import SessionLocal
from app.models.user import User
from app.models.category import Category
from app.models.transaction import Transaction
from app.models.budget import Budget

def seed_csv():
    db = SessionLocal()
    data_dir = os.path.join(os.path.dirname(__file__), '..', 'data')
    
    try:
        # 1. Seed Users
        print("Seeding users...")
        with open(os.path.join(data_dir, 'users.csv'), 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if not row: continue
                user_id, username, email, password_hash, created_at = row
                if not db.query(User).filter(User.user_id == int(user_id)).first():
                    user = User(
                        user_id=int(user_id),
                        username=username,
                        email=email,
                        password_hash=password_hash,
                        created_at=datetime.strptime(created_at, '%Y-%m-%d %H:%M:%S')
                    )
                    db.add(user)
        db.commit()

        # 2. Seed Categories
        print("Seeding categories...")
        with open(os.path.join(data_dir, 'categories.csv'), 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if not row: continue
                cat_id, u_id, name, c_type = row
                if not db.query(Category).filter(Category.category_id == int(cat_id)).first():
                    category = Category(
                        category_id=int(cat_id),
                        user_id=int(u_id),
                        category_name=name,
                        category_type=c_type
                    )
                    db.add(category)
        db.commit()

        # 3. Seed Transactions
        print("Seeding transactions...")
        with open(os.path.join(data_dir, 'transactions.csv'), 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if not row: continue
                t_id, c_id, amt, t_date, desc = row
                if not db.query(Transaction).filter(Transaction.transaction_id == int(t_id)).first():
                    transaction = Transaction(
                        transaction_id=int(t_id),
                        category_id=int(c_id),
                        amount=Decimal(amt),
                        transaction_date=datetime.strptime(t_date, '%Y-%m-%d').date(),
                        description=desc
                    )
                    db.add(transaction)
        db.commit()

        # 4. Seed Budgets
        print("Seeding budgets...")
        with open(os.path.join(data_dir, 'budgets.csv'), 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if not row: continue
                b_id, c_id, amt, period = row
                if not db.query(Budget).filter(Budget.budget_id == int(b_id)).first():
                    budget = Budget(
                        budget_id=int(b_id),
                        category_id=int(c_id),
                        amount=Decimal(amt),
                        period=period
                    )
                    db.add(budget)
        db.commit()

        print("Seeding completed successfully.")

    except Exception as e:
        print(f"Error during seeding: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_csv()
