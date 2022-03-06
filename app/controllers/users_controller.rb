class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :admin_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
    if logged_in?
      redirect_to tasks_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @tasks = Task.all
    @tasks = @tasks.page(params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "Your informations have been updated!"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password_digest, :password, :password_confirmation, :email)
  end

  def admin_user
    unless current_user.admin?
    redirect_to(tasks_path) 
    flash[:danger] = '管理者の権限が必要です！'
    end
  end
end