# リダイレクトしないとデータが表示されない

## 現象
コメントが表示されている画面で、何も入力しないで「送信」を押すと、何もコメントが表示されない画面になる。
DBからも消えたわけではなく、リロードしたら再び表示される。

## 解決方法
'Comments#create'アクションでエラーが発生し、'requests/show.html.erb'ビューがレンダリングされようとしている際に@commentsがnilのため、エラーが発生していた。
'Comments#create'アクションでバリデーションエラーが発生したときにリダイレクトする先が'requests/show'であり、そのビュー内で@commentsを使用しているため、エラーが発生していると考えられる。
解決策としては、'Comments#create'アクション内で@commentsを再定義（再取得）すること。以下のように修正した。

class CommentsController < ApplicationController

  def create
    @request = Request.find(params[:request_id])
    @comment = @request.comments.build(comment_params)
  
    if @comment.save
      redirect_to request_path(@request)
    else
      @comments = @request.comments.order(created_at: :desc) # 追記
      render "requests/show", status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, comment_time: Time.now)
  end
end