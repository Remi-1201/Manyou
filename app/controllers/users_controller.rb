class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :correct_user?, only: %i[ show ]

  def index
    @users = User.all
  end

  def correct_user?
    @user = User.find_by(id: params[:id])
    if current_user.id != @user.id
      flash[:danger] = "権限がありません"
      redirect_to user_path(current_user.id)
    end
  end

  def new
    @user = User.new
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
    params.require(:user).permit(:name, :password_digest, :password, :password_confirmation, :email, :image, :image_cache,:avatar)
  end
end