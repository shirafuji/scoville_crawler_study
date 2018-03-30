# Scoville勉強会#7 railsでwebスクレイピング
___

## 目次
1. 今回の目的
 * 勉強会の目的
 * 勉強会の理由
2. railsのgemについて
 * gemとは？
 * railsでのgemの利用法
 * gemの例
3. webスクレイピングについて
 * webスクレイピングとは？
 * 実行理由
 * webスクレイピングに関するgem
4. webスクレイピング体験
 * 体験してみる
 * コード解説
5. 演習
 * 便利なメソッド
 * 自分で作ってみましょう！
___

## 1. 今回の目的
___
### 勉強会の目的
* railsのgemを理解する
* webスクレイピングの知識をつける
* railsでwebスクレイピングができる
___
### 勉強会の理由
* railsでgemが使えると、本格的な機能を素早く簡単に実装することができるので、とても便利。
* webスクレイピングができるとweb上から自動で素早くデータを集めることができる。
___
## 2. railsのgemについて
___
### gemとは？
Ruby用のパッケージ管理ツール。
つまり、railsでライブラリを利用するときに必要なツール。
___
### railsでのgemの利用法
Bundler:
Railsアプリケーションに必要となるGemパッケージの種類やバージョンを管理する。
利用したいgemパッケージの情報 (名前とバージョン)をGemfileに書き込み`bundle install`というコマンドを実行するとインストールが完了。
___
### gemパッケージの例
* Anemone:webスクレイピングのパッケージ(今回のsample appにも利用しています。)
* Nokogiri:HTMLやXMLの構造を解析して、特定の要素を指定しやすい形に加工できる。XpathやCSSセレクタを使った要素の抽出を行うことができる。(今回のsample appにも利用しています。)
* devise:ログイン機能のパッケージ
などなど
___
## 3. webスクレイピングについて
___
### webスクレイピングとは？
Webスクレイピングとは、WebサイトからWebページのHTMLデータを収集して、特定のデータを抽出、整形し直すこと。
クロールなどとも言う。
___
### 実行理由
webスクレイピングをすれば、公式に公開されていない情報も、web上から自動で素早く収集することができる。
例）hoskomi
___
## 4. webスクレイピング体験
___
### 体験してみる
まず、以下のコマンドでcloneしてください。
`git clone https://github.com/shirafuji/scoville_crawler_study.git`

次に、clonesしたディレクトリに移動し、`bundle install`でgemパッケージをインストール、`rails db:migrate`で全てのマイグレーションを実行する。

これで準備は完了です。
___
今回は[Anemone](https://github.com/chriskite/anemone)、[Nokogiri](http://www.nokogiri.org/)というgemパッケージを使って、[Scoville Tech Blog](https://tech.sc0ville.com/)のすべての記事のタイトルと掲載日をクロールして、それをdbに入れるクローラーを用意しています。

`rails crawler:run`とコマンドを打つとこのクローラーが実行されます。
___
`rails c`を実行してコンソールを開き、`Article.all`とコマンドを打って、dbに[Scoville Tech Blog](https://tech.sc0ville.com/)のすべての記事が入っていることを確認してください。
(コンソールはexitで終了することができます。)
___
### コード解説
```
Anemone.crawl(url, depth_limit: 0) do |anemone|
  ...
end
```
urlで指定したページからクロールを始める。
depth_limitはどれだけの深さまでクロールを続けるかを意味するオプション。depth_limit: 0は最初に飛ぶページのみをクロールするという意味。
___
```
anemone.on_every_page do |page|
  ...
end
```
可能な限りすべてのページをクロールするというメソッド。
ここで`.on_pages_like(正規表現) do |page|`を使うと、その正規表現に合ったページのみをクロールする
___
```
doc = Nokogiri::HTML.parse(page.body)
```
ここでページのbodyを、Nokogiri形式に変換している。
このおかげで、xpathなどで要素を取得することができている。
___
```
article_divs = doc.xpath(%Q[/html/body/main/section/div[1]/div[@class="articleFeatured"]])
```
これは、＜html＞の中の＜body＞の中の＜main＞の中の＜section＞の中の＜div＞の１番目の中の＜div＞のclass="articleFeatured"であるものをarticle_divsに入れている。(なんとなくわかっていただけると思います。)
(%Q[]はその中身を文字列にするもの)
（ちなみにブラウザで検証からxpathをコピーすることができます。）
これにより、記事のタイトルと日付を取得しています。
___
それ以降の部分では、それぞれの記事の＜div＞で再びxpathを利用してタイトルと日付を取得して、その情報を利用してArticleをcreateしています。

このような流れでweb上の情報を収集しています。
___
## 5. 演習
##### 自分のクローラーを作る
___
### 便利なメソッドやオプション
Anemoneの便利なメソッドや、オプションを紹介します。
`Anemone.crawl()`
のオプションとしては、`depth_limit`, `delay`, `user_agent`などがある。
これにより、クロールする上での階層、間隔、UAが指定できる。
___
メソッド
* `.on_pages_like(正規表現) do |page|`
クロールするページを正規表現によって限定することができる。
___
メソッド
* `.skip_links_like(正規表現)`
指定された正規表現にあったページはクロールしない。
___
### 自分で作ってみましょう！
サンプルアプリケーションの`lib/tasks/crawler.rake`にmyCrawlerがあります。
自分で中身を書いてみましょう！
