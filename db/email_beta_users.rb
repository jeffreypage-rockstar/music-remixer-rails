#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

user = Referral.find_by_email('test4@avogen.com')
puts "Sending beta email to #{user.email}"
UserNotifier.beta_migration_email(user).deliver_now