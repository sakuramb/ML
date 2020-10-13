from requests_oauthlib import OAuth1Session
from requests.exceptions import ConnectionError, ReadTimeout, SSLError
import json, datetime, time, pytz, re, sys,traceback, pymongo
from pymongo import MongoClient
from collections import defaultdict
import numpy as np
import os

# 環境変数から認証情報を取得する。

# TWITTER_API_KEY = os.environ['TWITTER_API_KEY']
# TWITTER_API_SECRET_KEY = os.environ['TWITTER_API_SECRET_KEY']
# TWITTER_ACCESS_TOKEN = os.environ['TWITTER_ACCESS_TOKEN']
# TWITTER_ACCESS_TOKEN_SECRET = os.environ['TWITTER_ACCESS_TOKEN_SECRET']



KEYS = { # 自分のアカウントで入手したキーを下記に記載
        'consumer_key':os.environ['TWITTER_API_KEY'],
        'consumer_secret':os.environ['TWITTER_API_SECRET_KEY'],
        'access_token':os.environ['TWITTER_ACCESS_TOKEN'],
        'access_secret':os.environ['TWITTER_ACCESS_TOKEN_SECRET'],
       }

twitter = None
connect = None
db      = None
tweetdata = None
meta    = None

def initialize(): # twitter接続情報や、mongoDBへの接続処理等initial処理実行
    global twitter, twitter, connect, db, tweetdata, meta
    twitter = OAuth1Session(KEYS['consumer_key'],KEYS['consumer_secret'],
                            KEYS['access_token'],KEYS['access_secret'])
#   connect = Connection('localhost', 27017)     # Connection classは廃止されたのでMongoClientに変更 
    connect = MongoClient('localhost', 27017)
    db = connect.starbucks
    tweetdata = db.tweetdata
    meta = db.metadata

initialize()