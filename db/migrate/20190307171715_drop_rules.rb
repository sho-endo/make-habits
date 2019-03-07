class DropRules < ActiveRecord::Migration[5.2]
  def change
    drop_table :rules
  end
end
