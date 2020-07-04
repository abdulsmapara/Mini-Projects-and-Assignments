create table hierarchy(
    id number(7),
    region varchar2(100) not null,
    parent number(7,2),
    constraint pk_check
    primary key(id)
);
alter table hierarchyValues
modify id NUMBER(7);
commit;
delete hierarchy;
create table hierarchyValues(
    id number(7),
    value number(10,2),
    constraint pk_check2
    primary key(id),
    constraint fk_check1
    foreign key(id) references hierarchy(id) on delete cascade
);
alter table hierarchyValues add avg number(7,2);
commit;
delete hierarchyValues where id = 7;
insert all
into hierarchy values(1,'INDIA',null)
into hierarchy values(2,'MAHARASHTRA',1)
into hierarchy values(3,'GUJARAT',1)
into hierarchy values(4,'NAGPUR',2)
into hierarchy values(5,'MUMBAI',2)
into hierarchy values(6,'SURAT',3)
select 1 from dual;

select * from hierarchy;
alter table hierarchy add constraint fk_check2 foreign key(parent) references hierarchy(id);
insert all
into hierarchy values(25,'BTECH CLASS',26)
into hierarchy values(27,'MTECH CLASS',26)
select 1 from dual;
commit;
insert all
into hierarchyValues values(20,100)
into hierarchyValues values(22,190)
into hierarchyValues values(23,280)
select 1 from dual;
insert all
into hierarchy values(19,'IITH',16)
select 1 from dual;
commit;
insert all
into hierarchyValues values(25,1500)
into hierarchyvalues values(27,1200)
select 1 from dual;
commit;
rollback;
select * from hierarchy;
delete hierarchyvalues where id=22;
select * from hierarchyValues;
with tb as(
select hierarchy.id ID1,region,parent,value from hierarchy LEFT OUTER JOIN hierarchyValues ON hierarchy.id=hierarchyvalues.id
) select ID1,region,parent,value from tb connect by prior ID1 = parent start with ID1=1;

select hierarchy.id,region,parent,value from hierarchy LEFT OUTER JOIN hierarchyValues ON hierarchy.id=hierarchyvalues.id;
delete hierarchy;
delete hierarchyvalues;
insert into hierarchyvalues values(5,70);
commit;
update hierarchyValues set value=280.67 where id=23;
commit;


select * from hierarchyValues;
commit;
update hierarchyValues set Value=700 where id=20;
insert into hierarchy values(35,'COEN',0);
insert into hierarchy values(36,'REGION_ANDHRA_PRADESH_NAGPUR',0);
insert into hierarchy values(37,'B_TECH',35);
insert into hierarchy values(38,'M_TECH',35);
commit;
insert into hierarchyValues values(36,500);
select * from hierarchy;



update hierarchyValues set avg=10.0 where id=9;
commit;
