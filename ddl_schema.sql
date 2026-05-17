-- =============================================================================
-- PROJECT      : Expense Tracker System
-- DATABASE     : expense_tracker_system
-- RDBMS TARGET : MySQL 8.0+ (InnoDB)
-- MILESTONES   : M2 (Normalization) & M4 (DDL Implementation)
-- AUTHORS     : Ayesha & Raween
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Database Initialization
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS expense_tracker_system
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE expense_tracker_system;

-- -----------------------------------------------------------------------------
-- 2. Drop Tables (Clean State)
-- -----------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS budgets;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- 3. Table: users
-- -----------------------------------------------------------------------------
CREATE TABLE users (
    user_id       INT            NOT NULL AUTO_INCREMENT,
    username      VARCHAR(64)    NOT NULL,
    email         VARCHAR(255)   NOT NULL,
    password_hash VARCHAR(255)   NOT NULL,
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_users          PRIMARY KEY (user_id),
    CONSTRAINT uq_users_username UNIQUE      (username),
    CONSTRAINT uq_users_email    UNIQUE      (email)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='System users and their authentication credentials.';

-- -----------------------------------------------------------------------------
-- 4. Table: categories
-- -----------------------------------------------------------------------------
CREATE TABLE categories (
    category_id   INT            NOT NULL AUTO_INCREMENT,
    user_id       INT            NOT NULL,
    category_name VARCHAR(128)   NOT NULL,
    category_type ENUM('INCOME', 'EXPENSE') NOT NULL,

    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_user_name UNIQUE (user_id, category_name),
    CONSTRAINT fk_categories_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Customized categories for income and expenses.';

CREATE INDEX idx_categories_user_id ON categories (user_id);

-- -----------------------------------------------------------------------------
-- 5. Table: transactions
-- -----------------------------------------------------------------------------
CREATE TABLE transactions (
    transaction_id   INT            NOT NULL AUTO_INCREMENT,
    category_id      INT            NOT NULL,
    amount           DECIMAL(10,2)  NOT NULL,
    transaction_date DATE           NOT NULL,
    description      TEXT           NULL,

    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id),
    CONSTRAINT chk_transactions_amount CHECK (amount > 0),
    CONSTRAINT fk_transactions_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Unified ledger for income and expense transactions.';

CREATE INDEX idx_transactions_category_id ON transactions (category_id);
CREATE INDEX idx_transactions_date ON transactions (transaction_date);

-- -----------------------------------------------------------------------------
-- 6. Table: budgets
-- -----------------------------------------------------------------------------
CREATE TABLE budgets (
    budget_id     INT            NOT NULL AUTO_INCREMENT,
    category_id   INT            NOT NULL,
    amount        DECIMAL(10,2)  NOT NULL,
    period        ENUM('DAILY', 'WEEKLY', 'MONTHLY', 'ANNUAL') NOT NULL,

    CONSTRAINT pk_budgets PRIMARY KEY (budget_id),
    CONSTRAINT uq_budgets_category UNIQUE (category_id), -- One budget per category
    CONSTRAINT chk_budgets_amount CHECK (amount > 0),
    CONSTRAINT fk_budgets_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Spending limits set per category.';

CREATE INDEX idx_budgets_category_id ON budgets (category_id);