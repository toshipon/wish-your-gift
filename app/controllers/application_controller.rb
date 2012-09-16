class ApplicationController < ActionController::Base
  protect_from_forgery
  if Rails.env.development?
    require 'pry'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_affiliate_id
    if current_user.wishlist.has_affiliate_id?
      current_user.wishlist.affiliate_id
    else
      ENV['AMAZON_AFFILIATE_ID']
    end
  end
  helper_method :user_affiliate_id
end
