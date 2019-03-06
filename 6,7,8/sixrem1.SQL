

REM 1:

set serveroutput on;
SET ECHO ON
SET TRIMOUT ON
SET LINESIZE 256
SET PAGESIZE 3000
SET WRAP ON
SET COLSEP " | "

REM 1: For the given receipt number, calculate the Discount as given: 
REM For total amount > $10 and total amount < $25: Discount=5%
REM For total amount > $25 and total amount < $50: Discount=10%
REM For total amount > $50: Discount=20%
REM Calculate the amount (after the discount) and update the same in Receipts table.
REM Receipt Number:13355 Customer Name: TOUSSAND SHARRON
REM Receipt Date :19Oct2007


CREATE OR REPLACE PROCEDURE discountCalc(x_rno IN receipts.rno%TYPE, x_date IN receipts.rdate%TYPE) IS
  CURSOR cursorOne IS
    SELECT sum(p.price), p.food, p.flavor, c.fname, c.lname, p.price
    FROM products p, item_list i, receipts r, customers c
    WHERE p.pid = i.item AND i.rno = x_rno AND r.rdate = x_date
    AND r.rno=i.rno AND c.cid = r.cid
    GROUP BY p.flavor, p.food, p.price, c.fname, c.lname;

  type discountClass IS RECORD(
    a_price products.price%type,
    a_food products.food%type,
    a_flavor products.flavor%type,
    a_fname customers.fname%type,
    a_lname customers.lname%type,
    price number(10,2)
  );
  discObj discountClass;
  discount number;
  sno number := 0;
  totalVal number := 0;
  totalDisc number := 0;
BEGIN
  OPEN cursorOne;
    LOOP
      FETCH cursorOne into discObj;
     IF (discObj.a_price BETWEEN 10 AND 25 )THEN
        discount := 0.05;
      ELSIF (discObj.a_price BETWEEN 25 AND 50) THEN
        discount := 0.10;
      ELSIF (discObj.a_price > 50) THEN
        discount := 0.20;
      ELSE
        discount := 0;
      END IF;
      sno := sno + 1;
      totalVal := totalVal + discObj.a_price;
      totalDisc := totalDisc + discount;
      IF sno = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Receipt Number: ' || x_rno || '             Customer Name: ' || discObj.a_fname || ' ' || discObj.a_lname);
        DBMS_OUTPUT.PUT_LINE('Receipt Date: ' || x_date);
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Sno     Flavor        Food            Price');
      END IF;
        EXIT WHEN cursorOne%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sno || '     ' || discObj.a_flavor || '        ' || discObj.a_food || '         ' || (discObj.price - (discObj.a_price * discount)));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Amount:   $' || totalVal);
    DBMS_OUTPUT.PUT_LINE('Total Discount:   (' || totalDisc*100 || ' )            :$' || totalDisc*totalVal);
    DBMS_OUTPUT.PUT_LINE('Amount to be paid:   $' || totalVal - totalDisc);
  CLOSE cursorOne;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('');
END;
/

exec discountCalc(13355, '19-OCT-2007');
