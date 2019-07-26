require 'rails_helper'

RSpec.describe 'Create post', type: :feature, js: true do
  let!(:user) { create(:user) }

  before do
    login user

    visit '/#/newpost'
  end

  describe 'Empty fields' do
    before do
      click_button 'Save post'
    end

    it 'shows error message' do
      expect(page).to have_content('can\'t be blank')
    end
  end

  describe 'Correct fields' do
    before do
      fill_in 'Title', with: 'Example title'
      fill_in 'Content', with: 'Example content'
      click_button 'Save post'
    end

    it 'redirects to your posts list page' do
      expect(page).to have_content('List of your posts')
    end

    it 'there is the post title' do
      page.find_button('Create post')
      expect(page).to have_content('Example title')
    end

    it 'there is a new post in the server' do
      page.find_button('Create post')
      expect(Post.all.count).to eq 1
    end

    it 'the post in the server is the same' do
      page.find_button('Create post')
      expect(Post.first.content).to eq 'Example content'
    end
  end
end
