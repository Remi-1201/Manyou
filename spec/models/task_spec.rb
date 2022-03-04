require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :model do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(name: '', detail: '失敗テスト')
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(name: '失敗テスト', detail: '')
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(name: '成功テスト', detail: '成功テスト')
        expect(task).to be_valid
      end
    end

  describe '検索ができる' do
    before do
      @task1 = FactoryBot.create(:task, name: 'task1')
      @task2 = FactoryBot.create(:second_task, name: 'task2')
      @task3 = FactoryBot.create(:third_task, name: 'task3')
    end
    it 'タイトルの検索ができる' do
      expect(Task.search_sort('task1')).to include(@task1)
    end
    it 'ステータスの検索ができる' do
      expect(Task.status_sort(1)).to include(@task2)
    end
    it 'タイトルとステータスの両方が検索ができる' do
      expect(Task.search_sort('task3').status_sort(2)).to include(@task3)
    end
  end
end
