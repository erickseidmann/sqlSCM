WITH ADDITIONS
AS (
	SELECT DISTINCT BKCTRL.BOOK_TYPE_CODE AS "ASSET BOOK"
	,'' AS "TRANSACTION NAME"
	,favl.ASSET_NUMBER ASSET_NUMBER
	,favl.DESCRIPTION ASSET_DESCRIPTION
	,'' AS "Tag Number"
	,favl.MANUFACTURER_NAME AS "MANUFACTURER"
	,favl.SERIAL_NUMBER AS "SERIAL NUMBER"
	,favl.MODEL_NUMBER AS "MODEL"
	,favl.ASSET_TYPE AS "ASSET TYPE"
	,FABOOKS.COST AS "COST"
	,TO_CHAR(FABOOKS.DATE_PLACED_IN_SERVICE, 'YYYY/MM/DD') AS "Date Placed in Service"
	,CT.DESCRIPTION AS "PRORATE CONVENTION"
	,favl.CURRENT_UNITS AS "ASSET UNITS"
	,FA_CATEGORY.SEGMENT1 AS "Asset Category Segment1"
	,FA_CATEGORY.SEGMENT2 AS "Asset Category Segment2"
	,'' AS "Asset Category Segment3"
	,'' AS "Asset Category Segment4"
	,'' AS "Asset Category Segment5"
	,'' AS "Asset Category SEGMENT6"
	,'' AS "Asset Category SEGMENT7"
	,'NEW' AS "POSTING STATUS"
	,'NEW' AS "QUEUE NAME"
	,-- same as POSTING_STATUS
	'' AS "Feeder System"
	-- ,FA2.ASSET_NUMBER AS "PARENT ASSET NUMBER"
	,'' AS "ADD TO ASSET NUMBER"
	,ASSETKEYWORDS.SEGMENT1 AS "ASSET KEY SEGMENT1"
	,ASSETKEYWORDS.SEGMENT2 AS "ASSET KEY SEGMENT2"
	,ASSETKEYWORDS.SEGMENT3 AS "ASSET KEY SEGMENT3"
	,favl.INVENTORIAL AS "In physical inventory"
	,favl.PROPERTY_TYPE_CODE AS "PROPERTY TYPE"
	,favl.PROPERTY_1245_1250_CODE AS "PROPERTY CLASS"
	,favl.IN_USE_FLAG AS "In use"
	,favl.OWNED_LEASED AS "OWNERSHIP"
	,favl.NEW_USED AS "BOUGHT"
	,FABOOKS.DEPRECIATE_FLAG AS "DEPRECIATE"
	,(
		SELECT SUM(fds.DEPRN_RESERVE)
		FROM fa_deprn_summary fds
		WHERE 1 = 1
			AND fds.asset_id = favl.asset_id
			AND FABOOKS.book_type_code = fds.book_type_code
			AND fds.deprn_source_code = 'DEPRN'
			AND fds.period_counter = (
				SELECT DISTINCT MAX(period_counter)
				FROM fa_deprn_summary fds1
				WHERE fds1.asset_id = fds.asset_id
					AND fds1.book_type_code = FABOOKS.book_type_code
					AND period_counter <= (
						SELECT period_counter
						FROM fa_deprn_periods fdp
						WHERE fdp.period_name = 'FEB-2023'
							AND fdp.book_type_code = FABOOKS.book_type_code
						)
				)
		) reserve
	,(
		SELECT SUM(fds.YTD_DEPRN)
		FROM fa_deprn_summary fds
		WHERE 1 = 1
			AND fds.asset_id = favl.asset_id
			AND FABOOKS.book_type_code = fds.book_type_code
			AND fds.deprn_source_code = 'DEPRN'
			AND fds.period_counter = (
				SELECT DISTINCT MAX(period_counter)
				FROM fa_deprn_summary fds1
				WHERE fds1.asset_id = fds.asset_id
					AND fds1.book_type_code = FABOOKS.book_type_code
					AND period_counter <= (
						SELECT period_counter
						FROM fa_deprn_periods fdp
						WHERE fdp.period_name = 'FEB-2023'
							AND fdp.book_type_code = FABOOKS.book_type_code
						)
					AND period_counter >= (
						SELECT period_counter
						FROM fa_deprn_periods fdp
						WHERE fdp.period_name = 'APR-2022'
							AND fdp.book_type_code = FABOOKS.book_type_code
						)
				)
		) ytd_amount
	-- ,FDS.YTD_DEPRN ytd_amount
	-- ,FDS.YTD_DEPRN + NVL((
	-- SELECT SUM(fa.ADJUSTMENT_AMOUNT)
	-- FROM FA_ADJUSTMENTS fa
	-- WHERE fa.asset_id = favl.ASSET_ID
	-- AND fa.book_type_code = FABOOKS.BOOK_TYPE_CODE
	-- AND fa.SOURCE_TYPE_CODE = 'DEPRECIATION'
	-- AND FDP.PERIOD_COUNTER = fa.PERIOD_COUNTER_ADJUSTED
	-- ), 0) YTD_DEPRN
	-- ,FDS.DEPRN_RESERVE reserve
	-- ,FDS.DEPRN_RESERVE + NVL((
	-- SELECT SUM(fa.ADJUSTMENT_AMOUNT)
	-- FROM FA_ADJUSTMENTS fa
	-- WHERE fa.asset_id = favl.ASSET_ID
	-- AND fa.book_type_code = FABOOKS.BOOK_TYPE_CODE
	-- AND fa.SOURCE_TYPE_CODE = 'DEPRECIATION'
	-- AND FDP.PERIOD_COUNTER = fa.PERIOD_COUNTER_ADJUSTED
	-- ), 0) DEPRN_RESERVE
	-- ,--
	-- FDS.BONUS_YTD_DEPRN AS "YTD Bonus Depreciation"
	-- ,FDS.BONUS_DEPRN_RESERVE AS "Bonus Depreciation Reserve"
	-- ,FDS.YTD_IMPAIRMENT AS "YTD_IMPAIRMENT"
	-- ,FDS.IMPAIRMENT_RESERVE AS "IMPAIRMENT_RESERVE"
	,fm.METHOD_CODE AS "Depreciation Method"
	,fm.LIFE_IN_MONTHS AS "Life in Months"
	-- AIA.INVOICE_AMOUNT AS "INVOICE COST"
	,GCC.SEGMENT1 AS "COST CLEARING SEGMENT1"
	,GCC.SEGMENT2 AS "COST CLEARING SEGMENT2"
	,GCC.SEGMENT3 AS "COST CLEARING SEGMENT3"
	,GCC.SEGMENT4 AS "COST CLEARING SEGMENT4"
	,GCC.SEGMENT5 AS "COST CLEARING SEGMENT5"
	,GCC.SEGMENT6 AS "COST CLEARING SEGMENT6"
	,GCC.SEGMENT7 AS "COST CLEARING SEGMENT7"
	,GCC.SEGMENT8 AS "COST CLEARING SEGMENT8"
	,'' AS "Cost Clearing Account Segment9"
	,'' AS "Cost Clearing Account Segment10"
	,'' AS "Cost Clearing Account Segment11"
	,'' AS "Cost Clearing Account Segment12"
	,'' AS "Cost Clearing Account Segment13"
	,'' AS "Cost Clearing Account Segment14"
	,'' AS "Cost Clearing Account Segment15"
	,'' AS "Cost Clearing Account Segment16"
	,'' AS "Cost Clearing Account Segment17"
	,'' AS "Cost Clearing Account Segment18"
	,'' AS "Cost Clearing Account Segment19"
	,'' AS "Cost Clearing Account Segment20"
	,'' AS "Cost Clearing Account Segment21"
	,'' AS "Cost Clearing Account Segment22"
	,'' AS "Cost Clearing Account Segment23"
	,'' AS "Cost Clearing Account Segment24"
	,'' AS "Cost Clearing Account Segment25"
	,'' AS "Cost Clearing Account Segment26"
	,'' AS "Cost Clearing Account Segment27"
	,'' AS "Cost Clearing Account Segment28"
	,'' AS "Cost Clearing Account Segment29"
	,'' AS "Cost Clearing Account Segment30"
	,favl.ATTRIBUTE1 AS "ATTRIBUTE1"
	,--TEM O FLEX DEFINIDO
	favl.ATTRIBUTE2 AS "ATTRIBUTE2"
	,favl.ATTRIBUTE3 AS "ATTRIBUTE3"
	,favl.ATTRIBUTE4 AS "ATTRIBUTE4"
	-- ,FAI.VENDOR_NAME AS " SUPPLIER_NAME"
	-- ,PS.SEGMENT1 AS "SUPPLIER_NUMBER"
	-- ,FAI.PO_NUMBER AS "Purchase Order Number"
	-- ,FAI.INVOICE_NUMBER AS "Invoice Number"
	-- ,FAI.INVOICE_VOUCHER_NUMBER AS "Invoice Voucher Number"
	-- ,TO_CHAR(FAI.INVOICE_DATE, 'YYYY/MM/DD') AS "INVOICE DATE"
	-- ,FAI.PAYABLES_UNITS AS "Payables Units"
	-- ,FAI.INVOICE_LINE_NUMBER AS "Invoice Line Number"
	-- ,FAI.INVOICE_LINE_TYPE AS "Invoice Line Type"
	-- ,REPLACE(TRIM(FAI.INVOICE_LINE_DESCRIPTION), CHR(10), ' ') AS "Invoice Line Description"
	-- ,FAI.INVOICE_PAYMENT_NUMBER AS "Invoice Payment Number"
	-- ,FAI.PROJECT_NUMBER AS "Project Number"
	,'' AS "Task Number"
	,'' AS "Fully depreciate"
	,'' AS "Depreciation Factor"
	,'' AS "Revalued Cost"
	,'' AS "Backlog Depreciation Reserve"
	,'' AS "YTD Backlog Depreciation Reserve"
	,'' AS "Life-to-Date Revaluation Reserve Amortization"
	,'' AS "YTD Revaluation Reserve Amortization"
	,favl.ASSET_ID
FROM FA_BOOK_CONTROLS BKCTRL
	,FA_BOOKS FABOOKS
	,FA_ADDITIONS_VL favl
	,FA_METHODS fm
	,FA_CATEGORIES_VL FA_CATEGORY
	,FA_ASSET_KEYWORDS ASSETKEYWORDS
	,FA_CONVENTION_TYPES CT
	-- ,FA_DEPRN_PERIODS FDP
	-- ,fa_deprn_summary FDS
	-- ,FA_ASSET_INVOICES FAI
	,FA_CATEGORY_BOOKS FCB
	-- ,AP_INVOICES_ALL AIA
	,GL_CODE_COMBINATIONS GCC
-- ,POZ_SUPPLIERS PS
WHERE 1 = 1
	-- AND favl.ASSET_ID = FDS.ASSET_ID
	-- AND FDP.PERIOD_COUNTER = FDS.PERIOD_COUNTER
	-- AND FDS.BOOK_TYPE_CODE = FABOOKS.BOOK_TYPE_CODE
	AND FABOOKS.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
	AND favl.ASSET_ID = FABOOKS.ASSET_ID
	AND FABOOKS.METHOD_ID = fm.METHOD_ID(+)
	AND favl.ASSET_CATEGORY_ID = FA_CATEGORY.CATEGORY_ID(+)
	AND favl.ASSET_KEY_CCID = ASSETKEYWORDS.CODE_COMBINATION_ID(+)
	-- AND FABOOKS.BOOK_TYPE_CODE = FA_DISTRIB.BOOK_TYPE_CODE(+)
	-- AND favl.ASSET_ID = FA_DISTRIB.ASSET_ID(+)
	-- AND FA_DISTRIB.LOCATION_ID = FA_LOCATION.LOCATION_ID(+)
	---
	-- AND FA2.ASSET_ID(+) = FA1.PARENT_ASSET_ID
	-- AND AIA.INVOICE_ID(+) = FAI.INVOICE_ID
	-- AND favl.ASSET_ID = FAI.ASSET_ID(+)
	-- AND FABOOKS.BOOK_TYPE_CODE = FAI.BOOK_TYPE_CODE(+)
	AND FCB.ASSET_CLEARING_ACCOUNT_CCID = GCC.CODE_COMBINATION_ID
	AND FCB.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
	AND favl.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
	-- AND fds.DISTRIBUTION_ID = FA_DISTRIB.DISTRIBUTION_ID
	-- AND FA_DISTRIB.book_type_code = fds.book_type_code
	AND FABOOKS.CONVENTION_TYPE_ID = CT.CONVENTION_TYPE_ID(+)
	-- AND FA1.ASSET_ID = favl.ASSET_ID
	-- AND PS.VENDOR_ID(+) = AIA.VENDOR_ID
	AND NVL(FABOOKS.DATE_INEFFECTIVE, sysdate) >= sysdate
	--and fb.period between FABOOKS.DATE_EFFECTIVE NVL(FABOOKS.DATE_INEFFECTIVE, sysdate)
	-- AND NVL(FA_DISTRIB.DATE_INEFFECTIVE, sysdate) >= sysdate
	-- AND FDP.PERIOD_COUNTER IN (
	-- SELECT MAX(FDS1.PERIOD_COUNTER)
	-- FROM fa_deprn_summary FDS1
	-- WHERE FDS.ASSET_ID = FDS1.ASSET_ID
	-- AND FDS.BOOK_TYPE_CODE = FDS1.BOOK_TYPE_CODE
	-- )
	AND FABOOKS.COST <> 0
	-- AND favl.asset_number = '10885'
	AND FABOOKS.BOOK_TYPE_CODE = 'USA CORP'
ORDER BY favl.ASSET_NUMBER
)
SELECT DISTINCT ADDITIONS.asset_number
	,fdh.UNITS_ASSIGNED UNITS_ASSIGNED
	,PEA.EMAIL_ADDRESS EMPLOYEE_EMAIL_ADDRESS
	,FL.SEGMENT1
	,fl.SEGMENT2
	,fl.SEGMENT3
	,fl.SEGMENT4
	,fl.SEGMENT5
	,fl.SEGMENT6
	,fl.SEGMENT7
	,gcc.segment1 EXPENSE_ACCOUNT_SEGMENT1
	,GCC.SEGMENT2 EXPENSE_ACCOUNT_SEGMENT2
	,GCC.SEGMENT3 EXPENSE_ACCOUNT_SEGMENT3
	,GCC.SEGMENT4 EXPENSE_ACCOUNT_SEGMENT4
	,GCC.SEGMENT5 EXPENSE_ACCOUNT_SEGMENT5
	,GCC.SEGMENT6 EXPENSE_ACCOUNT_SEGMENT6
	,GCC.SEGMENT7 EXPENSE_ACCOUNT_SEGMENT7
	,GCC.SEGMENT8 EXPENSE_ACCOUNT_SEGMENT8
FROM FA_LOCATIONS FL
	,FA_DISTRIBUTION_HISTORY fdh
	,ADDITIONS
	,gl_code_combinations gcc
	,per_persons pp
	,PER_EMAIL_ADDRESSES pea
WHERE fdh.LOCATION_ID = fl.LOCATION_ID(+)
	AND fdh.code_combination_id = gcc.code_combination_id
	AND fdh.ASSIGNED_TO = pp.PERSON_ID(+)
	AND pea.person_id(+) = pp.person_id
	AND ADDITIONS.asset_id = fdh.asset_id
	AND FDH.TRANSACTION_HEADER_ID_OUT IS NULL
	AND FDH.DATE_INEFFECTIVE IS NULL
ORDER BY asset_number
