class Artist::ClipTypesController < ApplicationController
  before_action :set_clip_type, only: [:show, :edit, :update, :destroy]

  def new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @clip_type.update(clip_type_params)
        # format.html { redirect_to [@song, @clip_type], notice: 'clip_type was successfully updated.' }
        format.json { render json: @clip_type}
      else
        # format.html { render :edit }
        format.json { render json: @clip_type.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_clip_type
    @song = Song.find(params[:song_id])
    @clip_type = ClipType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def clip_type_params
    params.require(:clip_type).permit(:name, :row)
  end
end
