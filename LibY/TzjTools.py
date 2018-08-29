# encoding: utf-8
# !/usr/bin/env python

__author__ = 'Younghy'

import sys, logging, random, string, time

import sys
reload(sys)
sys.setdefaultencoding('utf8')

import json,datetime
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


class TzjTools():
    def __init__(self):
        self.token = ''
        self.resp_data = ''
        self.code = ''

    def Senddebt(self, amount=Tzjconfig.debt_amount,period=Tzjconfig.debt_period,period_unit=Tzjconfig.debt_period_unit,type=Tzjconfig.debt_type,borrower=Tzjconfig.debt_borrower,
                 repaymentType=Tzjconfig.debt_repaymentType,
                 mandataryUid=Tzjconfig.debt_mandataryUid,open_invest_at=Tzjconfig.debt_open_invest_at):
        '''
                发布借款标
                :param amount:借款金额10000
                :param period:期限：默认是3
                :param period_unit:期限单位：m默认是月
                :param type:默认是8  新手标是3
                :param uid: 借款人uid(默认：mall-LEnLvfiEDA)
                :param repaymentType:默认是ONE_TIME
                :param mandataryUid:默认是"mall-iStUDMAMHR"
                :param open_invest_at:默认不填，如果需要发倒计时标,这里填写比当前时间大几天的整数天，int类型
                :return:返回标的id
                '''
        headers = {'content-type': 'application/json'}
        print(Tzjconfig.debt_url)
        print(Tzjconfig.debt_url)
        url = '%s%s' % (Tzjconfig.debt_url,"/core.bid.svc/api")

        # 债权申请
        data = json.dumps(
            {'uid': borrower, "amount": amount, "borrowPeriod": period, "borrowPeriodUnit": period_unit, "rate": 9.5,
             "repaymentType": repaymentType, "description": "test", "loanType": "PERSON", "mandataryUid": mandataryUid})

        urls = '%s%s' % (url,"/loans")
        result = requests.post(urls, data=data, headers=headers)
        print(result)
        json_result = result.json()
        loanId = json_result['id']  # 获得ID


        # 债权配置
        data_peizhi = json.dumps({'loanId': loanId, "categoryId": type})

        urls = url + "/debts/package"
        result1 = requests.post(urls, data=data_peizhi, headers=headers)

        json_result = result1.json()
        debtId = json_result["id"]  # 获得债权ID
        categoryLabel = json_result['title']

        # 审核
        data_shenhe = json.dumps({'operator': "sytem", "description": "tongguo"})

        urls = '%s%s%d%s' % (url,"/debts/", int(debtId), "/verify")
        result2 = requests.put(urls, data=data_shenhe, headers=headers)

        json_result = result2.json()
        debtId = json_result['id']  # 获得债权ID


        # 上线
        if open_invest_at == 'nodata':
            data_shenhe = json.dumps({'operator': "sytem", "description": "tongguo"})
        else:
            time=(datetime.datetime.now()+datetime.timedelta(days=int(open_invest_at))).strftime("%Y-%m-%d %H:%M:%S")
            data_shenhe = json.dumps({'operator': "sytem", "description": "tongguo",'openInvestAt':time})

        urls = '%s%s%d%s' % (url,"/debts/", int(debtId), "/online")
        result3 = requests.put(urls, data=data_shenhe, headers=headers)

        json_result = result3.json()
        debtId = json_result['id']  # 获得债权ID
        print(debtId)
        return debtId


    def Sendvoucher(self, uid,rewardId=Tzjconfig.voucher_rewardId,activityId=Tzjconfig.voucher_activityId,channel=Tzjconfig.voucher_channel,comment=Tzjconfig.voucher_comment,
                 activitySerialNo=Tzjconfig.voucher_activitySerialNo,user=Tzjconfig.voucher_senduser):
        '''
                发布借款标
                :param amount:借款金额10000
                :param period:期限：默认是3
                :param period_unit:期限单位：m默认是月
                :param type:默认是8  新手标是3
                :param uid: 借款人uid(默认：mall-LEnLvfiEDA)
                :param repaymentType:默认是ONE_TIME
                :param mandataryUid:默认是"mall-iStUDMAMHR"
                :param open_invest_at:默认不填，如果需要发倒计时标,这里填写比当前时间大几天的整数天，int类型
                :return:返回标的id
                '''
        headers = {'content-type': 'application/json'}
        print(Tzjconfig.debt_url)
        print(Tzjconfig.debt_url)
        url = '%s%s' % (Tzjconfig.debt_url,"/core.bid.svc/api")

        # 债权申请
        data = json.dumps(
            {'uid': user, "activityId": activityId, "rewardId": rewardId, "comment": comment, "channel": channel,
             "rewards":[{"uid": uid, "activitySerialNo": activitySerialNo}]})

        urls = Tzjconfig.voucher_url
        result = requests.post(urls, data=data, headers=headers)
        code=result.status_code
        if code==200:
            logging.info(u'提现券发放成功')
            time.sleep(2) #发完券后会立马查询不到，需要等待1秒钟
        else:
            logging.info(u'提现券发放失败，请检查')


    def update_debtId_calculate_time(self, debtId):
        '''
        修改标的计息时间，往前改一天（debt表的calculate_interest_at, invest表的calc_interest_at）
        :param debtId:标的id
        :return:
        '''
        sqls = Tzj_sql()

        d1 = datetime.datetime.now()
        d3 = d1 + datetime.timedelta(days=-1)
        d3 = d3.strftime('%Y-%m-%d %H:%M:%S')

        # 计息时间写入debt表
        time_debt_string = "UPDATE bid.debt set calculate_interest_at=" + '"' + d3 + '"' + " where id =" + debtId
        sqls.query_sqlstring("bid", time_debt_string)

        # 计息时间写入invest表
        time_invest_string = "UPDATE bid.invest set calc_interest_at=" + '"' + d3 + '"' + " where relation_id =" + debtId
        sqls.query_sqlstring("bid", time_invest_string)


if __name__ == '__main__':
    hh = TzjTools()
    #print(hh.Senddebt(amount='16',period='3',period_unit='月',open_invest_at=1))
    #print(hh.Senddebt('16','3',U'月'))

    hh.Sendvoucher('MQyDqR25t')

