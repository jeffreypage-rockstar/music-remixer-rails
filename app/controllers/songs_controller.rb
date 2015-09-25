class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :configure, :mixaudio, :destroy]
  before_action :set_configuration, only: [:configure, :mixaudio]

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
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

    respond_to do |format|
      if @song.save
        format.html { redirect_to configure_song_path(@song), notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def configure
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to configure_song_path(@song), notice: 'Song was successfully updated.' }
        format.json { render json: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def mixaudio
    respond_to do |format|
      if @song.create_mixed_audio(params[:configuration])
        @mixaudio = @song.mixaudio
        if @configuration == 'style-up'
          @mixaudio = @song.mixaudio2
        elsif @configuration == 'style-down'
          @mixaudio = @song.mixaudio3
        end
        # format.html { redirect_to configure_song_path(@song), notice: 'Song was successfully updated.' }
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
        @song = Song.includes(:clip_types, :parts => [:clips]).find_by(id: params[:id])
      else 
        @song = Song.find(params[:id])
      end
    end

    def set_configuration
      @configuration = 'source'
      if params[:configuration].present?
        @configuration = params[:configuration]
      end

      @mixaudio = @song.mixaudio
      @state = 'state'
      if @configuration == 'style-up'
        @mixaudio = @song.mixaudio2
        @state = 'state2'
      elsif @configuration == 'style-down'
        @mixaudio = @song.mixaudio3
        @state = 'state3'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :duration, :zipfile)
    end
end
