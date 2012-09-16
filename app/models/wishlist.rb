class Wishlist < ActiveRecord::Base
  attr_accessible :user_id, :key
  belongs_to :user

  def has_key?
    key.present?
  end
end
