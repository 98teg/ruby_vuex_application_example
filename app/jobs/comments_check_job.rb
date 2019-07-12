class CommentsCheckJob < ApplicationJob
  queue_as :default

  def perform(comment)
    banned_words = %w[caca culo pedo pis]

    return unless banned_words.any? { |word| comment.content.downcase.include? word }

    AdminNotificationMailer.with(comments: [comment])
                           .send_notification.deliver_now
  end
end
