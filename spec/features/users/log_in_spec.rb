require 'rails_helper'

RSpec.describe 'Log in', type: :feature, js: true do
  let!(:user) { create(:user) }

  describe 'Clicking log in' do
    before do
      click_link_or_button 'login'
    end

    it 'goes to the log in page' do
      expect(page).to have_content('Login Form')
    end
  end

  describe 'Empty fields' do
    before do
      visit '/#/login'
      click_button 'Log in'
    end

    it 'stays in the log in page' do
      expect(page).to have_content('Login Form')
    end
  end

  describe ' Correct fields' do
    before do
      user.skip_confirmation!
      user.save

      visit '/#/login'
      fill_in 'User', with: user.email
      fill_in 'Password', with: 'foobar'
    end

    it 'Has the correct user' do
      expect(page).to have_field('User', with: user.email)
    end

    it 'Has the correct password' do
      expect(page).to have_field('Password', with: 'foobar')
    end

    it 'Goes to the home page' do
      puts User.first.confirmed?
      puts User.first.email == user.email
      puts user.authenticate('foobar')
      click_button 'Log in'

      expect(page).to have_content('Title of the home page')
    end
  end
end
