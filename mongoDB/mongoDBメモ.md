# mongoDB
- [やってみようNoSQL　MongoDBを最速で理解する](https://qiita.com/Brutus/items/8a67a4db0fdc5a33d549)
- [GitHubに載せたくない環境変数の書き方 Python](https://qiita.com/hedgehoCrow/items/2fd56ebea463e7fc0f5b)
- [.gitignore の書き方](https://qiita.com/inabe49/items/16ee3d9d1ce68daa9fff)
- [NoSQLデータベース「MongoDB」をPythonで利用する～pymongoの基本的な使い方まとめ～ ](https://qiita.com/ognek/items/a37dd1cd0e26e6adecaa)

### 概要
![mongodb.png](https://qiita-image-store.s3.amazonaws.com/0/221759/db09e353-6b01-4db4-ed95-7cff74239b3c.png)

- RDBMSのようにレコードをテーブルに格納するのではなく、「ドキュメント」と呼ばれる構造的データをJSONライクな形式で表現し、そのドキュメントの集合を「コレクション」として管理する
- コレクションはスキーマレスなドキュメントで格納され、任意のフィールドを好きなときに追加できる
- ドキュメントには複雑な階層構造を持たせることもでき、それらの構造に含まれるフィールドを指定したクエリやインデックス生成も簡単な指定によって行える
- KVSでは苦手なValueを検索の条件としたり、ソート・集計を実現できる
- [永続性](https://ja.wikipedia.org/wiki/%E6%B0%B8%E7%B6%9A%E6%80%A7)を提供

**MongoDBは、以下のようなシステムに適しています。**

- Webサイトの操作データログの蓄積
- アドホックなフィールドを検索対象とするコンテンツ
- ソーシャルゲーム 

**でも、MongoDBは以下のことができません。**

- NoSQLなので、SQLは使用できない。クエリはJavaScriptで行う
- RDBMSのように高度な結合操作（joinに相当する2つの関係から1つの関係を返す演算処理）
- トランザクション処理（※）

