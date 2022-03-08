class RemoveTaskIdFromLabelings < ActiveRecord::Migration[6.0]
  def change
    remove_column :labelings, :task_id, :integer
  end
end
