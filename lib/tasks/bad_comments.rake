namespace :bad_comments do
  desc 'Send an email to the admin to notify him about the suspicious emails'
  task notify: :environment do
    banned_words = %w[caca culo pedo pis]
    comments = []
    banned_words.each { |word| comments |= Comment.get(content: word) }
    unless comments.empty?
      AdminNotificationMailer.with(comments: comments)
                             .send_notification.deliver_now
    end
  end
end
