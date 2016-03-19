#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

text = File.read(File.dirname(__FILE__) + '/beta-users-test.csv')
csv = CSV.parse(text, :headers => true)
csv.each do |row|
  row = row.to_hash.with_indifferent_access
  row = row.to_hash.symbolize_keys

  email = row[:email]
  if user = BetaUser.find_by_email(row[:email])
    puts "BetaUser already exists for #{row[:email]}"
  elsif user = User.find_by_email(row[:email])
    puts "BetaUser does NOT exist, but User already exists for #{row[:email]}"
  elsif referral = Referral.find_by_email(row[:email])
    puts "Referral already exists for #{row[:email]}"
  else
    puts "Creating new beta user referral for #{row[:email]}"
    Referral.create!(row)
  end
end