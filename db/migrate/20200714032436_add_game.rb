require 'securerandom'

class AddGame < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :key

      t.timestamps
    end

    change_table :lobbies do |t|
      t.references :game
    end
  end
end
