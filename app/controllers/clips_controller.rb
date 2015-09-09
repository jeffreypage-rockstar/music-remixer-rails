class ClipsController < ApplicationController
  before_action :set_clip, only: [:show, :edit, :update, :destroy]
  
  def new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @clip.update(clip_params)
        format.json { render json: @clip}
      else
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # def state
  # 	@song = Song.find(params[:song_id])
  #   @clip = Clip.where(song_id: @song.id, row: params[:clip][:row], column: params[:clip][:column]).first
  #   unless @clip
  #     @clip = Clip.new(clip_params)
  #     @clip.song = @song
  #     @clip.save
  #   else 
  #     @clip.update_attributes(clip_params)
  #   end
  #   respond_to do |format|
  #     format.json { render json: @clip}
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clip_params
      params.require(:clip).permit(:name, :row, :column, :state)
    end
end
