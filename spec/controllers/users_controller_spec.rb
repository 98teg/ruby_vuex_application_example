require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :all do
    DatabaseCleaner.start
    @admin = FactoryBot.create(:admin)
    # @user = create(:user)
  end

  after :all do
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    before :all do
      @users = FactoryBot.create_list(:user, 5)
    end

    describe 'request' do
      before do
        get :index
      end

      it 'returns 200 Http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all resources' do
        expect(JSON.parse(response.body)['data'].size).to eq 6
      end

      it 'returns all information' do
        expect(JSON.parse(response.body)['data'].first.keys.map(&:to_sym)).to(
          match_array(User.new.as_json(representation: :basic).keys)
        )
      end
    end

    describe 'pagination' do
      before do
        get :index, params: {page: {number: 1, size: 2}}
      end

      it 'returns paginated resources' do
        expect(JSON.parse(response.body)['data'].size).to eq 2
      end
    end

    describe 'filters name' do
      let(:item) { User.all.to_a.sample }

      before do
        get :index, params: {filter: {name: item.name}}
      end

      it 'returns filtered resources' do
        expect(JSON.parse(response.body)['data'].size).to eq(1)
        expect(JSON.parse(response.body)['data'][0]['id']).to eq item.id
      end
    end

    describe 'order name' do
      before do
        get :index, params: {sort: 'name'}
      end

      it 'returns ordered resources' do
        expect(JSON.parse(response.body)['data'][0]['id']).to eq User.all.order('name ASC')
                                                                     .first.id
      end
    end
  end
  
#  describe 'GET #show' do

#  end
  
#  describe 'PUT #update' do

#  end
  
#  describe 'DELETE #destroy' do

#  end
end
