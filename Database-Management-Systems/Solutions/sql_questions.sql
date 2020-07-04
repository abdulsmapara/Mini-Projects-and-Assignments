/*
* dbms_qp/sql/sql_questions
*/
/*Question 1*/
/*1b*/select managername,count(empname) from (select empname,managername from asm_employee connect by prior managername=empname) group by managername;
with tb as 
/*1c*/(select managername,count(empname) cnt from (select empname,managername from asm_employee connect by prior managername=empname) group by managername)
select managername from tb
where cnt in (select max(cnt) from tb);
/*1d name of top 3 employees who have Mohsin as their employee*/
with tb as (select empname,salary,rank() over(order by salary desc) rnk from asm_employee where managername in 
(select managername from asm_employee connect by prior empname=managername start with managername='Mohsin')
)
select empname,salary from tb where rnk <= 3;
/*1e*/
update asm_employee set salary = salary + 100 where empname='Abdul' and managername in (select managername from asm_employee connect by prior empname=managername start with empname='Rohan' union select managername from asm_employee connect by prior empname=managername start with empname='Abdul');
/*Question 2*/
create table asm_sales(
    region varchar2(20),
    car varchar2(20),
    qty number(7,0),
    month1 date
);
insert all
into asm_sales values('Amravati','Indica',455,'01/01/2011')
into asm_sales values('Nagpur','Maruti',777,'01/01/2011')
select 1 from dual;
create table asm_location(
    region varchar2(20),
    pregion varchar2(20)
);

insert all
into asm_location values('Nagpur','Vidharbha')
into asm_location values('Vidharbha','Maharashtra')
into asm_location values('Maharashtra','India')
select 1 from dual;
/*2a*/
with tb as (select car,rank() over(order by qty desc) rnk from asm_sales  where region in (select region from asm_location connect by prior region=pregion start with pregion='Maharashtra') and extract(month from month1) in (select '01' from dual ) and extract(year from month1) in (select '2011' from dual)) select car from tb where rnk <= 3;
/*2b*/
with tb as (
   select car,qty from asm_sales where extract(month from month1) in (select '01' from dual ) and extract(year from month1) in (select '2011' from dual)
) select car,sum(qty) from tb group by car;
/*2c*/
    with tb1 as(
    select sum(qty) jan from asm_sales where extract(month from month1) in (select '01' from dual ) and extract(year from month1) in (select '2011' from dual))
    ,tb2 as (select sum(qty) feb from asm_sales where extract(month from month1) in (select '02' from dual ) and extract(year from month1) in (select '2011' from dual))
     select jan/feb from tb1,tb2;
/*2d???*/
/*2e*/
select coalesce(car,'0'),coalesce(region,'0'),month1,sum(qty) from asm_sales group by cube(car,region,month1);
