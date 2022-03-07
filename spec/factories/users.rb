FactoryBot.define do
  factory :user do
    name { 'aaa' }
    email { 'aaa@aaa.com' }
    password { 'aaaaaa' }
    password_confirmation { 'aaaaaa' }
    admin { 'true' }
  end
  factory :user2, class: User do
    name { 'bbb' }
    email { 'bbb@bbb.com' }
    password { 'bbbbbb' }
    password_confirmation { 'bbbbbb' }
    admin { 'false' }
  end
    factory :user3, class: User do
    name { 'ccc' }
    email { 'ccc@ccc.com' }
    password { 'cccccc' }
    password_confirmation { 'cccccc' }
    admin { 'false' }
  end
end