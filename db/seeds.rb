# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where({email: 'mark@8stem.com'}).delete_all
User.create!(
	email:'mark@8stem.com',
	username:'mark8stem',
	name:'Mark Puckett',
	password:'asdfasdf',
	is_admin:true,
	is_artist_admin:true,
	confirmed_at:'2015-10-10 10:10'
)

User.where({email: 'testartist@8stem.com'}).delete_all
User.create!(
  email:'testartist@8stem.com',
  username:'testartist',
  name:'Test Artist',
  password:'asdfasdf',
  is_admin:false,
  is_artist_admin:true,
  confirmed_at:'2015-10-01 10:10'
)

User.where({email: 'testuser@8stem.com'}).delete_all
User.create!(
  email:'testuser@8stem.com',
  username:'testuser',
  name:'Test User',
  password:'asdfasdf',
  is_admin:false,
  is_artist_admin:false,
  confirmed_at:'2015-10-01 10:10'
)

BetaUser.where({email: 'betauser@8stem.com'}).delete_all
BetaUser.create!(
  email:'betauser@8stem.com',
  name:'Beta User',
  invite_code:'abc123',
  age:23
)

MusicBackground.delete_all
MusicBackground.create!(name: 'Music Fan')
MusicBackground.create!(name: 'Produce Music')
MusicBackground.create!(name: 'Play Instrument')
MusicBackground.create!(name: 'Pro DJ')
MusicBackground.create!(name: 'Own Audio Software')
MusicBackground.create!(name: 'Pro Music Producer')
MusicBackground.create!(name: 'DJ')
MusicBackground.create!(name: 'Pro Audio Engineer')

# follow
User.find(1).follow!(User.find(2))
User.find(2).follow!(User.find(1))


