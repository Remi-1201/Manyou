# テーブルスキーマ

## Userモデル
|カラム名|カラム名|
|:--|:--:|
|id|index|
|name|string|
|email|string|
|password|string|

## Taskモデル
|カラム名|カラム名|
|:--|:--:|
|id|index|
|user_id|bigint|
|name|string|
|detail|text|
|deadline|date|
|status|text|
|priority|string|

## Labelモデル
|カラム名|カラム名|
|:--|:--:|
|id|index|
|user_id|bigint|
|name|string|

## Herokuへのデプロイ手順
<br>
1回目

* wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
* bundle update
* heroku login -i
* heroku create
* heroku git:remote -a アプリ名
* heroku buildpacks:set heroku/ruby
* heroku buildpacks:add --index 1 heroku/nodejs
* git add .
* git push heroku master
* heroku run rake db:migrate
<br>
2回目以降
* heroku login -i
* rails assets:precompile RAILS_ENV=production
* git add .
* git push heroku master
* heroku run rake db:migrate
