class App::RemixesController < App::BaseController
  respond_to :html, :json

  before_action :require_login, only: [:share_modal, :share, :like, :show_remixes]
  before_action :set_remix, only: [:show, :share_modal, :like, :show_remixes]

  # GET /remix/1
  # GET /remix/1.json
  def show
    @new_comment = Comment.build_from(@remix, current_user ? current_user.id : nil, "")
  end

  def share_modal
    track_event 'Social: remix: share modal fired', {'remix' => @remix.uuid, 'name' => @remix.name}
    respond_modal_with @remix
  end

  def share
    if %w(facebook twitter google-plus tumblr pinterest email).include? params[:channel]
      track_event 'Social: remix: shared', {'remix' => @remix.uuid, 'name' => @remix.name, 'channel' => params[:channel]}
      @remix.create_activity :share, owner: current_user, parameters: { channel: params[:channel] }
      respond_to do |format|
        format.json { render json: { remix_id: @remix.id, channel: params[:channel] } }
      end
    end
  end

  def like
    current_user.toggle_like!(@remix)
    if current_user.likes?(@remix)
      track_event 'Social: remix: liked', {'remix' => @remix.uuid, 'name' => @remix.name}
      @remix.create_activity :like, owner: current_user
    else
      track_event 'Social: remix: unliked', {'remix' => @remix.uuid, 'name' => @remix.name}
    end
    respond_to do |format|
      format.js { render :like_unlike_remix }
    end
  end

  def show_remixes
    render :remixes
  end

  private
  def set_remix
    @remix = Remix.find(params[:id])
    unless @remix
      return redirect_to app_home_path
    end
    @remix = @remix.decorate
  end
end
