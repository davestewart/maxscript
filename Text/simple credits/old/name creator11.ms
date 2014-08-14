rollout info "Info & Instructions" width:160 height:192
(
	label info "A simple utility to aid quick set-up of multiple text objects.\n\nJust copy and paste your text to the list-box, click \"Build Names\" and move the timeslider to see the results.\n\nAt the moment, the only way to specify a font is to type the font name manually. A fool-proof method is to copy and paste the font name from an existing text object." pos:[8,8] width:160 height:186
)


rollout nameList "Name List" width:160 height:512
(
	edittext edt1 "" pos:[4,8] width:160 height:306 text:"Copy & paste names here..."
)


rollout textOptions "Text Options" width:180 height:232
(
	GroupBox grpPositioning "Positioning" pos:[8,8] width:156 height:56
		checkbox twoLines "Split text to two lines" pos:[16,24] width:128 height:16 checked:true
		checkbox centre "Centre text vertically" pos:[16,40] width:128 height:16 checked:false

	GroupBox grpScaling "Scaling" pos:[8,72] width:156 height:72
		radiobuttons scaling "" pos:[16,88] width:94 height:48 labels:#("All same width", "All same height", "Normal") default:3

	GroupBox grpAppearance "Appearance" pos:[8,152] width:156 height:64
		edittext font "Font" pos:[17,168] width:136 height:16 text:"Times New Roman"
		spinner shapeSteps "Shape steps" pos:[70,192] width:84 height:16 range:[0,10,3] type:#integer


)


rollout create "Create" width:160 height:56
(

	button camBtn "Create camera" pos:[8,32] width:156 height:16
	button namBtn "Build Names" pos:[8,8] width:156 height:16



	
	on camBtn pressed do
(
			Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,-700,0])
	)
	on namBtn pressed do
(
			-- set other globals
				spacing = 1000
		
		
			-- Build names list
				names = nameList.edt1.text
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
						obj.font = textOptions.font.text as String
						obj.steps = textOptions.shapeSteps.value
						
						--ctrl = bezier_float ()
						--obj.size.controller = ctrl 
						
					-- name new item
						if i < 10 then (obj.name = "Name 0" + i as String + " : " + names[i])
						else (obj.name = "Name " + i as String + " : " + names[i])
					
	
					-- colour new item
				newClr = [255,255,255] as Color
						--obj.wirecolor = color 0 0 ((i as Float / names.count) * 255)
						obj.wirecolor.h = ((i as Float / names.count) * 255)
						obj.wirecolor.s = 128
						obj.wirecolor.v = 128
						newClr.h =1
			newClr.s =128
			newClr.v =255
			$.wirecolor = newClr


				
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
							obj.text  = copy.names[i]
					)




					-- Set up scaling
						targetWidth = 400
						targetHeight = 300
		
						case textOptions.scaling.state of (
						1: (
							span = obj.max.x - obj.min.x
							targetScale = targetHeight / span
							addModifier obj (XForm()) ui:on
							obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
							modPanel.setCurrentObject obj.modifiers[#XForm]
							subobjectLevel = 0
						)
							
						2: (
							span = obj.max.z - obj.min.z
							targetScale = targetHeight / span
							addModifier obj (XForm()) ui:on
							obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
							modPanel.setCurrentObject obj.modifiers[#XForm]
							subobjectLevel = 0
						)
						3:(
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
		)
)


rof=newrolloutfloater "Simple Credits Setup" 200 200
addrollout info rof
addrollout nameList rof 
addrollout textOptions rof 
addrollout create rof 
rof.size=[200,800]
rof.pos=[87,93]
info.open=false
