drop table MultipleOrders;
drop table Orders;
drop table Parts;
drop table Customer;
drop table Employee;
drop table Code;

create table Code
 (pin number(6),
 city varchar2(10),
 constraint pin_pk primary key(pin));

 desc Code;

 create table Employee
 (empno varchar2(5),
 name varchar2(10),
  dob date,
  pincode number(6),
  constraint pincode_fk foreign key(pincode) references Code(pin),
 constraint e_pk primary key(empno),
 constraint e_checker check(empno like 'e%'));

 desc Employee;

 create table Customer
 (cno varchar2(5),
 name varchar2(10),
  street varchar2(15),
  pinc number(6),
  dob date,
  phno number(10),
  constraint ph_unique unique(phno),
 constraint pinc_fk foreign key(pinc) references Code(pin),
 constraint c_pk primary key(cno),
 constraint c_checker check(cno like 'c%'));

 desc Customer;

 create table Parts
 (pno varchar2(5),
 name varchar2(10),
  price number(6) constraint price_nn not null,
  qty number(4),
 constraint p_pk primary key(pno),
 constraint p_checker check(pno like 'p%'));

 desc Parts;

 create table Orders
 (ono varchar2(5),
 eno varchar2(5),
  cno varchar2(5),
  rdate date,
  sdate date,
  constraint date_checker check(rdate<sdate),
 constraint c_fk foreign key(cno) references Customer(cno),
 constraint e_fk foreign key(eno) references Employee(empno),
 constraint o_pk primary key(ono),
 constraint o_checker check(ono like 'o%'));

 desc Orders;

 create table MultipleOrders
 (ono varchar2(5),
  pno varchar2(5),
  qty number(4),
  constraint qty_checker check(qty>0),
  constraint om_fk foreign key(ono) references Orders(ono),
 constraint pm_fk foreign key(pno) references Parts(pno),
 constraint com_k primary key(ono,pno));

  desc MultipleOrders;
  
  insert into Code values
  (603103,'senganmal');
  
  insert into Code values
  (600092,'virgbkm');
  
  SELECT *
  FROM Code;
  
  INSERT INTO Employee VALUES
  ('e0001','madhu','16-Sep-1999',600092);
  
  INSERT INTO Employee VALUES
  ('e0002','deka','14-Oct-1999',603103);
  
  SELECT *
  FROM Employee;
  
  INSERT INTO Customer VALUES
  ('c0001','Swathi','chithirai',600092,'21-Jul-1999','9876543579');
  
  INSERT INTO Customer VALUES
  ('c0002','Amri','elango',603103,'22-Jun-1999','9874563579');
  
  SELECT *
  FROM Customer;
  
  INSERT INTO Parts VALUES
  ('p0001','clutch','2000',20);
  
  INSERT INTO Parts VALUES
  ('p0002','gasket','4000',30);
  
  SELECT *
  FROM Parts;
  
  INSERT INTO Orders VALUES
  ('o1233','e0001','c0001','10-Apr-2018','10-May-2018');
  
  SELECT *
  FROM Orders;
  
  INSERT INTO MultipleOrders VALUES
  ('o1233','p0001',3);
  
  SELECT *
  FROM MultipleOrders;
  
  

  
