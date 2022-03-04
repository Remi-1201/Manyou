# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    name { 'test0' }
    detail { 'test0' }
    deadline { DateTime.now }
    status { 0 }
  end
  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    name { 'test1' }
    detail { 'test1' }
    deadline { DateTime.now + 1 }
    status { 1 }
  end

  factory :third_task, class: Task do
    name { 'test2' }
    detail { 'test2' }
    deadline { DateTime.now + 2 }
    status { 2 }
  end
end