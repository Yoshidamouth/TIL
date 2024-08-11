# エラー文が表示されるとレイアウトが崩れる

この事象の原因は、エラーが発生している時Railsが自動的にfield_with_errorsクラスを持つdivタグで、labelタグやinputタグを囲むことによって発生する。
field_with_errorsクラスに「display contents」を記述したら解決した。

.field_with_errors {
  display: contents;
}