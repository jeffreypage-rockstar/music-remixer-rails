# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
class HomeController < ApplicationController
	def index
		@song = Song.includes(:clips).all.last
		if @song.blank?
		   return redirect_to new_song_path
		end
	end
end
