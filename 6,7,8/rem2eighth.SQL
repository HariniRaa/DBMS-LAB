REM 2.While inserting the receipt details, raise an exception when the receipt date is greater than the current date**

Alter table Receipts add amt decimal(5,3);

declare
	receiptnumber Receipts.rno%type;
	receiptdate varchar(20);
	cust_id Receipts.cid%type;
	amount Receipts.amt%type;
	my_exception2 EXCEPTION;
	cur_date varchar2(20);
	
	Begin
		receiptnumber := &Receipt_Number;
		receiptdate := '&receipt_date';
		cust_id := &Customer_id;
		amount := &Amount;

		select current_date into cur_date from dual;

		if receiptdate > cur_date then 
			RAISE my_exception2;
		end if;
	
		Insert into Receipts Values(receiptnumber,receiptdate,cust_id,amount);
		dbms_output.put_line('Receipt Inserted');
		
	Exception
		WHEN my_exception2 THEN
			dbms_output.put_line('*******************************************************************');
			dbms_output.put_line('Exception Caught! Receipt Date is greater than the current date');
			dbms_output.put_line('*******************************************************************');
		
	End;
/ 

Alter table Receipts drop column amt;
	