class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :content, null: false
      t.references :habit, foreign_key: true, null: false

      t.timestamps
    end
  end
end
