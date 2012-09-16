class MypagesController < ApplicationController
  def index
  end

  def register_wishlist_id
    redirect_to wishlist_path(current_user)
  end

  def other_info
  end
end
