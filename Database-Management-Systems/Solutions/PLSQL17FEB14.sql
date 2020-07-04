/*2a*/
create table item_sales(
    item varchar2(20),
    sale number(7,2),
    advt number(7,2)
);
insert all
into item_sales values('I1',50,30)
into item_sales values('I1',60,75)
into item_sales values('I1',34,54)
into item_sales values('I2',50,34)
into item_sales values('I2',90,54)
into item_sales values('I2',65,49)
select 1 from dual;
commit;
create table analytics_item_sales(
    item varchar2(20),
    slope number,
    intercept number
);
select * from analytics_item_sales;
declare
    cursor c1 is select distinct(item) from item_sales ;
    slope number;
    intercept number;
begin
    for z in c1 loop
        select regr_slope(sale,advt) into slope from item_sales where item=z.item;
        select regr_intercept(sale,advt) into intercept from item_sales where item=z.item;
        insert into analytics_item_sales values(z.item,slope,intercept);
    end loop;
end;
/
rollback;

/*2b*/
create table mobile_db(
    empno number,
    mobile varchar2(2019)
);
insert all
into mobile_db values(101,'8888763783')
into mobile_db values(102,'9876543210')
into mobile_db values(103,'9876453210')
into mobile_db values(104,'9776453210')
select 1 from dual;
commit;
insert all
into mobile_db values(101,'9876543219')
into mobile_db values(101,'9876453277')
into mobile_db values(104,'9776453998')
select 11 from dual;
rollback;
select * from mobile_db;
declare
    cursor c1 is select empno,mobile,row_number() over(order by empno) rn from mobile_db;
    mobno varchar2(20);
    
begin
    for z in c1 loop
            mobno := z.mobile;
            
                update mobile_db set mobile = concat(mobile,concat(',',mobno)) where empno=z.empno and mobile not like '%'||mobno||'%';
            
            
    end loop;
    delete  mobile_db
    where rowid not in(
        select min(rowid) from mobile_db group by empno
    );
   -- commit;
end;
/
/*1*/
--cos(x)
declare
    x number(7,2);
    n number(7,2);
    sum1 number(7,2):=1;
    t number(7,2):=1;
    val number(7,2);
    pi constant number(7,2):=3.14;
begin
    x:=&x;
    n:=&n;
    x:=x*pi;
    x:=x/180;
    for i in 1..n loop
         t := t*x*x;
        t:=t*-1;
        val:=2*i-1;
        val := 2*i*val;
        t := t / val;
        sum1:=sum1+t;   
    end loop;  
    dbms_output.put_line(sum1);
 
end;
/
