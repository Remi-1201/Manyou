FactoryBot.define do
  factory :label do
    name { "Ruby" }
    user_id { user.id }
  end
  factory :label2, class: Label do
    name { 'Rails' }
    user_id { user.id }
  end
end