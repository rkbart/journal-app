class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  # GET /categories 
  def index
    @categories = Category.all
  end

  # GET /categories/1 
  def show
    @tasks = @category.tasks
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories 
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category created successfully.'
    else
      flash[:alert] = @category.errors.full_messages.join(", ")  # Make errors visible
      render :new
    end
  end

  # PATCH/PUT /categories/1 
  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category updated successfully.'
    else
      render :edit
    end
  end

  # DELETE /categories/1 
  def destroy
    category = Category.find(params[:id])
    default_category = Category.find_by(name: "Uncategorized")

  if default_category.nil?
    flash[:alert] = "Default category not found. Cannot delete this category."
    redirect_to categories_path and return
  end

  begin
    # Reassign all tasks to the default category before deleting
    category.tasks.update_all(category_id: default_category.id)

    if category.destroy
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
    @tasks = Task.all.sort_by do |task|
      if task.due_date.nil?
        Date.today + 100.years  # Push tasks without a due date to the bottom
      else
        task.due_date
      end
    end
  end
  
  private
  def category_params
    params.require(:category).permit(:name) # Correct syntax for strong params
  end
  def set_category
    @category = Category.find(params[:id]) # Use params[:id] instead
  end
  
end
