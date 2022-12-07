select * 
from FAMILYTYPES;

select * 
from FAMILY;

select * 
from COMPANIES;

select * 
from PART;

select * 
from STATES;

select * 
from AGENTS;

select *
from CUSTOMERS;

select *
from INVOICES;

select STATEID, count(CUST) as count
from CUSTOMERS
group by STATEID;

select cust, stateid
from CUSTOMERS
where cust = 744;

select distinct C.CUST, 
	   C.STATEID,
	   A.AGENT,
	   A.OPENINGDATE
from CUSTOMERS C
inner join AGENTS A
on C.STATEID = A.STATEID;


select * 
from INVOICES;

select i.agent, i.CUST, a.STATEID
from INVOICES i
inner join agents a
on a.agent = i.agent
where CUST = 7;


DECLARE @FromDate date
DECLARE @ToDate   date

SET @FromDate = '2000-01-01' 
SET @ToDate = '2022-11-15'

select dateadd(day, 
               rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
               @FromDate)



select i.IVDATE, a.OPENINGDATE
from INVOICES i
inner join agents a
on a.agent = i.agent
where i.IVDATE >= a.OPENINGDATE;


select max(DISCOUNT)
from INVOICES;

select agent, count(iv)
from INVOICES
group by agent;

select * from INVOICEITEMS;


select ixp.*, s.STATENAME
from STATES s
inner join CUSTOMERS c
on s.STATEID = c.STATEID
inner join
(
	select i.IV,
		   i.CUST,
		   p.PART, 
		   p.PRICE
	from INVOICES i, PART p
) ixp
on c.CUST = ixp.CUST
order by ixp.IV;

select agent, openingdate
from agents;

select count(KLINE)
from INVOICEITEMS;

select min(QUANT), MAX(QUANT)
from INVOICEITEMS;

select IV
from INVOICES
where IV not in 
(
	select IV 
	from INVOICEITEMS
);

select CUST
from CUSTOMERS
where CUST not in 
(
	select CUST 
	from INVOICES i
	inner join INVOICEITEMS ii
	on i.IV = ii.IV
);

select AGENT
from AGENTS
where AGENT not in
(
	select i.AGENT
	from INVOICES i
	inner join INVOICEITEMS ii
	on i.IV = ii.IV
);