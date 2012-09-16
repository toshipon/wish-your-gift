class WishlistController < ApplicationController
  def new
    @wishilist = Wishlist.create(:user_id => current_user.id)
  end

  def show
    @wishlist = current_user.wishlist
    redirect_to :action => :new unless @wishlist
  end

  def update
    @wishlist = current_user.wishlist
    @wishlist.key = params[:wishlist][:key]
    @wishlist.save
  end
end