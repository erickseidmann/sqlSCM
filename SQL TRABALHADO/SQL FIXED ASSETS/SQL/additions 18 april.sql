SELECT DISTINCT BKCTRL.BOOK_TYPE_CODE ASSET_BOOK
	,'' TRANSACTION_NAME
	,favl.ASSET_NUMBER ASSET_NUMBER
	,favl.DESCRIPTION ASSET_DESCRIPTION
	,'' Tag_Number
	,favl.MANUFACTURER_NAME MANUFACTURER
	,favl.SERIAL_NUMBER SERIAL_NUMBER
	,favl.MODEL_NUMBER MODEL
	,favl.ASSET_TYPE ASSET_TYPE
	,FABOOKS.COST COST
	,TO_CHAR(FABOOKS.DATE_PLACED_IN_SERVICE, 'YYYY/MM/DD') Date_Placed_in_Service
	,CT.DESCRIPTION PRORATE_CONVENTION
	,favl.CURRENT_UNITS ASSET_UNITS
	,FA_CATEGORY.SEGMENT1 Asset_Category_Segment1
	,FA_CATEGORY.SEGMENT2 Asset_Category_Segment2
	,'NEW' POSTING_STATUS
	,'NEW' QUEUE_NAME
	,ASSETKEYWORDS.SEGMENT1 ASSET_KEY_SEGMENT1
	,ASSETKEYWORDS.SEGMENT2 ASSET_KEY_SEGMENT2
	,ASSETKEYWORDS.SEGMENT3 ASSET_KEY_SEGMENT3
	,favl.INVENTORIAL In_physical_inventory
	,favl.PROPERTY_TYPE_CODE PROPERTY_TYPE
	,favl.PROPERTY_1245_1250_CODE PROPERTY_CLASS
	,favl.IN_USE_FLAG In_use
	,favl.OWNED_LEASED OWNERSHIP
	,favl.NEW_USED BOUGHT
	,FABOOKS.DEPRECIATE_FLAG DEPRECIATE
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
	,fm.METHOD_CODE Depreciation_Method
	,fm.LIFE_IN_MONTHS Life_in_Months
	,GCC.SEGMENT1 COST_CLEARING_SEGMENT1
	,GCC.SEGMENT2 COST_CLEARING_SEGMENT2
	,GCC.SEGMENT3 COST_CLEARING_SEGMENT3
	,GCC.SEGMENT4 COST_CLEARING_SEGMENT4
	,GCC.SEGMENT5 COST_CLEARING_SEGMENT5
	,GCC.SEGMENT6 COST_CLEARING_SEGMENT6
	,GCC.SEGMENT7 COST_CLEARING_SEGMENT7
	,GCC.SEGMENT8 COST_CLEARING_SEGMENT8
	,favl.ATTRIBUTE1 ATTRIBUTE1
	,favl.ATTRIBUTE2 ATTRIBUTE2
	,favl.ATTRIBUTE3 ATTRIBUTE3
	,favl.ATTRIBUTE4 ATTRIBUTE4
	,favl.ASSET_ID
FROM FA_BOOK_CONTROLS BKCTRL
	,FA_BOOKS FABOOKS
	,FA_ADDITIONS_VL favl
	,FA_METHODS fm
	,FA_CATEGORIES_VL FA_CATEGORY
	,FA_ASSET_KEYWORDS ASSETKEYWORDS
	,FA_CONVENTION_TYPES CT
	,FA_CATEGORY_BOOKS FCB
	,GL_CODE_COMBINATIONS GCC
WHERE 1 = 1
	AND FABOOKS.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
	AND favl.ASSET_ID = FABOOKS.ASSET_ID
	AND FABOOKS.METHOD_ID = fm.METHOD_ID(+)
	AND favl.ASSET_CATEGORY_ID = FA_CATEGORY.CATEGORY_ID(+)
	AND favl.ASSET_KEY_CCID = ASSETKEYWORDS.CODE_COMBINATION_ID(+)
	AND FCB.ASSET_CLEARING_ACCOUNT_CCID = GCC.CODE_COMBINATION_ID
	AND FCB.BOOK_TYPE_CODE = BKCTRL.BOOK_TYPE_CODE
	AND favl.ASSET_CATEGORY_ID = FCB.CATEGORY_ID
	AND FABOOKS.CONVENTION_TYPE_ID = CT.CONVENTION_TYPE_ID(+)
	AND NVL(FABOOKS.DATE_INEFFECTIVE, sysdate) >= sysdate
	AND favl.asset_id NOT IN (
		SELECT fr.asset_id
		FROM fa_retirements fr
			,fa_tRANSACTION_HEADERS fth
		WHERE fr.asset_id = favl.asset_id
			AND fr.BOOK_TYPE_CODE = FABOOKS.book_type_code
			AND fr.TRANSACTION_header_id_out IS NULL
			AND fr.TRANSACTION_header_id_in = fth.TRANSACTION_header_id
			AND TRANSACTION_type_code = 'FULL RETIREMENT'
		)
	AND FABOOKS.BOOK_TYPE_CODE = 'USA CORP'
	AND favl.ASSET_TYPE <> 'EXPENSED'
