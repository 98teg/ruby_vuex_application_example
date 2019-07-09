require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:content).of_type(:text) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :comments }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :content }
  end

  describe 'Methods' do
    describe '.get' do
      Faker::UniqueGenerator.clear

      it 'get all posts' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        expect(Post.get(filter).length).to eq 3
      end

      it 'get a post using its title' do
        FactoryBot.create_list(:post, 3)
        post = Post.first
        filter = {}
        filter[:title] = post.title
        expect(Post.get(filter).length).to eq 1
        expect(Post.get(filter).first.title).to eq post.title
      end

      it 'get a post using its content' do
        FactoryBot.create_list(:post, 3)
        post = Post.first
        filter = {}
        filter[:content] = post.content
        expect(Post.get(filter).length).to eq 1
        expect(Post.get(filter).first.content).to eq post.content
      end

      it 'get all the posts until today' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:until] = Time.zone.now
        expect(Post.get(filter).length).to eq 3
      end

      it 'get all the posts since today' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:since] = Time.zone.now
        expect(Post.get(filter).length).to eq 0
      end

      it 'get a post using its user id' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:user_id] = Post.first.user_id
        expect(Post.get(filter).length).to_not eq 0
      end
    end

    describe '.sort' do
      Faker::UniqueGenerator.clear

      it 'any sort at all' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        sort = ''
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '')
      end

      it 'sort by title' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        sort = 'title'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '').order('title ASC')
        sort = '-title'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '').order('title DESC')
      end

      it 'sort by creation date' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = 'created_at'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '')
                                                             .order('created_at ASC')
        sort = '-created_at'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '')
                                                             .order('created_at DESC')
      end

      it 'sort by author name' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = 'user_name'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '').includes(:user)
                                                             .order('users.name ASC')
        sort = '-user_name'
        expect(Post.order(Post.get(filter), sort)).to eq Post.get(filter: '').includes(:user)
                                                             .order('users.name DESC')
      end
    end

    describe '.paginate' do
      it 'any pagination at all' do
        FactoryBot.create_list(:post, 30)
        filter = {}
        page = {}
        expect(Post.paginate(Post.get(filter), page).length).to be 10
      end

      it 'paginate per 2' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        page = {}
        page[:size] = 2
        expect(Post.paginate(Post.get(filter), page).length).to be 2
        page[:number] = 2
        expect(Post.paginate(Post.get(filter), page).length).to be 1
        page[:number] = 3
        expect(Post.paginate(Post.get(filter), page).length).to be 0
      end

      it 'paginate per 1' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        page = {}
        page[:size] = 1
        page[:number] = 1
        expect(Post.paginate(Post.get(filter), page).first).to eq Post.get(filter).first
        page[:number] = 2
        expect(Post.paginate(Post.get(filter), page).first).to eq Post.get(filter).second
        page[:number] = 3
        expect(Post.paginate(Post.get(filter), page).first).to eq Post.get(filter).last
      end
    end
  end
end
