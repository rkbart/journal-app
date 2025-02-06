class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    
      @tasks = Task.all
    
  end

  # def show
  #   @task = Task.find(params[:id])
  # end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted successfully."
  end
  def new
    @task = Task.new  
  end

  def create
    @task = @category.tasks.build(task_params)
    if @task.save
      redirect_to category_tasks_path(@category), notice: 'Task created successfully.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task updated successfully."
    else
      render :index
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :due_date, :completed)
  end
end
