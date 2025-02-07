class TasksController < ApplicationController
  before_action :set_category  # Ensure the category is set before running index

  def index
    @tasks = @category.tasks # Fetch tasks only for the selected category
  end

  def new
    @category = Category.find(params[:category_id])
    @task = @category.tasks.new  # Ensure new task is scoped to a category
  end

  def create
    @task = @category.tasks.build(task_params) # Associate task with category
    if @task.save
      redirect_to category_tasks_path(@category), notice: 'Task created successfully.'
    else
      render :new
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])  # Ensure category exists
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :completed)
  end
end
