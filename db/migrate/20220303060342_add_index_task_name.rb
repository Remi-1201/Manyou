class AddIndexTaskName < ActiveRecord::Migration[6.0]
  def up
    add_index :tasks, :name
  end
  def down
    remove_index :tasks, :name
  end
end
