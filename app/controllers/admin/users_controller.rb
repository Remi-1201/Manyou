class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit,:update, :destroy]
  before_action :admin_user

  def index
    @users = User.all.includes(:tasks)
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "#{@user.name}さんのアカウントを作成しました"
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "#{@user.name}さんのデータを更新しました"
    elsif @user.errors.any? 
      render :edit, notice: "管理権を外せません。最低一人の管理者が必要です"
    end
  end

  def destroy
    if @user.destroy
    redirect_to admin_users_path, notice: "#{@user.name}さんのデータを削除しました"
    elsif @user.errors.any? 
      redirect_to admin_users_path, notice: "削除できません。最低一人の管理者が必要です"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user
    unless current_user.admin?
      redirect_to tasks_path
      flash[:notice] = '管理者の権限が必要です！'
    end
  end
end
