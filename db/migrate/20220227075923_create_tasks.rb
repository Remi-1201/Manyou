class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :detail, null: false
      t.string :priority, default: 0, null: false

      t.timestamps
    end
  end
end
