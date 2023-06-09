SELECT DISTINCT
    '28032025' as "Import Batch Identifier",
    payee.EXT_PAYEE_ID as "Payee Identifier",
    bu_tl.NAME as "Business Unit Name",
    ps.SEGMENT1 as "Supplier Number",
    pssm.VENDOR_SITE_CODE as "Supplier Site",
    payee.EXCLUSIVE_PAYMENT_FLAG as "Pay Each Document Alone",
    payee.DEFAULT_PAYMENT_METHOD_CODE as "Payment Method Code",
    payee.DELIVERY_CHANNEL_CODE as "Delivery Channel Code",
    payee.SETTLEMENT_PRIORITY as "Settlement Priority",
    payee.REMIT_ADVICE_DELIVERY_METHOD as "Remit Delivery Method",
    payee.REMIT_ADVICE_EMAIL as "Remit Advice Email",
    payee.REMIT_ADVICE_FAX as "Remit Advice Fax",
    payee.BANK_INSTRUCTION1_CODE as "Bank Instructions 1",
    payee.BANK_INSTRUCTION2_CODE as "Bank Instructions 2",
    payee.BANK_INSTRUCTION_DETAILS as "Bank Instruction Details",
    payee.PAYMENT_REASON_CODE as "Payment Reason Code",
    payee.PAYMENT_REASON_COMMENTS as "Payment Reason Comments",
    payee.PAYMENT_TEXT_MESSAGE1 as "Payment Message1",
    payee.PAYMENT_TEXT_MESSAGE2 as "Payment Message2",
    payee.PAYMENT_TEXT_MESSAGE3 as "Payment Message3",
    payee.BANK_CHARGE_BEARER as "Bank Charge Bearer Code"

FROM
    poz_suppliers            ps     ,
    poz_supplier_sites_all_m pssm   ,
    iby_external_payees_all  payee  ,
    iby_pmt_instr_uses_all   uses   ,
    hr_organization_units_f_tl bu_tl

WHERE
        ps.vendor_id            = pssm.vendor_id
AND     ps.party_id             = payee.payee_party_id
AND     payee.supplier_site_id  = pssm.vendor_site_id
AND     uses.instrument_type    = 'BANKACCOUNT'
AND     payee.ext_payee_id      = uses.ext_pmt_party_id
AND     uses.payment_function   = 'PAYABLES_DISB'
AND     payee.org_id            = bu_tl.organization_id(+)
AND     SYSDATE BETWEEN NVL(uses.start_date,SYSDATE) AND     NVL(uses.end_date,SYSDATE)
AND     NVL(ps.end_date_active,SYSDATE+1) > TRUNC (SYSDATE)
AND     NVL(pssm.inactive_date,SYSDATE+1) > TRUNC (SYSDATE)