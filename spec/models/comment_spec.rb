require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:content).of_type(:text) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :post }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :post_id }
    it { is_expected.to validate_presence_of :content }
  end

  describe 'Methods' do
    describe '.get' do
      it 'get all comments' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        expect(Comment.get(filter).length).to eq 3
      end

      it 'get a comment using its content' do
        FactoryBot.create_list(:comment, 3)
        comment = Comment.first
        filter = {}
        filter[:content] = comment.content
        expect(Comment.get(filter).length).to eq 1
        expect(Comment.get(filter).first.content).to eq comment.content
      end

      it 'get all the comments until now' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        filter[:until] = Time.zone.now
        expect(Comment.get(filter).length).to eq 3
      end

      it 'get all the comments since now' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        filter[:since] = Time.zone.now
        expect(Comment.get(filter).length).to eq 0
      end

      it 'get a comment using its user id' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        filter[:user_id] = Comment.first.user_id
        expect(Comment.get(filter).length).not_to eq 0
      end

      it 'get a comment using its post id' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        filter[:post_id] = Comment.first.post_id
        expect(Comment.get(filter).length).not_to eq 0
      end
    end

    describe '.sort' do
      it 'any sort at all' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        sort = ''
        expect(Comment.order(Comment.get(filter), sort)).to eq Comment.get(filter: '')
      end

      it 'sort by creation date' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        sort = 'created_at'
        expect(Comment.order(Comment.get(filter), sort)).to eq Comment.get(filter: '')
                                                                      .order('created_at ASC')
        sort = '-created_at'
        expect(Comment.order(Comment.get(filter), sort)).to eq Comment.get(filter: '')
                                                                      .order('created_at DESC')
      end

      it 'sort by author\'s name' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        sort = 'user_name'
        expect(Comment.order(Comment.get(filter), sort))
          .to eq Comment.get(filter: '').includes(:user, :post).order('users.name ASC')
        sort = '-user_name'
        expect(Comment.order(Comment.get(filter), sort))
          .to eq Comment.get(filter: '').includes(:user, :post).order('users.name DESC')
      end

      it 'sort by post\'s title' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        sort = 'post_title'
        expect(Comment.order(Comment.get(filter), sort))
          .to eq Comment.get(filter: '').includes(:user, :post).order('posts.title ASC')
        sort = '-post_title'
        expect(Comment.order(Comment.get(filter), sort))
          .to eq Comment.get(filter: '').includes(:user, :post).order('posts.title DESC')
      end
    end

    describe '.paginate' do
      it 'any pagination at all' do
        FactoryBot.create_list(:comment, 30)
        filter = {}
        page = {}
        expect(Comment.paginate(Comment.get(filter), page).length).to be 10
      end

      it 'paginate per 2' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        page = {}
        page[:size] = 2
        expect(Comment.paginate(Comment.get(filter), page).length).to be 2
        page[:number] = 2
        expect(Comment.paginate(Comment.get(filter), page).length).to be 1
        page[:number] = 3
        expect(Comment.paginate(Comment.get(filter), page).length).to be 0
      end

      it 'paginate per 1' do
        FactoryBot.create_list(:comment, 3)
        filter = {}
        page = {}
        page[:size] = 1
        page[:number] = 1
        expect(Comment.paginate(Comment.get(filter), page).first).to eq Comment.get(filter).first
        page[:number] = 2
        expect(Comment.paginate(Comment.get(filter), page).first).to eq Comment.get(filter).second
        page[:number] = 3
        expect(Comment.paginate(Comment.get(filter), page).first).to eq Comment.get(filter).last
      end
    end
  end
end
