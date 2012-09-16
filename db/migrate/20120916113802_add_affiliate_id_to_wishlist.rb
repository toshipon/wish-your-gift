class AddAffiliateIdToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :affiliate_id, :string

  end
end
