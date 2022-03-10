class AddLabelRefToLabelings < ActiveRecord::Migration[6.0]
  def change
    add_reference :labelings, :label, null: false, foreign_key: true
  end
end
