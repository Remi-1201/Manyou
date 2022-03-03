class RemoveStatusFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :status, :text
  end
end
