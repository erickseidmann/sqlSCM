select distinct
HEADER.SEGMENT1 "Order",
LINE.LINE_NUM as "Line Number",
LINE_TYPE.LINE_TYPE_CODE as "Type",
EGP.ITEM_NUMBER as "ITEM",
REPLACE(TRIM(LINE.ITEM_DESCRIPTION),CHR(10),' ')  as "Description",
LINE.QUANTITY as "Quantity",
LINE.SHIPPING_UOM_CODE as "UOM",
LINE.unit_PRICE as "Price",
LINE_LOCATION.ASSESSABLE_VALUE as "ORDERED",
LINE.TAX_EXCLUSIVE_PRICE as "TOTAL TAX",
LINE_LOCATION.ASSESSABLE_VALUE as "TOTAL",
HEADER.DOCUMENT_STATUS as "STATUS",
nvl((
			SELECT max(hl.description)
			FROM hr_locations_all_f_vl hl
			WHERE 1 = 1
				AND hl.location_id = pola.ship_to_location_id
			), (
			SELECT max(address1 || '' || city || ',' || STATE || ',' || postal_code)
			FROM hz_locations hl
			WHERE 1 = 1
				AND hl.location_id = pola.ship_to_cust_location_id
			)) as "Location",
TO_CHAR(LINE_LOCATION.NEED_BY_DATE, 'YYYY/MM/DD') as "Requested Delivery Date",
TO_CHAR(LINE_LOCATION.PROMISED_DATE, 'YYYY/MM/DD') as "Promised Delivery Date",
HEADER.MODE_OF_TRANSPORT as "Shipping Method",
LINE.ITEM_REVISION as "REVISION",
CATEGORIES.category_name as "Category name",
nvl((
			SELECT max(hl.description)
			FROM hr_locations_all_f_vl hl
			WHERE 1 = 1
				AND hl.location_id = pola.ship_to_location_id
			), (
			SELECT max(address1 || '' || city || ',' || STATE || ',' || postal_code)
			FROM hz_locations hl
			WHERE 1 = 1
				AND hl.location_id = pola.ship_to_cust_location_id
			)) as "Deliver to location",
LINE_LOCATION.DESTINATION_TYPE_CODE as "Destination Type",
LINE.HAZARD_CLASS_ID as "HAZARD CLASS",
LINE_LOCATION.INVOICE_CLOSE_TOLERANCE as "invoice close tolerance percentage",
case LINE_LOCATION.MATCH_OPTION
    when 'P' then 'Order'
    when 'R' then 'Receipt'
    else NULL
end as "Invoice Match Option",
'3-Way' as "MATCH APPROVAL LEVEL",
LINE.NEGOTIATED_BY_PREPARER_FLAG as "Negotiated",
SHIP_TO_ORGANIZATION.ORGANIZATION_CODE as "organization", 
COMBINATIONS.SEGMENT1 as "po_charge_account_SEGMENT1",
COMBINATIONS.SEGMENT2 as "po_charge_account_SEGMENT2", 
COMBINATIONS.SEGMENT3 as "po_charge_account_SEGMENT3", 
COMBINATIONS.SEGMENT4 as "po_charge_account_SEGMENT4", 
COMBINATIONS.SEGMENT5 as "po_charge_account_SEGMENT5", 
COMBINATIONS.SEGMENT6 as "po_charge_account_SEGMENT6", 
COMBINATIONS.SEGMENT7 as "po_charge_account_SEGMENT7", 
COMBINATIONS.SEGMENT8 as "po_charge_account_SEGMENT8", 
BUYER_NAME.FULL_NAME as "Requester",
PRHA.REQUISITION_NUMBER as "REQUISITIONS",
LINE.VENDOR_PRODUCT_NUM as "Supplier Item",
LINE.MANUFACTURER as "MANUFACTURER",
LINE.MANUFACTURER_PART_NUM as "manufacturer part number",
BPA.SEGMENT1 as "Source_agreement",
LINE.SECONDARY_QUANTITY as "SECONDARY QUANTITY",
LINE.SECONDARY_UOM_CODE as "SECONDARY UOM",
pla.line_num as "Source Agreement Line",
pdt.type_name as "Source Agreement Document Type",
PROCUREMENT_BUSINESS_UNIT_TL.NAME as "Source Agreement Procurement BU",
'' as "subinventory",
'' as "supplier configuration id",
REPLACE(TRIM(HEADER.NOTE_TO_VENDOR),CHR(10),' ') AS "Note to Supplier",
LINE_LOCATION.PRODUCT_TYPE as "Product Type",
LINE_LOCATION.PRODUCT_CATEGORY as "Product Category",
LINE_LOCATION.INPUT_TAX_CLASSIFICATION_CODE as "Tax Classification",
LINE_LOCATION.ASSESSABLE_VALUE as "ASSESSABLE VALUE",
LINE_LOCATION.FINAL_DISCHARGE_LOCATION_ID as "location of final discharge",
DISTRIBUTION.PJC_PROJECT_ID as "Project Number",
DISTRIBUTION.PJC_TASK_ID as "Task Number",
DISTRIBUTION.PJC_EXPENDITURE_ITEM_DATE as "Expenditure Item Date",
DISTRIBUTION.PJC_EXPENDITURE_TYPE_ID as "Expenditure Item Type",
DISTRIBUTION.PJC_ORGANIZATION_ID as "Expenditure Organization",
LINE.CONTRACT_ID as "Contract Number",
LINE.ATTRIBUTE1 as "company name",
LINE.ATTRIBUTE2 as "PO status note",
LINE.ATTRIBUTE3 as "cep number"

FROM
PO_LINES_ALL LINE
    left join PO_LINE_LOCATIONS_ALL LINE_LOCATION
        on LINE.PO_LINE_ID = LINE_LOCATION.PO_LINE_ID
    left join PO_HEADERS_ALL HEADER
        on LINE.PO_HEADER_ID = HEADER.PO_HEADER_ID
    left join PO_HEADERS_ALL BPA
        on LINE_LOCATION.FROM_HEADER_ID = BPA.PO_HEADER_ID
    left join PO_LINES_ALL PLA
        ON LINE_LOCATION.FROM_HEADER_ID = PLA.PO_HEADER_ID
        AND LINE_LOCATION.FROM_LINE_ID = PLA.PO_LINE_ID
    left join PO_DOCUMENT_TYPES_ALL_B DOCUMENT_TYPE
        on HEADER.TYPE_LOOKUP_CODE = DOCUMENT_TYPE.DOCUMENT_SUBTYPE
        and LINE.PRC_BU_ID = DOCUMENT_TYPE.PRC_BU_ID
    left join PO_LINE_TYPES_B LINE_TYPE
        on LINE.LINE_TYPE_ID = LINE_TYPE.LINE_TYPE_ID
    left join EGP_CATEGORIES_TL CATEGORIES
        on LINE.CATEGORY_ID = CATEGORIES.CATEGORY_ID
    LEFT JOIN egp_system_items EGP
        on LINE.ITEM_ID = EGP.INVENTORY_ITEM_ID
    left join PO_UN_NUMBERS_B UN_NUMBER
        on LINE.UN_NUMBER_ID = UN_NUMBER.UN_NUMBER_ID
    left join HR_LOCATIONS_ALL SHIP_TO_LOCATION
        on LINE_LOCATION.SHIP_TO_LOCATION_ID = SHIP_TO_LOCATION.LOCATION_ID
    left join PO_DISTRIBUTIONS_ALL DISTRIBUTION
        ON LINE_LOCATION.LINE_LOCATION_ID = DISTRIBUTION.LINE_LOCATION_ID  
    left join GL_CODE_COMBINATIONS COMBINATIONS
        on DISTRIBUTION.CODE_COMBINATION_ID = COMBINATIONS.CODE_COMBINATION_ID
    left join HR_ORGANIZATION_UNITS_F_TL PROCUREMENT_BUSINESS_UNIT_TL
        on HEADER.PRC_BU_ID = PROCUREMENT_BUSINESS_UNIT_TL.ORGANIZATION_ID
    left join INV_ORG_PARAMETERS SHIP_TO_ORGANIZATION
        on LINE_LOCATION.SHIP_TO_ORGANIZATION_ID = SHIP_TO_ORGANIZATION.ORGANIZATION_ID
    left join (
        select distinct
            PERSON_ID,
            FULL_NAME
        from
            PER_PERSON_NAMES_F
        where
            NAME_TYPE = 'US'
    ) BUYER_NAME
        on DISTRIBUTION.DELIVER_TO_PERSON_ID = BUYER_NAME.PERSON_ID
    left join POR_REQ_DISTRIBUTIONS_ALL PRDA
        on DISTRIBUTION.REQ_DISTRIBUTION_ID = PRDA.DISTRIBUTION_ID
    left join POR_REQUISITION_LINES_ALL PRLA
        on PRDA.REQUISITION_LINE_ID = PRLA.REQUISITION_LINE_ID
    left join POR_REQUISITION_HEADERS_ALL PRHA
        on PRLA.REQUISITION_HEADER_ID = PRHA.REQUISITION_HEADER_ID
    left join PO_DOCUMENT_TYPES_ALL_TL pdt
        on BPA.type_lookup_code = pdt.DOCUMENT_SUBTYPE
    left join po_line_locations_all pola
        on LINE.po_line_id = pola.po_line_id
    
where
    HEADER.DOCUMENT_STATUS = 'OPEN'
    and LINE_LOCATION.ASSESSABLE_VALUE <> '0'
order by
    HEADER.SEGMENT1