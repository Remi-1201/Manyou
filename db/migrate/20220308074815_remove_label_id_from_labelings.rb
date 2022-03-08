class RemoveLabelIdFromLabelings < ActiveRecord::Migration[6.0]
  def change
    remove_column :labelings, :label_id, :integer
  end
end
