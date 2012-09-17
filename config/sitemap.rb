# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://wish-your-list.com"

SitemapGenerator::Sitemap.create do
  #add "/mypages/index", :priority => 1.0
  Wishlist.find_each do |w|
    if w.key.present?
      add "/gift/#{w.id}", :lastmod => w.updated_at
    end
  end
end
