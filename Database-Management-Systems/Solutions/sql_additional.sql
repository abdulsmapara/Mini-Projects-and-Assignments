create table asm_shares(
    cname varchar2(20),
    sdate date,
    price number(7,2)
);
create table company_group (
    cname varchar2(20),
    gname varchar2(20) -- group name
);
/*<1>
(1) not sure*/

with tb as
( 
   select cname,sdate,price from ASM_SHARES 
)
select (asm_shares.price-tb.price)/(tb.price)  growth from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual);
/*<1>(2)*/
with tb as
( 
   select cname,sdate,price from ASM_SHARES  where cname='ACC'
),
tbfinal as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.sdate from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
)
select sdate from tbfinal where growth in(
    select max(growth) from tbfinal
);
/*<1>(3)*/
with tb as
( 
   select cname,sdate,price from ASM_SHARES 
),
finaltb as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.cname,asm_shares.sdate from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
)
select cname from finaltb where growth>0.1 and extract(month from sdate) in (select '1' from dual) and extract(year from sdate) in(
select '2019' from dual);
/*<1>(4)*/
with tb as (
select sdate,avg(price) over(order by sdate rows '1' preceding) avgp from asm_shares  where cname='ACC'
) select avgp from tb where sdate = '02/01/19';
/*<1>(5)*/
with tb as
( 
   select cname,sdate,price from ASM_SHARES  where cname in (select cname from company_group where gname='CEMENT GROUP')
),
tbfinal as(
select (asm_shares.price-tb.price)/(tb.price)  growth,asm_shares.sdate,asm_shares.cname from asm_shares,tb where tb.cname=asm_shares.cname and asm_shares.sdate in (select add_months(tb.sdate,1) from dual)
) select sdate,cname from tbfinal where growth in (select max(growth) from tbfinal);
/*<1>(7)*/
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
