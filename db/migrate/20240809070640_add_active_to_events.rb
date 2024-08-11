class AddActiveToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :active, :boolean, default: true, null: false
  end
end
