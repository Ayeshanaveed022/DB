-- =============================================================================
-- MILESTONE 5: VALIDATION QUERIES
-- Project: Expense Tracker System
-- Authors: Ayesha & Raween
-- Purpose: Verify row counts, NULL checks, and foreign key integrity.
-- =============================================================================

USE expense_tracker_system;

-- -----------------------------------------------------------------------------
-- 1. ROW COUNT VERIFICATION
-- Screenshot name: row_counts.png
-- Expected:
-- users = 50
-- categories = 100
-- transactions = 99 after DELETE demo
-- budgets = 50
-- -----------------------------------------------------------------------------

SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets;


-- -----------------------------------------------------------------------------
-- 2. NULL CHECKS ON KEY COLUMNS
-- Screenshot name: null_checks.png
-- Expected result: all null_issue_count values should be 0
-- -----------------------------------------------------------------------------

SELECT 'users' AS table_name, COUNT(*) AS null_issue_count
FROM users
WHERE user_id IS NULL OR username IS NULL OR email IS NULL OR password_hash IS NULL

UNION ALL

SELECT 'categories', COUNT(*)
FROM categories
WHERE category_id IS NULL OR user_id IS NULL OR category_name IS NULL OR category_type IS NULL

UNION ALL

SELECT 'transactions', COUNT(*)
FROM transactions
WHERE transaction_id IS NULL OR category_id IS NULL OR amount IS NULL OR transaction_date IS NULL

UNION ALL

SELECT 'budgets', COUNT(*)
FROM budgets
WHERE budget_id IS NULL OR category_id IS NULL OR amount IS NULL OR period IS NULL;


-- -----------------------------------------------------------------------------
-- 3. JOIN-BASED FOREIGN KEY INTEGRITY CHECK
-- Screenshot name: fk_integrity.png
-- Expected result: all orphan_count values should be 0
-- -----------------------------------------------------------------------------

SELECT 'categories_to_users' AS relationship_checked, COUNT(*) AS orphan_count
FROM categories c
LEFT JOIN users u ON c.user_id = u.user_id
WHERE u.user_id IS NULL

UNION ALL

SELECT 'transactions_to_categories', COUNT(*)
FROM transactions t
LEFT JOIN categories c ON t.category_id = c.category_id
WHERE c.category_id IS NULL

UNION ALL

SELECT 'budgets_to_categories', COUNT(*)
FROM budgets b
LEFT JOIN categories c ON b.category_id = c.category_id
WHERE c.category_id IS NULL;