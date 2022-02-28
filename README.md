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
|status|integer|
|priority|string|

## Labelモデル
|カラム名|カラム名|
|:--|:--:|
|id|index|
|user_id|bigint|
|name|string|
