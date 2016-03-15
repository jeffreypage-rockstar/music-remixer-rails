#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

User.find(35).authentications.each do |auth|
  @graph = Koala::Facebook::API.new(auth.token)

  profile = @graph.get_object("me")
  puts profile.inspect

  permissions = @graph.get_connections("me", "permissions")
  puts permissions.inspect

  friends = @graph.get_connections("me", "friends")
  puts friends.inspect
end
