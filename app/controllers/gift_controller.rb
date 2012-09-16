class GiftController < ApplicationController
  def show
    @person_wishlist = Wishlist.find(params[:id])
    @wish_products = []
    contents = Net::HTTP.get_response(URI.parse("http://www.amazon.co.jp/registry/wishlist/#{@person_wishlist.key}?layout=compact")).body
    contents.scan(/(http:\/\/[^\/]*\/[a-zA-Z0-9?&-_=%\/]*\/dp\/([a-zA-Z0-9?&-_=%][^\/]*)\/[a-zA-Z0-9?&-_=%\/]*)/) do |matched|
      begin
        product = {}
        product.store("url", matched[0] + "&tag=" + user_affiliate_id(params[:id]))
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
    @sliced_products = []
    @wish_products.each_slice(4) {|slice|
      @sliced_products << slice
    }
  end
end
