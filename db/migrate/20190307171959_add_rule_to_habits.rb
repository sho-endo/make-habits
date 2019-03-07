class AddRuleToHabits < ActiveRecord::Migration[5.2]
  def change
    add_column :habits, :rule1, :string, null: false
    add_column :habits, :rule2, :string,  null: false
  end
end
