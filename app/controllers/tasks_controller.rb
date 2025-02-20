class TasksController < ApplicationController
  before_action :set_category  
  before_action :require_login
  
  def index
    @tasks = @category.tasks 
  end

  def new
    @category = Category.find(params[:category_id])
    @task = @category.tasks.new(due_date: Date.today)  
  end

  def create
    @task = @category.tasks.build(task_params) 
    
    if @task.save
      redirect_to category_tasks_path(@category), notice: 'Task created successfully.'
    else
      flash[:alert] = @task.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = @category.tasks.find(params[:id]) 
    if @task.update(task_params) 
      redirect_to category_tasks_path(@category), notice: 'Task updated successfully.'
    else
      render :edit 
    end
  end

  def destroy
    @task = @category.tasks.find(params[:id]) 
    @task.destroy
    redirect_to category_tasks_path(@category), notice: 'Task deleted successfully.'
  end

  def toggle_complete
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed) 
    redirect_to category_tasks_path(@task.category), notice: "Task updated successfully."
  end
  
  private

  def set_category
    @category = Category.find(params[:category_id])  
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :completed, :category_id)
  end
end
