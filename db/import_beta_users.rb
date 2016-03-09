#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

text = File.read(File.dirname(__FILE__) + '/beta-users-test.csv')
csv = CSV.parse(text, :headers => true)
csv.each do |row|
  row = row.to_hash.with_indifferent_access
  Referral.create!(row.to_hash.symbolize_keys)
end