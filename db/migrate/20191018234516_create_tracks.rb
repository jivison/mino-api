class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.references :album, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
