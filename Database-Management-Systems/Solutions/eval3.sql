/*SET D*/
set serveroutput on;
/*1.2*/
declare
    str varchar2(200);
    no_vowels number:=0;
    no_consonants number:=0;
    c char;
    len number;
begin
    str:='&str';
    str:=lower(str);
    len:=length(str);
    for i in 1..length(str) loop
        c:=Substr(str,i,1);
        if c in ('a','e','i','o','u') then
            no_vowels := no_vowels + 1;
        else
            no_consonants:=no_consonants+1;
        end if;
    end loop;
    dbms_output.put_line('VOWELS='||no_vowels||' CONSONANTS='||no_consonants);
end;
/

/*1.5*/
declare
given char;
rep1 char;
str1 varchar2(200);
begin
    str1:='&str1';
    given:='&given';
    rep1:='&rep1';
    select replace(str1,given,rep1) into str1 from dual;
    dbms_output.put_line(str1);
end;
/
select * from asm_student;
select * from asm_course;
select * from warning;

/*2.2*/
declare
    cursor c1 is
        select rollno,coursecode,marks,grade from asm_student where coursecode in (select coursecode from asm_course where coursetype in ('DC'));
    num_tot number:=0;
    num_tot1 number:=0;
    num_pass number:=0;
    spec number:=0;
begin
    spec := &spec;
    for z in c1 loop
        if z.rollno = spec then
            
                num_tot := num_tot + 1;
                if z.grade !='FF' then
                    num_pass := num_pass + 1;
                end if;
            
        end if;
    end loop;
select count(coursecode) into num_tot1 from asm_student where rollno=spec;

    if(num_pass = 0 or num_tot1 / num_pass < 3) then
        insert into warning values(spec);
        commit;
    end if;
    dbms_output.put_line('DC PASSED: '||num_pass|| ' DC_TOT '|| num_tot||' TOT'||' ' || num_tot1);
end;
/
/*2.3*/

declare

cursor c1 is select rollno,count(reg) cnt1 from asm_student group by rollno;
num1 number:=0;
num2 number:=0;num3 number:=0;num4 number:=0;
begin
    dbms_output.put_line('Rn TOT OC DC DE HM');
    for z in c1 loop
        select count(coursecode) into num1 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='OC');
        select count(coursecode) into num2 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='DC');
        select count(coursecode) into num3 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='DE');
        select count(coursecode) into num4 from asm_student where z.rollno=asm_student.rollno and coursecode in (select coursecode from asm_course where coursetype='HM');
        
        
        
        dbms_output.put_line(z.rollno||'  '||z.cnt1||'  '|| num1||'  '||num2||'  '||num3||'  '||num4);
    end loop;
    
end;
/
insert into asm_course values('CSL11','CN','JK');
/*3.4*/
declare
name1 varchar2(200);
PAN varchar2(200);
income number(20);
optax number(8,2):=0;
function calcTax(name1 in varchar2,PAN_NUMBER in number,income in number) return number is
 tax number(8,2):=0;
begin
        if income >= 0 and income <= 300000 then
            tax:=0;
        
        elsif income > 300000 and income <= 500000 then
            tax:=10000+0.2*income;
        --end if;
        elsif income > 500000 and income <= 1000000 then
            tax:=30000+0.3*income;
        --end if;
        elsif income > 100000 then
            tax:=0.4*income;
        end if;
        
        dbms_output.put_line('NAME: '||name1||' PAN NUMBER: '||PAN_NUMBER||' '||' INCOME: '||income||' TAX: '||tax);
        return tax;
end;
begin

    name1:='&name1';
    PAN:='&PAN';
    income:=&income;
    dbms_output.put_line(calcTax(name1,PAN,income));

end;
/

