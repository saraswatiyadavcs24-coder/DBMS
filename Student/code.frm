CREATE TABLE Student (
    Stid INT(5),
    Stname VARCHAR(20),
    dob DATE,
    doj DATE,
    fee INT(5),
    gender VARCHAR(20)
);

DESC Student;

INSERT INTO Student (Stid, Stname, dob, doj, fee, gender)
VALUES (1, 'Thon', '2001-01-10', '2000-10-05', 10000, 'M');

INSERT INTO Student (Stid, Stname, dob, doj, fee, gender)
VALUES (2, 'Lok', '2019-11-03', '2001-10-20', 11000, 'M');

ALTER TABLE Student ADD phone_no INT(10);

ALTER TABLE Student RENAME TO Student_info;

SELECT * FROM Student_info;

ALTER TABLE Student_info DROP COLUMN gender;

DELETE FROM Student_info WHERE Stid = 1;
