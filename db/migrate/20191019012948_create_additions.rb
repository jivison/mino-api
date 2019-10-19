class CreateAdditions < ActiveRecord::Migration[6.0]
  def change
    create_table :additions do |t|
      t.string :addition_type
      t.string :id_string

      t.timestamps
    end
  end
end
