json.extract! @user, :id, :email, :username, :created_at, :confirmed_at, :is_admin
json.profile_image @user.profile_image
