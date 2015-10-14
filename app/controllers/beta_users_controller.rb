class BetaUsersController < ApplicationController

	def join
		if request.post? && params.include?(:beta_user)
			@beta_user = BetaUser.new(beta_user_params)
			@beta_user.invite_code = Digest::SHA1.hexdigest([Time.now, rand].join)
			if @beta_user.save
				redirect_to beta_thanks_url
			else
				render :join
			end
		else
			@beta_user = BetaUser.new
		end
	end

	def thanks
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def beta_user_params
		params.require(:beta_user).permit(:name, :email, :message)
	end

end
