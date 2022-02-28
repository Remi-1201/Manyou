class TasksController < ApplicationController
  before_action :set_task, only:  %i[ show edit update destroy ]
  # before_action :authenticate_user

  # def authenticate_user
  #   @current_user = User.find_by(id: session[:user_id])
  #   if @current_user.nil?
  #     redirect_to new_session_path
  #   end
  # end

  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    if params[:back]
      @task= Task.new(task_params)
    else
      @task= Task.new
    end  
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
      if @task.save
        redirect_to tasks_path, notice: "Task was successfully created."
      else
        render :new
      end
    end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Blog was successfully updated."
    else
      render :edit
    end
  end

  def confirm
    @task= Task.new(task_params)
    render :new if @task.blank?
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_url, notice:"Task was successfully destroyed."
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :detail, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end