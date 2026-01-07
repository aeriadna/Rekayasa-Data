CREATE DATABASE tugas2;

USE tugas2;

CREATE TABLE account (
	ID INT,
    balance_account INT,
    status VARCHAR(255),
    created_at DATETIME,
    deleted_at VARCHAR(255),
    client_id INT,
    account_type_id INT,
    branch_id INT,
    PRIMARY KEY (ID)
);

CREATE TABLE account_types (
    ID INT,
    description_type TEXT,
    account_type_name VARCHAR(255),
    PRIMARY KEY (ID)
);

UPDATE account_types SET account_type_name = 'Savings' WHERE ID = 1;
UPDATE account_types SET account_type_name = 'Student' WHERE ID = 2;
UPDATE account_types SET account_type_name = 'Online Banking' WHERE ID = 3;
UPDATE account_types SET account_type_name = 'Health Saving (HSA)' WHERE ID = 4;
UPDATE account_types SET account_type_name = 'Business' WHERE ID = 5;
UPDATE account_types SET account_type_name = 'Certificate of Deposit (CD)' WHERE ID = 6;
UPDATE account_types SET account_type_name = 'Money Market' WHERE ID = 7;
UPDATE account_types SET account_type_name = 'Checking' WHERE ID = 8;
UPDATE account_types SET account_type_name = 'Trust' WHERE ID = 9;
UPDATE account_types SET account_type_name = 'Cusaccount_typestodial' WHERE ID = 10;

CREATE TABLE branch (
	branch_ID INT,
    branch_name VARCHAR(255),
    location VARCHAR(255),
    manager VARCHAR(255),
    PRIMARY KEY (branch_ID)
);

CREATE TABLE client (
	client_ID INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    dob DATE,
    address VARCHAR(255),
    age INT,
    sex VARCHAR(255),
    created_time DATETIME,
    contact_number VARCHAR(255),
    work_number VARCHAR(255),
    PRIMARY KEY (client_ID)
);

CREATE TABLE transactions (
	ID INT,
    amount_transaction INT,
    date_issued TEXT,
    deposit INT,
    withdraw INT,
    transfer INT,
    total_balance TEXT,
    transaction_type_id INT,
    source_account_ID INT,
    destination_account_ID INT,
    PRIMARY KEY (ID)
);

CREATE TABLE transaction_types (
    ID INT,
    transaction_type VARCHAR(255),
    descriptions TEXT,
    transaction_fee INT,
    PRIMARY KEY (ID)
);

SELECT 
	DATE_FORMAT(created_at, '%Y-%m') AS bulan_dibuat,
	COUNT(*) AS jumlah_akun
FROM account
GROUP BY bulan_dibuat
ORDER BY bulan_dibuat ASC;

SELECT 
	a_t.account_type_name AS jenis_akun,
	COUNT(*) AS jumlah_akun
FROM account AS a
JOIN account_types AS a_t ON a.account_type_id = a_t.ID
GROUP BY jenis_akun
ORDER BY jumlah_akun DESC;

SELECT 
	b.*, 
    COUNT(a.ID) AS jumlah_akun
FROM branch as b LEFT JOIN account AS a 
ON b.branch_ID = a.branch_ID
GROUP BY b.branch_ID
ORDER BY jumlah_akun ASC;

SELECT 
  CONCAT(c.first_name, ' ', c.last_name) AS nama_lengkap,
  a_t.account_type_name AS jenis_akun,
  a.balance_account AS total_saldo
FROM client AS c
JOIN account AS a ON c.client_ID = a.client_id
JOIN account_types AS a_t ON a.account_type_id = a_t.ID
GROUP BY nama_lengkap, jenis_akun, total_saldo
ORDER BY nama_lengkap;

SELECT
  c.sex AS jenis_kelamin,
  COUNT(t.id) AS jumlah_transaksi
FROM transactions AS t
JOIN account AS a ON t.source_account_id = a.id
JOIN client AS c ON a.client_id = c.client_id
GROUP BY c.sex
ORDER BY jumlah_transaksi DESC;

SELECT 
    t_t.transaction_type AS jenis_transaksi,
    COUNT(t.ID) AS jumlah_transaksi
FROM transactions AS t
JOIN transaction_types AS t_t ON t.transaction_type_id = t_t.ID
JOIN account AS a ON t.source_account_id = a.ID
JOIN client AS c ON a.client_id = c.client_id
WHERE c.sex = 'F' 
GROUP BY t_t.transaction_type
ORDER BY jumlah_transaksi DESC;
