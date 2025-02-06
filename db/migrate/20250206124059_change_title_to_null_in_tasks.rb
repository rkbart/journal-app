class ChangeTitleToNullInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :title, true  # Allow NULL values
  end
end
