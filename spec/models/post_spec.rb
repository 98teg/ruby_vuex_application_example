require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:content).of_type(:text) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :content }
  end

  describe 'Methods' do
    describe '.filter' do
      it 'get all posts' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        expect(Post.filter(filter).count).to eq 3
      end

      it 'get a post using its title' do
        FactoryBot.create_list(:post, 3)
        post = Post.first
        filter = {}
        filter[:title] = post.title
        expect(Post.filter(filter).count).to eq 1
        expect(Post.filter(filter).first.title).to eq post.title
      end

      it 'get a post using its content' do
        FactoryBot.create_list(:post, 3)
        post = Post.first
        filter = {}
        filter[:content] = post.content
        expect(Post.filter(filter).count).to eq 1
        expect(Post.filter(filter).first.content).to eq post.content
      end

      it 'get all the posts until today' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:until] = Time.zone.now + 2.hours
        expect(Post.filter(filter).count).to eq 3
      end

      it 'get all the posts since today' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:since] = Time.zone.now + 2.hours
        expect(Post.filter(filter).count).to eq 0
      end

      it 'get a post using its user id' do
        FactoryBot.create_list(:post, 3)
        filter = {}
        filter[:user_id] = Post.first.user_id
        expect(Post.filter(filter).count).not_to eq 0
      end
    end

    describe '.ordenate' do
      it 'any sort at all' do
        FactoryBot.create_list(:post, 3)
        sort = ''
        expect(Post.ordenate(sort)).to eq Post.all
      end

      it 'sort by title' do
        FactoryBot.create_list(:post, 3)
        sort = 'title'
        expect(Post.ordenate(sort)).to eq Post.all.order('title ASC')
        sort = '-title'
        expect(Post.ordenate(sort)).to eq Post.all.order('title DESC')
      end

      it 'sort by creation date' do
        FactoryBot.create_list(:post, 3)
        sort = 'created_at'
        expect(Post.ordenate(sort)).to eq Post.all
                                              .order('created_at ASC')
        sort = '-created_at'
        expect(Post.ordenate(sort)).to eq Post.all
                                              .order('created_at DESC')
      end

      it 'sort by author\'s name' do
        FactoryBot.create_list(:post, 3)
        sort = 'user_name'
        expect(Post.ordenate(sort)).to eq Post.all.includes(:user)
                                              .order('users.name ASC')
        sort = '-user_name'
        expect(Post.ordenate(sort)).to eq Post.all.includes(:user)
                                              .order('users.name DESC')
      end
    end

    describe '.paginate' do
      it 'any pagination at all' do
        FactoryBot.create_list(:post, 30)
        expect(Post.paginate.count).to be 10
      end

      it 'paginate per 2' do
        FactoryBot.create_list(:post, 3)
        page = {}
        page[:size] = 2
        expect(Post.paginate(page).count).to be 2
        page[:number] = 2
        expect(Post.paginate(page).count).to be 1
        page[:number] = 3
        expect(Post.paginate(page).count).to be 0
      end

      it 'paginate per 1' do
        FactoryBot.create_list(:post, 3)
        page = {}
        page[:size] = 1
        page[:number] = 1
        expect(Post.paginate(page).first).to eq Post.first
        page[:number] = 2
        expect(Post.paginate(page).first).to eq Post.second
        page[:number] = 3
        expect(Post.paginate(page).first).to eq Post.last
      end
    end
  end
end
