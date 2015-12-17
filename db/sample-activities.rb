User.find(1).create_activity :follow, owner: User.find(2)
User.find(2).create_activity :follow, owner: User.find(1)
Song.find(1).create_activity :like,   owner: User.find(1)
Song.find(2).create_activity :like,   owner: User.find(1)
Song.find(1).create_activity :like,   owner: User.find(2)

