require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
  end

  describe 'Relations' do
    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :comments }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_length_of(:name).is_at_most(64) }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to allow_value('email@email.com').for(:email) }
    it { is_expected.to_not allow_value('email').for(:email) }
    it { is_expected.to_not allow_value('email.com').for(:email) }
    it { is_expected.to_not allow_value('email@email.').for(:email) }
  end

  describe 'Hooks' do
    describe '.after_create' do
      it 'should call method assign_default_role' do
        user = FactoryBot.create(:user)
        expect(user.has_role?(:user)).to be true
      end
    end
  end

  describe 'Methods' do
    describe '.get' do
      it 'get all users' do
        FactoryBot.create_list(:user, 3)
        expect(User.get(nil).length).to be 3
      end

      it 'get an user using his name' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filter = {}
        filter[:name] = user.name
        expect(User.get(filter).length).to be 1
        expect(User.get(filter).first.name).to eq user.name
      end

      it 'get an user using his email' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filter = {}
        filter[:email] = user.email
        expect(User.get(filter).length).to be 1
        expect(User.get(filter).first.email).to eq user.email
      end

      it 'get an user using both his name and his email' do
        FactoryBot.create_list(:user, 3)
        user = User.first
        filter = {}
        filter[:name] = user.name
        filter[:email] = user.email
        expect(User.get(filter).length).to be 1
        expect(User.get(filter).first.email).to eq user.email
      end

      it 'failing because of a different name and email' do
        FactoryBot.create_list(:user, 3)
        user1 = User.first
        user2 = User.second
        filter = {}
        filter[:name] = user1.name
        filter[:email] = user2.email
        expect(User.get(filter).length).to be 0
      end
    end

    describe '.sort' do
      it 'any sort at all' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = ''
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '')
      end

      it 'sort by name' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = 'name'
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '').order('name ASC')
        sort = '-name'
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '').order('name DESC')
      end

      it 'sort by email' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = 'email'
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '').order('email ASC')
        sort = '-email'
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '').order('email DESC')
      end

      it 'sort by name and email' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        sort = 'name,email'
        expect(User.order(User.get(filter), sort)).to eq User.get(filter: '')
                                                             .order('name ASC, email ASC')
      end
    end

    describe '.paginate' do
      it 'any pagination at all' do
        FactoryBot.create_list(:user, 30)
        filter = {}
        page = {}
        expect(User.paginate(User.get(filter), page).length).to be 10
      end

      it 'paginate per 2' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        page = {}
        page[:size] = 2
        expect(User.paginate(User.get(filter), page).length).to be 2
        page[:number] = 2
        expect(User.paginate(User.get(filter), page).length).to be 1
        page[:number] = 3
        expect(User.paginate(User.get(filter), page).length).to be 0
      end

      it 'paginate per 1' do
        FactoryBot.create_list(:user, 3)
        filter = {}
        page = {}
        page[:size] = 1
        page[:number] = 1
        expect(User.paginate(User.get(filter), page).first).to eq User.get(filter).first
        page[:number] = 2
        expect(User.paginate(User.get(filter), page).first).to eq User.get(filter).second
        page[:number] = 3
        expect(User.paginate(User.get(filter), page).first).to eq User.get(filter).last
      end
    end
  end
end
