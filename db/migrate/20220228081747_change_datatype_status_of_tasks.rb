class ChangeDatatypeStatusOfTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :status, :text
  end
end
