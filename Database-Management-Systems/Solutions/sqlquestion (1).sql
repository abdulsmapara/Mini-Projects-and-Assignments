/*
 * /dbms_qp/sql/sqlquestion (1)
*/
create table asm_person(
    driver_id varchar2(20),
    name varchar2(20),
    address varchar2(20)
);
create table asm_car(
    license varchar2(20),
    model varchar2(20),
    year1 varchar2(20)
);

create table asm_fine(
    reportnum varchar2(20),
    date1 date,
    location varchar2(20)
);

create table asm_owns(
    driver_id varchar2(20),
    license varchar2(20)
);

create table asm_participated(
    driver_id varchar2(20),
    car varchar2(20),
    reportnum varchar2(20),
    amount number(7,2)
);
/*2a) number of people who owned car that were involved in accidents/fines in 1989*/
with tb as(
    select count(driver_id) cnt from asm_participated where reportnum in 
        (select reportnum from asm_fine where extract(year from date1) in 
            (select '1989' from dual)
        ) and driver_id in (
            select driver_id from asm_owns
        )
) select cnt from tb;

/*2b*/
select count(reportnum) from asm_fine where reportnum in 
(
    select reportnum from asm_participated where driver_id in 
    (
        select driver_id from asm_person where name='John Smith' and driver_id in (select driver_id from asm_owns)--should be owner
    ) 
);  
