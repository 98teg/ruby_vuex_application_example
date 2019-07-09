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
  end
end
