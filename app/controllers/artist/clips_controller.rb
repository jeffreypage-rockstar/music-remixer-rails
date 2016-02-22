class Artist::ClipsController < Artist::BaseController
  before_action :set_clip, only: [:show, :edit, :update, :destroy, :update_clip]
  
  def new
  end

  def show
    @clip = Clip.find(params[:id])
    respond_to do |format|
      format.json { render json: @clip}
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      # clip_type and part are nil when not placed in the grid correctly
      if @clip.clip_type.nil?
        @clip.clip_type = ClipType.find_by(:song_id => @clip.song_id, :row => clip_params[:row])
      end
      if @clip.part.nil?
        @clip.part = Part.find_by(:song_id => @clip.song_id, :column => clip_params[:column])
      end

      if @clip.update(clip_params)
        format.json { render json: @clip}
      else
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_clip
      respond_to do |format|
       file_path = "#{Rails.root}/public/uploads/tmp/" + params[:file].original_filename
       aFile = File.new(file_path, "w")
       aFile.write(open(params[:file]).read)
       aFile.close
       file = ::FFMPEG::Movie.new(file_path)
       if @clip.duration == file.duration
        @new_clip = Clip.new ({id: @clip.id, row: @clip.row, column: @clip.column, storing_status: 0, file: File.open(file_path), song: @clip.song, clip_type: @clip.clip_type, part: @clip.part})
        @clip.destroy
        @new_clip.save
        format.json { render json: @new_clip}
       else
        format.json { render json: @clip.errors, status: :unprocessable_entity }
       end
       FileUtils.rm_rf(file_path)
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clip_params
      params.require(:clip).permit(:name, :row, :column, :state, :state2, :state3)
    end
end