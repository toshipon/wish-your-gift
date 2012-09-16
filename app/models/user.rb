# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  has_one :wishlist

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.birthday = DateTime.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y")
      user.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def birthday_str
    birthday.strftime("%m/%d")
  end

  def self.post_wishlist
    users = User.all
    users.each do |specified_user|
      if specified_user.birthday_come_after(7)
        if specified_user.try(:wishlist).try(:has_key?)
          specified_user.publish_wishlist
        end
      end
    end
  end

  def birthday_come_after(days=10)
    this_year_birthday = DateTime.new(DateTime.now.year, birthday.month, birthday.day)
    now = DateTime.now
    remain_days = (this_year_birthday - now).to_i
    (days - 1) < remain_days && remain_days < (days + 1)
  end

  def publish_wishlist
    main_message = "#{name}さんの誕生日が近づいています。ほしい物リストの中から#{name}さんが確実に喜ぶプレゼントを贈りましょう。"
    name = "#{name}さんの欲しい物リストを見てみる"
    link = "http://wish-your-gift.herokuapp.com/gift/#{wishlist.id}"
    description = "誕生日が近づくと、自動でほしい物リストを共有するアプリからの投稿です。"
    picture = "http://g-ec2.images-amazon.com/images/G/09/x-locale/communities/wishlist/uwl/UWL_SWF_shims._V158153249_.png"
    facebook.put_wall_post(main_message,{
      :name => name,
      :link => link,
      :description => description,
      :picture => picture,
    })
  end
end
