# エラー文が重複表示される

## 現象
何も入力しないで送信ボタンを押すと、エラー文が重複して表示される

## 解決方法
optional: trueを追加して、belongs_toアソシエーションによる自動的なバリデーションチェックを回避する
エラー文が重複して表示される問題は、`belongs_to`アソシエーションと、`validates :article_id, presence: true`が両方とも適用されているために発生しているため。
Rails5から`belongs_to`アソシエーションがデフォルトで必須となり、`article_id`が存在しないと自動的にエラーを出すようになりました。それとは別に`validates :article_id, presence: true`で再度`article_id`の存在チェックを行っているため、同じエラーメッセージが2回表示されていると考えられる。
そこで、Requestモデルのbelongs_to :articleの部分に`optional: true`を追加して、belongs_toアソシエーションによる自動的なバリデーションチェックを回避する。
その上で、自分で定義したバリデーションによって存在チェックを行うようにする。

class Request < ApplicationRecord
  validates :article_id, presence: { message: "を選択してください" }
  validates :quantity,
            presence: { message: "を入力してください" },
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 100,
              message: "は1以上100以下の半角数字で入力してください",
              allow_blank: true
            }
  validates :status, :user_id, :request_time, presence: true

  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :article, optional: true #ここを追加
  belongs_to :response_user, class_name: 'User', optional: true
end