class App::ReferralsController < ApplicationController
  def new
    @referral = Referral.new
  end

  def create
    emails = batch_referral_params[:emails]
    message = batch_referral_params[:message]
    @referral = Referral.new(batch_referral_params)

    respond_to do |format|
      if @referral.valid?
        emails.split(',').uniq.each { |email|
          Referral.create(email: email, message: message, referring: current_user)
          $tracker.track current_user.uuid, 'Referral: created', {'email' => email}
        }
        format.html { redirect_to referrals_thanks_path }
        format.js { render :thanks }
      else
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  def thanks

  end

  def track
    if params[:invite_code]
      referral = Referral.virgin.find_by(invite_code: params[:invite_code])
      if referral
        referral.update_attribute(:clicked_at, Time.now)
        redirect_to beta_sign_up_path(invite_code: params[:invite_code])
      end
    end
  end

  def batch_referral_params
    params.require(:referral).permit(:emails, :message)
  end
end
