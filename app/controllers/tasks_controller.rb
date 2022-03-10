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
    @tasks = current_user.tasks.sorted.kaminari(params[:page])
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
    @tasks = @tasks.reorder(priority: :desc) if params[:priority_sort]
  end

  def new
    @task = Task.new
    @label = @task.labelings.build
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
  end

  def edit
    @labels = Label.where(user_id: 9).or(Label.where(user_id: current_user))
  end

  def sort
    @tasks = searched
    @search_name = session[:search]['name']  if session[:search].present?
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks =
      if params[:sort] == 'created_at'
        @tasks.sorted
      elsif params[:sort] == 'deadline'
        @tasks.deadline_sorted
      elsif params[:sort] == 'priority'
        @tasks.priority_sort          
      end
    session[:search] = nil
    render :index
  end

  def search
    session[:search] = {'name' => params[:search_name], 'status' => params[:search_status], 'priority' => params[:search_priority], 'label' => params[:search_label]}
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks = searched
    @tasks = @tasks.sorted
    @search_name = session[:search]['name']
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

  def correct_user
    if current_user.id != @task.user_id
      redirect_to tasks_path
    end
  end

  def searched
    if session[:search].present?
      # all blank
      if session[:search]['name'].blank? && session[:search]['status'].blank? && session[:search]['priority'].blank? && session[:search]['label'].blank?
        Task.current_user_sort(current_user.id).kaminari(params[:page])
      # name = present
      elsif session[:search]['name'].present?
        # status & priority & label = present 
        if session[:search]['status'].present? && session[:search]['priority'].present? && session[:search]['label'].present?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # status & priority  = present
        elsif session[:search]['status'].present? && session[:search]['priority'].present?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).kaminari(params[:page])
        # status & label  = present
        elsif session[:search]['status'].present? && session[:search]['label'].present? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).status_sort(session[:search]['status']).label_sort(session[:search]['label']).kaminari(params[:page])
        # priority & label  = present 
        elsif session[:search]['priority'].present? && session[:search]['label'].present? && session[:search]['status'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # status  = present
        elsif session[:search]['status'].present? && session[:search]['priority'].blank? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).status_sort(session[:search]['status']).kaminari(params[:page])
        #  priority = present 
        elsif session[:search]['priority'].present? && session[:search]['status'].blank? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).priority_sort(session[:search]['priority']).kaminari(params[:page])
        # label  = present 
        elsif session[:search]['label'].present? && session[:search]['status'].blank? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).label_sort(session[:search]['label']).kaminari(params[:page])
        #  name  = present 
        else
          Task.current_user_sort(current_user.id).search_sort(session[:search]['name']).kaminari(params[:page])
        end
  
      elsif session[:search]['status'].present?
  
        if session[:search]['priority'].present? && session[:search]['label'].present?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
  
        elsif session[:search]['priority'].present? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).kaminari(params[:page])
  
        elsif session[:search]['label'].present? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).label_sort(session[:search]['label']).kaminari(params[:page])
  
        else
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).kaminari(params[:page])
        end
  
      elsif session[:search]['priority'].present?
  
        if session[:search]['label'].present?
          Task.current_user_sort(current_user.id).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
  
        else
          Task.current_user_sort(current_user.id).priority_sort(session[:search]['priority']).kaminari(params[:page])
        end
  
      elsif session[:search]['label'].present?
        Task.current_user_sort(current_user.id).label_sort(session[:search]['label']).kaminari(params[:page])
      end
    else
      Task.current_user_sort(current_user.id).kaminari(params[:page])
    end
  end
  