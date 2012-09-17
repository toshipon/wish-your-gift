class WishlistController < ApplicationController
  before_filter :require_login

  def new
    @wishlist = Wishlist.create(:user_id => current_user.id)
  end

  def show
    @wishlist = current_user.wishlist
    redirect_to :action => :new unless @wishlist
  end

  def update
    @wishlist = current_user.wishlist
    @wishlist.key = params[:wishlist][:key] if params[:wishlist][:key]
    @wishlist.affiliate_id = params[:wishlist][:affiliate_id] if params[:wishlist][:affiliate_id]
    @wishlist.save
  end

  def require_login
    unless current_user
      redirect_to root_path
    end
  end
end