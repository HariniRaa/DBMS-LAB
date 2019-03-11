REM 4. Write a stored function to display the customer name who ordered maximum for the
rem given food and flavor.

create or replace function get_Customer
  (fd in varchar2,fl in varchar2)
  return varchar2
  is
    ans varchar2(100);
    fname varchar2(30);
    lname varchar2(30);
    c number;
    cursor maxcust is
    select fname,lname from customers
    where cid in (select c.cid from products p
                join item_list i on(p.pid = i.item)
                join receipts r on(r.rno = i.rno)
                join customers c on(r.cid = c.cid)
                where food = fd and flavor = fl
                group by c.cid
                having count(*) = (select max(count(*)) from products p
                                  join item_list i on(p.pid = i.item)
                                  join receipts r on(r.rno = i.rno)
                                  join customers c on(r.cid = c.cid)
                                 where food = fd and flavor = fl
                                  group by c.cid));
  begin
    open maxcust;
    c:=0;
    fetch maxcust into fname,lname;
    while maxcust%FOUND loop
      if c = 0 then
        ans:=fname || ' ' || lname;
      else
        ans:=ans||','||fname || ' ' || lname;
      end if;
      c:=c+1;
      fetch maxcust into fname,lname;
      end loop;
    return ans;
    close maxcust;
  end;
  /

declare
  food varchar2(30);
  flavor varchar2(30);
begin
  food := '&food';
  flavor := '&flavor';
  dbms_output.put_line(to_char(get_Customer(food,flavor)) || ' are(is) The customer(s) who bought the maximum number of '|| to_char(flavor)||' '||to_char(food));
end;
/