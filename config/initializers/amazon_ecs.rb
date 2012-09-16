require 'amazon/ecs'

Amazon::Ecs.debug = true
Amazon::Ecs.options = {
  :associate_tag => ENV['AMAZON_AFFILIATE_ID'],
  :AWS_access_key_id => 'AKIAIC6QGSQRYZW7FDIA',
  :AWS_secret_key => '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'
}