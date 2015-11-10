# Bob created a new remix "Bob Marley No...Cry (jammie jam)"
# Bob shared a new remix "Bob Marley No...Cry (jammie jam)"
# Bob started a new remix of "Bob Marley No...Cry"
# Bob started following Sarah
# Sarah liked Bob's remix "..."


json.array!(@activities) do |a|
	json.actor do
		json.id a.owner.id
		json.name a.owner.name
		json.username a.owner.username
		json.profile_image a.owner.profile_image  # TODO: only return thumbnail
	end

	json.action a.key


	json.when a.created_at
end
