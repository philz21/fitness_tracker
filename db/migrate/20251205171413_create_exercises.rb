class CreateExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :exercises do |t|
      t.string :external_id
      t.string :name
      t.string :body_part
      t.string :target
      t.string :equipment
      t.string :image_url

      t.timestamps
    end
  end
end
