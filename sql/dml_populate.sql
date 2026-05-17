-- =============================================================================
-- MILESTONE 5: DATA POPULATION SCRIPT
-- Project: Expense Tracker System
-- Authors: Ayesha & Raween
-- Purpose: Load synthetic CSV data into the normalized database.
-- =============================================================================

USE expense_tracker_system;

-- -----------------------------------------------------------------------------
-- IMPORTANT NOTE:
-- LOAD DATA LOCAL INFILE was disabled on the local MySQL setup.
-- Therefore, the CSV data was populated using:
--
-- python scripts/seed_csv.py
--
-- This Python script loads the same CSV files into the same database tables:
-- users, categories, transactions, and budgets.
-- This follows the INSERT-statement approach allowed in Milestone 5.
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Required DML demonstration: UPDATE with WHERE condition
-- -----------------------------------------------------------------------------
UPDATE budgets
SET amount = amount + 500.00
WHERE budget_id = 1;

-- Show updated budget record
SELECT *
FROM budgets
WHERE budget_id = 1;

-- -----------------------------------------------------------------------------
-- Required DML demonstration: DELETE with WHERE condition
-- -----------------------------------------------------------------------------
DELETE FROM transactions
WHERE transaction_id = 100;

-- Show that deleted transaction no longer exists
SELECT *
FROM transactions
WHERE transaction_id = 100;