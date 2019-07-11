class AdminNotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_notification
    @comments = params[:comments]
    mail(to: 'admin@email.com', subject: 'Estos comentarios contienen palabras baneadas')
  end
end
