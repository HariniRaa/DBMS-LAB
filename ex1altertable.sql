REM: 7 add reorder level into Parts

ALTER TABLE Parts
  add(reorderlevel number(1));
  
  DESC Parts;
  
  REM:7 add reorder level into Employee

  ALTER TABLE Employee
  add(hiredate date);
  DESC Employee;
  
  REM: 8 Names length is not sufficient
 Insert into Employee VALUES
 ('e009','ragavendranrao','11-Nov-1999',600094);
  ALTER TABLE Employee
  MODIFY(name varchar2(15));
  
  REM: 9 DOB of Customer can be entered later

  ALTER TABLE Customer
  drop column dob;
  DESC Customer;

  REM :10 received date cannot be null
  ALTER TABLE Orders
  MODIFY(rdate date constraint rdate_nn not null);
  INSERT INTO Orders VALUES
  ('o1234','e009','c0004',NULL,'10-Apr-2016');
  
  REM: 11 if the details are deleted from Parts or Orders,the change must be made in Multiple Orders too

  ALTER TABLE MultipleOrders
  drop constraint om_fk;

  ALTER TABLE MultipleOrders
  add(constraint om_fk foreign key(ono) references Orders(ono) on delete cascade);

  ALTER TABLE MultipleOrders
  drop constraint pm_fk;

  ALTER TABLE MultipleOrders
  add(constraint pm_fk foreign key(pno) references Parts(pno) on delete cascade);
  SELECT * FROM MultipleOrders;
  SELECT * FROM Orders;
  DELETE FROM Orders 
  WHERE ono='o1233' 
 ;
 
  SELECT * FROM MultipleOrders;
  