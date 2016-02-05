#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

accounts = [
  {:name => "Dirtwire",     :email => "evanjawharp@gmail.com",        :username => 'dirtwire'},
  {:name => "Lulacruza",    :email => "luis.maurette@gmail.com",      :username => 'lulacruza'},
  {:name => "Random Rab",   :email => "rab@randomrab.net",            :username => 'rab'},
  {:name => "Perlo",        :email => "hbredouw@gmail.com",           :username => 'perlo'},
  {:name => "Yamia",        :email => "yaimamusicproject@gmail.com",  :username => 'yamia'},
  {:name => "Dogon Lights", :email => "virmccoy@gmail.com",           :username => 'dogon-lights'},
  {:name => "Fearce Vill",  :email => "beanone76@gmail.com",          :username => 'fearce-vill'},
  {:name => "Hamsa Lila",   :email => "tmindel@gmail.com",            :username => 'hamsa-lila'}
]

accounts.each do |account|
  ActiveRecord::Base.transaction do
    user = User.create!(
      name: account[:name],
      email: account[:email],
      username: account[:username],
      password: 'asdfasdf',
      is_admin: false,
      is_artist_admin: true,
      confirmed_at: '2016-02-05 12:00'
    )

    artist = BetaArtist.create!(
      artist_name: account[:name],
      artist_url: 'http://8stem.com',
      name: account[:name],
      email: account[:email],
      user_id: user.id
    )
  end
end
