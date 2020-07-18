class AddMetaToLobbies < ActiveRecord::Migration[6.0]
  def change
    change_table :lobbies do |t|
      t.jsonb :meta
    end
  end
end
