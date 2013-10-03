require 'spec_helper'

def sign_up
  visit '/users/sign_up'
  fill_in "#user_name", with: "Test Two"
  fill_in "#user_email", with: "test@two.com"
  fill_in "#user_password", with: "password"
  fill_in "#user_password_confirmation", with: "password"
  click_button "btn-success"
end

def login
  user = Factory.create(:user)
  visit '/users/sign_in'
  fill_in "#user_email", with: user.email
  fill_in "#user_password", with: user.password
  click_button "btn-success"
end

describe "BankmyBiz" do
  describe "Not Signed In '/' goes to Landing Page" do
    visit "/"
    page.should have_content
    end
  end

  describe "Home page after login" do
    login
    page.should have_content
  end

  describe "Home page after sign up" do
    sign_up
    page.should have_content
  end
end
