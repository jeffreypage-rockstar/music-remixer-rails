# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where({email: 'mark@8stem.com'}).delete_all
User.create!(email:'mark@8stem.com', username:'mark8stem', name:'Mark Puckett', password:'asdfasdf', is_admin:true)

User.where({email: 'test@test.com'}).delete_all
User.create!(email:'test@test.com', username:'test', name:'Test Test', password:'asdfasdf', is_admin:false, is_artist_admin:true)