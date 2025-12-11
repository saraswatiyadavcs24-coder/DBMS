CREATE TABLE suppliers (
    sid INT PRIMARY KEY,
    sname VARCHAR(20),
    address VARCHAR(20)
);

CREATE TABLE parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(20),
    color VARCHAR(40)
);

CREATE TABLE catalog (
    sid INT,
    pid INT,
    cost FLOAT(6),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES suppliers(sid),
    FOREIGN KEY (pid) REFERENCES parts(pid)
);

INSERT INTO suppliers VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi'),
(10005, 'Mahindra', 'Mumbai');

INSERT INTO parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

SELECT DISTINCT p.pname
FROM parts p
JOIN catalog c ON p.pid = c.pid;

SELECT s.sname
FROM suppliers s
WHERE (SELECT COUNT(*) FROM parts) =
      (SELECT COUNT(*) FROM catalog c WHERE c.sid = s.sid);

SELECT s.sname
FROM suppliers s
WHERE (SELECT COUNT(*) FROM parts WHERE color='Red') =
      (SELECT COUNT(*) 
       FROM catalog c 
       JOIN parts p ON c.pid = p.pid
       WHERE c.sid = s.sid AND p.color='Red');

SELECT p.pname
FROM parts p
JOIN catalog c ON p.pid = c.pid
JOIN suppliers s ON c.sid = s.sid
WHERE s.sname='Acme Widget'
AND NOT EXISTS (
      SELECT 1
      FROM catalog c1
      JOIN suppliers s1 ON c1.sid = s1.sid
      WHERE c1.pid = p.pid
      AND s1.sname <> 'Acme Widget'
);

SELECT DISTINCT c.sid
FROM catalog c
WHERE c.cost > (SELECT AVG(c1.cost) FROM catalog c1 WHERE c1.pid=c.pid);

SELECT p.pid, s.sname
FROM catalog c
JOIN suppliers s ON c.sid = s.sid
JOIN parts p ON c.pid = p.pid
WHERE c.cost = (SELECT MAX(c2.cost) FROM catalog c2 WHERE c2.pid=p.pid);

SELECT s.sid, s.sname, c.pid, p.pname, c.cost
FROM catalog c
JOIN suppliers s ON c.sid = s.sid
JOIN parts p ON c.pid = p.pid
WHERE c.cost = (SELECT MAX(cost) FROM catalog);

SELECT sid, sname
FROM suppliers
WHERE sid NOT IN (
      SELECT c.sid
      FROM catalog c
      JOIN parts p ON c.pid = p.pid
      WHERE p.color='Red'
);

SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM suppliers s
LEFT JOIN catalog c ON s.sid=c.sid
GROUP BY s.sid, s.sname;

SELECT sid
FROM catalog
WHERE cost < 20
GROUP BY sid
HAVING COUNT(*) >= 2;

SELECT c.sid, c.pid, c.cost
FROM catalog c
WHERE c.cost = (
      SELECT MIN(c2.cost)
      FROM catalog c2
      WHERE c2.sid = c.sid
);

CREATE VIEW supplier_part_count AS
SELECT s.sid, s.sname, COUNT(c.pid) AS total
FROM suppliers s
LEFT JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname;

CREATE VIEW most_expensive_supplier_per_part AS
SELECT c.sid, c.pid, c.cost
FROM catalog c
WHERE c.cost = (
      SELECT MAX(c2.cost)
      FROM catalog c2
      WHERE c2.pid = c.pid
);

DELIMITER $$
CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost cannot be less than 1';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER set_default_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10;
    END IF;
END$$
DELIMITER ;
