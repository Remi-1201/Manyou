class TasksController < ApplicationController
  before_action :set_task, only:  %i[ show edit update destroy ]
  before_action :authenticate_user

  def authenticate_user
    @current_user = User.find_by(id: session[:user_id])
    if @current_user.nil?
      redirect_to new_session_path
    end
  end

  def index
    @task = Task.new
    @tasks = Task.where(user_id: current_user.id).includes(:user)
    @tasks = Task.all.order(created_at: :desc).kaminari(params[:page])
    @users = User.all
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
  end

  def new
    if params[:back]
      @task = Task.new(task_params)
    else
      @task = Task.new
      @labels = Label.where(user_id: 9).or(Label.where(user_id: current_user))
    end
  end

  def edit
    @labels = Label.where(user_id: 9).or(Label.where(user_id: current_user))
  end

  def sort
    @tasks =
      if params[:sort] == 'created_at'
        Task.all.order(created_at: :desc).kaminari(params[:page])
      elsif params[:sort] == 'deadline'
        Task.all.order(deadline: :asc).kaminari(params[:page])
      elsif params[:sort] == 'priority'
        Task.all.order(priority: :asc).kaminari(params[:page])
      end
      render :index
  end

  def search
    @tasks =
    if params[:search_name].blank? && params[:search_status].blank?
      Task.all.sorted.kaminari(params[:page])
    elsif params[:search_name].present?
      if params[:search_status].present? && params[:search_priority].present?
        Task.search_sort(params[:search_name]).status_sort(params[:search_status]).priority_sort(params[:search_priority]).sorted.kaminari(params[:page])
      elsif params[:search_status].present? && params[:search_priority].blank?
        Task.search_sort(params[:search_name]).status_sort(params[:search_status]).sorted.kaminari(params[:page])
      elsif params[:search_status].blank? && params[:search_priority].present?
        Task.search_sort(params[:search_name]).priority_sort(params[:search_priority]).sorted.kaminari(params[:page])
      else
        Task.search_sort(params[:search_name]).sorted.kaminari(params[:page])
      end
    elsif params[:search_status].present?
      if params[:search_priority].present?
        Task.status_sort(params[:search_status]).priority_sort(params[:search_priority]).sorted.kaminari(params[:page])
      else
        Task.status_sort(params[:search_status]).sorted.kaminari(params[:page])
      end
    elsif params[:search_priority].present?
      Task.priority_sort(params[:search_priority]).sorted.kaminari(params[:page])
    end
    render :index
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
      if @task.save
        redirect_to tasks_path, notice: "Task was successfully created."
      else
        render :new
      end
    end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def confirm
    @task= Task.new(task_params)
    render :new if @task.blank?
  end

  def show
    @task= Task.find(params[:id])
    @labels = Label.where(user_id: 9).or(Label.where(user_id: current_user))
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_url, notice:"Task was successfully destroyed."
    end
  end

  private  
  def task_params
    params.require(:task).permit(
      :name, 
      :detail, 
      :deadline, 
      :status, 
      :priority,
      label_ids: []
    )
  end

  def set_task
    @task = Task.find(params[:id])
  end