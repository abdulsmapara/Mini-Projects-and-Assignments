/*
SET A
*/
create table vehicle_tb(
    vehicleid number(10),
    x number(10,2),
    y number(10,2),
    time number(10,2)
);
commit;
/*1a*/
create or replace trigger alumni_trigger
after delete on asm_student_new
for each row
declare
begin
    dbms_output.put_line(:old.sname);
    insert into alumni values(:old.sname,:old.major);
end;
/
select * from alumni;
delete alumni;

select * from asm_student_new;
commit;
rollback;
insert into asm_student_new values(103,'QWERTY','CSE','4',21);
delete asm_student_new where snum=103;


/*1b*/
insert into asm_class_new values('CPL',TO_DSINTERVAL('0 9:00:00'),'UG2',210);
SELECT * FROM ASM_CLASS_NEW;
rollback;
create or replace trigger prevent_enroll
after insert or update  on enrolled
declare
    c11 number:=0;
    cursor c1 is select snum,cname from enrolled ;--where snum=snum1;
    cursor c2 is select snum,cname from enrolled ;--where snum=snum1;
    
    m1 interval day(0) to second(0);
    m2 interval day(0) to second(0);
begin
    for z in c1 loop
        
        select count(cname) into c11 from enrolled where snum=z.snum and cname=z.cname;
        if c11 > 1 then
            raise_application_error(-20002,'Cannot enroll here');
        end if;
    end loop;
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
insert into enrolled values(101,'DSPD');
insert into enrolled values(101,'CPL');
insert into enrolled values(101,'AWP');
rollback;
commit;

/*3c 3d*/
set SERVEROUTPUT on;
declare
    type varrayx is varray (9) of number(7);
    arr varrayx;
    a1 number;
    a2 number;
    a3 number;
    a4 number;
    a5 number;
    a6 number;
    a7 number;
    a8 number;
    a9 number;
    x number;
    row1 number:=0;
    
    row2 number:=0;
    
    row3 number:=0;
    col1 number:=0;
    col2 number:=0;
    col3 number:=0;
begin
    a1:=&a1;
    a2:=&a2;
    a3:=&a3;
    a4:=&a4;
    a5:=&a5;
    a6:=&a6;
    a7:=&a7;
    a8:=&a8;
    a9:=&a9;
    
    arr:=varrayx(a1,a2,a3,a4,a5,a6,a7,a8,a9);
    for i in 1..9 loop
        x:=arr(i);
        if i mod 3 = 0 then
            col3 := col3 + x;
        elsif i mod 3 = 1 then
            col1 := col1 + x;
        elsif i mod 3 = 2 then
            col2 := col2 + x;
        end if;
        
        if i <= 3 then
            row1 := row1 + x;
        elsif i <= 6 then
            row2:=row2+x;
        elsif i <= 9 then
            row3:=row3+x;
        end if;
    end loop;
    dbms_output.put_line('Col1 '|| col1);
    dbms_output.put_line('Col2 '|| col2);
    dbms_output.put_line('Col3 '|| col3);
    dbms_output.put_line('Row1 '|| row1);
    
    dbms_output.put_line('Row2 '|| row2);
    
    dbms_output.put_line('Row3 '|| row3);
end;
/
declare
    type varrayx is varray (9) of number(7);
    arr varrayx;
    a1 number;
    a2 number;
    a3 number;
    a4 number;
    a5 number;
    a6 number;
    a7 number;
    a8 number;
    a9 number;
    x number;
    diag1 number:=0;
    diag2 number:=0;
begin
    a1:=&a1;
    a2:=&a2;
    a3:=&a3;
    a4:=&a4;
    a5:=&a5;
    a6:=&a6;
    a7:=&a7;
    a8:=&a8;
    a9:=&a9;
    
    arr:=varrayx(a1,a2,a3,a4,a5,a6,a7,a8,a9);
    --sum of diagonal elements
    diag1 := arr(1)+arr(5)+arr(9);
    diag2:=arr(3)+arr(5)+arr(7);
    dbms_output.put_line(diag1);
    dbms_output.put_line(diag2);
end;
/
commit;
select * from vehicle_tb;
insert into vehicle_tb values(800,5,4,1052);
/*2b*/
declare
    cursor c1(vid number) is select vehicleid,x,y,time from vehicle_tb where vehicleid=vid order by time;
    avg1 number:=0;
    dist number:=0;
    first1 number:=1;
    count1 number:=0;
    prevx number:=0;
    prevy number:=0;
    timereq number:=0;
    prevtime number:=0;
    vid number:=0;
begin
    vid:=&vid;
    for z in c1(vid) loop
        count1 := count1 + 1;
        if first1 = 0 then
            dist := dist + sqrt((prevx-z.x)*(prevx-z.x) + (prevy-z.y)*(prevy-z.y));
            timereq:=timereq+z.time - prevtime;
        end if;
        prevtime:=z.time;
        prevx:=z.x;
        prevy:=z.y;
        first1:=0;
    end loop;
    if count1 = 1 then
        dbms_output.put_line('0');
    else
        dbms_output.put_line(dist/timereq);
    end if;
end;
/
commit;
select vehicleid,time,x,y from vehicle_tb vt1 where time in(

    select min(time) from vehicle_tb where vehicleid=vt1.vehicleid
) or time in(
    select max(time) from vehicle_tb where vehicleid=vt1.vehicleid
)
order by vehicleid ,time;

insert into vehicle_tb values(700,10,6,400);
insert into vehicle_tb values(700,4,6,500);

insert into vehicle_tb values(901,4,6,490);
insert into vehicle_tb values(901,4,5,450);
with t1 as(
select vehicleid,(x-4)*(x-4) + (y-5)*(y-5) dist,time from vehicle_tb
),
t2 as(
select (vehicleid),time from t1
)
select distinct(vehicleid) from t2;
select vehicleid,x,y,time, row_number() over(partition by vehicleid order by time) from vehicle_tb;
/*2b ii*/
declare
hr1 number(7);
mi1 number(7);
hr2 number(7);
mi2 number(7);
time1 number(7):=0;
time2 number(7):=0;
num_vehicles number(7):=0;
cursor c1(t1 number,t2 number) is 

with t1 as(
select vehicleid,(x-4)*(x-4) + (y-5)*(y-5) dist, time from vehicle_tb
), t2 as(
select (vehicleid) from t1 where dist<=1 and time<=t2 and time>=t1
) select distinct(vehicleid) from t2;
begin
    hr1 := &hr1;
    mi1 := &mi1;
    hr2 := &hr2;
    mi2 := &mi2;
    time1:=hr1*60+mi1;
    time2:=hr2*60+mi2;
    for z in c1(time1,time2) loop
            num_vehicles:=num_vehicles+1;
    end loop;
    dbms_output.put_line(num_vehicles);
end;
/
select * from vehicle_tb;
with t1 as(
select vehicleid,(x-4)*(x-4) + (y-5)*(y-5) dist, time from vehicle_tb
), t2 as(
select (vehicleid) from t1
) select distinct(vehicleid) from t2;
/*
declare
hr1 number(7);
mi1 number(7);
hr2 number(7);
mi2 number(7);
time1 number(7):=0;
time2 number(7):=0;
num_vehicles number(7):=0;
cnt1 number(7):=0;
cursor c1 is 
select vehicleid,time,x,y from vehicle_tb vt1 where time in(

    select min(time) from vehicle_tb where vehicleid=vt1.vehicleid
) or time in(
    select max(time) from vehicle_tb where vehicleid=vt1.vehicleid
)
order by vehicleid ,time;
cursor c2 is
with t1 as(
select vehicleid,(x-4)*(x-4) + (y-5)*(y-5) dist, time from vehicle_tb
), t2 as(
select (vehicleid) from t1
) select distinct(vehicleid) from t2;

val1 number(7);
val2 number(7);
slope1 number(7);
slope2 number(7);
int1 number(7);
int2 number(7);
cnt2 number(7);
cnt3 number(7);
cnt4 number(7);
brk number(7);
begin
    hr1 := &hr1;
    mi1 := &mi1;
    hr2 := &hr2;
    mi2 := &mi2;
    time1:=hr1*60+mi1;
    time2:=hr2*60+mi2;
    for z in c2 loop
        select regr_slope(x,time) into cnt1 from vehicle_tb where vehicleid=z.vehicleid;
        select regr_intercept(x,time) into cnt2 from vehicle_tb where vehicleid=z.vehicleid;
        select regr_slope(y,time) into cnt3 from vehicle_tb where vehicleid=z.vehicleid;
        select regr_intercept(y,time) into cnt4 from vehicle_tb where vehicleid=z.vehicleid;
        brk:=0;
        dbms_output.put_line(cnt1||' '||cnt2||' '||z.vehicleid);
        for t in time1..time2 loop
            val1:=cnt1*t+cnt2;
            val2:=cnt3*t+cnt4;
            if ((val1-4)*(val1-4) + (val2-5)*(val2-5)) <= 1 then
               brk:=1; 
            end if;
        end loop;
        if brk=1 then
            num_vehicles:=num_vehicles+1;
        end if;
    end loop;
    
        select regr_slope(x,time) into cnt1 from vehicle_tb where vehicleid=700;
        select regr_intercept(x,time) into cnt2 from vehicle_tb where vehicleid=700;
        
        select regr_slope(y,time) into cnt3 from vehicle_tb where vehicleid=700;
        select regr_intercept(y,time) into cnt4 from vehicle_tb where vehicleid=700;
    dbms_output.put_line(num_vehicles||' ' ||(cnt1*400+cnt2)||' ' || (cnt3*400+cnt4));
end;
/
select * from vehicle_tb;
insert into vehicle_tb values(1,9,15,500);
commit;
*/