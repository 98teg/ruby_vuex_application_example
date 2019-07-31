class CommentsCheckJob < ApplicationJob
  queue_as :default

  def perform(id)
    banned_words = %w[caca culo pedo pis]

    comment = Comment.find(id)

    return unless banned_words.any? { |word| comment.content.downcase.include? word }

    AdminNotificationMailer.with(comments: [comment])
                           .send_notification.deliver_now
  end
end
