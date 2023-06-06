# cje1gw-samples-2022
Sample codes of presented at the Code4Lib Japan Conference 2022

Code4lib Japanan カンファレンス2022で発表した
「目録検索システム構築演習その後 – 外部サービス利用条件変更への対応」
https://wiki.code4lib.jp/wiki/C4ljp2022/presentation#p6
(スライド: https://www.sakalab.org/redirect/luEjlA) 
のサンプルコードです。このままでは使用できません(一部snip/置き換えしています)。
apache httpd等の設定ファイルは、それぞれ適切な修正が必要でしょう。

2023年6月6日追記: flask-ngrokはFlaskを古いバージョンに置き換えて稼働する仕組みで、
この cje1gwも同様でした。
しかしながら、最近になってFlaskが依存するライブラリの更新と共にその古いFlaskが
動かなくなったので、最新版のFlaskで動くように、テストhttpサーバを wsgiref を使う
ように書き換えたのが、今回更新した pycode.cje1gw.__init__.py です。
