class ApplicationController < ActionController::Base
  protect_from_forgery
  if Rails.env.development?
    require 'pry'
    require 'pry-nav'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_affiliate_id(wishlist_id=nil)
    if current_user.try(:wishlist).try(:has_affiliate_id?)
      current_user.wishlist.affiliate_id
    elsif wishlist_id
      person_affiliate_id = Wishlist.find(wishlist_id).affiliate_id
      unless person_affiliate_id.present?
        ENV['AMAZON_AFFILIATE_ID']
      else
        person_affiliate_id
      end
    else
      ENV['AMAZON_AFFILIATE_ID']
    end
  end
  helper_method :user_affiliate_id
end