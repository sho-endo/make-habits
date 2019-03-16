class AddProgressToHabits < ActiveRecord::Migration[5.2]
  def change
    add_column :habits, :progress, :integer, null: false, default: 0
  end
end
