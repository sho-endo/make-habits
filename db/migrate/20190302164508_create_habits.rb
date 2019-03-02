class CreateHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :habits do |t|
      t.string :type, null: false
      t.string :title, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
