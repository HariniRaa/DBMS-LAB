REM 1. For the given receipt number, if there are no rows then display as “No order with the given receipt <number>”. If the receipt contains more than one item, REM display as “The given receipt <number> contains more than one item”. If the receipt contains single item, display as “The given receipt <number> contains exactly 
REM one item”. Use predefined exception handling**

declare
	receiptnumber item_list.rno%type;
	counts_item number(4);
	it_item item_list.item%type;
	my_exception1 EXCEPTION;
	
	Begin
		receiptnumber :=&Receipt_Number;

		Select count(item) into counts_item from item_list where rno = receiptnumber group by rno;
		Select item into it_item from item_list where rno = receiptnumber;	

		dbms_output.put_line('**************************************');
		dbms_output.put_line('Receipt Number : '||  receiptnumber); 
		dbms_output.put_line('**************************************');
		if counts_item = 1 then 
			RAISE my_exception1;		
		end if;
	
	Exception 
		WHEN no_data_found THEN 
			dbms_output.put_line('Item Count : '||  counts_item);
      			dbms_output.put_line('No Order with the given receipt number '||receiptnumber);
		WHEN too_many_rows THEN
			dbms_output.put_line('Item Count : '||  counts_item);
			dbms_output.put_line('The given receipt number ' || receiptnumber || ' contains more than one item ');
		WHEN my_exception1 THEN
			dbms_output.put_line('Item Count : '||  counts_item);
			dbms_output.put_line('The given receipt number ' || receiptnumber || ' contains exactly one item ');		
		
	End;
/

