## SQLレシピメモ
[ビッグデータ分析・活用のためのSQLレシピ](https://www.amazon.co.jp/gp/product/B06XRWPPC9/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)

<details><summary>参考サイト</summary>

 - [PostgreSQL チートシート 入門 - Qiita](https://qiita.com/yusk24/items/e102f3660120ff4fa5e0)
 - [PostgreSQLコマンドチートシート - Qiita](https://qiita.com/Shitimi_613/items/bcd6a7f4134e6a8f0621)
 - [テーブルの作成(CREATE TABLE) ｜ PostgreSQLではじめるDB入門](https://db-study.com/archives/233)
 - [PostgreSQLのデータ型](https://thinkit.co.jp/cert/marugoto/2/1/19/2table.htm)
</details>

<details><summary>雑多メモ</summary>

 - [アクセスログ解析・デジタルアナリティクス用語集 \| 用語集 | ミツエーリンクス](https://www.mitsue.co.jp/case/glossary/l_index.html)

 - インプレッション数：広告が表示された回数
 - リファラー：アクセスログに記載されている情報のひとつで、当該ファイルを取得する（ブラウザで表示する）直前に閲覧していたページのURLを内容とする情報
 - [数値データ型](https://www.postgresql.jp/document/8.2/html/datatype-numeric.html)
 - 移動年計:
その月の売上に過去11カ月分のデータを加えた、その月の直近1 年分の売上の累計値
 - [Zチャートとは？見方を理解して売上の傾向を把握する – ”経営を学ぶ”マネジメントクラブWEBメディア](https://media.management-club.jp/data-zchart-20190601/#:~:text=Z%E3%83%81%E3%83%A3%E3%83%BC%E3%83%88%E3%81%A8%E3%81%AF%E3%80%81%E3%80%8C%E6%9C%88%E3%80%85,%E3%81%A8%E5%91%BC%E3%81%B0%E3%82%8C%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82)
 - ABC分析：全体の割合を占める上位の項目からABCとランク付ける。
 - ファンチャート：ある基準となる時点を100%として、以降の数値の変動を見るグラフ。
 - ヒストグラムの作成方法
   1. 最大値、最小値、範囲（最大値ー最小値）を求める。
   2. 範囲を元に、幾つの階級に分けるか決めて、各階級下限、上限を求める。
   3. 各階級に入るデータの個数（度数）を調べ、その結果を整理して表にまとめる。

</details>

<!-- <details><summary></summary><details> -->

<details><summary>postgreSQL復習</summary>

- postgreSQLサーバの起動し、一応データベース一覧を確認。

```
% pg_ctl start -D /usr/local/var/postgres
% psql -l
```

- データベース”sql”を作成し接続する、テーブル一覧を確認する
```
% createdb sql
% psql sql
sql-# \dt
```
- テーブル”mst_users”を作成しデータを挿入（サンプルコードコピペ）
```
CREATE TABLE mst_users(
    user_id         varchar(255)
  , register_date   varchar(255)
  , register_device integer
);

INSERT INTO mst_users
VALUES
    ('U001', '2016-08-26', 1)
  , ('U002', '2016-08-26', 2)
  , ('U003', '2016-08-27', 3)
;

```
確認してみると、書籍通りのテーブルが完成しているはず。
```
sql=# SELECT*FROM mst_users
```
- DB名を変更する（変更したいDB以外のDBに接続しておく）
```
sqlsql=# ALTER DATABASE sql_Chap_3 RENAME TO sql_3to8;
```
</details>

<details><summary>postgreSQLが起動できない？</summary>

```
pg_ctl: another server might be running;〜
```
いざ起動させようとすると、こんなエラーが表示されてしまった。。
以下のサイトを参考に、ファイルを削除してから起動させると問題なく起動できた。
[postgres をちゃんと終了しないと.pidファイルが残っちゃって、Rails が起動しないもんだい · GitHub](https://gist.github.com/taea/8865831)
[postgresに接続できなくなったのでやったこと - Qiita](https://qiita.com/aiyu427/items/4716903ddeef5ecf16c9)
```
rm /usr/local/var/postgres/postmaster.pid
```
postgreSQLで学習後は以下のコマンドでしっかり終了させておくこと。
```
sql=# exit
$ pg_ctl stop -D /usr/local/var/postgres
```
</details>

<details><summary>サンプルコードの実行に関して</summary>
sqlファイルを実行する。
```
% psql sql
sql-# \i <file_path>
```
</details>

### <U>実践メモ</U>
* [Chap3](#Chap3)
* [Chap4](#Chap4)
* [Chap5](#Chap5)
* [Chap6](#Chap6)
* [Chap7](#Chap7)
* [Chap8](#Chap8)


### <U>Chap3</U>
### 3-1-1
### 3-1-2
- substring関数
- [文字列関数と演算子](https://www.postgresql.jp/document/9.3/html/functions-string.html)
- 正規表現
- [正規表現チェッカー \| WEB ARCH LABO](https://weblabo.oscasierra.net/tools/regex/)
### 3-1-3
- split_part関数
### 3-1-4
- CURRENT_DATE関数
- CURRENT_TIMESTAMP関数
- CAST関数: 2つのデータ型間の変換処理方法を指定するもの
- EXTRACT関数
### 3-1-5
- COALESCE関数:NULLを含む場合任意の値に置き換えて処理
### 3-2-1
- CONCAT関数
- '||'演算子
### 3-2-2
- SIGN関数：引数が正の値は１、０は０、負の値は−１を返す
- greatest関数
- least関数
### 3-2-3
- double precision型（倍精度浮動小数点数型）
※整数の割り算では小数点が切り捨てられてしまうので、明示的に型を変換
- NULLIF:NULLIF(a, 0) aの値が０の場合にNULL
※０除算を避ける
### 3-2-4
- ABS関数：絶対値
- POWER関数：累乗
- SQRT関数：平方根
- ユークリッド距離の計算
  - POINT型：座標を扱うデータ構造
  - 距離演算子：<->

### 3-2-5
- interval型
- age関数
- floor関数：引数より大きくない最大の整数

### 3-2-6
- inet型：IPアドレスを取り扱うためのデータ型
- '>>'演算子：含まれるか否か
- lpad関数：文字列を指定した文字数になるように左埋めする。


### 3-3-1
- DISTINCT句：ユニークな値の数のみ計算
- GROUP BY句：指定のカラムごとにデータをグルーピングし、それぞれ集約関数を適用
- ウィンドウ関数：テーブル内のある種の範囲（ウィンドウ）を定義し、その範囲内に含まれる値を特定のレコードから自由に利用できるよう導入された。
- OVER句：
  - 引数なし→テーブル全体に適用
  - PARTITION BY＋カラム名→カラムの値ごとにグルーピングして適用

### 3-3-2
- DESC:昇順
- ROW_NUMBER関数：ランキングの番号を付与する
- RANK関数、DENSE＿RANK関数：同順位は同じランキング番号、RANK関数は順位の番号を飛ばす
- LAG関数、LEAD関数：前後の行の値を取得する、第２引数で前後n番目の値を取得
- ROWS句：ORDER BY ~ ROWS　~　ウィンドウのフレーム指定の構文
- ROWS BETWEEN start AND end
  - start,endに入る例:
    - CURRENT ROW
    - n RECEDING(n行前)
    - n FOLLOWING(n行後)
    - UNBOUNDED PRECEDING(前の行全て)
    - UNBOUNDED FOLLOWING(後の行全て)
- FIRST_VALUE,LAST_VALUEウィンドウ関数：ウィンドウ内の最上
- フレーム指定：現在のレコード位置に基づき相対的なウィンドウを定義するための構文
- array_agg:対象を集約

### 3-3-3
- 行を列に変換
- string_agg関数:行を文字列に集約する

### 3-3-4(途中)
- 横持ちのデータを縦持ちに
  - 結合テーブル、クロス結合　CROSS JOIN
- 任意長の配列を行集合に展開
  - unnest関数
  - string_to_array関数：提供された区切り文字、およびオプショナルなNULL文字を使用して、文字列を配列の要素に分割
- ピボットテーブル
  - UNION
  - [【SQL】結果の統合はUNIONで!だれでもわかるUNION解説! \| 侍エンジニア塾ブログ（Samurai Blog） - プログラミング入門者向けサイト](https://www.sejuku.net/blog/74750)

### 3-4-1
- UNION ALL

### 3-4-4
- WITH句
- SELECT DISTINCT:問い合わせの結果から重複行を除くように指定

### 3-4-5
- VALUE句で擬似テーブルを作成
- generate_serie：連番を生成

### <U>Chap4</U>
- 時系列データの集計
- SUM(CASE - END)
- ROLLUP:複合カラムでの集計
  - ROLLUP(A, B) 総計、A集計、A＆B集計
- FIRST_VALUE:レコードの先頭行の値を取得

