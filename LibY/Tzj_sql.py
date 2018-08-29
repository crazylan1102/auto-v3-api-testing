#!/usr/bin/env python
# encoding: utf-8
__author__ = 'Younghy'

import pymysql
import Tzjconfig
import logging
import sys


class Tzj_sql():

    def mysql_conn(self,db='bid'):
        co=pymysql.connect(host=Tzjconfig.mysql_host,port=Tzjconfig.mysql_port,user=Tzjconfig.mysql_user,passwd=Tzjconfig.mysql_password,charset=Tzjconfig.mysql_charset,db=db)
        return co

    def query_sqlstring(self, database, sql_string):
        logging.info(u"***********进入查询函数*********")
        conn = self.mysql_conn(database)
        cursor = conn.cursor()
        effect_row = cursor.execute(sql_string)
        row1 = cursor.fetchone()
        print row1
        print(type(row1))
        conn.commit()
        logging.info(u"查询结果")
        return row1

    def query_voucher_count(self,uid,type='0',status='2',database='tzj_wallet_voucher'):
        '''
        查询uid不同类型的可用券码的数量

        uid: 投资用户的uid

        type: 使用的券类型 提现券：0；投资券：1；加息券：3；红包券：6,默认是0提现券

        database: 查询的库，默认是tzj_wallet_voucher

        :return: 返回当前可用券的数量

        '''
        logging.info(u"***********查询全部可用券数量函数query_voucher_count开始*********")
        conn=self.mysql_conn(database)
        type=int(type)
        try:
            with conn.cursor() as cursor:
                sql="SELECT count(*)  FROM tzj_wallet_voucher.vouchers WHERE uid=%s AND type=%s AND `status`=%s"
                cursor.execute(sql,(uid,type,status))
                voucher_count=cursor.fetchall()  #这里也可以用fetchall()
                logging.info(u'当前券可用的数量是：%d' %voucher_count[0][0])
                return  voucher_count[0][0]

        except Exception as e:
            logging.info(e)
        finally:
            conn.close()

    def query_voucher_all(self,uid,type,amount=1,database='tzj_wallet_voucher'):
        '''
        查询uid不同类型的可用券码，只查询券类型，不能查询券的面额大小

        uid: 投资用户的uid

        type: 使用的券类型 提现券：0；投资券：1；加息券：3；红包券：6

        amount:一次使用几张券，默认是1，除了提现券、红包外，其他不可传多张

        database: 查询的库，默认是tzj_wallet_voucher

        :return: 返回一个券码
        '''
        logging.info(u"***********查询全部可用券券码函数qurery_voucher_all开始*********")
        conn=self.mysql_conn(database)
        type=int(type)
        try:
            with conn.cursor() as cursor:
                sql="SELECT code  FROM tzj_wallet_voucher.vouchers WHERE uid=%s AND type=%s AND `status`='2' "
                cursor.execute(sql,(uid,type))
                voucher_code=cursor.fetchall()  #这里也可以用fetchall()
                if type==0:
                    voucher_catagory=u'提现券'
                elif type==6:
                    voucher_catagory=u'红包券'
                elif type==1:
                    voucher_catagory=u'投资券'

                elif type==3:
                    voucher_catagory=u'加息券'
                elif type==6:
                    voucher_catagory=u'红包券'
                else:
                    logging.info(u'不支持的券')
                    return u"不支持的券"
                #logging.info(u"用户%s当前可使用的%s的券码是:%s" %(uid,voucher_code))
                voucher_code_list=[]
                if len(voucher_code)<int(amount):
                    logging.info(u"当前账户%s不足" %voucher_catagory)
                    return u"当前账户%s不足" %voucher_catagory
                else:
                    for i in range(int(amount)):
                        voucher_code_list.append(voucher_code[i][0])
                    logging.info(u"用户%s当前使用的%s券码是:%s" %(uid,voucher_catagory,voucher_code_list))
                    return  voucher_code_list

        except Exception as e:
            logging.info(e)
        finally:
            conn.close()

    def update_voucher_status(self,uid,type='0',voucher_status='3',database='tzj_wallet_voucher'):
        '''
        更新当前券的状态，变为已使用

        uid: 投资用户的uid

        type: 使用的券类型 提现券：0；投资券：1；加息券：3；红包券：6,默认是0提现券

        status:想要更新券的状态，默认是3（这里只可以更新为3或者4）

        database: 查询的库，默认是tzj_wallet_voucher

        :return: 返回当前可用券的数量

        '''
        logging.info(u"***********更新当前券为已使用状态函数update_voucher_status开始*********")
        conn=self.mysql_conn(database)
        type=int(type)
        try:
            with conn.cursor() as cursor:
                sql="update tzj_wallet_voucher.vouchers set status=%s WHERE uid=%s AND type=%s AND  status='2'"
                cursor.execute(sql,(voucher_status,uid,type))
                conn.commit()

        except Exception as e:
            logging.info(e)
        finally:
            conn.close()

    def create_tuple(self,*args):
        return args

if __name__ == '__main__':
    aa=Tzj_sql()
    #result = aa.query_invest('20180513975','Lh25OilS0')
    # keys = aa.create_tuple("effected_amount","effected_part","receive_amount","receive_capital_amount","receive_interest_amount","vouchers_value")
    #
    # print(aa.create_tuple("effected_amount","effected_part","receive_amount","receive_interest_amount","vouchers_value"))
    # print(result)
    #
    # print("******************")
    # print(aa.create_sql_result_dict(keys,result))
    #
    # print("sdfsdf"+",sdfsdf")

    # sql="SELECT uid,cert_no,card_no,NAME,mobile,(CASE bind_bank_card_flag WHEN 1 THEN 'true'	WHEN 0 THEN	'false'	ELSE 'null' END) bind_bank_card_flag,(CASE password_flag WHEN 1 THEN 'true' WHEN 0 THEN 'false' ELSE 	'null' END ) password_flag,(CASE is_from_upgrade WHEN 1 THEN 'true' WHEN 0 THEN 'false' ELSE 'null' END ) is_from_upgrade FROM tzj_deposit_account.account WHERE uid="
    # print(aa.query_invest('tzj_deposit_account',sql,'"uCEAK2293"'))

    # print(aa.crete_keys_list(['aa','bb','cc'],['dd','ee'],['ff']))

    #print(aa.create_sql_result_dict(['a','b','c'],[1,2,3]))

    # sql1="SELECT uid,cert_no,card_no,name,mobile,(CASE bind_bank_card_flag WHEN 1 THEN 'true'	WHEN 0 THEN	'false'	ELSE 'null' END) bind_bank_card_flag,(CASE password_flag WHEN 1 THEN 'true' WHEN 0 THEN 'false' ELSE 	'null' END ) password_flag,(CASE is_from_upgrade WHEN 1 THEN 'true' WHEN 0 THEN 'false' ELSE 'null' END ) is_from_upgrade FROM tzj_deposit_account.account WHERE uid=" + "'uCEAK2293'"
    # result1 = aa.query_sqlstring('tzj_deposit_account',sql1)
    #
    #
    # sql2="select (case (select count(*) as num  from tzj_deposit_sign.user_sign where uid="+"'uCEAK2293'" +"and bid_status='having') WHEN 1 THEN 'true' ELSE '0' END )"
    # result2 = aa.query_sqlstring('tzj_deposit_sign',sql2)
    #
    # keys = ["uid","cert_no","card_no","name","mobile","bind_bank_card_flag","password_flag","is_from_upgrade"]+["agreementSigned"]
    #
    # values = list(result1+result2)
    #
    # dicts = aa.create_sql_result_dict(keys,values)
    #
    # print(dicts)
    #bb=aa.query_voucher_all('Lh25OilS0',6,2)
    #print bb[0],bb[1]
    aa.update_voucher_status('MQyDqR25t')
    #print type(aa.query_voucher_count('hKvWH48R3'))




