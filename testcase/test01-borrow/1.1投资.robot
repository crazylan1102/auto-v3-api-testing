*** Settings ***
Suite Setup       清除数据、发标
Suite Teardown
Test Setup
Library           ../../LibY/TzjTools.py
Library           ../../LibY/TzjTestLib.py
Library           ../../LibY/ExcelLibrary.py
Library           RequestsLibrary
Library           ../../LibY/Tzj_sql.py

*** Variables ***
${sheet}          0    # 当前测试接口在excel的索引值（从0开始）

*** Test Cases ***
invest_001:正常投资3月标、全部参数校验
    ${debtid}=    Senddebt    400    3    月    8    #发固定标
    ${row}    Set Variable    1    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    isLastInvestFlag    &{expect}[isLastInvestFlag]    ${excel_data}    ${sheet}    ${row}    #校验最后一笔投资
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}    #校验利率
    Check Response Body    rewardRateTitle    &{expect}[rewardRateTitle]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时的空值
    Check Response Body    rewardRateStr    &{expect}[rewardRateStr]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时空值
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}    #校验期限
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}    #校验期限单位
    comment    预计回款日未校验暂时未找到好的方式

invest_002:正常投资天标
    ${debtid}=    Senddebt    500    26    天    8    #发固定天标
    ${row}    Set Variable    2    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}    #校验利率
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}    #校验期限
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}    #校验期限单位
    comment    预计回款日未校验暂时未找到好的方式

invest_003:投资普通标利息四舍五入
    ${debtid}=    Senddebt    1000    1    月    8    #发固定新手3月标
    ${row}    Set Variable    3    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额

invest_004:投资3月新手标
    ${debtid}=    Senddebt    600    3    月    3    #发固定新手3月标
    ${row}    Set Variable    4    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    isLastInvestFlag    &{expect}[isLastInvestFlag]    ${excel_data}    ${sheet}    ${row}    #校验最后一笔投资
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}    #校验利率
    Check Response Body    rewardRateTitle    &{expect}[rewardRateTitle]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时的空值
    Check Response Body    rewardRateStr    &{expect}[rewardRateStr]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时空值
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}    #校验期限
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}    #校验期限单位
    comment    预计回款日未校验暂时未找到好的方式

invest_005:投资1月新手标
    ${debtid}=    Senddebt    600    1    月    3    #发固定新手3月标
    ${row}    Set Variable    5    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    rate    &{expect}[rate]    ${excel_data}    ${sheet}    ${row}    #校验利率
    Check Response Body    rewardRateTitle    &{expect}[rewardRateTitle]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时的空值
    Check Response Body    rewardRateStr    &{expect}[rewardRateStr]    ${excel_data}    ${sheet}    ${row}    #校验无加息利率时空值
    Check Response Body    borrowPeriod    &{expect}[borrowPeriod]    ${excel_data}    ${sheet}    ${row}    #校验期限
    Check Response Body    borrowPeriodUnit    &{expect}[borrowPeriodUnit]    ${excel_data}    ${sheet}    ${row}    #校验期限单位
    comment    预计回款日未校验暂时未找到好的方式

invest_006:投资新手标收益四舍五入
    ${debtid}=    Senddebt    800    1    月    3    #发固定新手3月标
    ${row}    Set Variable    6    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息

invest_007:使用投资券
    ${debtid}=    Senddebt    2500    1    月    8    #发固定普通1月标
    ${row}    Set Variable    7    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    1    #从数据库中获取券码,1为投资券
    ${invest_data}    Add Data all    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的券面值
    Check Response Body    vouchersType    &{expect}[vouchersType]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的加息类型

invest_008:使用红包
    ${debtid}=    Senddebt    100    1    月    8    #发固定普通1月标
    ${row}    Set Variable    8    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher All    ${data[2]}    6    #从数据库中获取券码,6为红包
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的券面值
    Check Response Body    vouchersType    &{expect}[vouchersType]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的加息类型

invest_09:使用多张红包
    ${debtid}=    Senddebt    100    1    月    8    #发固定普通1月标
    ${row}    Set Variable    9    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher All    ${data[2]}    6    3    #从数据库中获取券码,6为红包，后一位参数表示使用几张红包券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的券面值
    Check Response Body    vouchersType    &{expect}[vouchersType]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的加息类型

invest_010:使用加息券投资月标
    ${debtid}=    Senddebt    150    1    月    8    #发固定普通1月标
    ${row}    Set Variable    10    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为加息券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    effectInvestPart    &{expect}[effectInvestPart]    ${excel_data}    ${sheet}    ${row}    #校验有效投资份额
    Check Response Body    effectInvestAmount    &{expect}[effectInvestAmount]    ${excel_data}    ${sheet}    ${row}    #校验有效投资金额
    Check Response Body    receiveAmount    &{expect}[receiveAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款总额
    Check Response Body    receiveCapitalAmount    &{expect}[receiveCapitalAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款本金
    Check Response Body    receiveInterestAmount    &{expect}[receiveInterestAmount]    ${excel_data}    ${sheet}    ${row}    #校验回款利息
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息
    Check Response Body    vouchersAmount    &{expect}[vouchersAmount]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的券面值
    Check Response Body    vouchersType    &{expect}[vouchersType]    ${excel_data}    ${sheet}    ${row}    #校验使用的券的加息类型

invest_011:使用加息券投资天标
    ${debtid}=    Senddebt    150    50    天    8    #发固定普通1月标
    ${row}    Set Variable    11    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为加息券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息

invest_012:使用加息时长、加息上限加息券投资月标
    ${debtid}=    Senddebt    500    3    月    8    #发固定普通1月标
    ${row}    Set Variable    12    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为加息券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息

invest_013:使用加息时长、加息上限加息券投资天标
    ${debtid}=    Senddebt    500    50    天    8    #发固定普通1月标
    ${row}    Set Variable    13    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为加息券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息

invest_014:使用加息券不足0.01
    Comment    ${debtid}=    Senddebt    200    1    月    8
    ...    #发固定普通1月标
    ${row}    Set Variable    14    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为加息券
    ${invest_data}    Add Data All    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    receiveInterestAddVoucherAmount    &{expect}[receiveInterestAddVoucherAmount]    ${excel_data}    ${sheet}    ${row}    #校验券加息

invest_015:普通标最后一笔投资
    ${debtid}=    Senddebt    100    3    月    8    #发固定月标
    ${row}    Set Variable    15    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    isLastInvestFlag    &{expect}[isLastInvestFlag]    ${excel_data}    ${sheet}    ${row}

invest_016:官方标最后一笔投资
    ${debtid}=    Senddebt    100    3    月    3    #发固定月标
    ${row}    Set Variable    16    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Response Body    isLastInvestFlag    &{expect}[isLastInvestFlag]    ${excel_data}    ${sheet}    ${row}

invest_017:标的已售罄
    ${row}    Set Variable    17    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    Senddata    ${data[3]}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_018:投之家余额充足、存管余额不足
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    18    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_019:投之家余额不足
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    19    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_020:项目余额不足
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    20    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_021:券期限不满足使用条件
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    21    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    3    #从数据库中获取券码,3为投资券
    ${invest_data}    Add Data all    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_022:投资金额不满足券使用条件
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    22    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    1    #从数据库中获取券码,1为加息券
    ${invest_data}    Add Data all    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_023:新手标不可用券
    Comment    ${debtid}=    Senddebt    100    3    月    3
    ...    #发固定标
    ${row}    Set Variable    23    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    @{code}    Query Voucher all    ${data[2]}    6    #从数据库中获取券码,6为红包
    ${invest_data}    Add Data all    ${data[4]}    ${code}    #将券码添加到投资参数中
    Senddata    ${url}    ${invest_data}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_024:新手额度不足
    Comment    ${debtid}=    Senddebt    100    3    月    3
    ...    #发固定标
    ${row}    Set Variable    24    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid_new}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_025:券已被使用
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    25    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_026:账户未登录
    Comment    ${debtid}=    Senddebt    100    3    月    3
    ...    #发固定标
    ${row}    Set Variable    26    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    \    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code

invest_027:投资0
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    27    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
    &{expect}    To Json    ${data[6]}    #预期值格式化
    Check Code    &{expect}[code]    ${excel_data}    ${sheet}    ${row}    #校验请求code
    Check Code Msg    &{expect}[code]    &{expect}[message]    ${excel_data}    ${sheet}    ${row}

invest_028:投资小数
    Comment    ${debtid}=    Senddebt    100    3    月    8
    ...    #发固定标
    ${row}    Set Variable    28    #设置用例所处的行数
    ${data}    Read Excel Row    ${excel_data}    ${sheet}    ${row}    #读取测试用例
    ${token}    Login    ${data[2]}    #获取登录态的token
    ${url}    Catenate Url    ${data[3]}    ${debtid}    #拼接url
    Senddata    ${url}    ${data[4]}    ${data[5]}    ${token}    #请求投资接口
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
