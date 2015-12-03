class BetaUsersController < ApplicationController
  before_action :set_referral, except: [:thanks]

  def new
    @beta_user = BetaUser.new(email: @referral.email, name: @referral.name, invite_code: @referral.invite_code)
	end

	def create
    beta_user = { invite_code: @referral.invite_code }.merge(beta_user_params)

    if BetaUser.create(beta_user)
      @referral.update_attribute(:signed_up_at, Time.now)
      redirect_to beta_thanks_path
    else
      render :new
    end
  end

  def thanks
  end

  private
  def set_referral
    if params[:invite_code]
      referral = Referral.virgin.find_by(invite_code: params[:invite_code])
      @referral = referral if referral
    end

    redirect_to root_path, alert: 'Invalid invite code or already occupied.' if @referral.nil?
  end

	# Never trust parameters from the scary internet, only allow the white list through.
	def beta_user_params
		params.require(:beta_user).permit(:name, :email, :message)
	end

end
