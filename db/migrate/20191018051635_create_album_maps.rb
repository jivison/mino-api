class CreateAlbumMaps < ActiveRecord::Migration[6.0]
  def change
    create_table :album_maps do |t|
      t.string :input
      t.references :album, null: false, foreign_key: true
      t.integer :scope

      t.timestamps
    end
  end
end
