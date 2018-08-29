#!/usr/bin/env python
# encoding: utf-8
__author__ = 'Younghy'
import random

host_url=r'http://api.tzj.net/v3'
password='test1111'
login_url=r'/user/login'

#测试环境数据库连接
mysql_host='mysql.tzj.net'
mysql_port=3306
mysql_user='root'
mysql_password='tzj'
mysql_charset='utf8mb4'
mysql_db='bid'


#发标默认数据配置
debt_borrower = "mall-tMHDIwGrWy"
debt_amount = "1002"
debt_period = "3"
debt_period_unit = '月'
debt_type = 8
debt_repaymentType = 'ONE_TIME'
debt_mandataryUid = "mall-iStUDMAMHR"
debt_url = "http://a.io.tzj.net"
debt_open_invest_at='nodata'


#发提现券默认数据配置
voucher_senduser='yanghy'
voucher_activityId='CLUB_SHOP'
voucher_rewardId='cash_voucher'
voucher_comment='test'
voucher_channel='CLUB_SHOP'
voucher_activitySerialNo='20180611%s' %random.randint(0000,9999999)
voucher_url='http://a.io.tzj.net/vouchers_trade.reward.svc/api/rewards'



excel_dataahah = "fsdfsa"
