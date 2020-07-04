set serveroutput on;
/*I) 2.*/
create or replace trigger sal
before insert or delete or update of salary on asm_emp
for each row
declare
    sal number:=0;
    budget number:=0;
begin
    select budget into budget from asm_dept where did in(
        select did from asm_works where eid=:new.eid or eid=:old.eid
    );
    if budget < :new.salary then
        raise_application_error(-20001,'Employee salary cannot be greater than department budget');
    end if;
end;
/
/*
    for I). 3) refer PLSQL_24THFEB.sql in the solutions 1b
    I) 3)
*/
create or replace procedure print_sal_123 is
    cursor c1 is select did,dname,budget from asm_dept;
    sal number:=0;
    diff number(7):=0;
begin
    for z in c1 loop
        select sum(salary) into sal from asm_emp where eid in(select eid from asm_works where did=z.did);
        diff:=z.budget-sal;
        dbms_output.put_line(z.dname||' '||z.budget||' '||diff);
    end loop;
end;
/
begin
print_sal_123;
end;
/
/*I)4 refer PLSQL_24THFEB.sql in the solutions 1c*/
/*I) 5)*/
select * from asm_dept;
select * from asm_dept natural join asm_works natural join asm_emp;
update asm_dept set managerid=102 where dname='MEC';
update asm_emp set salary=8000 where eid=102;
commit;
with t1 as(
select * from asm_dept natural join asm_works natural join asm_emp where dname='CSE'
) select eid,salary,dname,managerid from t1 connect by nocycle prior managerid=eid start with eid=110;
select * from asm_dept natural join asm_works natural join asm_emp;

create or replace trigger manager_more
after insert or delete or update of salary on asm_emp
declare
    sal1 number(7,2);
    sal2 number(7,2);
    cursor c1 is 
        select distinct(dname) from asm_dept;
    cursor c2(dept_name varchar2,eidg varchar2) is
        with t1 as(
select * from asm_dept natural join asm_works natural join asm_emp where dname=dept_name
) select eid,salary,dname,managerid from t1 connect by nocycle prior managerid=eid start with eid=eidg;
    cursor c3(dept_name varchar2) is
        select eid from asm_emp where eid in (select eid from asm_works where did in(select did from asm_dept where dname=dept_name));
begin
    for dnames in c1 loop
        for z in c3(dnames.dname) loop
            for x in c2(dnames.dname,z.eid) loop
                select salary into sal1 from asm_emp where eid=x.eid;
                select salary into sal2 from asm_emp where eid=x.managerid;
                dbms_output.put_line(x.eid||' = '||sal1||' '||x.managerid||' = '||sal2);
                if sal1 > sal2 then
                    raise_application_error(-20001,'MANAGER SALARY SHOULD ALWAYS BE GREATER THAN EMPLOYEE');
                end if;
            end loop;
        end loop;
    end loop;
end;
/

create view v1 as select * from asm_emp;
/*
create or replace trigger manager_more
after insert or delete or update on asm_emp
for each row
declare
cursor c1(dept_name varchar2,eidg varchar2) is
        with t1 as(
select * from asm_dept natural join asm_works natural join asm_emp where dname=dept_name
) select eid,salary,dname,managerid from t1 connect by nocycle prior managerid=eid start with eid=eidg;
dname varchar2(20);
sal1 number;
sal2 number;
begin
    select dname into dname from asm_dept where did in (
        select did from asm_works where eid = :new.eid
    );    
    sal1:=:new.salary;
    for z in c1(dname,:new.eid) loop
        if z.eid != :new.eid then
            sal2 := z.salary;
            if sal1 > sal2 then
                raise_application_error(-20001,'ERROR- MANAGER SALARY CANNOT BE LESS THAN EMPLOYEE SALARY');
            end if;
        end if;
    end loop;
end;
/
*/
commit;
rollback;
select * from asm_emp;
insert into asm_emp values(190,'QWERTY',20,10000);
insert into asm_works values(190,701,7);
update asm_dept set managerid=190 where dname='CSE';
update asm_emp set salary=11000 where eid=110;

/*QUESTION 2*/
create table asm_student_new(
    snum number(7),
    sname varchar2(20),
    major varchar2(20),
    level1 varchar2(20),
    age number(7)
);
create table asm_class_new(
    cname varchar2(20),
    meetsat interval day (0) to second(0),
    room varchar2(20),
    fid number(7)
);
create table enrolled(
    snum number(7),
    cname varchar2(20)
);
create table faculty(
    fid number(7),
    fname varchar2(20),
    deptid number(7)
);
create table alumni(
aname varchar2(20),
major varchar2(20)
);
commit;
select * from alumni;

select * from asm_student_new;
commit;
insert into asm_student_new values(103,'QWERTY','CSE','4',21);
delete asm_student_new where snum=103;
/*II) 1.*/
create or replace trigger alumni_trigger
after delete on asm_student_new
for each row
declare
begin
    dbms_output.put_line(:old.sname);
    insert into alumni values(:old.sname,:old.major);
end;
/
commit;
/*II) 2.*/
insert into asm_class_new values('CPL',TO_DSINTERVAL('0 9:00:00'),'UG2',210);
SELECT * FROM ASM_CLASS_NEW;
rollback;
create or replace trigger prevent_enroll
after insert or update  on enrolled
declare
    cursor c1 is select snum,cname from enrolled ;--where snum=snum1;
    cursor c2 is select snum,cname from enrolled ;--where snum=snum1; 
    m1 interval day(0) to second(0);
    m2 interval day(0) to second(0);
begin
    for z in c1 loop
        for z1 in c2 loop
            if z.snum=z1.snum and z.cname != z1.cname then
                select meetsat into m1 from asm_class_new where cname=z.cname;
                select meetsat into m2 from asm_class_new where cname=z1.cname;
                dbms_output.put_line(m1||' '||m2);
                if m1 = m2 then
                    raise_application_error(-20001,'CANNOT ENROLL');
                end if;
            end if;
        end loop;
    end loop;
end;
/
rollback;
select * from enrolled;
delete enrolled;
insert into enrolled values(101,'CPL');
commit;

/*I) 5.*/
select * from asm_class_new;
select fid,count(cname) cn from asm_class_new group by fid;

create or replace trigger faculty1
before insert or update on asm_class_new
declare
    cursor c1 is select fid,count(cname) cn from asm_class_new group by fid;
    cx number;
    cnt number:=0;
begin
    for z in c1 loop
    with t1 as(
    select fid,count(cname) cn from asm_class_new group by fid
    ) select cn into cnt from t1 where fid=z.fid;
    dbms_output.put_line('cnt is ' || cnt);
    if cnt > 3 then
        raise_application_error(-20002,'Cannot allocate');
    end if;
    end loop;
end;
/
select * from asm_class_new;
rollback;
insert into asm_class_new values('SL','0 12:00:00','UG1',213);
/*I) 3.*/
create or replace trigger avoid_clash
after insert or update on asm_class_new
declare
cursor c1 is select cname,meetsat,room from asm_class_new;
cursor c2 is select cname,meetsat,room from asm_class_new;
begin
    for z in c1 loop
        for z1 in c2 loop
            if z.cname != z1.cname and z.meetsat=z1.meetsat and z.room = z1.room then
                dbms_output.put_line(z.cname||' ' ||z1.cname);
                raise_application_error(-20001,'Cannot allocate room and time');
            end if;
        end loop;
    end loop;
end;
/
insert into asm_class_new values('LA','0 9:00:00','UG1',217);
commit;

/*II). 4.*/
/*
JR=1
SR=4
*/
declare
    procedure display;
    procedure display is
        cursor c1 is 
        select cname from asm_class_new where cname in(
            select cname from enrolled where snum in(
                select snum from asm_student_new where level1='1'
            )
        ) and cname in(
             select cname from enrolled where snum in(
                select snum from asm_student_new where level1='4'
            )
        );
        cursor c2 is
        select cname,count(snum) jrcount from enrolled where cname in(
select cname from asm_class_new where cname in(
            select cname from enrolled where snum in(
                select snum from asm_student_new where level1='1'
            )
        ) and cname in(
             select cname from enrolled where snum in(
                select snum from asm_student_new where level1='4'
            )
        )
) and snum in(select snum from asm_student_new where level1='1') group by cname ;
    cursor c3 is
    select cname,count(snum) srcount from enrolled where cname in(
select cname from asm_class_new where cname in(
            select cname from enrolled where snum in(
                select snum from asm_student_new where level1='1'
            )
        ) and cname in(
             select cname from enrolled where snum in(
                select snum from asm_student_new where level1='4'
            )
        )
) and snum in(select snum from asm_student_new where level1='4') group by cname ;

        begin
            for z in c2 loop
                for z1 in c3 loop
                    if z.cname = z1.cname then
                        dbms_output.put_line(z.cname||' '||z.jrcount||' '||z1.srcount||' ratio is '||z.jrcount/z1.srcount);
                    end if;
                end loop;
            end loop;
        end;
begin
    display;
end;
/
rollback;
commit;
select * from enrolled;
insert into enrolled values(102,'DSPD');
select * from asm_student_new;

select cname,count(snum) jrcount from enrolled where cname in(
select cname from asm_class_new where cname in(
            select cname from enrolled where snum in(
                select snum from asm_student_new where level1='1'
            )
        ) and cname in(
             select cname from enrolled where snum in(
                select snum from asm_student_new where level1='4'
            )
        )
) and snum in(select snum from asm_student_new where level1='1') group by cname ;
