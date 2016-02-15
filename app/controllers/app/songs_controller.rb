class App::SongsController < App::BaseController
  respond_to :html, :json

  before_action :require_login
  before_action :set_song, only: [:show, :share_modal, :toggle_like_song]

  # GET /songs/1
  # GET /songs/1.json
  def show
    @mixes = []

    @new_comment = Comment.build_from(@song, current_user.id, "")
  end

  def share_modal
    $tracker.track current_user.uuid, "Song: share modal fired", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
    respond_modal_with @song
  end

  def share
    if %w(facebook twitter google-plus tumblr pinterest email).include? params[:channel]
      $tracker.track current_user.uuid, "Song: shared", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist, 'channel' => params[:channel]}
      @song.create_activity :share, owner: current_user, parameters: { channel: params[:channel] }
      respond_to do |format|
        format.json { render json: { song_id: @song.id, channel: params[:channel] } }
      end
    end
  end

  def toggle_like_song
    current_user.toggle_like!(@song)
    if current_user.likes?(@song)
      $tracker.track current_user.uuid, "Song: liked", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
      @song.create_activity :like, owner: current_user
    else
      $tracker.track current_user.uuid, "Song: unliked", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
    end
    respond_to do |format|
      format.js { render :like_unlike_song }
    end
  end

  private
  def set_song
    @song = Song.find(params[:id])
    unless @song
      return redirect_to artist_songs_path
    end
    @song = @song.decorate
  end
end
