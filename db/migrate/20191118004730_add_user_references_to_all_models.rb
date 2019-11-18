class AddUserReferencesToAllModels < ActiveRecord::Migration[6.0]
  def change
    add_reference :artists, :user, null: false, foreign_key: true
    add_reference :artist_maps, :user, null: false, foreign_key: true
    
    add_reference :albums, :user, null: false, foreign_key: true
    add_reference :album_maps, :user, null: false, foreign_key: true

    add_reference :tracks, :user, null: false, foreign_key: true
    add_reference :additions, :user, null: false, foreign_key: true
    add_reference :taggings, :user, null: false, foreign_key: true
    add_reference :formattings, :user, null: false, foreign_key: true

  end
end
