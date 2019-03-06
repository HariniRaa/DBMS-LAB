rem 1. The combination of Flavor and Food determines the product id. Hence, while
rem inserting a new instance into the Products relation, ensure that the same combination
rem of Flavor and Food is not already available.

create or replace trigger tr_unique_food
before insert 
on products
for each row
declare
  pidp varchar2(30);
  cursor c1 is
  	select pid 
	from products
  	where food = :new.food and flavor = :new.flavor;
begin
  open c1;
  fetch c1 into pidp;
  if c1%found then
      RAISE_APPLICATION_ERROR( -20001, 'The Combination of Food and Flavor already exists' );
  end if;
  close c1;
end;
/
insert into products values('1-21-1','Chocolate','Cake',20.01);
insert into products values('1-21-2','Lemon','Eclair',10.21);

rem 3. Implement the following constraints for Item_list relation:

rem a. A receipt can contain a maximum of five items only.

create or replace trigger tr_max_items
before insert or update 
on item_list
for each row
declare
  counter number;
  cursor c1 is
  	select count(*)
  	from item_list
  	where rno = :new.rno
  	group by rno;
begin
  open c1;
  fetch c1 into counter;
  if counter>=5 then
    RAISE_APPLICATION_ERROR( -20001, 'Can Order only 5 Items maximum' );
  end if;
  close c1;
end;
/

savepoint s;
insert into receipts values(9999,'24-dec-1999',5);
insert into item_list values(9999,1,'26-8x10');
insert into item_list values(9999,2,'26-8x10');
insert into item_list values(9999,3,'90-APP-11');
insert into item_list values(9999,4,'70-LEM');
insert into item_list values(9999,5,'70-LEM');
insert into item_list values(9999,6,'70-LEM');
rollback to s;

rem b. A receipt should not allow an item to be purchased more than thrice.

create or replace trigger max_item
before insert or update on item_list
for each row
declare
  counter number;
  cursor c1 is
  	select count(*) from item_list
  	where rno = :new.rno and item = :new.item
  	group by (rno,item);
begin
  open c1;
  fetch c1 into counter;
  if counter>=3 then
    RAISE_APPLICATION_ERROR( -20001, 'You have already bought this item 3 times ' );
  end if;
  close c1;
end;
/

savepoint s1;
insert into receipts values(9999,'24-dec-1999',5);
insert into item_list values(9999,1,'26-8x10');
insert into item_list values(9999,2,'26-8x10');
insert into item_list values(9999,3,'26-8x10');
insert into item_list values(9999,4,'26-8x10');
rollback to s1;
