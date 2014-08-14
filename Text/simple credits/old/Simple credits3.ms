--------------------------------------------------------------------------------------------------------------------------------
-- Define rollouts
--------------------------------------------------------------------------------------------------------------------------------

rollout info "Info & Instructions" width:160 height:300
(
	label info "A simple utility to aid quick set-up of multiple text objects.\n\nJust copy and paste your text to the list-box, click \"Build Names\" and move the timeslider to see the results.\n\nApply whatever modifier you want to the entire selection (this can be very slow), and render!\n\n* Note: At the moment, the only way to specify a font is to type the font name manually. The best method is to copy and paste the font name from an existing text object." pos:[8,8] width:160 height:240
)


rollout nameList "Name List" width:160 height:512
(
	edittext edt1 "" pos:[4,8] width:160 height:306 text:"Dave Stewart\rIan Stewart\rBen Rowe"
)


rollout textOptions "Text Options" width:176 height:384
(
	GroupBox grpPositioning "Positioning" pos:[8,8] width:156 height:56
		checkbox twoLines "Split text to two lines" pos:[16,24] width:128 height:16 checked:true
		checkbox centre "Centre text vertically" pos:[16,40] width:128 height:16 checked:false


	GroupBox grpScaling "Scaling" pos:[8,72] width:156 height:112
		radiobuttons scaleMethod "" pos:[16,88] width:94 height:48 labels:#("None", "All same width", "All same height") default:1
		radioButtons scaleType "" pos:[16,144] width:116 height:32 labels:#("XForm modifier", "Scale transform")


	GroupBox grpRendering "Rendering" pos:[8,328] width:160 height:40
		spinner shapeSteps "Shape steps" pos:[75,344] width:84 height:16 range:[0,10,3] type:#integer


	--set up instanced controllers for text options
		local sizeCtrl = bezier_float ()
		local leadingCtrl = bezier_float ()
		local kerningCtrl = bezier_float ()

	GroupBox grpTypographic "Typographic" pos:[8,192] width:160 height:128
		edittext font "Font" pos:[16,208] width:131 height:16 text:"Times New Roman"
		spinner size "Size" pos:[88,232] width:71 height:16 range:[0,1000,100] controller:sizeCtrl
		spinner leading "Leading" pos:[75,256] width:84 height:16 range:[0,1000,0] controller:leadingCtrl
		spinner kerning "Kerning" pos:[75,280] width:84 height:16 range:[0,1000,0] controller:kerningCtrl
		button updateFontBtn ">" pos:[147,208] width:12 height:16 toolTip:"Update Font"


	--set up spinners
		on textOptions open do (
			sizeCtrl.value = 100 as Float
	)
		
	on updateFontBtn pressed do
(
	for i = 1 to objectList.count do (
		obj = execute ("$'" + objectList[i] + "'")
		if obj != undefined then obj.font = font.text as String
	)
)
	
)


rollout create "Create" width:160 height:56
(
	button namBtn "Create names" pos:[8,8] width:156 height:16 toolTip:"Build all the objects"
	button camBtn "Create camera" pos:[8,32] width:156 height:16



--------------------------------------------------------------------------------------------------------------------------------
-- Main Code & handlers
--------------------------------------------------------------------------------------------------------------------------------

	on camBtn pressed do
(
	if $Camera_Front == undefined then
		Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,-700,0]) name:"Camera_Front"
		else print "Camera already exists"

			max vpt camera
	)

	on namBtn pressed do
(
			-- set other globals
				spacing = 1000
				objectList = #()
		
			-- Build names list
				names = nameList.edt1.text
				names = filterString names "\r\"\n"
				print names
	
	
			--sets the animation range
				if names.count == 0 then (
					print "No Data!"
				)
				else (
					animationRange = interval 0 (names.count + 1)
				)
	
	
			-- creates the objects & positions them
				for i = 1 to names.count do (
					

					-- build text & set up text formatting

						obj = text size:textOptions.size.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
						obj.alignment = 2

						obj.font = textOptions.font.text as String
						obj.steps = textOptions.shapeSteps.value

						--obj.leading = textOptions.leading.value
						--obj.kerning = textOptions.kerning.value


					--set up instanced controllers
						--obj.size.controller = sizeCtrl
						--obj.leading.controller = leadingCtrl
						--obj.kerning.controller = kerningCtrl


					-- name new item
						if i < 10 then (obj.name = "Name 0" + i as String + " : " + names[i])
						else (obj.name = "Name " + i as String + " : " + names[i])
					

					--put item name in array for deleting
						append objectList obj.name
						--print execute ("putting name in " + obj.name)



					-- colour new item
						objClr = [0,0,0] as Color
						objClr.b = ((i as Float / names.count) * 255)
						obj.wirecolor = objClr



					-- put in carriage returns
						if textOptions.twoLines.checked then (
							displayText = names[i]
							spaceIndex = findString displayText " " -- find any spaces
							if spaceIndex != undefined then (
								obj.text = replace displayText spaceIndex 1 "\r"
							)
							else (
								obj.text = displayText
							)
						)
							else
						(
							obj.text  = names[i]
					)




					-- Set up scaling
						targetWidth = 400
						targetHeight = 300
		
						case textOptions.scaleMethod.state of (
						1:(
							-- do nothing
						)
						2: (
							span = obj.max.x - obj.min.x
							targetScale = targetHeight / span
							addModifier obj (XForm()) ui:on
							obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
							modPanel.setCurrentObject obj.modifiers[#XForm]
							subobjectLevel = 0
						)
							
						3: (
							span = obj.max.z - obj.min.z
							targetScale = targetHeight / span
							addModifier obj (XForm()) ui:on
							obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
							modPanel.setCurrentObject obj.modifiers[#XForm]
							subobjectLevel = 0
						)
					) 
		

					-- set up objects to move
						obj.pos.controller = Position_XYZ ()
					
						addNewKey obj.pos.controller.Z_Position.controller ((i-1) as Time)
						addNewKey obj.pos.controller.Z_Position.controller (i as Time)
						addNewKey obj.pos.controller.Z_Position.controller ((i+1) as Time)
					
					-- Centre the object as well?
						if textOptions.centre.checked then (
							obj.pivot.z = (obj.max.z - obj.min.z) / 2 + obj.min.z
					)

						obj.pos.controller.Z_Position.controller.keys[1].value = spacing
						obj.pos.controller.Z_Position.controller.keys[2].value = 0
						obj.pos.controller.Z_Position.controller.keys[3].value = -spacing

			)
				sliderTime = 1
		)
	)

rollout delNames "Delete" width:160 height:512
(
	button listBtn "List Names" pos:[8,8] width:156 height:16
	button delBtn "Delete Names" pos:[8,32] width:156 height:16

	on listBtn pressed do
(
	for i = 1 to objectList.count do (print objectList[i])
	)
		
	on delBtn pressed do
(
	for i = 1 to objectList.count do (
		obj = execute ("$'" + objectList[i] + "'")
		if obj != undefined then delete obj
	)
		objectList = #()
)
)


--------------------------------------------------------------------------------------------------------------------------------
-- Final setup
--------------------------------------------------------------------------------------------------------------------------------

-- create the Floater window and add the rollouts
	if SCrof != undefined do
	(
			closerolloutfloater SCrof
	)		

	SCrof=newrolloutfloater "Simple Credits" 200 200

-- add the rollouts
	addrollout info SCrof
	addrollout nameList SCrof
	addrollout textOptions SCrof
	addrollout create SCrof
	addrollout delNames SCrof
	
-- position & setup the floater
	SCrof.size=[200,898]
	--SCrof.pos=[87,93]
	SCrof.pos=[1088,83]
	info.open=false