select distinct
HEADER.PO_HEADER_ID as "Interface Header Key",
'ORIGINAL' as "Action",
'100' as "Batch ID",
'BYPASS' as "Approval Action",
HEADER.segment1 as "Order",
REPLACE(TRIM(HEADER.COMMENTS),CHR(10),' ')  as "Description",
TO_CHAR(HEADER.creation_date, 'YYYY/MM/DD') as creation_date,
HEADER.DOCUMENT_STATUS as "Header Status",
PROCUREMENT_BUSINESS_UNIT_TL.NAME as "Procurement BU",
REQUISITIONING_BU_TL.NAME as "Requisitioning BU",
SUPPLIER.VENDOR_NAME as "Supplier",
SUPPLIER_SITE.VENDOR_SITE_CODE as "Supplier Site",
--SUPPLIER_SITE.VENDOR_DOC_NUM as "Supplier order",
--SUPPLIER_SITE.VENDOR_CONTACT as "Supplier Contact",
xle.name as "sold to legal entity",
HEADER.SUPPLIER_NOTIF_METHOD as "Communication Method",
BILL_TO_LOCATION.LOCATION_CODE as "Bill To Location",
--SHIP_TO_LOCATION.LOCATION_CODE as "Ship-to Location",
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
			)) as "Ship-to Location",
HEADER.GROUP_REQUISITIONS as "REQUISITIONS",
HEADER.INTERFACE_SOURCE_CODE AS "Import Source",
BUYER_NAME.FULL_NAME as "Buyer",
LINE.TAX_EXCLUSIVE_PRICE as "TOTAL TAX",
--LINE_LOCATION.ASSESSABLE_VALUE as "ORDERED",
--SUM(LINE_LOCATION.ASSESSABLE_VALUE) AS total_sum,
TERM_TL.NAME as "Payment Terms",
HEADER.MODE_OF_TRANSPORT as "Shipping Method",
HEADER.FREIGHT_TERMS_LOOKUP_CODE as "Freight Terms",
HEADER.FOB_LOOKUP_CODE as "Fob",
HEADER.PAY_ON_CODE as "Pay On Code",
HEADER.CONFIRMING_ORDER_FLAG as "Confirming order",
REPLACE(TRIM(HEADER.NOTE_TO_VENDOR),CHR(10),' ') AS "Note to Supplier",
REPLACE(TRIM(HEADER.NOTE_TO_RECEIVER),CHR(10),' ') AS "Note to Receiver",
HEADER.PAY_ON_USE_FLAG as "Pay On Receipt",
HEADER.ATTRIBUTE1 as "Capital Expenditure Type"

from
PO_HEADERS_ALL HEADER   
    LEFT JOIN PO_LINES_ALL LINE
       on HEADER.PO_HEADER_ID = LINE.PO_HEADER_ID 
    LEFT JOIN PO_LINE_LOCATIONS_ALL LINE_LOCATION
        ON  LINE.PO_LINE_ID  = LINE_LOCATION.PO_LINE_ID
    left join XLE_ENTITY_PROFILES XLE
        on HEADER.SOLDTO_LE_ID = XLE.LEGAL_ENTITY_ID
    left join PO_DOCUMENT_TYPES_ALL_B DOCUMENT_TYPE
        on HEADER.TYPE_LOOKUP_CODE = DOCUMENT_TYPE.DOCUMENT_SUBTYPE
    left join PO_DOC_STYLE_HEADERS DOCUMENT_STYLE
        on HEADER.STYLE_ID = DOCUMENT_STYLE.STYLE_ID
    left join HR_ORGANIZATION_UNITS_F_TL PROCUREMENT_BUSINESS_UNIT_TL
        on HEADER.PRC_BU_ID = PROCUREMENT_BUSINESS_UNIT_TL.ORGANIZATION_ID
        and PROCUREMENT_BUSINESS_UNIT_TL.LANGUAGE = 'US'
    left join HR_ORGANIZATION_UNITS_F_TL REQUISITIONING_BU_TL
        on HEADER.REQ_BU_ID = REQUISITIONING_BU_TL.ORGANIZATION_ID
        and REQUISITIONING_BU_TL.LANGUAGE = 'US'
    left join HR_ORGANIZATION_UNITS_F_TL BILL_TO_BU_TL
        on HEADER.BILLTO_BU_ID = BILL_TO_BU_TL.ORGANIZATION_ID
        and BILL_TO_BU_TL.LANGUAGE = 'US'
    left join (
        select distinct
            PERSON_ID,
            FULL_NAME
        from
            PER_PERSON_NAMES_F
        where
            NAME_TYPE = 'US'
    ) BUYER_NAME
        on HEADER.AGENT_ID = BUYER_NAME.PERSON_ID
    left join POZ_SUPPLIERS_SIMPLE_V SUPPLIER
        on HEADER.VENDOR_ID = SUPPLIER.VENDOR_ID
    left join POZ_SUPPLIER_SITES_ALL_M SUPPLIER_SITE
        on HEADER.VENDOR_SITE_ID = SUPPLIER_SITE.VENDOR_SITE_ID
    left join HZ_PARTIES FREIGHT_CARRIER
        on HEADER.CARRIER_ID = FREIGHT_CARRIER.PARTY_ID
    left join AP_TERMS_TL TERM_TL
        on HEADER.TERMS_ID = TERM_TL.TERM_ID
        and TERM_TL.LANGUAGE = 'US'
    left join HR_LOCATIONS_ALL BILL_TO_LOCATION
        on HEADER.BILL_TO_LOCATION_ID = BILL_TO_LOCATION.LOCATION_ID
    left join HR_LOCATIONS_ALL SHIP_TO_LOCATION
        on HEADER.SHIP_TO_LOCATION_ID = SHIP_TO_LOCATION.LOCATION_ID
    left join (
        select
            PO_HEADER_ID,
            ORIGINATOR_ROLE,
            CHANGE_ORDER_DESC
        from
            PO_VERSIONS
        where
            CO_SEQUENCE = 0
    ) VERSION
        on HEADER.PO_HEADER_ID = VERSION.PO_HEADER_ID
    left join (
        select 
        distinct
            PERSON_ID,
            EMAIL_ADDRESS
        from
            PER_EMAIL_ADDRESSES
    ) BUYER_EMAIL
        on HEADER.AGENT_ID = BUYER_EMAIL.PERSON_ID
    left join po_line_locations_all pola
        on LINE.po_line_id = pola.po_line_id
    
where
    HEADER.DOCUMENT_STATUS ='OPEN'
    and LINE_LOCATION.ASSESSABLE_VALUE <> '0'
    and HEADER.segment1 ='PUSA9020028956'