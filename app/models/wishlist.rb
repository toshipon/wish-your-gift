class Wishlist < ActiveRecord::Base
  attr_accessible :user_id, :key, :affiliate_id
  belongs_to :user

  def has_key?
    key.present?
  end

  def has_affiliate_id?
    affiliate_id.present?
  end
end
