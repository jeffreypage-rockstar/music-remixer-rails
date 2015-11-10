# Bob created a new remix "Bob Marley No...Cry (jammie jam)"
# Bob shared a new remix "Bob Marley No...Cry (jammie jam)"
# Bob started a new remix of "Bob Marley No...Cry"
# Bob started following Sarah
# Sarah liked Bob's remix "..."


json.array!(@activities) do |a|
	json.who do
		json.id a.owner.id
		json.name a.owner.name
		json.username a.owner.username
		json.profile_image a.owner.profile_image  # TODO: only return thumbnail
	end

	json.what do
		json.action a.key
	end

	json.when a.created_at
end
