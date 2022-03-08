require 'rails_helper'
RSpec.describe 'ユーザー機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:user3) { FactoryBot.create(:user3) }
  
  before do
    visit new_session_path
  end

  describe 'ユーザー新規作成機能' do
    context 'ユーザー新規作成した場合' do
      it 'ユーザー新規登録できる' do
        visit new_user_path
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'testtest'
        fill_in 'user[password_confirmation]', with: 'testtest'
        click_on 'Create my account'
        expect(page).to have_content 'test'
        expect(page).to have_content 'test@test.com'
      end
    end
    context 'ユーザーがログインせずタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移' do
        visit tasks_path
        expect(page).to have_content 'Log in'
      end
    end
  end
  describe 'セッション機能' do
    context 'ログイン操作した場合' do
      it 'ログインできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        expect(page).to have_content 'aaa@aaa.com'
      end
    end
    context '詳細ボタンを押した場合' do
      it '自分の詳細画面に飛べる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        expect(page).to have_content 'aaa@aaa.com'
      end
    end
    context '一般ユーザーが他人の詳細画面に飛ぶ場合' do
      it 'タスク一覧画面に遷移' do
        visit new_session_path
        fill_in 'session[email]', with: 'bbb@bbb.com'
        fill_in 'session[password]', with: 'bbbbbb'
        click_on 'Log in'
        visit admin_users_path
        expect(current_path).to eq tasks_path
      end
    end
    context 'ログアウトボタン操作した場合' do
      it 'ログアウトできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'bbb@bbb.com'
        fill_in 'session[password]', with: 'bbbbbb'
        click_on 'Log in'
        click_on 'Logout'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  
  describe '管理画面機能' do
    context '管理ユーザーが管理画面へ遷移した場合' do
      it '管理画面にアクセスできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        click_on 'Admin'
        expect(page).to have_content '管理者画面'
      end
    end
    context '一般ユーザーが管理画面へ遷移した場合' do
      it '管理画面にアクセスできない' do
        visit new_session_path
        fill_in 'session[email]', with: 'bbb@bbb.com'
        fill_in 'session[password]', with: 'bbbbbb'
        click_on 'Log in'
        visit admin_users_path	
        expect(page).to have_content '管理者の権限が必要です！'
      end
    end
    context '管理ユーザは管理画面でユーザーの新規登録をした場合' do
      it 'ユーザー新規登録できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        click_on 'Admin'
        click_on 'Make new user'
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@test.com'
        fill_in 'user[password]', with: 'testtest'
        fill_in 'user[password_confirmation]', with: 'testtest'
        click_on '登録する'
        expect(page).to have_content 'test'
      end
    end
    context '管理ユーザーは一般ユーザーの詳細画面へ遷移した場合' do
      it 'ユーザー詳細画面にアクセスできる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        visit user_path(user3)
        expect(page).to have_content 'ccc'
      end
    end
    context '管理ユーザーは管理画面でユーザーを編集した場合' do
      it 'ユーザーの編集ができる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        visit edit_admin_user_path(user3)
        fill_in 'user[name]', with: 'ddd'
        click_on '更新する'
        expect(page).to have_content 'ddd'
      end
    end
    context '管理ユーザーは管理画面でユーザー削除操作した場合' do
      it 'ユーザー削除できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'aaa@aaa.com'
        fill_in 'session[password]', with: 'aaaaaa'
        click_on 'Log in'
        click_on 'Admin'
        click_on :Destroy, match: :first
        expect {
          page.accept_confirm 'Are you sure？'
          expect(page).to have_content 'bbb'
        }
        end
      end
    end
  end
end