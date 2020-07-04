set serveroutput on;
--A5,A6 not completed
create table asm_branch(
    branch_name varchar2(20),
    branch_city varchar2(20),
    assets number(7,2)
);
create table asm_customer(
customer_name varchar2(20),
customer_street varchar2(20),
customer_city varchar2(20)
);
create table asm_loan(
loan_number number(3),
branch_name varchar2(20),
balance number(7,2)
);
create table asm_borrower(
    customer_name varchar2(20),
    loan_number number(3)
);

create table asm_account(
    account_number number(10),
    branch_name varchar2(20),
    balance number(7,2)
);
create table asm_depositor(
    customer_name varchar2(20),
    account_number number(10)

);
/*A1 STARTS*/
select customer_name from asm_customer 
    where customer_city='Harrison'
    and customer_name in (
    with t1 as(
        select customer_name,count(account_number) cn from asm_depositor
        group by customer_name
    )   select customer_name from t1 where t1.cn >= 3);      

insert all
into asm_customer values('ABC','ROAD','Mumbai')
into asm_customer values('DEF','XYZ','Harrison')
select 1 from dual;
commit;

create or replace trigger t2
before update or insert or delete on asm_customer
for each row
declare
cursor c1 is select customer_name from asm_customer 
    where customer_city='Harrison'
    and customer_name in (
    with t1 as(
        select customer_name,count(account_number) cn from asm_depositor
        group by customer_name
    )   select customer_name from t1 where t1.cn >= 3);
    is_present number:=0;
begin
    for z in c1 loop
        if z.customer_name = :new.customer_name then
            is_present:=1;
        end if;
    end loop;
    if is_present != 1 then
        raise_application_error(-20001,'Cannot perform DML operation');
    end if;
end;
/
alter table asm_customer
disable all triggers ;
/*A1 ENDS*/
/*------------A2 STARTS-------------*/
create or replace trigger t1
before insert or delete or update on asm_borrower
for each row
declare
    cursor c1 is select distinct(customer_name) cn from asm_depositor asm1 where not exists(
select branch_name from asm_branch where asm_branch.branch_city='Brooklyn'
            minus
            select branch_name from asm_account where account_number in (
                select account_number from asm_depositor where asm_depositor.customer_name=asm1.customer_name
            )
);

    names varchar2(20);
begin
    
    for z in c1 loop
        if :old.customer_name = z.cn or :new.customer_name=z.cn then
            raise_application_error(-20010,'Cannot perform any DML operation');
        end if;
    end loop;
    
end;
/

insert into asm_borrower values('ABC',24);
select * from asm_borrower;
commit;
/*-------A2 ENDS-----------*/

insert all
into asm_branch values ('A','Brooklyn',7000)
into asm_branch values ('B','Brooklyn',7000)
into asm_branch values ('C','Brooklyn',7000)
into asm_branch values ('D','Brooklyn',7000)

into asm_branch values ('E','Mumbai',73000)
select 1 from dual;

insert all
into asm_depositor values('ABC',101)
into asm_depositor values('DEF',102)
into asm_depositor values('DEF',103)
into asm_depositor values('DEF',104)
into asm_depositor values('DEF',105)
select 1 from dual;

insert all
into asm_account values(101,'A',500)
into asm_account values(102,'A',1000)
into asm_account values(103,'C',1900)
into asm_account values(104,'D',234)
into asm_account values(105,'B',890)
select 1 from dual;
commit;
select * from asm_account;
select * from asm_branch;
select * from asm_depositor;

select distinct(customer_name) from asm_depositor asm1 where not exists(
select branch_name from asm_branch where asm_branch.branch_city='Brooklyn'
            minus
            select branch_name from asm_account where account_number in (
                select account_number from asm_depositor where asm_depositor.customer_name=asm1.customer_name
            )
);

/*-----A3 STARTS--------*/
with t1 as(
select distinct(customer_name)  c11,count(account_number) cn from asm_depositor asm1 where account_number in(
    
select (account_number) from asm_account where branch_name in(
select branch_name from asm_branch where branch_city='Perryridge'
) and 
account_number in( select account_number from asm_depositor where customer_name=asm_depositor.customer_name)
    
) group by customer_name
)
select c11 from t1 where cn >= 2;

create or replace trigger t1
before insert or update or delete on asm_borrower
for each row

declare
cursor c1 is 
with t1 as(
select distinct(customer_name)  c11,count(account_number) cn from asm_depositor asm1 where account_number in(
    
select (account_number) from asm_account where branch_name in(
select branch_name from asm_branch where branch_city='Perryridge'
) and 
account_number in( select account_number from asm_depositor where customer_name=asm_depositor.customer_name)
    
) group by customer_name
)
select c11 from t1 where cn >= 2;
begin
    
    for z in c1 loop
        if :old.customer_name = z.c11 or :new.customer_name = z.c11 then
            raise_application_error(-20001,'Cannot perform any DML operation');
        end if;
    end loop;
end;
/

insert into asm_depositor values('DEF',112);
select * from asm_depositor;
insert into asm_account values(112,'M',5100);
commit;
insert into asm_borrower values('QWERTY',512);
select * from asm_branch;
insert into asm_branch values('M','Perryridge',1854);

/*------A3 ENDS--------*/
/*A4 STARTS*/

with t1 as(
select distinct(customer_name)  c11,count(account_number) cn from asm_depositor asm1 where account_number in(
    
select (account_number) from asm_account where branch_name in(
select branch_name from asm_branch where branch_city='Perryridge'
) and 
account_number in( select account_number from asm_depositor where customer_name=asm_depositor.customer_name)
    
) group by customer_name
)
select c11 from t1 where cn <= 1;

create or replace trigger t1
before insert or update or delete on asm_borrower
for each row

declare
cursor c1 is 
with t1 as(
select distinct(customer_name)  c11,count(account_number) cn from asm_depositor asm1 where account_number in(
    
select (account_number) from asm_account where branch_name in(
select branch_name from asm_branch where branch_city='Perryridge'
) and 
account_number in( select account_number from asm_depositor where customer_name=asm_depositor.customer_name)
    
) group by customer_name
)
select c11 from t1 where cn <= 1;
begin
    
    for z in c1 loop
        if :old.customer_name = z.c11 or :new.customer_name = z.c11 then
            raise_application_error(-20001,'Cannot perform any DML operation');
        end if;
    end loop;
end;
/

/*A4 ENDS*/
/*A7 STARTS*/
select avg(balance) from asm_account ;
create or replace trigger tx
after insert or update on asm_account

declare
    avg number:=0;
    cursor c1 is select account_number,balance from asm_account;
    cnt number:=0;
begin
    select avg(balance) into avg from asm_account;
    select count(*) into cnt from asm_account where balance < avg;
    if cnt >= 1 then
        delete asm_depositor where account_number in (select account_number from asm_account where balance<avg);
        delete asm_account where balance < avg;
    end if;
end;
/
rollback;
select * from asm_account;
update asm_account set balance=1000 where balance = 1000;
/*A7 ENDS*/

/*SET III*/
--all functions not implemented (can be implemented similarly
create or replace package vectors is
pragma serially_reusable;
type vector is record(
    val1 number(7,2),
    val2 number(7,2)
);
function add(v1 in vector,v2 in vector) return vector;
function dot(v1 in vector,v2 in vector) return number;
function magnitude(v1 in vector) return number;
function angle(v1 in vector,v2 in vector) return number;
end vectors;
/
create or replace package body vectors is
pragma serially_reusable;
function add(v1 in vector,v2 in vector) return vector is
    v3 vector;
    begin
        v3.val1:=0;
        v3.val2:=0;
        v3.val1:=v1.val1+v2.val1;
        v3.val2:=v1.val2+v2.val2;
        return v3;
    end;
function dot(v1 in vector,v2 in vector) return number is
    v3 number;
    begin
        v3:=v1.val1*v2.val1;
        v3:=v3+v2.val2*v1.val2;
        return v3;
    end;
function magnitude(v1 in vector) return number is
    v3 number;
    begin
        return sqrt(v1.val1*v1.val1+v1.val2*v1.val2);
    end;
function angle(v1 in vector,v2 in vector) return number is
    v3 number;
    begin
        return acos(dot(v1,v2)/(magnitude(v1)*magnitude(v2)));
    end;
begin
    dbms_output.put_line('Static initializer block');
end vectors;
/
declare
v1 vectors.vector;
v2 vectors.vector;
v3 vectors.vector;
begin
    v1.val1:=1;
    v1.val2:=0;
    v2.val1:=0;
    v2.val2:=1;
    v3:=vectors.add(v1,v2);
    
    dbms_output.put_line(vectors.angle(v1,v3));
end;
/
/*SET II*/
--not complete Can be continued in similar fashion
create table check_t(
a number(7),
b number(7),
c number(7),
d number(7),
e number(7)
);
/
create or replace procedure check_insert(pa in number,pb in number, pc in number,pd in number,pe in number) is
    cursor c1 is select t1.a from check_t t1 , check_t t2 where t1.a=t2.a and t1.d=t2.d and t1.b=t2.b and t1.c != t2.c;
    cursor c21 is select t1.a from check_t t1, check_t t2 where t1.a=t2.a and t1.b != t2.b;
    cursor c22 is select t1.a from check_t t1, check_t t2 where t1.a=t2.a and t1.d != t2.d;
    cursor c23 is select t1.a from check_t t1, check_t t2 where t1.a=t2.a and t1.c != t2.c;
    cursor c31 is select t1.a from check_t t1, check_t t2 where t1.b=t2.b and t1.c != t2.c;    
    cursor c32 is select t1.a from check_t t1, check_t t2 where t1.b=t2.b and t1.e != t2.e;
    cursor c33 is select t1.a from check_t t1, check_t t2 where t1.b=t2.b and t1.d != t2.d;
    cursor c41 is select t1.a from check_t t1,check_t t2 where t1.a=t2.a and t1.d=t1.d and t1.b != t2.b;
    cursor c42 is select t1.a from check_t t1,check_t t2 where t1.a=t2.a and t1.d=t1.d and t1.c != t2.c;
    
    
    counter number:=0;
    done number:=0;
begin
    --constraint 1
    for z in c1 loop
        counter := counter+1;
    end loop;
    if counter != 0 then
        dbms_output.put_line('ERROR IN CONSTRAINT 1');
        done:=1;
    end if;
    
    --constraint 2
    if done != 1 then
        for z1 in c21 loop
            counter:=counter+1;
        end loop;
        
        for z2 in c22 loop
            counter:=counter+1;
        end loop;
        
        for z3 in c23 loop
            counter:=counter+1;
        end loop;
        if counter != 0 then
            dbms_output.put_line('ERROR IN CONSTRAINT 2');
            done:=1;
        end if;
    end if;
    
    --constraint 3
    if done != 1 then
        for z1 in c31 loop
            counter:=counter+1;
        end loop;
        
        for z2 in c32 loop
            counter:=counter+1;
        end loop;
        
        for z3 in c33 loop
            counter:=counter+1;
        end loop;
        if counter != 0 then
            dbms_output.put_line('ERROR IN CONSTRAINT 3');
            done:=1;
        end if;
    end if;
    
end;
/
commit;