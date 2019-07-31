require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { FactoryBot.create(:comment) }
  let(:post1) { FactoryBot.create(:post) }
  let(:user) { FactoryBot.create(:user) }
  let(:comment_by_user) {
    lambda do |user|
      FactoryBot.create(:comment, user: user)
    end
  }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }

  describe 'GET #index' do
    describe 'request' do
      before do
        FactoryBot.create_list(:comment, 5)
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
          match_array(%i[content creation post_id user_id author id])
        )
      end
    end

    describe 'pagination' do
      before do
        FactoryBot.create_list(:comment, 5)
        get :index, params: {page: {number: 1, size: 2}}
      end

      it 'returns paginated resources' do
        expect(JSON.parse(response.body)['data'].size).to eq 2
      end
    end

    describe 'filters content' do
      let(:item) { Comment.all.to_a.sample }

      before do
        FactoryBot.create_list(:comment, 5)
        get :index, params: {filter: {content: item.content}}
      end

      it 'returns only one resource' do
        expect(JSON.parse(response.body)['data'].size).to eq(1)
      end

      it 'returns filtered resources' do
        expect(JSON.parse(response.body)['data'][0]['id']).to eq item.id
      end
    end

    describe 'order created_at' do
      before do
        FactoryBot.create_list(:comment, 5)
        get :index, params: {sort: 'created_at'}
      end

      it 'returns ordered resources' do
        expect(JSON.parse(response.body)['data'][0]['id']).to eq Comment.all.order('created_at ASC')
                                                                        .first.id
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not logged' do
      before do
        get :show, params: {id: comment.id}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['id']).to eq(comment.id)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
        get :show, params: {id: comment.id}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['id']).to eq(comment.id)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not logged' do
      it 'doesn\'t create a resource' do
        expect {
          post :create, params: {data: {post_id: post1.id, content: 'Content'}}
        }.to change(Comment, :count).by(0)
      end

      it 'returns the correct error message' do
        post :create, params: {data: {post_id: post1.id, content: 'Content'}}
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is logged' do
      before { sign_in user }

      it 'creates a resource' do
        expect {
          post :create, params: {data: {post_id: post1.id, content: 'Content'}}
        }.to change(Comment, :count).by(1)
      end

      it 'returns the correct values' do
        post :create, params: {data: {post_id: post1.id, content: 'Content'}}
        model = Comment.first

        {post_id: post1.id, content: 'Content'}.each do |field, value|
          expect(model.send(field)).to eq value
        end
      end

      it 'creates two jobs' do
        expect { post :create, params: {data: {post_id: post1.id, content: 'Content'}} }
          .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(2)
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
        put :update, params: {id: comment_by_user[user].id, data: {content: 'New Content'}}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['content']).to eq('New Content')
      end
    end

    context 'when user is logged as another user' do
      before do
        sign_in user1
        put :update, params: {id: comment_by_user[user2].id, data: {content: 'New Content'}}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when admin is logged' do
      before do
        sign_in admin
        put :update, params: {id: comment_by_user[user].id, data: {content: 'New Content'}}
      end

      it 'returns the correct status' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct values' do
        expect(JSON.parse(response.body)['data']['content']).to eq('New Content')
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
        delete :destroy, params: {id: comment_by_user[user].id}

        expect(response).to have_http_status(204)
      end

      it 'removes the resource' do
        id = comment_by_user[user].id

        expect {
          delete :destroy, params: {id: id}
        }.to change(Comment, :count).by(-1)
      end
    end

    context 'when user is logged as another user' do
      before do
        sign_in user1
        delete :destroy, params: {id: comment_by_user[user2].id}
      end

      it 'returns the unauthorized error' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when admin is logged' do
      before do
        sign_in admin
      end

      it 'returns the correct status' do
        delete :destroy, params: {id: comment_by_user[user].id}

        expect(response).to have_http_status(204)
      end

      it 'removes the resource' do
        id = comment_by_user[user].id

        expect {
          delete :destroy, params: {id: id}
        }.to change(Comment, :count).by(-1)
      end
    end
  end
end
