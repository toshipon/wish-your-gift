module WishlistHelper
  def update_wishlist_id?
    params[:wishlist][:key].present?
  end

  def update_affiliate_id?
    params[:wishlist][:affiliate_id].present?
  end
end
