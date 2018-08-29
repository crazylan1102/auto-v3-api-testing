#!/usr/bin/env python
# encoding: utf-8
__author__ = 'Younghy'

import requests
import logging,json
import Tzjconfig


class Login():
    res=''
    def tzj_login(self,url,username,password):
        logging.info(u"***********login函数开始*********")
         #处理请求头
        headers={"Content-Type":"application/json"}
        data=json.dumps({"username":username,'password':password})
        logging.info(U"当前uid是：%r" %username)
        try:
            resp=requests.post(Tzjconfig.host_url+url,data=data,timeout=30,verify=False,headers=headers)
            Login.res=resp.json()
            logging.info(u'登录后的结果:%r' %Login.res)

        except requests.RequestException as e:
            print e
            logging.info(u'登录异常')
            return Login.res

        else:
            return Login.res




if __name__ == '__main__':
    hh=Login()
    a=hh.tzj_login("http://api.tzj.net/v3/user/login",'Mh7ZY8MKz','test1111')
    print a

