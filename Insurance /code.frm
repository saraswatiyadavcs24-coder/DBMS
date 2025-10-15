create table Person (driver_id varchar(10), name varchar(20), address varchar(30), primary key(driver_id));

create table car(reg_num varchar(10),model varchar(10),year int, primary key(reg_num));
create table accident(report_num int, accident_date date, location varchar(20),primary key(report_num));
create table owns(driver_id varchar(10),reg_num varchar(10), primary key(driver_id, reg_num),foreign key(driver_id) references person(driver_id), foreign key(reg_num) references car(reg_num));
create table participated(driver_id varchar(10), reg_num varchar(10), report_num int, damage_amount int,primary key(driver_id, reg_num, report_num),foreign key(driver_id) references person(driver_id),foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num));
insert into person values('A01', 'Thor', 'california');
insert into person values('A02', 'Robert', 'Las Vegas');
insert into person values('A03', 'loki', 'Pennslyvania');
insert into person values('A04', 'Steve', 'Amytiville');
insert into person values('A05', 'Bruce', 'NYC');
insert into car values('JK1997', 'Toyota', '1981');
insert into car values('KT1996', 'Honda', '1982');
insert into car values('MY1992', 'FORD', '1983');
insert into car values('JH1995', 'Tesla', '1984');
insert into car values('JM1993', 'BMW', '1989');
insert into accident values (11, '2003-01-01','Miami');
insert into accident values (12,'2004-02-02','Arizona');
insert into accident values (13,'2003-01-21','Ohio');
insert into accident values (14,'2008-02-17','Chicago');
insert into accident values (15,'2004-03-05','Washington');
insert into owns values('A01','JK1997');
insert into owns values('A02','KT1996');
insert into owns values('A03','MY1992');
insert into owns values('A04','JH1995');
insert into owns values('A05','JM1993');
insert into participated values('A01','JK1997',11, 10000);
insert into participated values('A02','KT1996',12, 50000);
insert into participated values('A03','MY1992',13, 25000);
insert into participated values('A04','JH1995',14, 3000);   
insert into participated values('A05','JM1993',15, 5000);

insert into accident values(16,'2008-03-08','Domlur');


update participated set damage_amount=12000
where reg_num='JK1997' and report_num=11;


SELECT COUNT(DISTINCT driver_id) AS CNT
FROM participated a, accident b
WHERE a.report_num = b.report_num
  AND YEAR(b.accident_date) = 2008;

SELECT * FROM PARTICIPATED ORDER BY DAMAGE_AMOUNT DESC;
SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED;

SELECT NAME FROM PERSON A, PARTICIPATED B WHERE A.DRIVER_ID = B.DRIVER_ID AND
DAMAGE_AMOUNT > (SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED);

SELECT MAX(DAMAGE_AMOUNT) FROM PARTICIPATED;

SELECT * FROM accident;
SELECT * FROM person;
SELECT * FROM car;
SELECT * FROM owns;
SELECT * FROM participated;
