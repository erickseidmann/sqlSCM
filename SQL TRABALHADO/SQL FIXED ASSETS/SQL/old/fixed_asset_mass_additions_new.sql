SELECT a.asset_number as "INTERFACE LINE NUMBER",
A.*
FROM (
SELECT DISTINCT
BKCTRL.BOOK_TYPE_CODE as "ASSET BOOK",
''as "TRANSACTION NAME",
favl.ASSET_NUMBER ASSET_NUMBER,
REPLACE(TRIM(favl.DESCRIPTION ),CHR(10),' ') as "ASSET_DESCRIPTION" ,
'' as "Tag Number",
favl.MANUFACTURER_NAME as "MANUFACTURER",
favl.SERIAL_NUMBER as "SERIAL NUMBER",
favl.MODEL_NUMBER as "MODEL",
favl.ASSET_TYPE as "ASSET TYPE",
FABOOKS.COST as "COST",
TO_CHAR(FABOOKS.DATE_PLACED_IN_SERVICE, 'YYYY/MM/DD') as "Date Placed in Service",
CT.DESCRIPTION as "PRORATE CONVENTION",
favl.CURRENT_UNITS as "ASSET UNITS",
FA_CATEGORY.SEGMENT1 as "Asset Category Segment1",
FA_CATEGORY.SEGMENT2 as "Asset Category Segment2",
'' as "Asset Category Segment3",
'' as "Asset Category Segment4",
'' as "Asset Category Segment5",
'' as "Asset Category SEGMENT6",
'' as "Asset Category SEGMENT7",
'NEW' as "POSTING STATUS",
'NEW' as "QUEUE NAME", -- same as POSTING_STATUS
'' as "Feeder System",
FA2.ASSET_NUMBER as "PARENT ASSET NUMBER",
'' as "ADD TO ASSET NUMBER",	
ASSETKEYWORDS.SEGMENT1 as "ASSET KEY SEGMENT1",
ASSETKEYWORDS.SEGMENT2 as "ASSET KEY SEGMENT2",
ASSETKEYWORDS.SEGMENT3 as "ASSET KEY SEGMENT3",
--'' as "ASSET KEY SEGMENT4",
--'' as "ASSET KEY SEGMENT5",
--'' as "ASSET KEY SEGMENT6",
--'' as "ASSET KEY SEGMENT7",
--'' as "ASSET KEY SEGMENT8",
--'' as "ASSET KEY SEGMENT9",
--'' as "ASSET KEY SEGMENT10",
favl.INVENTORIAL as "In physical inventory",
favl.PROPERTY_TYPE_CODE as "PROPERTY TYPE",
favl.PROPERTY_1245_1250_CODE as "PROPERTY CLASS",
favl.IN_USE_FLAG as "In use" ,
favl.OWNED_LEASED as "OWNERSHIP",
favl.NEW_USED as "BOUGHT",
--'' as "Material",
--'' as "Indicator",
--'' as "Commitment",
--'' as "Investment" ,
--'' as "Law"	,
--'' as "Amortize",	
--'' as "Amortization", 
--'' as "Start Date",
--DECODE(FT.AMORTIZATION_START_DATE, NULL, 'NO', 'YES') AMORTIZE, --BKCTRL.AMORTIZE_FLAG
--TO_CHAR(FT.AMORTIZATION_START_DATE, 'YYYY/MM/DD')  AMORTIZATION_START_DATE,
FABOOKS.DEPRECIATE_FLAG as "DEPRECIATE",
--'' as "SALVAGE VALUE TYPE",
--'' as "SALVAGE VALUE AMOUNT",
--'' as "SALVAGE VALUE PERCENT",
(SELECT SUM(FDS.YTD_DEPRN)
                       from fa_deprn_detail   FDS
                       where 
            favl.ASSET_ID = FDS.ASSET_ID
            AND FDP.PERIOD_COUNTER = FDS.PERIOD_COUNTER
            AND FDP.BOOK_TYPE_CODE = FDS.BOOK_TYPE_CODE
            AND FDS.BOOK_TYPE_CODE = FABOOKS.BOOK_TYPE_CODE
            AND FABOOKS.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
            AND favl.ASSET_ID = FABOOKS.ASSET_ID
						) YTD_DEPRN,
(SELECT SUM(FDS.DEPRN_RESERVE)
                       from fa_deprn_detail   FDS
                       where 
            favl.ASSET_ID = FDS.ASSET_ID
            AND FDP.PERIOD_COUNTER = FDS.PERIOD_COUNTER
            AND FDP.BOOK_TYPE_CODE = FDS.BOOK_TYPE_CODE
            AND FDS.BOOK_TYPE_CODE = FABOOKS.BOOK_TYPE_CODE
            AND FABOOKS.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
            AND favl.ASSET_ID = FABOOKS.ASSET_ID
						) DEPRN_RESERVE,
FDS.BONUS_YTD_DEPRN as "YTD Bonus Depreciation",
FDS.BONUS_DEPRN_RESERVE as "Bonus Depreciation Reserve" ,
FDS.YTD_IMPAIRMENT as "YTD_IMPAIRMENT",
FDS.IMPAIRMENT_RESERVE as "IMPAIRMENT_RESERVE",
fm.METHOD_CODE as "Depreciation Method",
fm.LIFE_IN_MONTHS as "Life in Months",
--'' as "Basic",
--'' as "Rate",	
--'' as "Adjusted Rate",	
--'' as "Unit of Measure",	
--'' as "Production Capacity",	
--'' as "Ceiling Type",	
--'' as "Bonus Rule",	
--'' as "Cash Generating Unit",	
--'' as "Depreciation Limit Type",
--'' as "Depreciation Limit Percent",	
--'' as "Depreciation Limit Amount",
--BASIC RATE	 (ONLY FOR FLAT)
--ADJUSTED RATE (ONLY FOR FLAT)
--UNIT OF MEASURE
AIA.INVOICE_AMOUNT as "INVOICE COST",
GCC.SEGMENT1 as "COST CLEARING SEGMENT1",
GCC.SEGMENT2 as "COST CLEARING SEGMENT2",
GCC.SEGMENT3 as "COST CLEARING SEGMENT3",
GCC.SEGMENT4 as "COST CLEARING SEGMENT4",
GCC.SEGMENT5 as "COST CLEARING SEGMENT5",
GCC.SEGMENT6 as "COST CLEARING SEGMENT6",
GCC.SEGMENT7 as "COST CLEARING SEGMENT7",
GCC.SEGMENT8 as "COST CLEARING SEGMENT8",
'' as "Cost Clearing Account Segment9",
'' as "Cost Clearing Account Segment10",
'' as "Cost Clearing Account Segment11",
'' as "Cost Clearing Account Segment12",
'' as "Cost Clearing Account Segment13",
'' as "Cost Clearing Account Segment14",
'' as "Cost Clearing Account Segment15",
'' as "Cost Clearing Account Segment16",
'' as "Cost Clearing Account Segment17",
'' as "Cost Clearing Account Segment18",
'' as "Cost Clearing Account Segment19",
'' as "Cost Clearing Account Segment20",
'' as "Cost Clearing Account Segment21",
'' as "Cost Clearing Account Segment22",
'' as "Cost Clearing Account Segment23",
'' as "Cost Clearing Account Segment24",
'' as "Cost Clearing Account Segment25",
'' as "Cost Clearing Account Segment26",
'' as "Cost Clearing Account Segment27",
'' as "Cost Clearing Account Segment28",
'' as "Cost Clearing Account Segment29",
'' as "Cost Clearing Account Segment30",
favl.ATTRIBUTE1 as "ATTRIBUTE1", --TEM O FLEX DEFINIDO
favl.ATTRIBUTE2 as "ATTRIBUTE2",
favl.ATTRIBUTE3 as "ATTRIBUTE3",
favl.ATTRIBUTE4 as "ATTRIBUTE4",

FAI.VENDOR_NAME as " SUPPLIER_NAME",
PS.SEGMENT1 as "SUPPLIER_NUMBER",
FAI.PO_NUMBER as "Purchase Order Number",
FAI.INVOICE_NUMBER as "Invoice Number",
FAI.INVOICE_VOUCHER_NUMBER as "Invoice Voucher Number",
TO_CHAR(FAI.INVOICE_DATE, 'YYYY/MM/DD') as "INVOICE DATE",
FAI.PAYABLES_UNITS as "Payables Units" ,
FAI.INVOICE_LINE_NUMBER as "Invoice Line Number" ,
FAI.INVOICE_LINE_TYPE as "Invoice Line Type",
REPLACE(TRIM(FAI.INVOICE_LINE_DESCRIPTION),CHR(10),' ')  as "Invoice Line Description",
FAI.INVOICE_PAYMENT_NUMBER as "Invoice Payment Number" ,
FAI.PROJECT_NUMBER as "Project Number",
'' as "Task Number",	
'' as "Fully depreciate",	
'' as "Depreciation Factor",	
'' as "Revalued Cost",	
'' as "Backlog Depreciation Reserve",	
'' as "YTD Backlog Depreciation Reserve",	
'' as "Life-to-Date Revaluation Reserve Amortization",	
'' as "YTD Revaluation Reserve Amortization",
favl.ASSET_ID as " "
FROM
FA_BOOK_CONTROLS BKCTRL,
FA_BOOKS FABOOKS,
FA_ADDITIONS_VL favl,
FA_METHODS fm,
FA_CATEGORIES_VL FA_CATEGORY,
FA_ASSET_KEYWORDS ASSETKEYWORDS,
FA_DISTRIBUTION_HISTORY FA_DISTRIB,
FA_LOCATIONS FA_LOCATION,
--FA_TRANSACTION_HEADERS FT,
FA_CONVENTION_TYPES  CT ,
FA_ADDITIONS_B FA1,
FA_ADDITIONS_B FA2,
FA_DEPRN_PERIODS FDP,
fa_deprn_detail   FDS,
FA_ASSET_INVOICES FAI ,
FA_CATEGORY_BOOKS  FCB,
AP_INVOICES_ALL AIA,
GL_CODE_COMBINATIONS GCC,
POZ_SUPPLIERS PS
WHERE 
favl.ASSET_ID = FDS.ASSET_ID
and favl.ASSET_NUMBER = '19115'
AND FDP.PERIOD_COUNTER = FDS.PERIOD_COUNTER
AND FDP.BOOK_TYPE_CODE = FDS.BOOK_TYPE_CODE
AND FDS.BOOK_TYPE_CODE = FABOOKS.BOOK_TYPE_CODE
AND FABOOKS.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
AND favl.ASSET_ID = FABOOKS.ASSET_ID
AND FABOOKS.METHOD_ID = fm.METHOD_ID(+)
AND favl.ASSET_CATEGORY_ID = FA_CATEGORY.CATEGORY_ID(+)
AND favl.ASSET_KEY_CCID = ASSETKEYWORDS.CODE_COMBINATION_ID(+)
AND FABOOKS.BOOK_TYPE_CODE = FA_DISTRIB.BOOK_TYPE_CODE(+)
AND favl.ASSET_ID = FA_DISTRIB.ASSET_ID(+)
AND FA_DISTRIB.LOCATION_ID = FA_LOCATION.LOCATION_ID(+)
---
AND FA2.ASSET_ID (+) = FA1.PARENT_ASSET_ID
AND AIA.INVOICE_ID(+)=FAI.INVOICE_ID
AND favl.ASSET_ID = FAI.ASSET_ID(+)
AND FABOOKS.BOOK_TYPE_CODE = FAI.BOOK_TYPE_CODE(+)
AND FCB.ASSET_CLEARING_ACCOUNT_CCID = GCC.CODE_COMBINATION_ID
AND FCB.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
AND favl.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
and fds.DISTRIBUTION_ID = FA_DISTRIB.DISTRIBUTION_ID
and FA_DISTRIB.book_type_code = fds.book_type_code
AND FABOOKS.CONVENTION_TYPE_ID = CT.CONVENTION_TYPE_ID(+)
AND FA1.ASSET_ID = favl.ASSET_ID
AND PS.VENDOR_ID(+) = AIA.VENDOR_ID
and NVL(FABOOKS.DATE_INEFFECTIVE , sysdate) >= sysdate
and NVL(FA_DISTRIB.DATE_INEFFECTIVE , sysdate) >= sysdate
AND FDP.PERIOD_COUNTER IN ( SELECT MAX(FDS1.PERIOD_COUNTER)
                             FROM FA_DEPRN_DETAIL FDS1
							 WHERE FDS.ASSET_ID = FDS1.ASSET_ID
                               AND FDS.BOOK_TYPE_CODE = FDS1.BOOK_TYPE_CODE )
order by favl.ASSET_NUMBER ) A
order by a.asset_number