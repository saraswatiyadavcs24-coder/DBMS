CREATE TABLE dept_s1 (
    deptno DECIMAL(2,0) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR(13)
);

CREATE TABLE emp_s1 (
    empno DECIMAL(4,0) PRIMARY KEY,
    ename VARCHAR(10),
    mgr_no DECIMAL(4,0),
    hiredate DATE,
    sal DECIMAL(7,2),
    deptno DECIMAL(2,0),
    FOREIGN KEY (deptno) REFERENCES dept_s1(deptno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE incentives_s1 (
    empno DECIMAL(4,0),
    incentive_date DATE,
    incentive_amount DECIMAL(10,2),
    PRIMARY KEY (empno, incentive_date),
    FOREIGN KEY (empno) REFERENCES emp_s1(empno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE project_s1 (
    pno INT PRIMARY KEY,
    pname VARCHAR(30) NOT NULL,
    ploc VARCHAR(30)
);

CREATE TABLE assigned_to_s1 (
    empno DECIMAL(4,0),
    pno INT,
    job_role VARCHAR(30),
    PRIMARY KEY (empno, pno),
    FOREIGN KEY (empno) REFERENCES emp_s1(empno)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pno) REFERENCES project_s1(pno)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO dept_s1 VALUES
(10, 'ACCOUNTING', 'MUMBAI'),
(20, 'RESEARCH', 'BENGALURU'),
(30, 'SALES', 'DELHI'),
(40, 'OPERATIONS', 'CHENNAI');

INSERT INTO emp_s1 VALUES
(7369,'Adarsh',7902,'2012-12-17',80000,20),
(7499,'Shruthi',7698,'2013-02-20',16000,30),
(7521,'Anvitha',7698,'2015-02-22',12500,30),
(7566,'Tanvir',7839,'2008-04-02',29750,20),
(7654,'Ramesh',7698,'2014-09-28',12500,30),
(7698,'Kumar',7839,'2015-05-01',28500,20),
(7782,'Clark',7839,'2017-06-09',24500,10),
(7788,'Scott',7566,'2010-12-09',30000,20),
(7839,'King',NULL,'2009-11-17',50000,10),
(7844,'Turner',7698,'2010-09-08',15000,30),
(7876,'Adams',7788,'2013-04-12',11000,20),
(7900,'James',7698,'2017-12-03',9500,30),
(7902,'Ford',7566,'2010-12-03',30000,20);

INSERT INTO incentives_s1 VALUES
(7499,'2019-02-01',5000),
(7521,'2019-03-01',2500),
(7566,'2022-02-01',5070),
(7654,'2020-02-01',2000),
(7654,'2022-04-01',879),
(7521,'2019-02-01',800),
(7698,'2019-03-01',500),
(7698,'2020-03-01',9000),
(7698,'2022-04-01',4500);

INSERT INTO project_s1 VALUES
(101,'AI Project','Bengaluru'),
(102,'IoT','Hyderabad'),
(103,'Blockchain','Bengaluru'),
(104,'Data Science','Mysuru'),
(105,'Autonomous Systems','Pune');

INSERT INTO assigned_to_s1 VALUES
(7499,101,'Software Engineer'),
(7521,101,'Software Architect'),
(7566,101,'Project Manager'),
(7654,102,'Sales'),
(7521,102,'Software Engineer'),
(7499,102,'Software Engineer'),
(7654,103,'Cyber Security'),
(7698,104,'Software Engineer'),
(7900,105,'Software Engineer'),
(7839,104,'General Manager');

SELECT e.empno
FROM emp_s1 e
JOIN assigned_to_s1 a ON e.empno = a.empno
JOIN project_s1 p ON a.pno = p.pno
WHERE p.ploc IN ('Bengaluru','Hyderabad','Mysuru');

SELECT empno, ename
FROM emp_s1
WHERE empno NOT IN (SELECT empno FROM incentives_s1);

SELECT 
    e.empno AS employee_number,
    e.ename AS employee_name,
    d.dname AS department_name,
    a.job_role AS job_role,
    d.loc AS department_location,
    p.ploc AS project_location
FROM emp_s1 e
JOIN dept_s1 d ON e.deptno = d.deptno
JOIN assigned_to_s1 a ON e.empno = a.empno
JOIN project_s1 p ON a.pno = p.pno
WHERE d.loc = p.ploc;

SELECT m.ename, COUNT(*) AS count
FROM emp_s1 e
JOIN emp_s1 m ON e.mgr_no = m.empno
GROUP BY m.ename
HAVING COUNT(*) = (
    SELECT MAX(mycount)
    FROM (SELECT COUNT(*) mycount FROM emp_s1 GROUP BY mgr_no) a
);

SELECT DISTINCT m.mgr_no
FROM emp_s1 e
JOIN emp_s1 m ON e.mgr_no = m.mgr_no
WHERE e.deptno = m.deptno;

SELECT *
FROM emp_s1 e
JOIN incentives_s1 i ON e.empno = i.empno
WHERE i.incentive_amount = (SELECT MIN(incentive_amount) FROM incentives_s1);

SELECT *
FROM emp_s1 e
WHERE EXISTS (
    SELECT 1
    FROM emp_s1 m
    WHERE m.empno = e.mgr_no AND m.deptno = e.deptno
);

SELECT DISTINCT e.ename
FROM emp_s1 e
JOIN incentives_s1 i ON e.empno = i.empno
WHERE (e.sal + i.incentive_amount) >= ANY (
    SELECT sal FROM emp_s1
);
