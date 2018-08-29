# encoding: utf-8
# !/usr/bin/env python


__author__ = 'Younghy'

import sys, logging, random, string, time,re

import sys
reload(sys)
sys.setdefaultencoding('utf8')

import json
import requests
import xlrd
import xlwt
import os
from xlutils.copy import copy
from Login import Login
import Tzjconfig
import unittest
import sys
from Tzj_sql import Tzj_sql
import datetime


class TzjTestLib():
    def __init__(self):
        self.token = ''
        self.resp_data = ''
        self.code = ''

    def read_excel_row(self, excel_data, sheetindex, row):
        '''
        读取excel行数据，参数依次是excel名称、sheet名称、行（0开始）
        :param excel_data:
        :param sheetName:
        :param row:
        :return:
        '''

        data = xlrd.open_workbook(excel_data)  # 打开文件把参数传给 data
        table = data.sheet_by_index(int(sheetindex))  # 通过索引顺序获取Excel 文件
        parameter = table.row_values(int(row))  # 获取整行数据 获取Excel 第二行数据
        return parameter

    def read_excel_cell(self, excel_data, sheetName, row, column):
        '''
        读取excel单元格数据，参数依次是excel名称、sheet名称、行（0开始）、列（0开始）
        :param excel_data:
        :param sheetName:
        :param row:
        :return:
        '''

        data = xlrd.open_workbook(excel_data)  # 打开文件把参数传给 data
        table = data.sheet_by_name(sheetName)  # 通过索引顺序获取Excel 文件
        parameter = table.row_values(int(row))  # 获取整行数据 获取Excel 第二行数据
        jsoninfo = eval(parameter[int(column)])  # 因为 parameter 变量类型是str 需要用eval函数转换成dict
        return jsoninfo

    def write_excel_cell(self, excel_data, sheetIndex, row, column, data):
        '''
        写excel单元格数据
        :param excel_for_use: excel名称
        :param sheetIndex: sheet索引，从0开始
        :param row:行
        :param column:列
        :param data:被写入数据
        :return:
        '''
        old_excel = xlrd.open_workbook(excel_data, formatting_info=True)
        print(old_excel)
        new_excel = copy(old_excel)
        sheet = new_excel.get_sheet(int(sheetIndex))
        row = int(row)
        column = int(column)
        sheet.write(row, column, data.decode("unicode-escape"))
        new_excel.save(excel_data)

    def Senddata(self, url, data='nodata', method='get', X_Auth_Token=None):
        '''
        发送请求，url只填当前接口如/borrows，data数据读取excel（4），method读取excel（5），X_Auth_Token参数不填则不需要登录态
        :param url:
        :param data:
        :param method:
        :param X_Auth_Token:
        :return:
        '''
        logging.info(u"***********Senddata函数开始*********")

        # 处理请求头
        if X_Auth_Token == None:
            headers = {"Content-Type": "application/json"}
        else:
            headers = {"Content-Type": "application/json", 'X-Auth-Token': X_Auth_Token}

        logging.info(u'当前headers:%r' % headers)

        try:
            logging.info(U'当前url:' + Tzjconfig.host_url + url)
            if method.lower() == 'post':
                if data == 'nodata':
                    resp = requests.post(Tzjconfig.host_url + url, data=TzjTestLib.data, timeout=30, verify=False,
                                         headers=headers)
                else:
                    logging.info(u"***********post函数开始了*********")
                    logging.info(u"url:%s"%url)
                    logging.info(u"data:%s"%data)
                    logging.info(u"headers:%s"%headers)
                    resp = requests.post(Tzjconfig.host_url + url, data=data, timeout=30, verify=False, headers=headers)
                    logging.info(u"result:%s"%resp.status_code)


                    # 这里打印发出的请求body，在正式使用可以将日志级别调整成debug
                    # logging.info(u'request data:%s' % data)
                    # logging.info(u'response.text:%r'% resp.text)

                    # TzjTestLib.res=resp.json()

            elif method.lower() == 'get':
                if data == 'nodata':
                    logging.info(u"url:%s"%url)
                    logging.info(u"data:%s"%data)
                    logging.info(u"headers:%s"%headers)
                    resp = requests.get(Tzjconfig.host_url + url, timeout=30, verify=False,headers=headers)
                else:
                    logging.info(u"url:%s"%url)
                    logging.info(u"data:%s"%data)
                    logging.info(u"headers:%s"%headers)
                    logging.info(type(data))
                    data=eval(data)
                    resp =requests.get(Tzjconfig.host_url + url,params=data, timeout=30, verify=False,headers=headers)
                    logging.info(resp.url)
                    print  resp.url


                # TzjTestLib.res=resp.json()

            else:
                print U"请求方法不支持"

            self.code = resp.status_code
            if (self.code) == 401:
                return '401'

            self.resp_data1 = resp.json()

            '''解决print输出中文显示编码问题'''
            self.resp_data = json.dumps(self.resp_data1, encoding='UTF-8', ensure_ascii=False)

            print 'response:\n', self.code, '\n', self.resp_data

            logging.info(u'response.code:%d' % self.code)
            logging.info(u'response.data:%r' % self.resp_data)
            logging.info(u"***********Senddata函数正常结束*********")

        except requests.RequestException as e:
            print e
            return self.resp_data
            logging.info(u"***********Senddata函数异常结束*********")
        else:
            return self.resp_data

    def save_excel_name_Time(self, excel_data, destination):
        '''
        以时间为名字另存excel文件
        :param excel_data: 要另存的excel
        :param desinition:当前目录
        :return:
        '''
        timestamp = time.time()
        timestruct = time.localtime(timestamp)
        timestamp_string = time.strftime('%Y-%m-%d %H-%M-%S', timestruct)
        excel_name = timestamp_string + ".xls"
        old_excel = xlrd.open_workbook(excel_data, formatting_info=True)
        print(old_excel)
        new_excel = copy(old_excel)
        new_excel.save(destination + "\\result_history\\" + excel_name)
        new_excel.save(destination + "\\result_history\\" + excel_name)

    def login(self, username, password=Tzjconfig.password, url=Tzjconfig.login_url):
        '''
        登录，获取token，这里需填写用户名，password默认是test1111，url有默认值
        :param username:
        :param password:
        :param url:
        :return:
        '''
        ll = Login()
        backdata = ll.tzj_login(url=url, username=username, password=password)
        if backdata.has_key('token'):
            self.token = backdata['token']
            return self.token
        else:
            print U'无法获取token'
            return self.token

    def check_code(self, respect_code, excel_data,sheet_index, row, cloumn_real_value=7, cloumn_result=8):
        '''
        校验code
        respect_code:预期code

        excel_data:excel名称

        sheet_index:excel sheet序号，从0开始

        row: 用例所在行   从0开始

        cloumn_real_value: 实际值所在列（一般是7）

        cloumn_result:预期值  结果所在列（一般是8）
        '''
        logging.info(u"***********断言函数check_code开始*********")

        logging.info(U'预期结果：%s' % respect_code)
        logging.info(U'实际结果：%d' % self.code)

        if int(respect_code)==self.code:
            result_code= 'True'
        else:
            result_code= 'False'
        logging.info(u"实际测试结果：%s" %result_code)
        code="%s%s"%("code:",self.code)
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_real_value,code)
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_result, result_code)

        assert result_code == 'True'

    def check_code_msg(self, respect_code, respect_msg,excel_data,sheet_index, row, cloumn_real_value=7, cloumn_result=8):
        '''
        针对异常测试，对比响应结果及返回的message，respect_code取预期值中的code，respect_message取预期值中的message
        respect_code:预期code

        respect_msg:预期值

        excel_data:excel名称

        sheet_index:excel sheet序号，从0开始

        row: 用例所在行   从0开始

        cloumn_real_value: 实际值所在列（一般是7）

        cloumn_result:预期值  结果所在列（一般是8）

        '''
        logging.info(u"***********断言函数check_code_msg开始*********")
        code = self.code
        real_value=json.loads(self.resp_data)
        msg = real_value['message']

        logging.info(U'预期结果：%s %s' % (respect_code, respect_msg))
        logging.info(U'实际响应值：%s %s' % (code, msg))
        if respect_msg in msg:
            result_msg= 'True'
        else:
            result_msg= 'False'
        logging.info(u"实际测试结果：%s" %result_msg)
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_real_value,str(real_value))
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_result, result_msg)

        assert result_msg == 'True'

    def check_response_body_whole(self, expect_value, excel_data,sheet_index, row, cloumn_real_value=7, cloumn_result=8):
        '''
        比较两个字典是否相等
        :param expect_value:期望值
        :param real_value:预期值
        :param excel_data:excel名称
        :param row: 用例所在行   excel序号-1
        :param cloumn_real_value: 实际值所在列
        :param cloumn_result:预期值  结果所在列
        :return:（0）[相等] , （1，-1）[不相等]
        '''
        logging.info(u"***********断言函数check_response_body_all开始*********")
        logging.info(u"实际值是：%s"%self.resp_data)

        real_value=json.loads(self.resp_data)
        result = cmp(expect_value,real_value)
        if result == 0:
            result_txt = 'True'
        else:
            result_txt = 'False'
        logging.info(u"结果是：%s"%result_txt)

        logging.info(u"实际值是：%s"%real_value)

        logging.info(u"实际值写入excel")
        self.write_excel_cell(excel_data,sheet_index, row,cloumn_real_value,str(real_value))
        logging.info(u"结果写入excel")
        self.write_excel_cell(excel_data, sheet_index, row,cloumn_result,result_txt)

        assert result == 0
        logging.info(u"***********断言函数check_response_body_all函数正常结束*********")

    def check_response_body(self, key, values, excel_data, sheetIndex, row, cloumn_real_value=7,cloumn_result=8):
        """
        用于对比返回值的字典中有list嵌套多层字典的数据、或者是单层字典中单个字段
        返回值形式如下：
        {
            "list": [
                {"code": "nB9fr2kMYij","title": "2%加息券","extra": {"minAmount": 0,"maxAmount": 1000000,"limitDebtType": "1,2,3"}},
                {xxx：xxx}
            ],
        "totalSize": 3
        }

        key1、values:
        key的表现形式1： list、totalsize，可对比单个字段的值或者整个list，如选择对比list，values(excel的单元格里的形式xxx：value)的值要和list里的格式一样，形如[{xxx:xxx,xxx:{},xxx:xxx"},{},{}]

        key2、values:
        key的表现形式2： list.code或者list.extra.minAmount，可对比list中所有的字典中的code的值，values(excel的单元格里的形式xxx：value)的值要和list里的格式一样（但可不填所有的字段，只需要格式一样），形如[{xxx:xxx,xxx:{},xxx:xxx"},{},{}]

        key3、values:
        key的表现形式3： list[0].code或者list[0].extra.minAmount，可对比list某一列中的字典对应的值，values(excel的单元格里的形式minAmount：value)是一个键值对的值

        excel_data:  需要写入测试结果的excel路径

        sheetIndex:  需要写入测试结果的excel中对应的sheet索引，从0开始

        row:  需要写入测试结果的excel中相应表格的行，从0开始

        cloumn_real_value:  需要写入实际返回结果的excel中相应表格的列，从0开始，默认是7

        cloumn_result:  需要写入测试结果的列，从0开始，默认是8
        """

        logging.info(u"***********断言函数check_response_body开始*********")
        #data = self.resp_data
        #data=eval(data)
        data=json.loads(self.resp_data)
        if key.find('.') == -1 and key.find('[') == -1:
            # 这种比较response的第一层，用于有列表、size返回的，比较整个list（list需要格式h化为json格式）或者size的值，
            # key的表现形式：totalsize、list;value的表现形式为totalsize、list[{}，{}，{}]
            # 预期值的values要和返回值的list一模一样，包括顺序
            if key in data:
                # print data[key]
                # print type(data[key])
                if isinstance(data[key], list) and isinstance(values, list):
                    response_list = json.dumps(data[key])
                    respect_list = json.dumps(values)
                    logging.info(U"预期结果%s：%s" % (key, respect_list))
                    logging.info(U"实际响应值%s：%s" % (key, response_list))
                    # assert response_list==respect_list
                    if response_list == respect_list:
                        relult_body='True'
                    else:
                        relult_body='False'
                    logging.info(u"实际测试结果：%s" %relult_body)
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body)
                    assert relult_body=='True'

                else:
                    logging.info(U"预期结果%s：%s" % (key, values))
                    logging.info(U"实际响应值%s：%s" % (key, data[key]))
                    #assert data[key] == values
                    if data[key] == values:
                        relult_body='True'
                    else:
                        relult_body='False'
                    logging.info(u"实际测试结果：%s" %relult_body)
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body)
                    assert relult_body=='True'


            else:
                logging.info(u"返回值中没有%s" % key)
                relult_body='False'
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body)
                assert False

        elif key.find('[') == -1 and key.find(']') == -1 and key.find('.'):
            # 用于比较response的第二层，list中的所有元素中的某个值和预期结果一致,表达形式为list.extra.minAmount
            # list的结构要和value的结构一致，value的值应该是个list
            key_list = key.split('.')
            if key_list[0] in data:
                data_list = data[key_list[0]]  # 取出来第一层的list，list是由很多个字典组成的数组
                if len(data_list) == len(values):
                    for i in range(len(data_list)):
                        for j in range(len(key_list)):
                            if j == 0:
                                relult = data_list  # 如果是list层，直接等于list
                            else:
                                if key_list[j] in data_list[i]:
                                    relult = data_list[i].get(key_list[j])
                                    value_end = values[i].get(key_list[j])
                                else:
                                    logging.info(u'找不到：%s' % key_list[j])
                                    relult_body1='False'
                                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body1)
                                    assert False
                        logging.info(U"第%d个%s的实际返回值是：%s" % (i + 1, key, relult))
                        logging.info(U"第%d个%s的预期值是：%s" % (i + 1, key, value_end))

                        if type(value_end) != type(relult):  # 这个还要再想想，中文模式下，预期值是str类型，返回值是unicode
                            #assert unicode(value_end, 'utf-8') == relult


                            if unicode(value_end, 'utf-8') == relult:
                                relult_body1='True'
                            else:
                                relult_body1='False'
                            logging.info(u"实际测试结果：%s" %relult_body1)
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body1)
                            assert relult_body1=='True'

                        else:
                            #assert relult == value_end
                            if relult == value_end:
                                relult_body1='True'
                            else:
                                relult_body1='False'
                            logging.info(u"实际测试结果：%s" %relult_body1)
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body1)
                            assert relult_body1=='True'

                else:
                    logging.info(u'和预期结果条数不一致')
                    # print list,U'和预期结果条数不一致'
                    relult_body1='False'
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                    self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body1)
                    assert False
            else:
                logging.info(u'返回结果无：%s' % key_list[0])
                # print u"返回结果无",key_list[0]
                relult_body1='False'
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body1)
                assert False

        elif key.find('[') and key.find(']') and key.find('.'):
            # 用于比较response的第三层，list中的某一列中的字典对应的值,表达形式为list[0].extra.minAmount，value的是一个键值对的值
            key_list = key.split('.')
            # print key_list,data,'a'
            key_f = key[0:key.find('[')]
            index = int(key[key.find('[') + 1:key.find(']')])
            print index
            print key_list[0]
            if key_f in data:
                data_list = data[key_f]  # 取出来第一层的list，list是由很多个字典组成的数组
                #print data_list

                for j in range(len(key_list)):
                    if j == 0:
                        relult = data_list  # 如果是list层，直接等于list
                    else:
                        if key_list[j] in data_list[index]:
                            relult = data_list[index].get(key_list[j])
                            # value_end = key_list[0].get(key_list[j])
                        else:
                            logging.info(u'找不到：%s' % key_list[j])
                            # print u'找不到', key_list[j]
                            relult_body2='False'
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body2)
                            assert False

                logging.info(U"%s的实际返回值是：%s" % (key, relult))
                logging.info(U"%s的预期值是：%s" % (key, values))
                # print  u"返回值中", key, u"的值是：", relult, type(relult)
                # print  u"预期结果", key, u"的值是：", values, type(values)

                if type(values) != type(relult):  # 这个还要再想想，中文模式下，预期值是str类型，返回值是
                    #assert unicode(values, 'utf-8') == relult
                    if unicode(values, 'utf-8') == relult:
                        relult_body2 = 'True'
                    else:
                        relult_body2 = 'False'
                    logging.info(u"实际测试结果：%s" % relult_body2)
                    self.write_excel_cell(excel_data, sheetIndex, row, cloumn_real_value, str(data))
                    self.write_excel_cell(excel_data, sheetIndex, row, cloumn_result, relult_body2)
                    assert relult_body2 == 'True'

                else:
                    # assert relult == values
                    if relult == values:
                        relult_body2 = 'True'
                    else:
                        relult_body2 = 'False'
                    logging.info(u"实际测试结果：%s" % relult_body2)
                    self.write_excel_cell(excel_data, sheetIndex, row, cloumn_real_value, str(data))
                    self.write_excel_cell(excel_data, sheetIndex, row, cloumn_result, relult_body2)
                    assert relult_body2 == 'True'

            else:
                logging.info(u'返回结果无：%s' % key_f)
                # print u"返回结果无",key_f
                relult_body2='False'
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
                self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body2)
                assert False

        else:
            logging.info(u'不支持的比较方式，请输入正确的表现形式')
            relult_body3='False'
            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_real_value, str(data))
            self.write_excel_cell(excel_data,sheetIndex, row, cloumn_result, relult_body3)
            assert False


    def check_response_body_one(self,key,expect_value, excel_data,sheet_index, row, cloumn_real_value=7, cloumn_result=8):
        '''
        对比预期值与实际值的大小的，如：倒计时的标，剩余时间大于0
        key:想要对比实际值的键

        expect_value:预期值

        excel_data:excel名称

        sheet_index:excel sheet序号，从0开始

        row: 用例所在行   从0开始

        cloumn_real_value: 实际值所在列（一般是7）

        cloumn_result:预期值  结果所在列（一般是8）

        '''
        data=json.loads(self.resp_data)
        logging.info(U'预期结果：%s' % expect_value)
        logging.info(U'实际响应值：%s' %data[key])
        #if data[key]>int(expect_value):
        if cmp(data[key],int(expect_value)):
            result_one='True'
        else:
            result_one='False'
        logging.info(u"实际测试结果：%s" %result_one)
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_real_value,str(data))
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_result, result_one)
        assert result_one=='True'

    def check_response_body_equal(self,real_result,expect_value, excel_data,sheet_index, row, cloumn_real_value=7, cloumn_result=8):
        '''
        对比输入的预期值和实际值是否一致，如：使用提现券后，券的数量是否正确

        real_result:想要对比的实际值

        expect_value:预期值

        excel_data:excel名称

        sheet_index:excel sheet序号，从0开始

        row: 用例所在行   从0开始

        cloumn_real_value: 实际值所在列（一般是7）

        cloumn_result:预期值  结果所在列（一般是8）

        '''
        data=json.loads(self.resp_data)
        logging.info(u"***********断言函数check_response_body_equal开始*********")
        logging.info(U'预期结果：%s' % expect_value)
        logging.info(U'实际值：%s' %real_result)
        if real_result==expect_value:
            result_one='True'
        else:
            result_one='False'
        logging.info(u"实际测试结果：%s" %result_one)
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_real_value,str(data))
        self.write_excel_cell(excel_data,sheet_index, row, cloumn_result, result_one)
        assert result_one=='True'


    def func_equal(self,a,b):
        if a==b:
            return





    def catenate_url(self,pre_url,param):
        '''
        处理中间有变量的url,url拼接

        pre_url:需要拼接的url   excel中url的表现方式如：/borrows/%(debtid)s/invest;中间的变量的表现形式一定要写成：%(变量)s

        param:url中间需要传入的参数aa

        '''
        if pre_url.find('(') and pre_url.find(')') and pre_url.find('%'):
            re_id=re.findall(r'[^()]+', pre_url)[1] #通过匹配"()"获取到url中的变量
            url=pre_url%{re_id:param}  #采用占位符的方式拼接带参数的url  re_id=debtid
            return url

        else:
            logging.info(u'请在读取的url中输入正确格式的参数名称')

    def add_data_all(self,data,value,key='voucher'):
        '''
        向接口参数中增加请求数据,如：voucher='030n32tZ8tk'

        data:原始数据

        value:需要新增的值,类型是list，可以是多个

        key:需要新增的键，默认是voucher

        :return:返回最终的值
        '''
        data=json.loads(data)
        if isinstance(data,dict):
            for i in range(len(value)):
                if i==0:
                    data[key]=value[i]
                else:
                    data[key]=data[key]+','+value[i]
            print data
            data=json.dumps(data)
            return data
        else:
            logging.info(u"传入的值不是字典类型，不支持此操作")

    def check_B_contains_A(self, A, B):
        '''
        检查字典B 是否包含字典A
        :param A:
        :param B:
        :return:True（包含），False（不包含）
        '''
        length_A = len(A)
        length_B = len(B)

        if (length_A == 0 or length_B == 0):
            logging.info(u"***********字典长度为0*********")
            return

        keys_A = A.keys()
        for key in keys_A:
            if type(B[key]) == bool:
                B_value = str(B[key])
            else:
                B_value = B[key]

            if A[key] == B_value:
                pass
            else:
                return False
        return True

    def delete_excel_columnValue(self, excel_data, sheetIndex, column):
        '''
        清除excel指定列的单元格数据
        :param excel_data:
        :param sheetIndex: sheet
        :param column: 要清除的列  下标从0开始
        :return:
        '''
        old_excel = xlrd.open_workbook(excel_data, formatting_info=True)

        sheets = old_excel.sheet_by_index(int(sheetIndex))
        rows = sheets.nrows

        new_excel = copy(old_excel)
        sheet = new_excel.get_sheet(int(sheetIndex))
        column = int(column)

        row = 1
        while row <= rows:
            sheet.write(row, column, "")
            row = row + 1
        new_excel.save(excel_data)

    def query_sqlstring(self, database, sqlstring):
        '''

        :param database:
        :param sqlstring:
        :return:
        '''
        aa = Tzj_sql()
        logging.info(u"***********开始查询数据库*********")
        return aa.query_sqlstring(database, sqlstring)

    def create_sql_result_dict(self, keys, values):
        '''
        g根据健和值的列表，构造字典
        :param keys:
        :param values:
        :return:
        '''
        sql_result = {}
        length_keys = len(keys)
        length_values = len(values)
        if length_keys != length_values:
            logging.info(u"健和值的个数不匹配")
            return
        for i in range(length_keys):
            sql_result[keys[i]] = values[i]
        return sql_result

    def create_keys_list(self, *args):
        '''
        创建字典的健列表，由多个列表组成
        :param args:
        :return:
        '''
        keys = []
        length = len(args)
        for i in range(length):
            if type(args[i] == "tuple"):
                lists = list(args[i])
            keys = keys + lists
        return keys


if __name__ == '__main__':
    hh = TzjTestLib()
    path=unicode('E:\\RF_yhy\\auto-v3-api-testing\\testcase\\test01-borrow\\borrower.xls',"utf-8")
    a=hh.read_excel_row(path,2,2)
    #print a[4]
    d=eval(a[6])
    #b=hh.login('Lh25OilS0')
    #c=hh.Senddata(url='/borrows/20180514246/vouchers',data="nodata",method='get',X_Auth_Token=b)
    #hh.check_response_body('totalSize',d.get('totalSize'),path,0,4)
    #debtid='201705140026'
    #url=a[3]%{'debtid':debtid}
    #b=hh.catenate_url("/invest/%(wuji)s/haha",debtid)
    #print hh.add_data_all((a[4]),['123','456'])
    data={'voucher_amount':'10'}
    #print type(data)
    #e=hh.Senddata("/borrows/20180413578/max_invest",data='nodata',method='get',X_Auth_Token='jgFz152tGF9IDvKxxb3nxZNKU1w8oyIj')
    #print type(eval(a[4]))
    e=hh.Senddata("/borrows/20180615368/vouchers",X_Auth_Token='pnlibM3uA6fy5GSIg0xjW5S9KcCfeLXp')
    print d['list']
    dd=hh.check_response_body('list.code',d['list'],path,2,2)
    print dd




