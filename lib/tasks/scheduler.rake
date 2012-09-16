desc "This task for posting birthday wishlist"
task :birthday_post => :environment do
  puts "daily posting..."
  User.post_wishlist
  puts "done."
end