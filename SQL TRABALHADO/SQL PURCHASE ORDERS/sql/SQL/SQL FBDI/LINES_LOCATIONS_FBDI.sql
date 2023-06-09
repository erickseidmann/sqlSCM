select distinct

LINE_LOCATION.LINE_LOCATION_ID  as "Interface Line Location Key",
LINE.PO_LINE_ID as "Interface Line Key",
LINE_LOCATION.SHIPMENT_NUM as "Schedule",
SHIP_TO_LOCATION.LOCATION_CODE as "Ship-to Location",
SHIP_TO_ORGANIZATION.ORGANIZATION_CODE as "Ship-to Organization",
LINE_LOCATION.ASSESSABLE_VALUE as "AMOUNT",
LINE.QUANTITY as "Quantity",
TO_CHAR(LINE_LOCATION.NEED_BY_DATE, 'YYYY/MM/DD') as "Need-by Date",
TO_CHAR(LINE_LOCATION.PROMISED_DATE, 'YYYY/MM/DD') as "Promised Date",
LINE_LOCATION.SECONDARY_QUANTITY_RECEIVED as "Secondary Quantity",
LINE_LOCATION.SECONDARY_UOM_CODE as "Secondary UOM",
LINE_LOCATION.DESTINATION_TYPE_CODE as "Destination Type Code",
LINE_LOCATION.ACCRUE_ON_RECEIPT_FLAG as "Accrue at receipt",
LINE_LOCATION.ALLOW_SUBSTITUTE_RECEIPTS_FLAG as "Allow substitute receipts",
LINE_LOCATION.ASSESSABLE_VALUE as "Assessable Value",
LINE_LOCATION.DAYS_EARLY_RECEIPT_ALLOWED as "Early Receipt Tolerance in Days",
LINE_LOCATION.DAYS_LATE_RECEIPT_ALLOWED as "Late Receipt Tolerance in Days",
LINE_LOCATION.ENFORCE_SHIP_TO_LOCATION_CODE as "Enforce Ship to Location Code",
LINE_LOCATION.INSPECTION_REQUIRED_FLAG  as "Inspection Required",
LINE_LOCATION.RECEIPT_REQUIRED_FLAG as "Receipt Required",
LINE_LOCATION.INVOICE_CLOSE_TOLERANCE as "Invoice Close Tolerance Percent",
LINE_LOCATION.QTY_RCV_TOLERANCE as "Receipt Close Tolerance Percent",
LINE_LOCATION.QTY_RCV_TOLERANCE as "Qty Rcv Tolerance",
LINE_LOCATION.QTY_RCV_EXCEPTION_CODE as "Qty Rcv Exception Code",
LINE_LOCATION.RECEIPT_DAYS_EXCEPTION_CODE as "Receipt Days Exception Code",
CASE LINE_LOCATION.RECEIVING_ROUTING_ID 
        WHEN 1 THEN 'Standard Receipt'
        WHEN 2 THEN 'Inspection Required'
        WHEN 3 THEN 'Direct Delivery'
        ELSE 'Unknown'
    END AS "Receipt Routing",
LINE_LOCATION.NOTE_TO_RECEIVER  as "Note to receiver",
LINE_LOCATION.INPUT_TAX_CLASSIFICATION_CODE as "Tax Classification CODE",
LINE_LOCATION.LINE_INTENDED_USE as "Intended Use",
LINE_LOCATION.PRODUCT_CATEGORY as "Product Category code",
LINE_LOCATION.PRODUCT_FISC_CLASSIFICATION as "Product Fiscal Classification",
LINE_LOCATION.PRODUCT_TYPE as "Product Type Code",
LINE_LOCATION.TRX_BUSINESS_CATEGORY as "Transaction Business Category code",
LINE_LOCATION.USER_DEFINED_FISC_CLASS as "User-Defined Fiscal Classification Code",
'' as "ATTRIBUTE_CATEGORY",
'' as "ATTRIBUTE1",
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
LINE_LOCATION.CARRIER_ID as "Carrier",
HEADER.MODE_OF_TRANSPORT as "Mode of Transport",
LINE_LOCATION.SERVICE_LEVEL as "Service Level",
LINE_LOCATION.FINAL_DISCHARGE_LOCATION_ID as "Final discharge location code",
LINE_LOCATION.REQUESTED_SHIP_DATE  as "Requested Ship Date",
TO_CHAR(LINE_LOCATION.PROMISED_DATE, 'YYYY/MM/DD') as "Promised Ship  Date",
TO_CHAR(LINE_LOCATION.NEED_BY_DATE, 'YYYY/MM/DD') as "Requested Delivery Date",
TO_CHAR(LINE_LOCATION.PROMISED_DATE, 'YYYY/MM/DD') as "Promised Delivery Date",
LINE_LOCATION.RETAINAGE_RATE as "Retainage Rate (%)",
case LINE_LOCATION.MATCH_OPTION
    when 'P' then 'Order'
    when 'R' then 'Receipt'
    else NULL
end as "Invoice Match Option",
'' as "GLOBAL_ATTRIBUTE1",
'' as "GLOBAL_ATTRIBUTE_NUMBER1"


from

PO_LINE_LOCATIONS_ALL LINE_LOCATION 
    LEFT JOIN PO_LINES_ALL LINE
        ON LINE_LOCATION.PO_LINE_ID = LINE.PO_LINE_ID
    left join PO_DISTRIBUTIONS_ALL DISTRIBUTION
        ON LINE_LOCATION.LINE_LOCATION_ID = DISTRIBUTION.LINE_LOCATION_ID
    left join PO_HEADERS_ALL HEADER
        on LINE_LOCATION.PO_HEADER_ID = HEADER.PO_HEADER_ID
    left join GL_CODE_COMBINATIONS COMBINATIONS
        on DISTRIBUTION.CODE_COMBINATION_ID = COMBINATIONS.CODE_COMBINATION_ID
    left join PO_DOCUMENT_TYPES_ALL_B DOCUMENT_TYPE
        on HEADER.TYPE_LOOKUP_CODE = DOCUMENT_TYPE.DOCUMENT_SUBTYPE
        and LINE_LOCATION.PRC_BU_ID = DOCUMENT_TYPE.PRC_BU_ID
    left join HR_LOCATIONS_ALL SHIP_TO_LOCATION
        on LINE_LOCATION.SHIP_TO_LOCATION_ID = SHIP_TO_LOCATION.LOCATION_ID
    left join INV_ORG_PARAMETERS SHIP_TO_ORGANIZATION
        on LINE_LOCATION.SHIP_TO_ORGANIZATION_ID = SHIP_TO_ORGANIZATION.ORGANIZATION_ID
    LEFT JOIN egp_system_items EGP
        on LINE.ITEM_ID = EGP.INVENTORY_ITEM_ID
    -- left join RCV_ROUTING_HEADERS RECEIVING_ROUTE
    --     on LINE_LOCATION.RECEIVING_ROUTING_ID = RECEIVING_ROUTE.SHIPMENT_HEADER_ID
    -- left join HR_LOCATIONS_ALL FINAL_DISCHARGE_LOCATION
    --     on LINE_LOCATION.FINAL_DISCHARGE_LOCATION_ID = SHIP_TO_LOCATION.LOCATION_ID
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
where
    HEADER.DOCUMENT_STATUS ='OPEN'
and LINE_LOCATION.ASSESSABLE_VALUE <> '0'
