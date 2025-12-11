CREATE TABLE BankBranch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets REAL
);

CREATE TABLE Account (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES BankBranch(branch_name)
);

CREATE TABLE Customer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(50),
    customer_city VARCHAR(50)
);

CREATE TABLE Depositor (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES Customer(customer_name),
    FOREIGN KEY (accno) REFERENCES Account(accno)
);

CREATE TABLE Loan1 (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES BankBranch(branch_name)
);


INSERT INTO BankBranch VALUES
('SBI_ResidencyRoad', 'Bangalore', 8000000),
('SBI_Chamrajpet', 'Bangalore', 6000000),
('SBI_ShivajiRoad', 'Bombay', 7000000),
('SBI_ParliamentRoad', 'Delhi', 5000000),
('SBI_Jantarmantar', 'Delhi', 4000000);

INSERT INTO Account VALUES
(1001, 'SBI_ResidencyRoad', 50000),
(1002, 'SBI_Chamrajpet', 75000),
(1003, 'SBI_ShivajiRoad', 60000),
(1004, 'SBI_ParliamentRoad', 80000),
(1005, 'SBI_Jantarmantar', 55000),
(1006, 'SBI_ResidencyRoad', 90000);

INSERT INTO Customer VALUES
('Ravi Kumar', 'Church Street', 'Bangalore'),
('Priya Singh', 'MG Road', 'Bangalore'),
('Arjun Mehta', 'Residency Road', 'Bangalore'),
('Neha Gupta', 'Virat Road', 'Delhi'),
('Rahul Das', 'Prithviraj Road', 'Delhi');

INSERT INTO Depositor VALUES
('Ravi Kumar', 1001),
('Ravi Kumar', 1002),
('Priya Singh', 1003),
('Arjun Mehta', 1004),
('Neha Gupta', 1005),
('Ravi Kumar', 1006);

INSERT INTO Loan1 VALUES
(201, 'SBI_ResidencyRoad', 300000),
(202, 'SBI_Chamrajpet', 250000),
(203, 'SBI_ShivajiRoad', 400000),
(204, 'SBI_ParliamentRoad', 350000),
(205, 'SBI_Jantarmantar', 200000);

SELECT * FROM Loan1 ORDER BY amount DESC;

CREATE VIEW BranchLoanSummary2 AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan1
GROUP BY branch_name;

SELECT * FROM BranchLoanSummary2;

UPDATE Account
SET balance = balance * 1.05;

SELECT accno, branch_name, balance FROM Account;

SELECT DISTINCT C.customer_name
FROM Customer C
WHERE C.customer_name IN (
    SELECT D.customer_name
    FROM Depositor D
);
