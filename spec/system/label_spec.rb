require 'rails_helper'
RSpec.describe 'ラベル機能', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user_id: user.id) }
  let!(:label) { FactoryBot.create(:label, user_id: user.id) }
  let!(:label2) { FactoryBot.create(:label2, user_id: user.id) }

  def login
    visit new_session_path
    fill_in 'session[email]', with: 'aaa@aaa.com'
    fill_in 'session[password]', with: 'aaaaaa'
    click_on 'Log in'
    visit tasks_path
  end

  describe 'ラベル登録' do
    context 'タスクの新規作成' do
      it 'ラベルが作成される' do
        login
        visit new_label_path
        fill_in 'label[name]', with: 'Ruby'
        click_on '登録する'
        expect(page).to have_content 'Ruby'
      end
    end
  end
    context 'ラベルを複数選択した場合' do
      it '複数のラベルが登録される' do
        login
        visit new_task_path
        fill_in 'task[name]', with: 'app'
        fill_in 'task[detail]', with: 'manyo'
        check 'Ruby'
        check 'Rails'
        click_on '登録する'
        expect(page).to have_content 'Ruby'
        expect(page).to have_content 'Rails'
      end
    end

  describe 'ラベルの編集' do
    context 'タスク編集時にラベルの選択を更新した場合' do
      it 'ラベルが更新される' do
        login
        click_on 'Edit'
        check 'Ruby'
        check 'Rails'
        click_on '更新する'
        expect(page).to have_content 'Ruby'
        expect(page).to have_content 'Rails'
      end
    end
  end

  describe 'ラベルの検索機能' do
    context '一覧画面でラベルを検索した場合' do
      it '検索したタスクが表示される' do
        login
        visit new_task_path
        fill_in 'task[name]', with: 'app'
        fill_in 'task[detail]', with: 'manyo'
        check 'Ruby'
        click_on '登録する'
        select 'Ruby', from: 'label_id'
        click_on 'ラベル検索'
        expect(page).to have_content 'Ruby'
      end
    end
  end

end