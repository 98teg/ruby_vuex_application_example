class CommentNotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_notification
    @comment = params[:comment]
    @post = Post.find(@comment.post_id)
    @user = User.find(@post.user_id)
    mail(to: @user.email, subject: 'Tu post tiene un nuevo comentario')
  end
end
