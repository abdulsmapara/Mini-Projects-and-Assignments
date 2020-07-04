/*1a*/
declare
    cursor c1 is select rollno,avg(marks)from asm_student group by rollno;
    cursor c2 is select rollno,coursecode,marks from asm_student;
    stud asm_student.rollno%type;
    ans number:=0;
    spec number:=0;
    begin
            spec:=&spec;
            with t1 as(
                select marks,coursecode from asm_student as1 WHERE as1.rollno=spec)
                ,t2 as(
                select avg(marks) avg1 from t1
            )
            select count(coursecode) into ans from t1,t2 where marks < avg1;
            dbms_output.put_line('count is '||to_char(ans));
    end;
    
/
/*1b*/
declare
    cursor c1 is select distinct(coursecode),reg from asm_student;
    countc number := 0;
    x varchar2(30);
begin
    for z in c1 loop
        if z.reg = '2' then
            countc := countc + 1;
        end if;
    end loop;
    if countc > 4 then
        --delete the course reg for course having maximum reg for reg number 2
        with t1 as(
            select coursecode,reg from asm_student where reg='2'
        ),
        t2 as (
            select coursecode,count(reg) rnum from t1 group by coursecode
        )
        select coursecode into x from t2 where rnum in (select max(rnum) from t2);
        delete asm_student where coursecode = x;
       commit;
    end if;
    dbms_output.put_line(countc);
end;
/
/*1c*/

/*1c*/
--print the number of DC courses passed by the specified student
/*declare
    num_dc_passed number := 0;
    num_tot number := 0;
    spec asm_student.rollno%type;
begin 
    spec := &spec;  
    dbms_output.put_line(spec);
    with t1 as(
        select rollno,coursecode,marks from asm_student where coursecode in (select coursecode from asm_course where coursetype='DC') and to_char(rollno)=to_char(spec)
    ), t2 as(
        select count(coursecode) into num_tot from t1
    ) , t3 as(
        select count(coursecode) into num_dc_passed from t1 where marks >= 40
    ) select 1 from t1;
    dbms_output.put_line('dc passed '||num_dc_passed||' Tot reg '||num_tot);
end;
*/



/*1c correct and final*/
--print the number of DC courses passed by the specified student

declare
    cursor c1 is
        select rollno,coursecode,marks from asm_student where coursecode in (select coursecode from asm_course where coursetype in ('DC'));
    num_tot number:=0;
    num_pass number:=0;
    spec number:=0;
begin
    spec := &spec;
    for z in c1 loop
        if z.rollno = spec then
            
                num_tot := num_tot + 1;
                if z.marks >= 40 then
                    num_pass := num_pass + 1;
                end if;
            
        end if;
    end loop;
    if(num_pass / num_tot < 0.3) then
        insert into warning values(spec);
        commit;
    end if;
    dbms_output.put_line(num_pass|| ' '|| num_tot);
end;
/

/*1d*/

declare

cursor c1 is select rollno,count(reg) cnt1 from asm_student group by rollno;
num1 number:=0;
num2 number:=0;num3 number:=0;num4 number:=0;
begin
    dbms_output.put_line('Rn TO OC DC DE HM');
    for z in c1 loop
        select count(coursecode) into num1 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='OC');
        select count(coursecode) into num2 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='DC');
        select count(coursecode) into num3 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='DE');
        select count(coursecode) into num4 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='HM');
        
        
        
        dbms_output.put_line(z.rollno||'  '||z.cnt1||'  '|| num1||'  '||num2||'  '||num3||'  '||num4);
    end loop;
    
end;
/
/*1e*/
declare 
    cursor c1 is 
        select coursecode,count(rollno) cnt from asm_student group by coursecode;
    cursor c2 is
        select coursecode,count(grade) ff from asm_student where grade='FF' group by coursecode;
fail number:=0;
begin
    for z in c1 loop
        select count(rollno) into fail from asm_student where coursecode = z.coursecode and asm_student.grade='FF';
        dbms_output.put_line(z.coursecode||' '||z.cnt||' '||fail);
        
        
    end loop;
    
    
end;
/
select * from asm_student;
select * from asm_course;
select * from warning;
commit;

/*
    3
*/
create table asm_graph(
    fromnode number(7),
    tonode number(7),
    linkname varchar2(20),
    linkcost number(7,2)
);
/*3a CORRECT i think*/
declare
    start1 number;
    end1 number;
    status number:=0;
    
    varr number;
begin
    start1:=&start1;
    end1:=&end1;
    varr:=NULL;
    with t1 as(
        select tonode from asm_graph connect by nocycle prior tonode=fromnode start with fromnode=start1
    ) 
    select distinct(1) into status from asm_graph where tonode=end1;
    
    if status=1 then
        dbms_output.put_line('CONNECTED');
    else
        dbms_output.put_line('NOT CONNECTED');
    end if;
    exception when NO_DATA_FOUND then
        dbms_output.put_line('NOT CONNECTED');
    
end;
/
/*3c correct i think*/
declare
    start1 number;
    end1 number;
    status number:=0;
    
    varr number;
    cursor c1 is
    select connect_by_iscycle status from asm_graph connect by nocycle prior tonode=fromnode;
    cycle boolean:=false;
begin
    varr:=NULL;
    for z in c1 loop
        if z.status=1 then
            cycle:=true;
        end if;
    end loop;
    if cycle then
        dbms_output.put_line('cycle');
    else
        dbms_output.put_line('no cycle');
    end if;
        
end;
/

/*3b INCORRECT FOR SURE*/
declare
start1 number:=1;
end1 number:=5;
cost number:=99999;--infinity
temp number:=0;
val number;
i number;
j number;
status NUMBER:=0;
prev number:=0;
begin
    for z in (select fromnode,tonode from asm_graph connect by nocycle prior tonode=fromnode start with fromnode=start1) loop
        dbms_output.put_line(z.fromnode||' '||z.tonode);
        if z.fromnode = start1 then
            status:=1;
        end if;
            
        if status=1 and (prev=0 or prev=z.fromnode) then
                select linkcost into val from asm_graph where fromnode=z.fromnode and tonode=z.tonode;

            dbms_output.put_line(val);
            temp:=temp+val;
            if z.tonode = end1 then
                if cost > temp then
                    cost := temp;
                end if;
                temp:=0;--initialization
                status:=0;--initialization
            end if;
        
            prev:=z.tonode;
        else
            temp := temp - val;
            select linkcost into val from asm_graph where fromnode=z.fromnode and tonode=z.tonode;

            prev := z.fromnode;
            dbms_output.put_line(val);
            temp:=temp+val;
            if z.tonode = end1 then
                if cost > temp then
                    cost := temp;
                end if;
                temp:=0;--initialization
                status:=0;--initialization
            end if;
        
            prev:=z.tonode;
        end if;
        
      end loop;
    dbms_output.put_line(cost);
end;

/
/*3d correct i think*/
declare
    countp NUMBER:=0;
begin
    for z in (
    with t1 as (
    select distinct fromnode,tonode from asm_graph connect by nocycle prior tonode=fromnode
    )
    ,outdegree as(
    select fromnode,count(tonode) ct1 from t1 group by fromnode
    ),
    indegree as(
        select tonode,count(fromnode) ct2 from t1 group by tonode
    ), t2 as(
        select fromnode from outdegree where ct1<5
    ), t3 as(
        select tonode from indegree where ct2 > 2
    )
    select fromnode from t2,t3 where fromnode=tonode) loop
        countp:=countp+1;
    end loop;
    dbms_output.put_line(countp);
end;
/
--THE SQL LOGIC -
    with t1 as (
    select distinct fromnode,tonode from asm_graph connect by nocycle prior tonode=fromnode
    )
    ,outdegree as(
    select fromnode,count(tonode) ct1 from t1 group by fromnode
    ),
    indegree as(
        select tonode,count(fromnode) ct2 from t1 group by tonode
    ), t2 as(
        select fromnode from outdegree where ct1<5
    ), t3 as(
        select tonode from indegree where ct2 >= 2
    )
    select fromnode from t2,t3 where fromnode=tonode;

/*3e
not correct
*/
declare
type rectype is record(
    f number,
    t number,
    c number
);
z1 rectype;
type tb1 is table of rectype index by varchar2(2);
tb tb1;
ind number:=0;
gen varchar2(2):='1';
seq number:=1;
temp number;
function mincostcalc(start1 in number,end1 in number) return number is
    cost number:=99999;--infinity
    temp number:=0;
    val number;
    i number;
    j number;
    status NUMBER:=0;
    begin
        for z in (select fromnode,tonode from asm_graph connect by nocycle prior tonode=fromnode start with fromnode=start1) loop
            --dbms_output.put_line(z.fromnode||' '||z.tonode);
            if z.fromnode = start1 then
                status:=1;
            end if;
            if status=1 then
                select linkcost into val from asm_graph where fromnode=z.fromnode and tonode=z.tonode;
                temp:=temp+val;
                if z.tonode = end1 then
                    if cost > temp then
                        cost := temp;
                    end if;
                    temp:=0;--initialization
                    status:=0;--initialization
                end if;
            end if;
          end loop;
        --dbms_output.put_line(cost);
        return cost;
    end;
begin
    
    for start1 in 1..5 loop
        for end1 in 1..5 loop
            
            tb(to_char(seq)).f:=start1;
            tb(to_char(seq)).t:=end1;
            tb(to_char(seq)).c:=mincostcalc(start1,end1);
            temp := seq - 1;
            for x in 1..temp loop
                if tb(to_char(x)).c = mincostcalc(start1,end1) and tb(to_char(x)).c != 99999 then
                    dbms_output.put_line(tb(to_char(x)).f||' '||','||tb(to_char(x)).t||' '||start1||' '||end1);
                end if;
            end loop;
            
            
            --dbms_output.put_line(to_char(mincostcalc(start1,end1)));
            seq:=seq+1;
        end loop;
    end loop;
end;
/
/*---package----*/
create or replace package test1 as
pragma serially_reusable;
x number;
y number:=0;
procedure add3(a in number);
end test1;
/
create or replace package body test1 as
pragma serially_reusable;
procedure add3(a in number) is
begin
    x:=a+3;
    dbms_output.put_line(x);
end;
begin
    dbms_output.put_line('init');
end test1;
/
begin
test1.add3(2);
end;
/
/*------*/


/*3B TRIAL*/
SELECT fromnode src, tonode dest, path, sum_dist shortest_dist

FROM

(SELECT DISTINCT fromnode, tonode, path,

        sum(to_number( SUBSTR(x,

                       INSTR (x, ',', 1, LEVEL  ) + 1,

                       INSTR (x, ',', 1, LEVEL+1) -

      INSTR (x, ',', 1, LEVEL) -1 ))) OVER (PARTITION BY path) sum_dist

  FROM

 (

   WITH REMOVE_PATH AS (

   SELECT SUBSTR(str,

           INSTR(str, ',', 1, LEVEL  ) + 1,

           INSTR(str, ',', 1, LEVEL+1) -

           INSTR(str, ',', 1, LEVEL) -1 ) str     

   FROM (SELECT ','||NVL(:Remove_Path, ' ')||','||:src||','||:dest||','

         AS str FROM DUAL)

   CONNECT BY PRIOR STR = STR

   AND INSTR (str, ',', 1, LEVEL+1) > 0

   AND PRIOR dbms_random.string ('p', 10) IS NOT NULL )

   SELECT  connect_by_root fromnode as fromnode,  tonode,

           sys_connect_by_path(distance, ',')||',' x,

           :src|| sys_connect_by_path(tonode, ',') path        

   FROM  asm_graph

   WHERE  tonode = :dest

   START WITH fromnode  = :src

   CONNECT by nocycle PRIOR tonode = fromnode

   AND fromnode NOT IN (SELECT str FROM REMOVE_PATH)

  )

  CONNECT BY PRIOR path = path

  AND INSTR (x, ',', 1, LEVEL+1) > 0

  AND PRIOR dbms_random.string ('p', 10) IS NOT NULL

  ORDER BY sum_dist NULLS LAST

)

WHERE ROWNUM = 1
;
/*
declare
    type arrayx is varray (9) of number(7);
    array1 arrayx;
    determinant number(7);
begin
array1 := arrayx(1,2,3,4,5,6,7,8,9);
    determinant:=0;
    for i in 1..3 loop
        determinant:=determinant+(array1(i)*array1(3+(i+1) mod 4)*array1(6+(i+2) mod 4) - array1(3+(i+2) mod 4) * array1(6+(i+1) mod 4 ));
        dbms_output.put_line(i);
    end loop;
    
    for i in 1..3 loop
        for j in 1..3 loop
            dbms_output.put_line(array1(((i+1) mod 4)*3+(j+1) MOD 4)*array1((((i+2)mod 4)*3) + (j+2)mod 4) - array1(((i+1)mod 3)*3 + ((j+2)mod 3))*array1((((i+2)mod 4)*3 + ((j+1) mod 4))));
        end loop;
    end loop;
end;
/
*/
commit;