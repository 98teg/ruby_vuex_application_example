require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }

  describe 'GET #index' do
    describe 'request' do
      before do
        FactoryBot.create_list(:user, 5)
        get :index
      end

      it 'returns 200 Http status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all resources' do
        expect(JSON.parse(response.body)['data'].size).to eq 5
      end

      it 'returns all information' do
        expect(JSON.parse(response.body)['data'].first.keys.map(&:to_sym)).to(
          match_array(User.new.as_json(representation: :basic).keys)
        )
      end
    end

    describe 'pagination' do
      before do
        FactoryBot.create_list(:user, 5)
        get :index, params: {page: {number: 1, size: 2}}
      end

      it 'returns paginated resources' do
        expect(JSON.parse(response.body)['data'].size).to eq 2
      end
    end

    describe 'filters name' do
      let(:item) { User.all.to_a.sample }

      before do
        FactoryBot.create_list(:user, 5)
        get :index, params: {filter: {name: item.name}}
      end

      it 'returns only one resource' do
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end

      it 'returns filtered resources' do
        expect(JSON.parse(response.body)['data'][0]['id']).to eq item.id
      end
    end

    describe 'order name' do
      before do
        FactoryBot.create_list(:user, 5)
        get :index, params: {sort: 'name'}
      end

      it 'returns ordered resources' do
        expect(JSON.parse(response.body)['data'][0]['id']).to eq User.all.order('name ASC')
                                                                     .first.id
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not logged' do
      before do
        get :show, params: {id: 1}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
        get :show, params: {id: user.id}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['id']).to eq(user.id)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is not logged' do
      before do
        put :update, params: {id: 1}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
        put :update, params: {id: user.id, data: {name: 'New Name'}}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['name']).to eq('New Name')
      end
    end

    context 'when user is logged as another user' do
      before do
        sign_in user1
        put :update, params: {id: user2.id, data: {name: 'New Name'}}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when admin is logged' do
      before do
        sign_in admin
        put :update, params: {id: user.id, data: {name: 'New Name'}}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['name']).to eq('New Name')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged' do
      before do
        delete :destroy, params: {id: 1}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
      end

      it 'returns the correct status' do
        delete :destroy, params: {id: user.id}

        expect(response).to have_http_status(204)
      end

      it 'removes the resource' do
        expect {
          delete :destroy, params: {id: user.id}
        }.to change(User, :count).by(-1)
      end
    end

    context 'when user is logged as another user' do
      before do
        sign_in user1
        delete :destroy, params: {id: user2.id}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when admin is logged' do
      before do
        user
        sign_in admin
      end

      it 'returns the correct status' do
        delete :destroy, params: {id: user.id}

        expect(response).to have_http_status(204)
      end

      it 'removes the resource' do
        expect {
          delete :destroy, params: {id: user.id}
        }.to change(User, :count).by(-1)
      end
    end
  end
end
