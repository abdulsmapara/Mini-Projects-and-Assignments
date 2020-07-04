create table myusers(
    
    userid varchar2(100),
    name varchar2(25),
    mobile varchar2(20),
    pin number(20),
    blocked date,
    accbalance number(10),
    credit number(10),
    status varchar2(10),
    constraint primary_key
    primary key(userid)

);
commit;
select * from myusers;
update myusers set accbalance=10000 where userid=201;
commit;
update myusers set accbalance = 10000,credit=10000 where userid=123;
alter table myusers add times number(10);
create table myloan(
    userid varchar2(100),
    loanamount number(10),
    app date,
    constraint pkloan
    primary key(userid),
    constraint fkloan
    foreign key(userid) references myusers(userid)

);

create or replace function insertUsers(userid1 in varchar2,name1 in varchar2,mobile1 in varchar2,pin1 in varchar2) return varchar2 is
begin
insert into myusers values(userid1,name1,mobile1,pin1,null,null,10000,'a',0);commit;
return to_char('SUCCESSFUL REGISTRATION');
exception when others then
return 'error '||SQLERRM;
end;
/
select * from myusers;
create or replace function loginUsers(userid1 in varchar2,pin1 in varchar2) return number is
ret number;
times number;
today date;
any1 date;
cursor c1(userid1 varchar2,pin1 varchar2) is select userid from myusers where userid=userid1 and pin=pin1 and status='a';
cursor c2(userid1 varchar2,pin1 varchar2) is select userid from myusers where userid=userid1 and pin=pin1 and status='b';
begin
ret:=0;
for x in c1(userid1,pin1) loop
        ret:=ret+1;
end loop;
for y in c2(userid1,pin1) loop
    select blocked into any1 from myusers where userid=userid1;
    select sysdate into today from dual;
    if any1 != today then
        update myusers set status='a',blocked=null where userid=userid1;
        update myusers set times=0 where user=userid1;
    end if;
end loop;
commit;
if ret=0 then
    update myusers set times=times+1 where userid=userid1;
    commit;
    select times into times from myusers where userid=userid1;
    if times>=3 then
        ret:=-1;
        select sysdate into today from dual;
        update myusers set status='b' where userid=userid1;
        update myusers set blocked=today where userid=userid1;
        commit;
        
    end if;
end if;
return ret;
end;
/
create or replace function updateUsers(userid1 in varchar2,pin1 in varchar2,name1 in varchar2,mobile1 in varchar2) return varchar2 is
cursor c1(userid1 varchar2) is select userid from myusers where userid=userid1 and pin=pin1 for update;
begin
    for x in c1(userid1) loop
        update myusers set mobile=mobile1 where userid=x.userid;
        update myusers set name=name1 where userid=x.userid;
        
    end loop;
    commit;
    return 'UPDATED';
    exception when others then
    return 'FAILED'||SQLERRM;
    
end;
/

create or replace function withdraw(userid1 in varchar2,pin1 in varchar2,amount in number) return varchar2 is
balance number:=0;
credit number:=0;
today date;
begin
    if(loginUsers(userid1,pin1)=0) then return 'NOT LOGGED IN'; end if;
   select accbalance into balance from myusers where userid=userid1 and pin=pin1;
    if balance >= amount then
        update myusers set accbalance = accbalance - amount where userid=userid1 and pin=pin1;
        commit;
        return 'SUCCESS';
    else
        select credit into credit from myusers where userid=userid1 and pin=pin1;
        if credit >= amount then
            select sysdate into today from dual;
            insert into myloan values(userid1,amount,today);
            commit;
            update myusers set credit=credit-amount where userid=userid1 and pin=pin1;
            update myusers set accbalance=nvl(accbalance,0)+amount where userid=userid1 and pin=pin1;
            
            commit;
            return 'YOUR BALANCE HAS BEEN UPDATED BY TAKING A LOAN';
        else
            return 'INSUFFICIENT BALANCE and cannot take loan of that amount';
        end if;
    end if;
end;
/

commit;


