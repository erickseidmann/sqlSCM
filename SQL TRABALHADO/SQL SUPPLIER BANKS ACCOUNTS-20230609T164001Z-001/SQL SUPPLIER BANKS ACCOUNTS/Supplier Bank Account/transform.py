import pandas as pd

column_order = [
    "CHART_OF_ACCOUNTS_CODE",
    "ENABLED",
    "SEGMENT1",
    "SEGMENT2",
    "SEGMENT3",
    "SEGMENT4",
    "SEGMENT5",
    "SEGMENT6",
    "SEGMENT7",
    "SEGMENT8",
    "SEGMENT9",
    "SEGMENT10",
    "SEGMENT11",
    "SEGMENT12",
    "SEGMENT13",
    "SEGMENT14",
    "SEGMENT15",
    "SEGMENT16",
    "SEGMENT17",
    "SEGMENT18",
    "SEGMENT19",
    "SEGMENT20",
    "SEGMENT21",
    "SEGMENT22",
    "SEGMENT23",
    "SEGMENT24",
    "SEGMENT25",
    "SEGMENT26",
    "SEGMENT27",
    "SEGMENT28",
    "SEGMENT29",
    "SEGMENT30",
    "ALLOW_POSTING",
    "FROM_DATE",
    "TO_DATE",
    "PRESERVE_ATTRIBUTES",
    "ALTERNATE_ACCOUNT",
    "GROUP_NUMBER",
    "ATTRIBUTE_CATEGORY",
    "ATTRIBUTE1",
    "ATTRIBUTE2",
    "ATTRIBUTE3",
    "ATTRIBUTE4",
    "ATTRIBUTE5",
    "ATTRIBUTE6",
    "ATTRIBUTE7",
    "ATTRIBUTE8",
    "ATTRIBUTE9",
    "ATTRIBUTE10",
    "ATTRIBUTE_DATE1",
    "ATTRIBUTE_DATE2",
    "ATTRIBUTE_DATE3",
    "ATTRIBUTE_DATE4",
    "ATTRIBUTE_DATE5",
    "ATTRIBUTE_NUMBER1",
    "ATTRIBUTE_NUMBER2",
    "ATTRIBUTE_NUMBER3",
    "ATTRIBUTE_NUMBER4",
    "ATTRIBUTE_NUMBER5"
]
FILE_NAME="Extract General Ledger Account Combinations"

print("READING SOURCE")
source_dataframe = pd.read_excel(f"{FILE_NAME}.xlsx")

target_dataframe = pd.DataFrame(columns=column_order)

print("COPYING DATA")
for column_name in column_order:
    if column_name in source_dataframe:
        target_dataframe[column_name] = source_dataframe[column_name]

print("WRITING DATA")
print(target_dataframe)
target_dataframe.to_excel(f"{FILE_NAME}(1).xlsx", index=False)

print("DONE!")