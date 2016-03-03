class App::SongsController < App::BaseController
  respond_to :html, :json

  before_action :require_login, only: [:share_modal, :share, :like, :show_remixes]
  before_action :set_song, only: [:show, :share_modal, :like, :show_remixes]

  # GET /songs/1
  # GET /songs/1.json
  def show
    redirect_to app_show_profile_path(@song.user.username) + "?sid=#{@song.uuid}"
    return

    @new_comment = Comment.build_from(@song, current_user ? current_user.id : nil, "")
    @mixes = []

    @mixes << {
        :url => @song.mixaudio.url,
        :style => 'Original'
    }
    @mixes << {
        :url => @song.mixaudio_mix2.url,
        :style => 'Mix2'
    }
    @mixes << {
        :url => @song.mixaudio_mix3.url,
        :style => 'Mix3'
    }
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

  def like
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

  def show_remixes
    render :remixes
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
