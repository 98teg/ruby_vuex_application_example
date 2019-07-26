def login(user)
  visit '/#/login'
  fill_in 'User', with: user.email
  fill_in 'Password', with: 'foobar'
  click_button 'Log in'

  expect(page).to have_content(user.name)
end
