
rem 2. Ask the user for the budget and his/her preferred food type. You recommend the best
rem item(s) within the planned budget for the given food type. The best item is
rem determined by the maximum ordered product among many customers for the given
rem food type.
rem Print the recommended product that suits your budget as below:

create or replace procedure recommend(budget IN decimal,ft IN varchar2)
  IS
    rows products%rowtype;
    cursor get_list is
    select * from products
    where pid in (select i.item from item_list i
                    join products p on(i.item = p.pid)
                    where p.food = ft and p.price<=budget
                    group by (i.item));
    cursor get_max is
    select * from products
    where pid = (select i.item from item_list i
    join products p on(i.item = p.pid)
    where p.food = ft and p.price<=budget
    group by (i.item)
    having count(*) = (select max(count(*)) from item_list i
                        join products p on(i.item = p.pid)
                        where p.food = ft and p.price<=budget
                        group by i.item));
  begin
    open get_list;
    open get_max;
    dbms_output.put_line('*******************************************************************************');
    dbms_output.put_line('Budget: '||to_char(budget)||'                     Food type: '||to_char(ft));
    dbms_output.put_line('*******************************************************************************');
    dbms_output.put_line('Item Id     Flavor           Food              Price');
    fetch get_list into rows;
    while get_list%found loop
      dbms_output.put_line(to_char(rows.pid)||'    '||to_char(rows.flavor)||'          '||to_char(rows.food)||'          '||to_char(rows.price));
      fetch get_list into rows;
    end loop;
    fetch get_max into rows;
    dbms_output.put_line('--------------------------------------------------------------------------------');
    dbms_output.put_line(to_char(rows.pid)||' with ' ||to_char(rows.flavor)|| ' flavor is the best item in '||to_char(ft)||' type! ');
    dbms_output.put_line('You are entitled to purchase '|| to_char(floor(budget/rows.price)) ||' '||to_char(ft)||' '|| to_char(rows.flavor) ||' for the given ');
    dbms_output.put_line('budget !!!');
    dbms_output.put_line('*******************************************************************************');
    close get_list;
    close get_max;
  end;
  /


declare
  budget decimal(5,2);
  foodtype varchar2(30);
begin
  budget := &Budget;
  foodtype := '&FoodType';
  recommend(budget,foodtype);

end;
/






