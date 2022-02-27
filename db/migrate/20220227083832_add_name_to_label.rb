class AddNameToLabel < ActiveRecord::Migration[6.0]
  def change
    add_column :labels, :name, :string
  end
end
