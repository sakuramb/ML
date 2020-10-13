# coding:utf-8

import sys
import requests #ファイル名をrequests.pyにするとエラー発生

url = sys.argv[1]  # 第1引数からURLを取得する。
r = requests.get(url)  # URLで指定したWebページを取得する。
print(f'encoding: {r.encoding}', file=sys.stderr)  # エンコーディングを標準エラー出力に出力する。
print(r.text)  # デコードしたレスポンスボディを標準出力に出力する。

'''
% python dp_requests.py https://gihyo.jp/dp > dp.html
'''