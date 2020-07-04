with cnt_tb as (select deptname,count(city) over(partition by deptname) cnt from dept_asm)
select deptname from cnt_tb where cnt in ( select max(cnt) from cnt_tb);
/*insert all
into dept_asm values ('CSE','A','BOMBAY')
into dept_asm values ('MEC','b','BOMBAY')
into dept_asm values ('CSE','A','BOMBAY')
into dept_asm values ('CSE','A','CALCUTTA')
select 1 from dual;*/