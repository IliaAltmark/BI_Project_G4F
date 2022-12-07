use Guns4Freedom_ERP;

go

exec sys.sp_cdc_enable_db;
--exec sys.sp_cdc_disable_db;
GO  

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'FAMILYTYPES'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'FAMILY'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'COMPANIES'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'PART'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'STATES'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'AGENTS'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'CUSTOMERS'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'INVOICES'  --Table name
,@role_name= NULL; --Role Name GO

go

EXECUTE sys.sp_cdc_enable_table
@source_schema= N'dbo'  --schema name
,@source_name= N'INVOICEITEMS'  --Table name
,@role_name= NULL; --Role Name GO

go

/*
select count(*)
from INVOICES;

insert into PART (PARTNAME) values ('pew pew');
delete from PART where PARTNAME = 'pew pew';

--insert into INVOICES (CUST, AGENT, IVDATE, DISCOUNT) values ('740', 27, '2008-03-30', 0);
--insert into INVOICEITEMS (IV) values (5313);

update INVOICEITEMS
set PRICE = PRICE - 20;

update INVOICES
set DISCOUNT = DISCOUNT + 0.01;
*/