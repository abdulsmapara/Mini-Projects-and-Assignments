/*set b*/
select * from asm_shares;
/*1)4*/

with tb as
( 
   select cname,sdate,price from ASM_SHARES  where cname in (select cname from company_group where gname='CEMENT GROUP')
),
tbfinal as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.sdate,asm_shares.cname from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
) select sdate,cname from tbfinal t1 where growth in (select max(growth) from tbfinal t2 where t1.cname=t2.cname);



with tb as
( 
   select cname,sdate,price from ASM_SHARES
),
tbfinal as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.sdate,asm_shares.cname from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
),
cgrowth as(
    select growth,extract(month from sdate) mnt,cname from tbfinal t1 where growth in (select max(growth) mxgrowth from tbfinal t2 where t2.cname=t1.cname)
),
final1 as (
    select mnt,count(cname) cnt from cgrowth group by mnt
)select * from final1;

/*1)6*/


with tb as
( 
   select cname,sdate,price from ASM_SHARES
),
tbfinal as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.sdate,asm_shares.cname from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
),
cgrowth as(
    select growth,extract(month from sdate) mnt,cname from tbfinal t1 where growth in (select max(growth) mxgrowth from tbfinal t2 where t2.cname=t1.cname)
),
final1 as (
    select mnt,count(cname) cnt from cgrowth group by mnt
) select (CASE (to_char(mnt))
        WHEN '1' THEN 'JAN'
        WHEN '2' THEN 'FEB'
        WHEN '3' THEN 'MAR'
        WHEN '4' THEN 'APR'
        WHEN '5' THEN 'MAY'
        WHEN '6' THEN 'JUNE'
        WHEN '7' THEN 'JULY'
        WHEN '8' THEN 'AUG'
        WHEN '9' THEN 'SEPT'
        WHEN '10' THEN 'OCT'
        WHEN '11' THEN 'NOV'
        ELSE 'DEC'
        END) mnt1 from final1 where cnt in (select max(cnt) from final1); 

/*Schema 2*/

create table info(
    offspring varchar2(20),
    sex varchar2(20),
    cow varchar2(20),
    bull varchar2(20),
    birthdate date
);

insert all
into info values('BETSY','F','EVE','ADAM','02/01/00')
into info values('POCO','M','EVE','ADAM','15/07/00')
into info values('GRETA','F','EVE','BANDIT','12/03/01')
into info values('MANDY','F','EVE','POCO','22/08/02')
into info values('CINDY','F','EVE','POCO','09/02/03')
into info values('NOVI','F','BETSY','ADAM','30/03/03')
into info values('GINNY','F','BETSY','BANDIT','04/12/03')
into info values('DUKE','M','MANDY','BANDIT','24/07/04')
into info values('TEDDI','F','BETSY','BANDIT','12/08/05')
into info values('SUZY','F','GINNY','DUKE','03/03/06')
into info values('PAULA','F','MANDY','POCO','21/12/06')
into info values('RUTH','F','GINNY','DUKE','25/12/06')
into info values('DELLA','F','SUZY','BANDIT','11/10/08')
into info values('ADAM','M','','','')
into info values('EVE','F','','','')
into info values('BANDIT','M','','','')
select 1 from dual;

/*2)1*/

select DISTINCT(offspring) offspring,sex,cow,bull,birthdate from info connect by (prior cow = offspring or prior bull = offspring ) start with offspring='DELLA' order by BIRTHDATE DESC NULLS LAST;

/*Schema 3*/

create table bookshelf_author(
    title varchar2(50),
    authorname varchar2(50)
);
create table bookshelf(
    title varchar2(50),
    publisher varchar2(50),
    categoryname varchar2(50),
    rating number(7,0)
);
create table bookshelf_checkout (
    name varchar2(20),
    title varchar2(20),
    checkoutDate date,
    returnedDate date
);
create table my_person(
    name varchar2(20),
    address varchar2(20),
    phone number(11,0)
);

insert all
into bookshelf values ('TO KILL A MOCKINGBIRD','HARPERCOLLINS','ADULTFIC',5)
into bookshelf values('KIERKEGAARD ANTHOLOGY','PRINCETON UNIV PR','ADULTREF',3)
into bookshelf values('GOOD DOG CARL','LITTLE SIMON','CHILDRENPIC',1)
select 1 from dual;
insert all
into bookshelf_author values ('TO KILL A MOCKINGBIRD','RAJ')--,'ADULTFIC',5)
into bookshelf_author values('KIERKEGAARD ANTHOLOGY','RAJ')--,'ADULTREF',3)
into bookshelf_author values('GOOD DOG CARL','RAHUL')--,'CHILDRENPIC',1)
select 1 from dual;
/*4th question*/
/*with tb as (
select count(authorname) cnt,authorname from bookshelf_author,bookshelf where bookshelf.title=bookshelf_author.title group by bookshelf_author.authorname
) select count(cnt) cnt2 from tb t1 where EXISTS(select 1 from tb t2 where cnt > 1 and t1.authorname=t2.authorname);
*/
insert all
into bookshelf_checkout values('Rohan','GOOD DOG CARL','02/01/18','22/01/18')
select 1 from dual;

insert all
into bookshelf_checkout values('Pritam','GOOD DOG CARL','02/01/18','03/01/18')
select 1 from dual;

insert all
into my_person values('Rohan','VNIT','788994455')
select 1 from dual;

/*3)2 4th question*/

select title from bookshelf where title not in (
    select title from bookshelf_checkout
);
--select * from bookshelf full outer join bookshelf_checkout on bookshelf.title=bookshelf_checkout.title;


select bookshelf.title from bookshelf full outer join bookshelf_checkout on bookshelf.title=bookshelf_checkout.title where bookshelf_checkout.title IS NULL;
/*3) 4*/

select name from my_person where name in (
    select name from  bookshelf_checkout where exists (select 1 from dual where (returneddate-checkoutdate) > 14)
);
update bookshelf_checkout set returneddate = returneddate + 2 where name in(
    select name from  bookshelf_checkout where exists (select 1 from dual where (returneddate-checkoutdate) > 14)
);
