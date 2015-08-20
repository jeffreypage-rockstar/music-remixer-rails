# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
class HomeController < ApplicationController
	def index
		@filepath = "songs/jai_ambe"
		@song = [  {'1' => "O-Bass_1a.m4a", '2' => "O-Crash_1b.m4a", '3' => "O-Dive_1c.m4a", '4' => "O-Drums_1d.m4a", '5' => "O-DT-Perc_1e.m4a", '6' => "O-Inst_1f.m4a", '7' => "O-Up Perc_1g.m4a", '8' => "O-Vocals_1h.m4a"},
				   {'1' => "O-Bass_2a.m4a", '2' => "O-Crash_2b.m4a", '3' => "O-Dive_2c.m4a", '4' => "O-Drums_2d.m4a", '5' => "O-DT-Perc_2e.m4a", '6' => "O-Inst_2f.m4a", '7' => "O-Up Perc_2g.m4a", '8' => "O-Vocals_2h.m4a"}, 
				   {'1' => "O-Bass_3a.m4a", '2' => "O-Crash_3b.m4a", '3' => "O-Dive_3c.m4a", '4' => "O-Drums_3d.m4a", '5' => "O-DT-Perc_3e.m4a", '6' => "O-Inst_3f.m4a", '7' => "O-Up Perc_3g.m4a", '8' => "O-Vocals_3h.m4a"}, 
				   {'1' => "O-Bass_4a.m4a", '2' => "O-Crash_4b.m4a", '3' => "O-Dive_4c.m4a", '4' => "O-Drums_4d.m4a", '5' => "O-DT-Perc_4e.m4a", '6' => "O-Inst_4f.m4a", '7' => "O-Up Perc_4g.m4a", '8' => "O-Vocals_4h.m4a"}, 
				   {'1' => "O-Bass_5a.m4a", '2' => "O-Crash_5b.m4a", '3' => "O-Dive_5c.m4a", '4' => "O-Drums_5d.m4a", '5' => "O-DT-Perc_5e.m4a", '6' => "O-Inst_5f.m4a", '7' => "O-Up Perc_5g.m4a", '8' => "O-Vocals_5h.m4a"}, 
				   {'1' => "O-Bass_6a.m4a", '2' => "O-Crash_6b.m4a", '3' => "O-Dive_6c.m4a", '4' => "O-Drums_6d.m4a", '5' => "O-DT-Perc_6e.m4a", '6' => "O-Inst_6f.m4a", '7' => "O-Up Perc_6g.m4a", '8' => "O-Vocals_6h.m4a"}, 
				   {'1' => "O-Bass_7a.m4a", '2' => "O-Crash_7b.m4a", '3' => "O-Dive_7c.m4a", '4' => "O-Drums_7d.m4a", '5' => "O-DT-Perc_7e.m4a", '6' => "O-Inst_7f.m4a", '7' => "O-Up Perc_7g.m4a", '8' => "O-Vocals_7h.m4a"}, 
				   {'1' => "O-Bass_8a.m4a", '2' => "O-Crash_8b.m4a", '3' => "O-Dive_8c.m4a", '4' => "O-Drums_8d.m4a", '5' => "O-DT-Perc_8e.m4a", '6' => "O-Inst_8f.m4a", '7' => "O-Up Perc_8g.m4a", '8' => "O-Vocals_8h.m4a"}]
	end
end
