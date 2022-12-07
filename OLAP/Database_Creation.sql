use master;
GO
drop database if exists Guns4Freedom_DW;
GO
Create database Guns4Freedom_DW;
GO
use Guns4Freedom_DW;
GO

-- DimDate creation
drop table if exists DimDate;
create table DimDate (
	DateKey int Primary Key,
	Date date,
	Day varchar(20),
	DayOfWeek int,
    DayOfMonth int,
	DayOfYear int,
	PreviousDay date,
	NextDay date,
    WeekOfYear int,
    Month varchar(20),
	MonthOfYear int,
	QuarterOfYear int,
    Year int
);
go

-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals
SET DATEFIRST  7, -- 1 = Monday, 7 = Sunday
    DATEFORMAT mdy, 
    LANGUAGE   US_ENGLISH;

DECLARE @StartDate  date = '19960101';

DECLARE @CutoffDate date = '20301231';

WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
),
src AS
(
  SELECT
	DateKey         = (DATEPART(YEAR, d) * 100 + DATEPART(MONTH, d)) * 100 + DATEPART(DAY, d),
    Date			= CONVERT(date,		  d),
	Day				= DATENAME(WEEKDAY,   d),
	DayOfWeek		= DATEPART(WEEKDAY,   d),
    DayOfMonth      = DATEPART(DAY,       d),
	DayOfYear		= DATEPART(DAYOFYEAR, d),
	PreviousDay		= DATEADD(DAY, -1,	  d),
	NextDay			= DATEADD(DAY, 1,	  d),
    WeekOfYear      = DATEPART(WEEK,      d),
    Month			= DATENAME(MONTH,     d),
	MonthOfYear     = DATEPART(MONTH,     d),
	QuarterOfYear   = DATEPART(Quarter,   d),
    Year            = DATEPART(YEAR,      d)
  FROM d
)
insert into DimDate
SELECT * FROM src
  ORDER BY Date
  OPTION (MAXRECURSION 0);

  go

-- create DimProduct
drop table if exists DimProduct;
CREATE TABLE [DimProduct] (
  [ProductKey] int identity(1,1) PRIMARY KEY,
  [PART] bigint,
  [PARTNAME] nvarchar(50),
  [FAMILYNAME] nvarchar(50),
  [FTNAME] nvarchar(50),
  [COMPANYNAME] nvarchar(50),
  [COST] float,
  [PRICE] float,
  --[PriceStartDate] Datetime,
  --[PriceEndDate] Datetime,
  [UNIT] bigint,
  [STATUS] nchar(1)
)
GO

-- create [DimAgents]
drop table if exists [DimAgents];
CREATE TABLE [DimAgents] (
  [AgentKey] int identity(1,1) PRIMARY KEY,
  [AGENT] bigint,
  [STATENAME] nvarchar(50),
  [AGENTNAME] nvarchar(50),
  [ADDRESS] nvarchar(80),
  [EMAIL] nvarchar(100),
  [PHONE] nvarchar(50),
  [OPENINGDATE] date
)
GO

-- create [DimCustomers]
drop table if exists [DimCustomers];
CREATE TABLE [DimCustomers] (
  [CustomerKey] int identity(1,1) PRIMARY KEY,
  [CUST] bigint,
  [STATENAME] nvarchar(50),
  [CUSTNAME] nvarchar(60),
  [ADDRESS] nvarchar(80),
  [EMAIL] nvarchar(100),
  [PHONE] nvarchar(50)
)
GO

-- create [FactSales]
drop table if exists [FactSales];
CREATE TABLE [FactSales] (
  [ProductKey] int,
  [AgentKey] int,
  [CustomerKey] int,
  [DateKey] int,
  [IV] bigint,
  [PRICE] float,
  [QUANT] int,
  [DISCOUNT] float,
  [TotalPrice] float,
  PRIMARY KEY ([ProductKey], [AgentKey], [CustomerKey], [DateKey], [IV])
)
GO

ALTER TABLE [FactSales] ADD FOREIGN KEY ([ProductKey]) REFERENCES [DimProduct] ([ProductKey])
GO

ALTER TABLE [FactSales] ADD FOREIGN KEY ([AgentKey]) REFERENCES [DimAgents] ([AgentKey])
GO

ALTER TABLE [FactSales] ADD FOREIGN KEY ([CustomerKey]) REFERENCES [DimCustomers] ([CustomerKey])
GO

ALTER TABLE [FactSales] ADD FOREIGN KEY ([DateKey]) REFERENCES [DimDate] ([DateKey])
GO


--cdc state
drop table if exists [dbo].[cdc_states] ;
CREATE TABLE [dbo].[cdc_states] 
 ([name] [nvarchar](256) NOT NULL, 
 [state] [nvarchar](256) NOT NULL) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [cdc_states_name] ON 
 [dbo].[cdc_states] 
 ( [name] ASC ) 
 WITH (PAD_INDEX  = OFF) ON [PRIMARY]
GO


--creating mrr
CREATE SCHEMA mrr;

GO

CREATE TABLE [mrr].[PART] (
    [PARTNAME] nvarchar(50),
    [PART] bigint,
    [UNIT] bigint,
    [STATUS] nvarchar(1),
    [PRICE] float,
    [COST] float,
    [FAMILY] bigint,
    [COMPANY] bigint
)

CREATE TABLE [mrr].[INVOICES] (
    [__$start_lsn] binary(10),
    [__$operation] int,
    [__$update_mask] binary(128),
    [IVNUM] nvarchar(16),
    [DOC] bigint,
    [IV] bigint,
    [QPRICE] float,
    [TOTPRICE] float,
    [CURRENCY] bigint,
    [CUST] bigint,
    [DEBIT] nvarchar(1),
    [IVREF] nvarchar(10),
    [VAT] float,
    [UDATE] bigint,
    [T$USER] bigint,
    [PRINTED] nvarchar(1),
    [FINAL] nvarchar(1),
    [ORD] bigint,
    [DISCOUNT] float,
    [DISPRICE] float,
    [MONTHLY] nvarchar(1),
    [PAY] bigint,
    [FNCPATTERN] bigint,
    [PAYDATE] bigint,
    [FNCTRANS] bigint,
    [BOOKNUM] nvarchar(16),
    [AGENT] bigint,
    [PIV] bigint,
    [CALQPRICE] float,
    [TYPE] nvarchar(1),
    [CHECKING] nvarchar(1),
    [IMPFILE] bigint,
    [IMPFIVTYPE] nvarchar(1),
    [CASH] bigint,
    [TOCASH] bigint,
    [NOVATPRICE] float,
    [VATPRICE] float,
    [WARHS] bigint,
    [TOWARHS] bigint,
    [LCURRENCY] bigint,
    [LEXCHANGE] float,
    [WTAX] float,
    [AFTERWTAX] float,
    [WTAXPERCENT] float,
    [IVBALANCE] float,
    [ADVFLAG] nvarchar(1),
    [ACCOUNT] bigint,
    [CASHPAYMENT] float,
    [STORNOFLAG] nvarchar(1),
    [TAX] bigint,
    [INTERNAL] nvarchar(1),
    [BRANCH] bigint,
    [LIV] bigint,
    [ADJPRICEFLAG] nvarchar(1),
    [FNCITEMSFLAG] nvarchar(1),
    [DETAILS] nvarchar(24),
    [OWNER] bigint,
    [PHONE] bigint,
    [DESTCODE] bigint,
    [SHIPTYPE] bigint,
    [BALDATE] bigint,
    [PLIST] bigint,
    [T$PERCENT] float,
    [PACK] bigint,
    [MWEIGHT] float,
    [WEIGHT] float,
    [AIRWAYBILL] nvarchar(20),
    [PATTERN] bigint,
    [PATKLINE] bigint,
    [UDATESECONDS] bigint,
    [TAXSUM] float,
    [IVCODEID] bigint,
    [IVDATE] date,
    [__$command_id] int,
    [Operation] int
)

CREATE TABLE [mrr].[INVOICEITEMS] (
    [__$start_lsn] binary(10),
    [__$operation] int,
    [__$update_mask] binary(128),
    [IV] bigint,
    [PART] bigint,
    [PRICE] float,
    [QUANT] bigint,
    [QPRICE] float,
    [CURRENCY] bigint,
    [LINE] bigint,
    [ORDI] bigint,
    [T$PERCENT] float,
    [UDATE] bigint,
    [T$USER] bigint,
    [KLINE] bigint,
    [TQUANT] bigint,
    [TUNIT] bigint,
    [PURTAXPERCENT] float,
    [TRANS] bigint,
    [TOTPERCENT] float,
    [NONSTANDARD] bigint,
    [CALQPRICE] float,
    [SUPPART] bigint,
    [IVCOST] float,
    [DUTYCOST] float,
    [BUDGET] bigint,
    [VATFLAG] nvarchar(1),
    [TYPE] nvarchar(1),
    [PRSOURCE] nvarchar(1),
    [STORNOFLAG] nvarchar(1),
    [COSTC] bigint,
    [CREDITCOST] float,
    [ACCOUNT] bigint,
    [BRANCH] bigint,
    [IVDATE] bigint,
    [ICURRENCY] bigint,
    [IEXCHANGE] float,
    [COUNTRY] bigint,
    [CREDITFLAG] nvarchar(1),
    [AGENT] bigint,
    [COMMISSION] float,
    [XKLINE] bigint,
    [__$command_id] int,
    [Operation] int
)

GO
--creating history
CREATE SCHEMA hist;

GO

-- create DimProduct
drop table if exists [hist].[DimProduct];
CREATE TABLE [hist].[DimProduct] (
  [ProductKey] int identity(1,1) PRIMARY KEY,
  [PART] bigint,
  [PARTNAME] nvarchar(50),
  [FAMILYNAME] nvarchar(50),
  [FTNAME] nvarchar(50),
  [COMPANYNAME] nvarchar(50),
  [COST] float,
  [PRICE] float,
  [PriceStartDate] Datetime,
  [PriceEndDate] Datetime,
  [UNIT] bigint,
  [STATUS] nchar(1)
)
GO

--creating staging
CREATE SCHEMA stg;

GO

-- create Stg DimProduct
drop table if exists [stg].[DimProduct];
CREATE TABLE [stg].[DimProduct] (
    [PARTNAME] nvarchar(50),
    [PART] bigint,
    [UNIT] bigint,
    [STATUS] nvarchar(1),
    [PRICE] float,
    [COST] float,
    [FAMILY] bigint,
    [COMPANY] bigint,
    [COMPANYNAME] nvarchar(50),
    [FAMILYNAME] nvarchar(50),
    [FAMILYTYPE] bigint,
    [FTNAME] nvarchar(20)
)
GO