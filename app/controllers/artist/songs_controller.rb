class Artist::SongsController < Artist::BaseController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction

  before_action :require_login
  before_action :set_song, only: [:show, :edit, :update, :configure, :mixaudio, :share_modal, :destroy]
  before_action :set_configuration, only: [:configure, :mixaudio]

  # GET /songs
  # GET /songs.json
  def index
    @songs = @artist.artist_visible_songs.order("#{sort_column} #{sort_direction}")
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)
    @song.user = current_user
    if @song.save
      $tracker.track current_user.uuid, 'Song: uploaded', {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
      flash[:success] = 'Song was successfully created.'
      flash.keep(:success)

      if request.xhr?
        render json: { redirect_url: artist_songs_path }
      else
        redirect_to artist_songs_path
      end
    else
      if request.xhr?
        render partial: 'artist/songs/form', layout: false, status: :unprocessable_entity
      else
        render :new
      end
    end
  end

  def configure
    respond_to do |format|
      format.html {}
      format.js {}
    end

    @bad_clips = @song.clips.where(row: 0, column: 0)
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|      
      if params[:status] && params[:status] == "released" && @song.bpm == 0
        return
      end
    
      if @song.update(song_params)
        $tracker.track current_user.uuid, "Song: updated", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
        format.html { redirect_to configure_artist_song_path(@song), notice: 'Song was successfully updated.' }
        format.json { render json: @song }
        if params[:status]
          if params[:status] == "released"
            MixaudioBuildWorker.perform_async @song.id
            $tracker.track current_user.uuid, "Song: released", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
          elsif params[:status] == 'working'
            User.decrement_counter(:songs_count, @song.user_id)
            $tracker.track current_user.uuid, "Song: unreleased", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
          end
        end
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def mixaudio
    respond_to do |format|
      if @song.build_mixaudio(params[:configuration])
        @mixaudio = @song.mixaudio
        # format.html { redirect_to configure_artist_song_path(@song), notice: 'Song was successfully updated.' }
        format.js {}
        # format.json { render json: { song: @song, mixaudio: @mixaudio, state: @state} }
      else
        # format.html { render :edit }
        format.js {}
        # format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.status = Song.statuses[:deleted]
    @song.save
    $tracker.track current_user.uuid, "Song: deleted", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  # POST /songs/1/delete
  def delete_song
    if current_user.is_admin?
      @song.destroy
      $tracker.track current_user.uuid, "Song: destroyed", {'uuid' => @song.uuid, 'name' => @song.decorate.name_with_artist}
      respond_to do |format|
        format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
        format.json { head :no_content }
        format.js
      end
    else
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = current_user.artist_visible_songs.find(params[:id])
    unless @song
      return redirect_to artist_songs_path
    end
  end

  def set_configuration
    @configuration = 'source'
    if params[:configuration].present?
      @configuration = params[:configuration]
    end

    @mixaudio = @song.mixaudio
  end

  def sort_column
    Song.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def song_params
    params.require(:song).permit(:name, :duration, :bpm, :genre_list, :zipfile, :zipfile_cache, :image, :image_cache, :status)
  end
end
