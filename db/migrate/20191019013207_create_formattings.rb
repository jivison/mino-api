class CreateFormattings < ActiveRecord::Migration[6.0]
  def change
    create_table :formattings do |t|
      t.references :format, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.references :addition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
