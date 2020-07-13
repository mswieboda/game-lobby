class AddLobby < ActiveRecord::Migration[6.0]
  def change
    create_table :lobbies do |t|
      t.string :name
      t.string :host
      t.string :status
      t.integer :peers
      t.string :size

      t.timestamps
    end
  end
end
