*** Settings ***
Suite Setup       清除数据
Library           ../../LibY/TzjTestLib.py
Library           ../../LibY/TzjTools.py
Library           ../../LibY/Tzj_sql.py
Library           RequestsLibrary

*** Variables ***
${sheet}          3    # 在excel中所处的sheet

*** Test Cases ***
borrow_voucher_001:个人标-月标
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    1    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    title    &{expect}[title]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rewardRate    &{expect}[rewardRate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    onlineSec    &{expect}[onlineSec]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowAmount    &{expect}[borrowAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentType    &{expect}[repaymentType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentTypeStr    &{expect}[repaymentTypeStr]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    combinedPeriod    &{expect}[combinedPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowType    &{expect}[borrowType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    perInterest    &{expect}[perInterest]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagTitle    &{expect}[tagTitle]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagDesc    &{expect}[tagDesc]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    titleTag    &{expect}[titleTag]    ${excel_data}    ${sheet}    ${row}

borrow_voucher_002:企业标-天标
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    2    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    title    &{expect}[title]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rewardRate    &{expect}[rewardRate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowAmount    &{expect}[borrowAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentType    &{expect}[repaymentType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentTypeStr    &{expect}[repaymentTypeStr]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    combinedPeriod    &{expect}[combinedPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowType    &{expect}[borrowType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    perInterest    &{expect}[perInterest]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagTitle    &{expect}[tagTitle]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagDesc    &{expect}[tagDesc]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    titleTag    &{expect}[titleTag]    ${excel_data}    ${sheet}    ${row}

borrow_voucher_003:新手标1月（企业）
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    3    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    title    &{expect}[title]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rewardRate    &{expect}[rewardRate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    onlineSec    &{expect}[onlineSec]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowAmount    &{expect}[borrowAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentType    &{expect}[repaymentType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentTypeStr    &{expect}[repaymentTypeStr]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    combinedPeriod    &{expect}[combinedPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowType    &{expect}[borrowType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    perInterest    &{expect}[perInterest]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagTitle    &{expect}[tagTitle]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagDesc    &{expect}[tagDesc]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    titleTag    &{expect}[titleTag]    ${excel_data}    ${sheet}    ${row}

borrow_voucher_004:新手标3月（个人）
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    4    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    title    &{expect}[title]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    rewardRate    &{expect}[rewardRate]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowAmount    &{expect}[borrowAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentType    &{expect}[repaymentType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    repaymentTypeStr    &{expect}[repaymentTypeStr]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    combinedPeriod    &{expect}[combinedPeriod]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    borrowType    &{expect}[borrowType]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    perInterest    &{expect}[perInterest]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagTitle    &{expect}[tagTitle]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    tagDesc    &{expect}[tagDesc]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    titleTag    &{expect}[titleTag]    ${excel_data}    ${sheet}    ${row}

voucher_005:倒计时标
    ${debtid}    Senddebt    amount=100    period=3    period_unit=月    type=8    open_invest_at=1
    ...    #发倒计时普通标，默认开放时间1天后
    ${row}    Set Variable    5    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check response Body One    onlineSec    &{expect}[onlineSec]    ${excel_data}    ${sheet}    ${row}    #校验倒计时的标剩余时间大于0

voucher_006:万份收益四舍五入
    ${row}    Set Variable    6    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    perInterest    &{expect}[perInterest]    ${excel_data}    ${sheet}    ${row}

borrow_voucher_007:标的投资中
    ${debtid}    Senddebt    100    3    月    8    #发固定标
    ${row}    Set Variable    7    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    #请求债权详情接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    onlineSec    &{expect}[onlineSec]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    balanceAmount    &{expect}[balanceAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    balancePart    &{expect}[balancePart]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    projectProgress    &{expect}[projectProgress]    ${excel_data}    ${sheet}    ${row}

borrow_voucher_008:标的已售罄
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    8    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    Senddata    url=${data[3]}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    id    &{expect}[id]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    onlineSec    &{expect}[onlineSec]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    balanceAmount    &{expect}[balanceAmount]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    balancePart    &{expect}[balancePart]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    projectProgress    &{expect}[projectProgress]    ${excel_data}    ${sheet}    ${row}

*** Keywords ***
清除数据
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    7
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    8
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定普通标
    Comment    Set Suite Variable    ${debtid}
