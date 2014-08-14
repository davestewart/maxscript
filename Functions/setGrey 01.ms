--callbacks.addScript <callback_type_name> \ ( <script_string> | <script_stringstream> | \ fileName:<filename_string> ) \ [id:<name>] [ persistent:<boolean> ] 

fn assignGreyMaterial obj =
	(
	if superClassOf obj != 0 then
		(
		if $.material == undefined OR $.material.name != "Grey" then
			(
			try(
			$.material = sceneMaterials["Grey"]
			)
			catch()
			--print "Grey Material made"
			)
		)
	)

	


callbacks.removeScripts #nodeCreated
callbacks.addScript #nodeCreated "obj=(callbacks.NotificationParam()); if superclassOf obj != shape then obj.material = sceneMaterials[\"Grey\"]" persistent:true