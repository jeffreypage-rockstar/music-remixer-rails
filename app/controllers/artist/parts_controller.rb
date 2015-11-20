class Artist::PartsController < Artist::BaseController
  before_action :set_part, only: [:show, :edit, :update, :destroy]

	def new
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @part.update(part_params)
        # format.html { redirect_to [@song, @part], notice: 'Part was successfully updated.' }
        format.json { render json: @part}
      else
        # format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @song = Song.find(params[:song_id])
      @part = Part.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit(:name, :column)
    end
end
