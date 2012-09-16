# -*- coding: utf-8 -*-

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
    @sliced_products = []
    @wish_products.each_slice(4) {|slice|
      @sliced_products << slice
    }
  end

  def share
    if current_user
      main_message = "#{current_user.name}さんがAmazon ほしい物リストを共有しました。こっそりプレゼントしてあげると喜ぶかもしれません。"
      name = "#{current_user.name}さんの欲しい物リストを見てみる"
      link = "http://wish-your-gift.herokuapp.com/wishlist/detail/#{current_user.wishlist.id}"
      description = "誕生日が近づくと、自動でほしい物リストを共有するアプリからの投稿です。"
      picture = "http://g-ec2.images-amazon.com/images/G/09/x-locale/communities/wishlist/uwl/UWL_SWF_shims._V158153249_.png"
      current_user.facebook.put_wall_post(main_message,{
        :name => name,
        :link => link,
        :description => description,
        :picture => picture,
      })
    end
  end

  def register_wishlist_id
    redirect_to wishlist_path(current_user)
  end

  def other_info
  end
end
