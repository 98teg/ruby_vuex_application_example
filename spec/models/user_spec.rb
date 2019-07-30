require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
  end

  describe 'Relations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(64) }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to allow_value('email@email.com').for(:email) }
    it { is_expected.not_to allow_value('email').for(:email) }
    it { is_expected.not_to allow_value('email.com').for(:email) }
    it { is_expected.not_to allow_value('email@email.').for(:email) }
  end

  describe 'Hooks' do
    describe '.after_create' do
      it 'call method assign_default_role' do
        user = FactoryBot.create(:user)
        expect(user).to have_role(:user)
      end
    end
  end

  describe 'Methods' do
    describe '.filter' do
      it 'get all users' do
        FactoryBot.create_list(:user, 3)
        expect(User.filter.count).to be 3
      end

      it 'get an user using his name' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filters = {}
        filters[:name] = user.name
        expect(User.filter(filters).count).to be 1
        expect(User.filter(filters).first.name).to eq user.name
      end

      it 'get an user using his email' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filters = {}
        filters[:email] = user.email
        expect(User.filter(filters).count).to be 1
        expect(User.filter(filters).first.email).to eq user.email
      end

      it 'get an user using both his name and his email' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filters = {}
        filters[:name] = user.name
        filters[:email] = user.email
        expect(User.filter(filters).count).to be 1
        expect(User.filter(filters).first.email).to eq user.email
      end

      it 'failing because of a different name and email' do
        FactoryBot.create_list(:user, 3)
        user1 = User.first
        user2 = User.second
        filters = {}
        filters[:name] = user1.name
        filters[:email] = user2.email
        expect(User.filter(filters).count).to be 0
      end
    end

    describe '.ordenate' do
      it 'any sort at all' do
        FactoryBot.create_list(:user, 3)
        expect(User.ordenate).to eq User.all
      end

      it 'sort by name' do
        FactoryBot.create_list(:user, 3)
        sort = 'name'
        expect(User.ordenate(sort)).to eq User.all.order('name ASC')
        sort = '-name'
        expect(User.ordenate(sort)).to eq User.all.order('name DESC')
      end

      it 'sort by email' do
        FactoryBot.create_list(:user, 3)
        sort = 'email'
        expect(User.ordenate(sort)).to eq User.all.order('email ASC')
        sort = '-email'
        expect(User.ordenate(sort)).to eq User.all.order('email DESC')
      end

      it 'sort by name and email' do
        FactoryBot.create_list(:user, 3)
        sort = 'name,email'
        expect(User.ordenate(sort)).to eq User.all.order('name ASC, email ASC')
      end
    end

    describe '.paginate' do
      it 'any pagination at all' do
        FactoryBot.create_list(:user, 30)
        expect(User.paginate.count).to be 10
      end

      it 'paginate per 2' do
        FactoryBot.create_list(:user, 3)
        page = {}
        page[:size] = 2
        expect(User.paginate(page).count).to be 2
        page[:number] = 2
        expect(User.paginate(page).count).to be 1
        page[:number] = 3
        expect(User.paginate(page).count).to be 0
      end

      it 'paginate per 1' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        page = {}
        page[:size] = 1
        page[:number] = 1
        expect(User.paginate(page).first).to eq User.all.first
        page[:number] = 2
        expect(User.paginate(page).first).to eq User.all.second
        page[:number] = 3
        expect(User.paginate(page).first).to eq User.all.last
      end
    end
  end
end
