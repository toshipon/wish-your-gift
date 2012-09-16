class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.string :key
      t.references :user

      t.timestamps
    end
    add_index :wishlists, :user_id
  end
end
