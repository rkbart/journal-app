class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = current_user.categories
  end
   
  def show
    @tasks = @category.tasks
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
      flash[:alert] = @category.errors.full_messages.join(", ") 
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

    if default_category.nil?
      flash[:alert] = "Uncategorized category not found. Cannot delete this category."
      redirect_to categories_path and return
    end

    begin
      @category.tasks.update_all(category_id: default_category.id)

      if @category.destroy
        flash[:notice] = "Category deleted and tasks reassigned to 'Uncategorized'."
      else
        flash[:alert] = "Error deleting category."
      end

    rescue ActiveRecord::InvalidForeignKey
      flash[:alert] = "Cannot delete category due to foreign key constraints. Ensure it is not referenced by other records."
    rescue StandardError => e
      flash[:alert] = "An error occurred: #{e.message}"
    end

    redirect_to categories_path
  end

  def all_tasks
    @tasks = current_user.tasks.sort_by do |task|
      task.due_date || Date.today + 100.years
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
