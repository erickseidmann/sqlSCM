select distinct
HEADER.PO_HEADER_ID as "Interface Header Key",
'ORIGINAL' as "Action",
'100' as "Batch ID",
HEADER.INTERFACE_SOURCE_CODE AS "Import Source",
'BYPASS' as "Approval Action",
HEADER.segment1 as "Order",
HEADER.TYPE_LOOKUP_CODE as "Document Type Code",
'' as "Style",
PROCUREMENT_BUSINESS_UNIT_TL.NAME as "Procurement BU",
REQUISITIONING_BU_TL.NAME as "Requisitioning BU",
xle.name as "sold to legal entity",
BILL_TO_BU_TL.NAME as "Bill-to BU",
BUYER_NAME.FULL_NAME as "Buyer",
HEADER.CURRENCY_CODE as "Currency Code",
'' as "RATE",
'' as "RATE TYPE",
'' as "Rate Date",
REPLACE(TRIM(HEADER.COMMENTS),CHR(10),' ')  as "Description",
BILL_TO_LOCATION.LOCATION_CODE as "Bill To Location",
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
SUPPLIER.VENDOR_NAME as "Supplier",
'' as "Supplier Number",
SUPPLIER_SITE.VENDOR_SITE_CODE as "Supplier Site",
'' as "Supplier Contact",
'' as "Supplier Order",
HEADER.FOB_LOOKUP_CODE as "Fob",
'' as "Carrier",
--FREIGHT_CARRIER.PARTY_NAME as "Carrier", 
HEADER.FREIGHT_TERMS_LOOKUP_CODE as "Freight Terms",
HEADER.PAY_ON_CODE as "Pay On Code",
TERM_TL.NAME as "Payment Terms",
VERSION.ORIGINATOR_ROLE as "Initiating Party",
HEADER.ACCEPTANCE_REQUIRED_FLAG as "Required Acknowledgment",
'' as "Acknowledge Within (Days)",
'NONE' as "Communication Method",
'' as "fax",
'' as "TO email",
HEADER.CONFIRMING_ORDER_FLAG as "Confirming order",
REPLACE(TRIM(HEADER.NOTE_TO_VENDOR),CHR(10),' ') AS "Note to Supplier",
REPLACE(TRIM(HEADER.NOTE_TO_RECEIVER),CHR(10),' ') AS "Note to Receiver",
'' AS "Default Taxation Country Code",
'' as "Tax_Document_Subtype_Code",
'' as ATTRIBUTE_CATEGORY,
HEADER.ATTRIBUTE1 as ATTRIBUTE1,
'' as "ATTRIBUTE2",
'' as "ATTRIBUTE3",
'' as "ATTRIBUTE4",
'' as "ATTRIBUTE5",
'' as "ATTRIBUTE6",
'' as "ATTRIBUTE7",
'' as "ATTRIBUTE8",
'' as "ATTRIBUTE9",
'' as "ATTRIBUTE10",
'' as "ATTRIBUTE11",
'' as "ATTRIBUTE12",
'' as "ATTRIBUTE13",
'' as "ATTRIBUTE14",
'' as "ATTRIBUTE15",
'' as "ATTRIBUTE16",
'' as "ATTRIBUTE17",
'' as "ATTRIBUTE18",
'' as "ATTRIBUTE19",
'' as "ATTRIBUTE20",
'' as "ATTRIBUTE_DATE1",
'' as "ATTRIBUTE_DATE2",
'' as "ATTRIBUTE_DATE3",
'' as "ATTRIBUTE_DATE4",
'' as "ATTRIBUTE_DATE5",
'' as "ATTRIBUTE_DATE6",
'' as "ATTRIBUTE_DATE7",
'' as "ATTRIBUTE_DATE8",
'' as "ATTRIBUTE_DATE9",
'' as "ATTRIBUTE_DATE10",
'' as "ATTRIBUTE_NUMBER1",
'' as "ATTRIBUTE_NUMBER2",
'' as "ATTRIBUTE_NUMBER3",
'' as "ATTRIBUTE_NUMBER4",
'' as "ATTRIBUTE_NUMBER5",
'' as "ATTRIBUTE_NUMBER6",
'' as "ATTRIBUTE_NUMBER7",
'' as "ATTRIBUTE_NUMBER8",
'' as "ATTRIBUTE_NUMBER9",
'' as "ATTRIBUTE_NUMBER10",
'' as "ATTRIBUTE_TIMESTAMP1",
'' as "ATTRIBUTE_TIMESTAMP2",
'' as "ATTRIBUTE_TIMESTAMP3",
'' as "ATTRIBUTE_TIMESTAMP4",
'' as "ATTRIBUTE_TIMESTAMP5",
'' as "ATTRIBUTE_TIMESTAMP6",
'' as "ATTRIBUTE_TIMESTAMP7",
'' as "ATTRIBUTE_TIMESTAMP8",
'' as "ATTRIBUTE_TIMESTAMP9",
'' as "ATTRIBUTE_TIMESTAMP10",
'' as "Buyer E-mail",
HEADER.MODE_OF_TRANSPORT as "Mode of Transport",
'' as "Service Level",
'' as "First_Party_Tax_Registration_Number",
'' as "Third_Party_Tax_Registration_Number",
HEADER.BUYER_MANAGED_TRANSPORT_FLAG as "Buyer Managed Transportation",
'' as "Master Contract Number",
'' as "Master Contract Type",
'' as "Cc Email",
'' as "Bcc Email",
'' as "GLOBAL_ATTRIBUTE1",
'' as "GLOBAL_ATTRIBUTE2",
'' as "GLOBAL_ATTRIBUTE3",
'' as "GLOBAL_ATTRIBUTE4",
'' as "GLOBAL_ATTRIBUTE5",
'' as "GLOBAL_ATTRIBUTE6" 

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