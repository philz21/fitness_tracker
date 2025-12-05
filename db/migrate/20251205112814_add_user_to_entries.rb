class AddUserToEntries < ActiveRecord::Migration[7.2]
  def change
    add_reference :entries, :user, foreign_key: true
  end
end
