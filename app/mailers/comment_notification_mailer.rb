class CommentNotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_notification
    @comment = params[:comment]
    @post = @comment.post
    @user = @comment.user
    mail(to: @user.email, subject: 'Tu post tiene un nuevo comentario')
  end
end
