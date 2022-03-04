require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @task = FactoryBot.create(:task, name: 'task')
  end

  describe 'タスクの一覧画面' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        click_button '登録する'
        expect(page).to have_content 'task'
      end
    end
  end

    context 'ソートするというボタンを押した場合' do
      it 'タスクが終了期限の降順に並び替えられる' do
        new_task = FactoryBot.create(:second_task, name: 'task2')
        visit root_path
        select 'Sort by deadline', from: 'sort'
        click_button 'Sort'
        task_list = all('.task_row') 
        #'.task_row'=View側でidを振っておく
        expect(task_list[0]).to have_content 'task'
        expect(task_list[1]).to have_content 'task2'
      end
    end

    context '検索をした場合' do
      before do
        task2 = FactoryBot.create(:second_task, name: 'task2')
        task3 = FactoryBot.create(:third_task, name: 'task3')
      end
      it "タイトルの検索ができる" do
        visit root_path
        fill_in 'search_name', with: 'task'
        click_on '検索'
        expect(page).to have_content 'task'
      end
      it "ステータスの検索ができる" do
        visit root_path
        select '完了', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'task3'
      end
      it "タイトルとステータスの検索ができる" do
        visit root_path
        fill_in 'search_name', with: 'task3'
        select '完了', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'task3'
      end
    end
  end
      