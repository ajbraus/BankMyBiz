FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Test #{n}" }
    sequence(:email) { |n| "test@#{n}.com"} 
    password 'password'
    password_confirmation 'password'
    remember_me 'f'
  end
end