REM **1.For the given receipt number, calculate the Discount as follows And print the receipt**


Create or Replace procedure receipt_print1(receiptnumber in number)
AS
	f_name varchar2(20);
	l_name varchar2(20);
	flavorp products.flavor%type;
	foodp products.food%type;
	pricep products.price%type;
	counter number(3) :=1;
	t_price decimal(5,3);
	discount decimal(5,3);
	amount_pay decimal(5,2);

	CURSOR c1 IS
		select flavor,food,price 
		from products p JOIN item_list it ON(p.pid = it.item) JOIN Receipts r ON(r.rno=it.rno) 
		Where it.rno  = receiptnumber;
	
	begin		
		Select distinct fname,lname into f_name,l_name 
		from customers c JOIN Receipts r ON(c.cid = r.cid) JOIN item_list it ON (r.rno=it.rno) 
		where it.rno  = receiptnumber;

		select sum(price) into t_price 
		from  Receipts r JOIN item_list it ON(r.rno=it.rno) JOIN products p ON(p.pid = it.item) 
		Where it.rno = receiptnumber;
 
		dbms_output.put_line ('*******************************************************************'); 
		dbms_output.put_line ('Receipt Number : '|| receiptnumber || rpad('  ',6,'  ') || 'Customer Name : '|| f_name || rpad(' ',2,' ')|| l_name);
		dbms_output.put_line ('*******************************************************************');
		
		dbms_output.put_line ('Sno.'|| rpad(' ',8,' ') ||'FLAVOR'|| rpad(' ',8,' ') ||'FOOD'|| rpad(' ',8,' ') ||'PRICE'); 
		dbms_output.put_line ('------------------------------------------------------------------'); 
		
		open c1;
		loop
			FETCH c1 into flavorp, foodp, pricep;
			exit when c1%notfound;
			dbms_output.put_line (counter || rpad('  ',11,'  ') ||flavorp|| rpad(' ',10,'  ') ||foodp|| rpad('  ',8,'  ') ||pricep); 
			counter := counter + 1;
		end loop;
   		dbms_output.put_line ('------------------------------------------------------------------');

		

		dbms_output.put_line('				Total Price = $'|| t_price);
		dbms_output.put_line ('------------------------------------------------------------------'); 
		dbms_output.put_line('Total Price = $'|| t_price); 

		if t_price >10 AND t_price <25 then 
			discount := 0.05*t_price;
		elsif t_price >25 AND t_price <50 then
			discount := 0.10*t_price;
		elsif t_price > 50 then
			discount :=0.20*t_price;
		else
			discount :=0.00;
		end if;
		dbms_output.put_line('Discount  =   $'|| discount);
		dbms_output.put_line ('------------------------------------------------------------------'); 
		amount_pay := t_price-discount;
		dbms_output.put_line('Amount to be Paid  =   $'||amount_pay);
		dbms_output.put_line ('******************************************************************');

		dbms_output.put_line('Great Offers! Discount up to 25% on DIWALI Festival Day...');
		dbms_output.put_line ('******************************************************************');

		close c1;

	end;
/

declare
  	receiptnumber number(6);
	begin
  		receiptnumber := &Receipt_number;
  		receipt_print1(receiptnumber);
	end;
/