require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do  
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: user) }
  let!(:third_task) { FactoryBot.create(:third_task, user: user) }

  def login
    visit new_session_path
    fill_in 'session[email]', with: 'aaa@aaa.com'
    fill_in 'session[password]', with: 'aaaaaa'
    click_on 'Log in'
  end

    describe 'タスクの一覧画面' do
    context 'タスクを新規作成した場合' do
        it '作成したタスクが表示される' do
          login
          visit tasks_path
          expect(page).to have_content 'task'
        end
      end
    end

    context 'ソートするというボタンを押した場合' do
        it 'タスクが終了期限の降順に並び替えられる' do
          login
          visit tasks_path
          select 'Sort by deadline', from: 'sort'
          click_button 'Sort'
          task_list = all('.task_detail') 
          #'.task_row'=View側でidを振っておく          
          expect(task_list[0]).to have_content 'task'
          expect(task_list[1]).to have_content 'task2'
          expect(task_list[2]).to have_content 'task3'
        end
    end

    context '検索をした場合' do
        it "タイトルの検索ができる" do
          login
          visit tasks_path
          fill_in 'search_name', with: 'task'
          click_on '検索'
          expect(page).to have_content 'task'
        end
        it "ステータスの検索ができる" do
          login
          visit tasks_path
          select '完了', from: 'search_status'
          click_on '検索'
          expect(page).to have_content 'task'
        end
        it "タイトルとステータスの検索ができる" do
          login
          visit tasks_path
          fill_in 'search_name', with: 'task'
          select '完了', from: 'search_status'
          click_on '検索'
          expect(page).to have_content 'task'
        end
    end
end
