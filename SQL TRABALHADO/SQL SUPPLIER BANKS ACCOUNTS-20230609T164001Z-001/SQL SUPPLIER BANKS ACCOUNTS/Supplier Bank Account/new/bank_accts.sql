SELECT DISTINCT
    '28032023' as FEEDER_IMPORT_BATCH_ID,
    payee.EXT_PAYEE_ID as TEMP_EXT_PAYEE_ID,
    ieb.EXT_BANK_ACCOUNT_ID as TEMP_EXT_BANK_ACCT_ID,
    bank.PARTY_NAME as BANK_NAME,
    branch.PARTY_NAME as BRANCH_NAME,
    ieb.COUNTRY_CODE,
    ieb.BANK_ACCOUNT_NAME,
    ieb.BANK_ACCOUNT_NUM,
    ieb.CURRENCY_CODE,
    ieb.FOREIGN_PAYMENT_USE_FLAG,
    TO_CHAR(ieb.START_DATE, 'YYYY/MM/DD') as START_DATE,
    TO_CHAR(ieb.END_DATE, 'YYYY/MM/DD') as END_DATE,
    ieb.IBAN,
    ieb.CHECK_DIGITS,
    ieb.BANK_ACCOUNT_NAME_ALT,
    ieb.BANK_ACCOUNT_TYPE,
    ieb.ACCOUNT_SUFFIX,
    REPLACE(TRIM(ieb.DESCRIPTION),CHR(10),' ') as DESCRIPTION,
    ieb.AGENCY_LOCATION_CODE,
    ieb.EXCHANGE_RATE_AGREEMENT_NUM,
    ieb.EXCHANGE_RATE_AGREEMENT_TYPE,
    ieb.EXCHANGE_RATE,
    ieb.SECONDARY_ACCOUNT_REFERENCE,
    ieb.ATTRIBUTE_CATEGORY,
    ieb.ATTRIBUTE1,
    ieb.ATTRIBUTE2,
    ieb.ATTRIBUTE3,
    ieb.ATTRIBUTE4,
    ieb.ATTRIBUTE5,
    ieb.ATTRIBUTE6,
    ieb.ATTRIBUTE7,
    ieb.ATTRIBUTE8,
    ieb.ATTRIBUTE9,
    ieb.ATTRIBUTE10,
    ieb.ATTRIBUTE11,
    ieb.ATTRIBUTE12,
    ieb.ATTRIBUTE13,
    ieb.ATTRIBUTE14,
    ieb.ATTRIBUTE15
FROM
    poz_suppliers            ps     ,
    iby_external_payees_all  payee  ,
    iby_pmt_instr_uses_all   uses   ,
    iby_ext_bank_accounts    ieb    ,
    hz_parties               bank   ,
    hz_parties               branch
WHERE
    ps.party_id            = payee.payee_party_id
AND     uses.instrument_type   = 'BANKACCOUNT'
AND     payee.ext_payee_id(+)  = uses.ext_pmt_party_id
AND     uses.payment_function  = 'PAYABLES_DISB'
AND     uses.instrument_id     = ieb.ext_bank_account_id
AND     ieb.bank_id            = bank.party_id(+)
AND     ieb.branch_id          = branch.party_id(+)
AND     SYSDATE BETWEEN NVL(uses.start_date,SYSDATE) AND     NVL(uses.end_date,SYSDATE)
AND     SYSDATE BETWEEN NVL(ieb.start_date,SYSDATE) AND     NVL(ieb.end_date,SYSDATE)
AND     NVL(ps.end_date_active,SYSDATE+1) > TRUNC (SYSDATE)
and  ieb.EXT_BANK_ACCOUNT_ID =  '30002'