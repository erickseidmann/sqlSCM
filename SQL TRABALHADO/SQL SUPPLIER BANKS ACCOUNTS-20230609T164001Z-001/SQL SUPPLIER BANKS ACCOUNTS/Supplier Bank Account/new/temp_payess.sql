SELECT DISTINCT
    '28032025' as FEEDER_IMPORT_BATCH_ID,
    payee.EXT_PAYEE_ID as TEMP_EXT_PAYEE_ID,
    bu_tl.NAME as BUSINESS_UNIT,
    ps.SEGMENT1 as VENDOR_NUM,
    pssm.VENDOR_SITE_CODE,
    payee.EXCLUSIVE_PAYMENT_FLAG,
    payee.DEFAULT_PAYMENT_METHOD_CODE,
    payee.DELIVERY_CHANNEL_CODE,
    payee.SETTLEMENT_PRIORITY,
    payee.REMIT_ADVICE_DELIVERY_METHOD,
    payee.REMIT_ADVICE_EMAIL,
    payee.REMIT_ADVICE_FAX,
    payee.BANK_INSTRUCTION1_CODE,
    payee.BANK_INSTRUCTION2_CODE,
    payee.BANK_INSTRUCTION_DETAILS,
    payee.PAYMENT_REASON_CODE,
    payee.PAYMENT_REASON_COMMENTS,
    payee.PAYMENT_TEXT_MESSAGE1,
    payee.PAYMENT_TEXT_MESSAGE2,
    payee.PAYMENT_TEXT_MESSAGE3,
    payee.BANK_CHARGE_BEARER

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