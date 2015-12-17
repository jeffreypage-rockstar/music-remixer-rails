class Artist::SongsController < Artist::BaseController
  respond_to :html, :json
  helper_method :sort_column, :sort_direction

  before_action :require_login
  before_action :set_song, only: [:show, :edit, :update, :configure, :mixaudio, :share_modal, :toggle_like_song, :destroy]
  before_action :set_configuration, only: [:configure, :mixaudio]

  # GET /songs
  # GET /songs.json
  def index
    @songs = @artist.songs.order("#{sort_column} #{sort_direction}")
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
      # @song.create_activity :create, owner: current_user
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
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to configure_artist_song_path(@song), notice: 'Song was successfully updated.' }
        format.json { render json: @song }
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

  def share_modal
    respond_modal_with @song
  end

  def share
    if %w(facebook twitter google-plus tumblr pinterest email).include? params[:channel]
      @song.create_activity :share, owner: current_user, parameters: { channel: params[:channel] }
      respond_to do |format|
        format.json { render json: { song_id: @song.id, channel: params[:channel] } }
      end
    end
  end

  def toggle_like_song
    current_user.toggle_like!(@song)
    @song.create_activity current_user.likes?(@song) ? :like : :unlike, owner: current_user
    respond_to do |format|
      format.js { render :like_unlike_song }
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_song
    if action_name == 'configure' || action_name == 'mixaudio'
      @song = current_user.songs.includes(:clip_types, :parts => [:clips]).find_by(id: params[:id])
    else
      @song = current_user.songs.find(params[:id])
    end

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
