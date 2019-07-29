require 'rails_helper'

RSpec.describe 'Index of posts', type: :feature, js: true do
  let(:post) { create(:post, title: '$$$$$$$$$$$', content: '##########') }

  describe 'No data' do
    it 'shows no data message' do
      expect(page).to have_content('No hay datos')
    end
  end

  describe 'One post' do
    before do
      post
      refresh
    end

    it 'shows the post title' do
      expect(page).to have_content(post.title)
    end
  end

  describe 'Using the title filter' do
    before do
      create_list(:post, 10)
      post
      fill_in 'title', with: post.title
      click_button 'Apply filters'
    end

    it 'shows the searched post title' do
      expect(page).to have_content(post.title)
    end

    it 'doesn\'t show another post' do
      expect(page).to have_css('tr#post', count: 1)
    end
  end

  describe 'Using the content filter' do
    before do
      create_list(:post, 10)
      post
      fill_in 'content', with: post.content
      click_button 'Apply filters'
    end

    it 'shows the searched post content' do
      expect(page).to have_content(post.content)
    end

    it 'doesn\'t show another post' do
      expect(page).to have_css('tr#post', count: 1)
    end
  end

  describe 'Using the since filter' do
    before do
      create_list(:post, 10)
      fill_in 'since', with: Time.zone.now + 1.day
      click_button 'Apply filters'
    end

    it 'doesn\'t show any post' do
      expect(page).to have_css('tr#post', count: 0)
    end
  end

  describe 'Using the until filter' do
    before do
      create_list(:post, 10)
      fill_in 'until', with: Time.zone.now + 1.day
      click_button 'Apply filters'
    end

    it 'Show many posts' do
      expect(page).to have_css('tr#post', count: 3)
    end
  end

  describe 'Paginating' do
    before do
      create_list(:post, 10)
      refresh
    end

    it 'Show one post when selecting one' do
      select '1', from: 'limit'
      expect(page).to have_css('tr#post', count: 1)
    end

    it 'Show three posts when selecting three' do
      select '3', from: 'limit'
      expect(page).to have_css('tr#post', count: 3)
    end

    it 'Show five posts when selecting five' do
      select '5', from: 'limit'
      expect(page).to have_css('tr#post', count: 5)
    end
  end
end
