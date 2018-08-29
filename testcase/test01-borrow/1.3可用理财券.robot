*** Settings ***
Suite Setup       清除数据、发标
Library           ../../LibY/TzjTestLib.py
Library           ../../LibY/TzjTools.py
Library           ../../LibY/Tzj_sql.py
Library           RequestsLibrary

*** Variables ***
${sheet}          2    # 在excel中所处的sheet

*** Test Cases ***
voucher_001:普通标：红包券合并展示、到期日显示最近的
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    1    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    list[0].type    &{expect}[type]    ${excel_data}    ${sheet}    ${row}    #校验券类型是不是红包
    Check Response Body    list[0].code    &{expect}[code1]    ${excel_data}    ${sheet}    ${row}    #校验券码
    Check Response Body    list[0].title    &{expect}[title]    ${excel_data}    ${sheet}    ${row}    #校验title
    Check Response Body    list[0].denomination    &{expect}[denomination]    ${excel_data}    ${sheet}    ${row}
    Check Response Body    list[0].amount    &{expect}[amount]    ${excel_data}    ${sheet}    ${row}    #校验合并后的金额
    Check Response Body    list[0].expiredTimeStr    &{expect}[expiredTimeStr]    ${excel_data}    ${sheet}    ${row}    #校验到期期限
    Check Response Body    list[0].expireDate    &{expect}[expireDate]    ${excel_data}    ${sheet}    ${row}    #校验到期期限

voucher_002:排序：红包券、加息券、投资券
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    2    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    totalSize    &{expect}[totalSize]    ${excel_data}    ${sheet}    ${row}    #校验券类型是不是红包
    Check Response Body    list.code    &{expect}[list]    ${excel_data}    ${sheet}    ${row}    #校验券码，券码顺序相同，则排序相同

voucher_003:券面文案展示
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    3    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    200    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    totalSize    &{expect}[totalSize]    ${excel_data}    ${sheet}    ${row}    #校验数量对不对
    Check Response Body Whole    ${expect}    ${excel_data}    ${sheet}    ${row}

voucher_004:天标的万份收益
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    4    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    Senddata    url=${data[3]}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    200    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    totalSize    &{expect}[totalSize]    ${excel_data}    ${sheet}    ${row}    #校验数量对不对
    Check Response Body    list.code    &{expect}[list]    ${excel_data}    ${sheet}    ${row}    #校验券码对不对
    Check Response Body    list.perInterest    &{expect}[list]    ${excel_data}    ${sheet}    ${row}    #校验万份收益对不对

voucher_005:标的期限<券可用期限，券不显示
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    5    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    Senddata    url=${data[3]}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    totalSize    &{expect}[totalSize]    ${excel_data}    ${sheet}    ${row}    #校验数量对不对
    Check Response Body    list.code    &{expect}[list]    ${excel_data}    ${sheet}    ${row}    #校验券码

voucher_006:新手不可用理财券
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    6    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    Senddata    url=${data[3]}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    totalSize    &{expect}[totalSize]    ${excel_data}    ${sheet}    ${row}    #校验数量对不对

voucher_007:转让不可用理财券
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    7    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    Senddata    url=${data[3]}    X_Auth_Token=${token}    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code

voucher_008:未登录
    Comment    ${debtid}    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    8    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    url=${url}    #请求可用理财券接口    #请求可用理财券接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code

*** Keywords ***
清除数据、发标
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    7
    Delete Excel ColumnValue    ${excel_data}    ${sheet}    8
    ${debtid}    Senddebt    100    3    月    8    #发固定普通标
    Set Suite Variable    ${debtid}
