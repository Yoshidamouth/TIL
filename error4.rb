# エラーが意図せず吹き出しで表示される

## 現象
バリデーションエラーの表示が何故かemailのみ吹き出しで表示され、他の項目は表示されない。
調べたところjavascript(jquery?)の機能のようだが、何処を触れば良いのかが分からない。

## 解決方法
<%= form_for @user, url: user_registration_path do |f| %>

上記の記述を下記に修正することで解決した。

<%= form_for @user, url: user_registration_path, class: 'needs-validation', html: {novalidate: true} do |f| %>

bootstrap4の入力検証機能を有効にするneeds-validationクラスと、
ブラウザのデフォルトの入力検証機能を無効にするnovalidate属性を指定してなかった為不具合が発生していた。