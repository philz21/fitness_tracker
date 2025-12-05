class CreateEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :entries do |t|
      t.string :exercise_name
      t.integer :sets
      t.integer :reps
      t.integer :weight
      t.date :performed_on

      t.timestamps
    end
  end
end
