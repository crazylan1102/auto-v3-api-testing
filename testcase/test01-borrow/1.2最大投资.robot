*** Settings ***
Suite Setup       清除数据、发标
Library           ../../LibY/TzjTestLib.py
Library           ../../LibY/TzjTools.py
Library           ../../LibY/Tzj_sql.py
Library           RequestsLibrary

*** Variables ***
${sheet}          1    # 在excel中所处的sheet

*** Test Cases ***
max_invest_001:普通标：未使用券、标的余额小于可用余额
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    1    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_002:普通标：未使用券、可用余额小于标的余额
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    2    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_003:普通标：使用券、标的余额小于可用余额+券
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    3    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Comment    ${data1}    To Json    ${data[4]}
    ${res}    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求最大投资接口接口
    log    ${res}
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_004:普通标：使用券、券+可用余额小于标的余额
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    4    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    data=${data[4]}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_005:新手标：新手额度<可用余额、新手额度<标的余额
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    5    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_006:新手标：可用余额<新手额度、可用余额<标的余额
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    6    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_007:新手标：标的余额<可用余额、标的余额<新手额度
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    7    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    maxInvestPrice    &{expect}[maxInvestPrice]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    maxInvestPart    &{expect}[maxInvestPart]    ${excel_data}    ${sheet}    ${row}

max_invest_008:未登录
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    8    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    Senddata    url=${url}    #请求最大投资接口接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code

*** Keywords ***
清除数据、发标
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    7
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    8
    ${debtid}    Senddebt    100    3    月    8    #发固定普通标
    ${debtid_new}    Senddebt    100    3    月    3    #发固定新手标
    Set Suite Variable    ${debtid}
    Set Suite Variable    ${debtid_new}
