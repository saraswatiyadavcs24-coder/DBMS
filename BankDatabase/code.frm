CREATE TABLE Branch (branch_name VARCHAR(50) PRIMARY KEY, branch_city VARCHAR(50),assets REAL);
CREATE TABLE BankAccount (accno INT PRIMARY KEY, branch_name VARCHAR(50), balance REAL, FOREIGN KEY (branch_name) REFERENCES Branch(branch_name));

CREATE TABLE BankCustomer (customer_name VARCHAR(50) PRIMARY KEY,customer_street VARCHAR(50),customer_city VARCHAR(50));

CREATE TABLE Depositer (customer_name VARCHAR(50),accno INT,PRIMARY KEY (customer_name, accno),FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),FOREIGN KEY (accno) REFERENCES BankAccount(accno));

CREATE TABLE Loan (loan_number INT PRIMARY KEY,branch_name VARCHAR(50),amount REAL,FOREIGN KEY (branch_name) REFERENCES Branch(branch_name));
INSERT INTO Branch VALUES
('SBI_ResidencyRoad', 'Bangalore', 8000000),
('SBI_MG_Road', 'Bangalore', 6000000),
('SBI_Whitefield', 'Bangalore', 7000000),
('SBI_Indiranagar', 'Bangalore', 5000000),
('SBI_Jayanagar', 'Bangalore', 4000000);

INSERT INTO BankAccount VALUES
(1001, 'SBI_ResidencyRoad', 50000),
(1002, 'SBI_ResidencyRoad', 75000),
(1003, 'SBI_MG_Road', 60000),
(1004, 'SBI_Whitefield', 80000),
(1005, 'SBI_Indiranagar', 55000),
(1006, 'SBI_ResidencyRoad', 90000);

INSERT INTO BankCustomer VALUES
('Ravi Kumar', 'Church Street', 'Bangalore'),
('Priya Singh', 'MG Road', 'Bangalore'),
('Arjun Mehta', 'Residency Road', 'Bangalore'),
('Neha Gupta', 'Whitefield', 'Bangalore'),
('Rahul Das', 'Indiranagar', 'Bangalore');

INSERT INTO Depositer VALUES
('Ravi Kumar', 1001),
('Ravi Kumar', 1002),
('Priya Singh', 1003),
('Arjun Mehta', 1004),
('Neha Gupta', 1005),
('Ravi Kumar', 1006);

INSERT INTO Loan VALUES
(201, 'SBI_ResidencyRoad', 300000),
(202, 'SBI_MG_Road', 250000),
(203, 'SBI_Whitefield', 400000),
(204, 'SBI_Indiranagar', 350000),
(205, 'SBI_Jayanagar', 200000);

SELECT branch_name,(assets/100000)AS "assets in lakhs" from Branch;

SELECT
D.customer_name,
B.branch_name,
COUNT(D.accno) AS total_accounts
FROM Depositer D
JOIN BankAccount B ON D.accno = B.accno
GROUP BY D.customer_name, B.branch_name
HAVING COUNT(D.accno) >= 2;


CREATE VIEW BranchLoanSummary AS
SELECT branch_name,
SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;
SELECT * FROM BranchLoanSummary;
SELECT * from Branch;
SELECT * from BankAccount;
SELECT * from BankCustomer;
SELECT * from Depositer;
SELECT * from Loan;
