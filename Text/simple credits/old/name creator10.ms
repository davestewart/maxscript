utility Credits8 "Simple Credits Maker 8" width:162 height:1000
(

	checkbox chk1 "Text on 2 lines" pos:[8,8] width:144 height:16 checked:true
	checkbox centre "Centre Text Vertically" pos:[8,20] width:144 height:16 checked:true
	edittext edt1 "" pos:[17,136] width:128 height:264
	GroupBox grp1 "Names" pos:[9,48] width:144 height:360
	button btn1 "Build Names" pos:[8,515] width:144 height:16
	button camBtn "Create camera" pos:[8,546] width:144 height:16

	
	radiobuttons scaling "Scaling options" pos:[9,448] width:82 height:62 labels:#("Scale width", "Scale height", "None") default:3
	GroupBox grp6 "GroupBox" pos:[0,30] width:160 height:514


	
	------------------------------------------------------------------------------------------
	-- Main Code
	------------------------------------------------------------------------------------------
	





		
		
	on btn1 pressed do
	(
		-- set other globals
			carriageReturn = "yes"
			spacing = 1000
	
	
		-- Build names list
			names = edt1.text
			names = filterString names "\r\"\n"
			print names
	


		
		--sets the animation range
			if names.count == 0 then (
				print "No Data!"
				)
			else (
				animationRange = interval 0 names.count
				)
	
		
		
		-- creates the objects & positions them
			for i = 1 to names.count do (
				
				-- build text & set up text formatting
					obj = text size:100 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					obj.alignment = 2
				
				-- name new item
					if i < 10 then (obj.name = "Name 0" + i as String + " : " + names[i])
					else (obj.name = "Name " + i as String + " : " + names[i])
				
				-- colour new item
					obj.wirecolor = color 88 143 225
					
				-- put in carriage returns
					if carriageReturn == "yes" then (
						displayText = names[i]
						spaceIndex = findString displayText " " -- find any spaces
						obj.text = replace displayText spaceIndex 1 "\r"
					)
					else
						(
						obj.text  = names[i]
					)
				
		
				-- Set up scaling
					targetWidth = 400
					targetHeight = 300
	
					case scaling.state of (
					1: 	(
						print "Scaling by Width"
						span = obj.max.x - obj.min.x
						targetScale = targetHeight / span
						addModifier obj (XForm())
						obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
						)
						
					2: 	(
						print "Scaling by Height"
						span = obj.max.z - obj.min.z
						targetScale = targetHeight / span
						addModifier obj (XForm())
						obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
						)
					3:	(
						print "No scaling"
						)
					) 
	
	
				-- set up objects to move
					obj.pos.controller = Position_XYZ ()
				
					addNewKey obj.pos.controller.Z_Position.controller ((i-1) as Time)
					addNewKey obj.pos.controller.Z_Position.controller (i as Time)
					addNewKey obj.pos.controller.Z_Position.controller ((i+1) as Time)
				
					-- Centre the object?
					if centre.checked then (
						obj.pivot.z = (obj.max.z - obj.min.z) / 2 + obj.min.z
					)

					obj.pos.controller.Z_Position.controller.keys[1].value = spacing
					obj.pos.controller.Z_Position.controller.keys[2].value = 0
					obj.pos.controller.Z_Position.controller.keys[3].value = -spacing
			
			)
		)
	on camBtn pressed do
	(
	Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,-700,0])
	)
)