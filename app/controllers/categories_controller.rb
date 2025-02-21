class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = current_user.categories
  end
   
  def new
    @category = current_user.categories.build
  end
  
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to category_tasks_path(@category), 
      notice: 'Category created successfully.'
    else
      flash[:alert] = @category.errors.full_messages 
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to category_tasks_path(@category), 
      notice: "#{@category.name} updated successfully."
    else
      render :edit
    end
  end

  def destroy
    default_category = current_user.categories.find_by(name: "Uncategorized")
    @category.tasks.update_all(category_id: default_category.id)
    
    @category.destroy
    
    redirect_to categories_path
  end

  def all_tasks
    @tasks = current_user.tasks.sort_by do |task|
      task.due_date 
    end
  end

private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end
  
end
