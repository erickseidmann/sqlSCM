select

'28032023' as "Import Batch Identifier",
BANK_ACCOUNT.BANK_ID as "Payee Identifier",
BANK_ACCOUNT.EXT_BANK_ACCOUNT_ID as "*Payee Bank Account Identifier",
BANK_ACCOUNT.BANK_NAME,
BRANCH.PARTY_NAME as BRANCH_NAME,
BANK_ACCOUNT.COUNTRY_CODE,
BANK_ACCOUNT.BANK_ACCOUNT_NAME,
BANK_ACCOUNT.BANK_ACCOUNT_NUM,
BANK_ACCOUNT.CURRENCY_CODE,
BANK_ACCOUNT.FOREIGN_PAYMENT_USE_FLAG,
BANK_ACCOUNT.START_DATE,
BANK_ACCOUNT.END_DATE,
-- BANK_ACCOUNT.IBAN,
BANK_ACCOUNT.CHECK_DIGITS,
BANK_ACCOUNT.BANK_ACCOUNT_NAME_ALT,
BANK_ACCOUNT.BANK_ACCOUNT_TYPE,
BANK_ACCOUNT.ACCOUNT_SUFFIX,
BANK_ACCOUNT.DESCRIPTION,
-- BANK_ACCOUNT.AGENCY_LOCATION_CODE,
-- BANK_ACCOUNT.EXCHANGE_RATE_AGREEMENT_NUM,
-- BANK_ACCOUNT.EXCHANGE_RATE_AGREEMENT_TYPE,
-- BANK_ACCOUNT.EXCHANGE_RATE,
BANK_ACCOUNT.SECONDARY_ACCOUNT_REFERENCE
-- BANK_ACCOUNT.ATTRIBUTE_CATEGORY,
-- BANK_ACCOUNT.ATTRIBUTE1,
-- BANK_ACCOUNT.ATTRIBUTE2,
-- BANK_ACCOUNT.ATTRIBUTE3,
-- BANK_ACCOUNT.ATTRIBUTE4,
-- BANK_ACCOUNT.ATTRIBUTE5,
-- BANK_ACCOUNT.ATTRIBUTE6,
-- BANK_ACCOUNT.ATTRIBUTE7,
-- BANK_ACCOUNT.ATTRIBUTE8,
-- BANK_ACCOUNT.ATTRIBUTE9,
-- BANK_ACCOUNT.ATTRIBUTE10,
-- BANK_ACCOUNT.ATTRIBUTE11,
-- BANK_ACCOUNT.ATTRIBUTE12,
-- BANK_ACCOUNT.ATTRIBUTE13,
-- BANK_ACCOUNT.ATTRIBUTE14,
-- BANK_ACCOUNT.ATTRIBUTE15

from

IBY_EXT_BANK_ACCOUNTS BANK_ACCOUNT
    left join HZ_PARTIES BRANCH
        on BANK_ACCOUNT.BRANCH_ID = BRANCH.PARTY_ID

where BANK_ACCOUNT.EXT_BANK_ACCOUNT_ID = '30002'