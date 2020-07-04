/*1a(not sure)*/
create or replace trigger asm_emp_trriger before insert or update on asm_emp
for each row
declare
    budget number := 0;
    sum1 number :=0;
begin
    select budget into budget from asm_dept where did in(
        select did from asm_works where eid=:new.eid
    );
    sum1 := :new.salary;
    if(sum1 > budget) then
        raise_application_error(-20001,'ERROR');
    end if;
end;
/
select asm_emp.eid,salary,did from asm_emp, asm_works where asm_emp.eid=asm_works.eid;
select sum(salary),did from asm_emp,asm_works where asm_emp.eid=asm_works.eid group by did;
select * from asm_emp;

insert into asm_emp values(121,'SANJAY',30,11000);

update asm_emp set salary=10001 where eid=101;

/*1b*/
declare
    procedure print is
        cursor c1 is 
        select dname,budget from asm_dept;
        sum1 number:=0;
        varia number(7,0);
    begin
        for z in c1 loop
            select sum(salary) into sum1 from asm_emp where eid in (
                select eid from asm_works where did in(
                    select did from asm_dept where dname=z.dname
                )
            );
            varia := z.budget;
            varia := varia - sum1;
            dbms_output.put_line(z.dname||' '||z.budget||' '||varia);
        end loop;
    end;
begin
    print;
end;

/

/*1c*/
create or replace TRIGGER asm_works_trigger after insert or update or delete on asm_works
declare
    cursor c1 is select eid,sum(pct_time) wh from asm_works group by eid;
    begin
        for z in c1 loop
            if z.wh > 10 then
                dbms_output.put_line(z.eid);
            end if;
        end loop;
    end;
/
/*1d*/

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


/*1e*/
create or replace procedure upd(amount in number, deptname in varchar2) is
    begin
        update asm_emp set salary = salary + amount where eid in(
            select eid from asm_works where did in(
                select did from asm_dept where dname = deptname
            )
        );
        commit;
    end;
/
begin
    upd(199,'CSE');
end;
/
select * from asm_emp;
update asm_works set pct_time=7;
/*2.1*/
create or replace trigger asm_emp_no_op1 before insert or update or delete on asm_emp
declare
    today varchar2(20):='MONDAY';
begin
    select to_char(sysdate,'FMDAY') into today from dual;
    dbms_output.put_line(today);
    if upper(today) = 'SUNDAY' then
            raise_application_error(-20002,'Cant perform any op on sunday');
    end if;
end;
/
/*2.2*/
create or replace trigger asm_emp_no_op before insert or update or delete on asm_emp
declare
    today varchar2(20):='MONDAY';
begin
    select to_char(sysdate,'FMDAY') into today from dual;
    dbms_output.put_line(today);
    if upper(today) = 'SUNDAY' then
        dbms_output.put_line('HERE');
        if(to_char(sysdate,'HH24:MI') between '07:00' and '09:00') then
            dbms_output.put_line('HERE123');
            raise_application_error(-20001,'Cant perform any op now');
        end if;
    end if;
end;
/
insert into asm_emp values(299,'SOHAN',43,9000);

update asm_emp set salary=1000 where eid=101;

select to_char(sysdate,'HH24:MI') from dual;
select to_char(sysdate ,'DAY') from dual;
/*2.3*/
select table_name from user_tables;
declare cursor c1 is select table_name from user_tables;
x number :=0;
begin
    for z in c1 loop
        select NUM_ROWS into x from user_tables where table_name=z.table_name;
        dbms_output.put_line(nvl(x,0));
    end loop;
end;
/
select * from all_tables;
/*2.4*/
create or replace function sumsal(dept varchar2) return number is
    sum1 number:=0;
    begin
        select sum(salary) into sum1 from asm_emp where eid in(
            select eid from asm_works where did in(
                select did from asm_dept where dname=dept
            )
        );
        return sum1;
    end;
/
begin
    dbms_output.put_line(sumsal('MEC'));
end;
/
/*2.5*/
create or replace function eval(str in varchar2) return number is
        x number:=0;
    begin
        EXECUTE IMMEDIATE 'select '||str||' from dual' INTO x;
        dbms_output.put_line(x);
        return x;
    end;
/
declare
    x number:=0;
    begin
        x:=eval('5+7*2');
    end;