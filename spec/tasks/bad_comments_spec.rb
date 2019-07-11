require 'rails_helper'

describe 'rake bad_comments:notify', type: :task do
  context 'when there are not bad comments' do
    before do
      FactoryBot.create(:comment, content: 'Me hago la cena')
      FactoryBot.create(:comment, content: 'He merendado galletas')
      FactoryBot.create(:comment, content: 'Quiero desayunar')
      FactoryBot.create(:comment, content: 'He comido rico')
    end

    it 'works' do
      task.execute
    end

    it 'have not sent any email' do
      expect { task.execute }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'when there are bad comments' do
    before do
      FactoryBot.create(:comment, content: 'Hago caca')
      FactoryBot.create(:comment, content: 'He merendado galletas')
      FactoryBot.create(:comment, content: 'Hago pis')
      FactoryBot.create(:comment, content: 'Hago caca y pis')
    end

    it 'works' do
      task.execute
    end

    it 'have sent email' do
      expect { task.execute }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'has the correct destiny' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to eq ['admin@email.com']
    end

    it 'has the correct subject' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.subject).to eq 'Estos comentarios contienen palabras baneadas'
    end

    it 'includes the first comment\'s content' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to_s).to include 'Hago caca'
    end

    it 'does not include the second comment\'s content' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to_s).not_to include 'He merendado galletas'
    end

    it 'includes the third comment\'s content' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to_s).to include 'Hago pis'
    end

    it 'includes the fourth comment\'s content' do
      task.execute
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to_s).to include 'Hago caca y pis'
    end
  end
end
