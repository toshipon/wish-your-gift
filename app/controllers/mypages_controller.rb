class MypagesController < ApplicationController
  require 'open-uri'
  require 'net/http'

  def index
    if current_user && current_user.wishlist.has_key?
      @wish_products = []
      contents = Net::HTTP.get_response(URI.parse("http://www.amazon.co.jp/registry/wishlist/#{current_user.wishlist.key}?layout=compact")).body
      contents.scan(/(http:\/\/[^\/]*\/[a-zA-Z0-9?&-_=%\/]*\/dp\/([a-zA-Z0-9?&-_=%][^\/]*)\/[a-zA-Z0-9?&-_=%\/]*)/) do |matched|
        begin
          product = {}
          product.store("url", matched[0] + "&tag=" + user_affiliate_id)
          res = Amazon::Ecs.item_lookup(matched[1], {:country => 'jp', :response_group => 'Medium',})
          unless res.has_error?
            res.items.each do |item|
              product.store("title",item.get("ItemAttributes/Title"))
              product.store("image", item.get("MediumImage/URL"))
              product.store("price", item.get("ItemAttributes/ListPrice/FormattedPrice"))
            end
          end
          @wish_products << product
        rescue => e
          next
        end
      end
    end
  end

  def register_wishlist_id
    redirect_to wishlist_path(current_user)
  end

  def other_info
  end
end
