class CreateArtistMaps < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_maps do |t|
      t.string :input
      t.references :artist, null: false, foreign_key: true
    end
  end
end
