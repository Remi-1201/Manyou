20.times do |i|
  name = Faker::Name.first_name
  email = Faker::Internet.email
  password = 'password'
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    admin: false
  )
end

20.times do |i|
    Label.create!(
    name: "label#{rand(1..20)}",
    user_id: rand(1..20)
  )
end

20.times do |i|
  Task.create!(
    name: "task#{i + 1}",
    detail: "detail#{i + 1}",
    deadline: DateTime.now + 10,
    status: rand(0..2),
    priority: rand(0..2),
    user_id: rand(1..20),
  )
end

20.times do |i|
  Labeling.create!(
    task_id: rand(1..20),
    label_id: rand(1..20)
  )
end