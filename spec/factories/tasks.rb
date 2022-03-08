FactoryBot.define do

  factory :task do
    name { 'task' }
    detail { 'task' }
    deadline { DateTime.now }
    status { 0 }
    priority { 0 }
  end

  factory :second_task, class: Task do
    name { 'task2' }
    detail { 'task2' }
    deadline { DateTime.now + 1 }
    status { 1 }
    priority { 1 }
  end

  factory :third_task, class: Task do
    name { 'task3' }
    detail { 'task3' }
    deadline { DateTime.now + 2 }
    status { 2 }
    priority { 2 }
  end
end