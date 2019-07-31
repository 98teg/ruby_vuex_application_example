require 'rails_helper'

RSpec.describe CommentsCheckJob, type: :job do
  include ActiveJob::TestHelper

  let(:comment) { FactoryBot.create(:comment) }
  let(:bad_comment) { FactoryBot.create(:comment, content: 'CACA :P') }

  context 'when the comment doesn\'t contain a bad word' do
    before do
      comment
    end

    it 'enqueues a communication job' do
      expect { CommentsCheckJob.perform_later comment.id }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'does not sent any email' do
      expect { perform_enqueued_jobs { CommentsCheckJob.perform_later comment.id } }
        .to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'when the comment contains a bad word' do
    before do
      bad_comment
    end

    it 'enqueues a communication job' do
      expect { CommentsCheckJob.perform_later bad_comment.id }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'sent an email' do
      expect { perform_enqueued_jobs { CommentsCheckJob.perform_later bad_comment.id } }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'has the correct destiny' do
      perform_enqueued_jobs { CommentsCheckJob.perform_later bad_comment.id }
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to eq ['admin@email.com']
    end

    it 'has the correct subject' do
      perform_enqueued_jobs { CommentsCheckJob.perform_later bad_comment.id }
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.subject).to eq 'Estos comentarios contienen palabras baneadas'
    end

    it 'includes the comment\'s content' do
      perform_enqueued_jobs { CommentsCheckJob.perform_later bad_comment.id }
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to_s).to include 'CACA :P'
    end
  end
end
