class TasksController < ApplicationController
  before_action :set_category  # Ensure the category is set before running index
  before_action :require_login

  def index
    @tasks = @category.tasks # Fetch tasks only for the selected category
  end

  def new
    @category = Category.find(params[:category_id])
    @task = @category.tasks.new(due_date: Date.today)  # Ensure new task is scoped to a category
  end

  def create
    @task = @category.tasks.build(task_params) # Associate task with category
    if @task.save
      redirect_to category_tasks_path(@category), notice: 'Task created successfully.'
    else
      render :new
    end
  end
  def edit
    @task = Task.find(params[:id])
  end

  def destroy
    @task = @category.tasks.find(params[:id]) # Find task by ID under the category
    @task.destroy
    redirect_to category_tasks_path(@category), notice: 'Task deleted successfully.'
  end
  
  private

  def set_category
    @category = Category.find(params[:category_id])  # Ensure category exists
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :completed)
  end
end
