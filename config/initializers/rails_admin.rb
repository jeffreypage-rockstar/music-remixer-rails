RailsAdmin.config do |config|
	config.authorize_with do
		unless current_user && current_user.admin?
			redirect_to main_app.sign_in_url, alert: 'You are not permitted to view this page'
		end
	end

	config.current_user_method { current_user }

	config.model "User" do
		edit do
			field :email
			field :username
			field :password
			field :is_admin
			field :is_artist_admin
		end
	end
end
