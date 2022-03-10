class AddTaskRefToLabelings < ActiveRecord::Migration[6.0]
  def change
    add_reference :labelings, :task, null: false, foreign_key: true
  end
end
