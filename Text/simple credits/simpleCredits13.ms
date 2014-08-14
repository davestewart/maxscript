--------------------------------------------------------------------------------------------------------------------------------
-- Initialise globals
--------------------------------------------------------------------------------------------------------------------------------

	-- initialise data variables
		global objectList = #()

	-- set up instanced controllers for text options
		global sizeCtrl = bezier_float ()
		global leadingCtrl = bezier_float ()
		global kerningCtrl = bezier_float ()
		
	-- initialise text formatting variables
		global tempShapeSteps = textOptions.shapeSteps.value
		global tempFont = textOptions.fontListBox.selected
		global progressTotal = 0
		global progressCurrent = 0
	
	-- initialise others
		global d = 1

--------------------------------------------------------------------------------------------------------------------------------
--
-- Start main interface
--
--------------------------------------------------------------------------------------------------------------------------------
-- Define info, data & text options rollouts
--------------------------------------------------------------------------------------------------------------------------------

rollout info "Info & Instructions" width:176 height:672
(
		label info "A utility to quickly set-up still renders of multiple text objects.
		\rJust copy and paste your text to the list-box like so...
		\r    George Clooney\r    John Travolta\r    Anna Kournikova
		\r...then click \"Build Names\" and move the timeslider to see the results.
		\rApply whatever modifiers you want to the entire selection (this can be very slow), and render!
		\r* Font Names List-Box: Occasionally, the Font Name List-Box might not display all available fonts. If you experience problems, use the Type-In box instead by copying and pasting a font name from an existing text object.
		" pos:[8,8] width:156 height:340
)

rollout data "Data" width:160 height:512
(
	edittext edt1 "" pos:[4,8] width:160 height:204 text:"One
Two
Three
Four
Five
etc..."

)


rollout textPlacement "Text Placement" width:176 height:493
(

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpPositioning "Positioning" pos:[8,8] width:156 height:56
		checkbox twoLines "Split text to two lines" pos:[16,24] width:128 height:16 checked:true
		checkbox centre "Centre text vertically" pos:[16,40] width:128 height:16 checked:false


	GroupBox grpScaling "Scaling" pos:[8,72] width:156 height:112
		radiobuttons scaleMethod "" pos:[16,88] width:94 height:48 labels:#("None", "All same width", "All same height") default:1
		radioButtons scaleType "" pos:[16,144] width:116 height:32 labels:#("XForm modifier", "Scale transform")

	GroupBox grpDuration "Duration" pos:[8,192] width:156 height:44
		spinner frames "Show each for "  pos:[45,210] width:83 height:16 range:[1,1000,1] type:#integer 
		label frmLbl "frame" pos:[131,210] width:31 height:16
		


	--------------------------------------------------------------------------------------------------------------------------------
	-- handlers
	--------------------------------------------------------------------------------------------------------------------------------

	on frames changed val do
		(
		if frames.value == 1 then frmLbl.text = "frame"
		else frmLbl.text = "frames"
		)
)

rollout textOptions "Text Options" width:352 height:456
(
--------------------------------------------------------------------------------------------------------------------------------
-- Initialise fontList
--------------------------------------------------------------------------------------------------------------------------------

-- This is the script which gets the font names
	--local scriptFile = getDir #scripts + "\listFonts\getFontNames-v0_3.ms"
	include "D:\Design\1 - 3D\3dsmax4\scripts\listFonts\getFontNames-v0_3.ms"

	local getFontNamesList

	on textOptions open do
		(
		global fontNamesList = getFontNamesList()
		fontListBox.items=fontNamesList
		)

	fn getFontNamesList forceUpd:false =
		(
		if forceUpd or (fontNamesList == undefined) then return getFontNames()
		else return fontNamesList
		)

	



	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	GroupBox grpTypographic "Typographic" pos:[8,8] width:156 height:184

	radiobuttons pickFont "Pick font using:" pos:[16,24] width:148 height:30 labels:#("Type-In","List-Box") columns:2 default:2

	edittext fontTypeIn "" pos:[12,64] width:132 height:21
	button fontTypeInUpdt ">" pos:[144,64] width:14 height:21 toolTip:"Update font"
	dropdownList fontListBox "" pos:[16,88] width:144 height:21 items:fontNamesList selection:1

	spinner size "Size" pos:[86,119] width:71 height:16 range:[0,1000,100] controller: sizeCtrl  
	spinner leading "Leading" pos:[73,143] width:84 height:16 range:[-1000,1000,0] controller: leadingCtrl 
	spinner kerning "Kerning" pos:[73,167] width:84 height:16 range:[-1000,1000,0] controller: kerningCtrl  

	GroupBox grpRendering "Rendering" pos:[8,200] width:156 height:40
	spinner shapeSteps "Shape steps" pos:[72,216] width:84 height:16 range:[0,10,1] type:#integer


	GroupBox vptUpdate "Font / Shape update" pos:[8,248] width:156 height:70
	button updateBtn "Update Now" pos:[16,266] width:66 height:16 enabled:false toolTip:"Update font and shape steps now"
	checkbutton interactiveBtn "Interactive" pos:[88,266] width:66 height:16 highlightColor:(color 0 255 0) toolTip:"Interactive viewport update from spinners" checked:true
	progressBar pb1 "ProgressBar" pos:[16,290] width:142 height:16
		


	--set up spinners & scene on open


	--------------------------------------------------------------------------------------------------------------------------------
	-- variables
	--------------------------------------------------------------------------------------------------------------------------------

	local font

	--------------------------------------------------------------------------------------------------------------------------------
	-- Font & Shape functions
	--------------------------------------------------------------------------------------------------------------------------------


	fn updatePB i progressTotal =
		(
		progressCurrent += 1
		pb1.value = 100.0 * progressCurrent / progressTotal
		-- reset when progress bar is full
			if pb1.value == 100 then
				(
				pb1.value = 0
				progressTotal = 0
				progressCurrent = 0
				)
		)


	fn pickFontUpdt =
		(
		case pickFont.state of
			(
			1:	(
				fontTypeIn.enabled=true
				fontTypeInUpdt.enabled=true
				fontListBox.enabled=false
				)
			2:	(
				fontTypeIn.enabled=false
				fontTypeInUpdt.enabled=false
				fontListBox.enabled=true
				)
			)
			size.value = 100
		)

	fn updateFont =
		(
		if pickFont.state==1 then font=fontTypeIn.text
			else font=fontListBox.selected

		if objectList.count != 0 then
			(
			for i = 1 to objectList.count do
				(
				obj = execute ("$'" + objectList[i] + "'")
				obj.font = font
				updatePB i progressTotal
				)
			tempFont = font
			)
		)


	fn updateShapeSteps =
		(
		if objectList.count != 0 then
			(
			for i = 1 to objectList.count do
				(
				obj = execute ("$'" + objectList[i] + "'")
				obj.steps = shapeSteps.value
				updatePB i progressTotal
				)
			tempShapeSteps = textOptions.shapeSteps.value
			)
		)
		
	fn updateAll =
		(
		progressTotal = 0
		
		-- Check if font needs updating (only if dropdown has changed from last time)
			if 	(
				(pickFont.state==1 AND textOptions.fontTypeIn.text != tempFont)or(pickFont.state==2 AND textOptions.fontListBox.selected != tempFont)
				)
				then
					(
					progressTotal = progressTotal + objectList.count
					updateFontState = 1
					print "Updating Font"
					)
		
		-- Check if Shape Steps needs updating (only if spinner has changed from last time)
			if textOptions.shapeSteps.value != tempShapeSteps then
				(
				progressTotal = progressTotal + objectList.count
				updateShapeStepsState = 1
				print "Updating Steps"
				)
		
		-- call appropriate functions
		
			print ("progressTotal is " + progressTotal as String)
			if updateFontState == 1 then updateFont()
			if updateShapeStepsState == 1 then updateShapeSteps()
		
		)

	--------------------------------------------------------------------------------------------------------------------------------
	-- Font & shape step handlers
	--------------------------------------------------------------------------------------------------------------------------------


	on textOptions open do
		(
		pickFontUpdt()
		sizeCtrl.value = 100
		--for obj in geometry do delete obj
		--for obj in shapes do delete obj
		)

	on pickFont changed state do pickFontUpdt()

	on fontTypeIn changed text do
		(
	-- check for carriage returns
		end = findstring text "\r"
		if end != undefined then
			(
			fontTypeIn.text = substring text 1 (end-1)
			updateFont()
			)
		)

	
	on fontTypeInUpdt pressed do updateFont()
	
	on fontListBox selected sel do updateFont()

	on shapeSteps changed val do
		(
		if textOptions.interactiveBtn.checked then
			(
			progressTotal = objectList.count
			updateShapeSteps()
			)
		)

	on updateBtn pressed do updateAll()

	on interactiveBtn changed state do
		(
		if textOptions.updateBtn.enabled == false then textOptions.updateBtn.enabled = true
		else textOptions.updateBtn.enabled = false
		)


)


--------------------------------------------------------------------------------------------------------------------------------
-- Define creation rollout
--------------------------------------------------------------------------------------------------------------------------------

rollout textObjects "Text Objects" width:160 height:56
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button createBtn "Create New" pos:[8,8] width:156 height:32 toolTip:"Build all the objects"
	button delLastBtn "Delete Last" pos:[8,48] width:156 height:16 toolTip:"Delete last created objects"
	button delAllBtn "Delete All" pos:[8,72] width:156 height:16 toolTip:"Delete all shapes / geometry" -- enabled:false


	--------------------------------------------------------------------------------------------------------------------------------
	-- Creation handlers
	--------------------------------------------------------------------------------------------------------------------------------
	on createBtn pressed do
		(
				-- deleteTextObj()
			-- set other globals
				spacing = 1000
				objectList = #()
				global d = textPlacement.frames.value

			-- updates font info
				textOptions.updateFont()


			-- Build names list
				names = data.edt1.text
				names = filterString names "\r\"\n"
				print names
	
	
			--sets the animation range
				if names.count == 0 then
					(
					print "No Data!"
					)
				else
					(
					animationRange = interval 0 ((names.count * d) + 1)
					)
	
	
			-- creates the objects & positions them
				for i = 1 to names.count do (
					

					-- build text
						obj = text size:textOptions.size.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
						obj.alignment = 2


					-- format text
						obj.font = textOptions.font as String
						obj.steps = textOptions.shapeSteps.value

						obj.size.controller = sizeCtrl
						obj.leading.controller = leadingCtrl
						obj.kerning.controller = kerningCtrl


					-- name new item
						if i < 10 then (obj.name = "Text0" + i as String + " : " + names[i])
						else (obj.name = "Text" + i as String + " : " + names[i])
					

					--put item name in array for deleting
						append objectList obj.name



					-- colour new item
						objClr = [0,0,0] as Color
						objClr.b = ((i as Float / names.count) * 255)
						obj.wirecolor = objClr



					-- put in carriage returns if requested
						if textPlacement.twoLines.checked then
							(
							displayText = names[i]
							spaceIndex = findString displayText " " -- find any spaces
							if spaceIndex != undefined then
								(
								obj.text = replace displayText spaceIndex 1 "\r"
								)
							else
								(
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
						
						fn scaleText obj targetScale =
						(
							case textPlacement.scaleType.state of
							(
							1:	(
								addModifier obj (XForm()) ui:on
								obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
								modPanel.setCurrentObject obj.modifiers[#XForm]
								subobjectLevel = 0
								)
							2: 	(
								obj.scale = [targetScale ,targetScale ,targetScale ]
								)	
							)
						)
						
						case textPlacement.scaleMethod.state of
							(
							1:
								(
								-- do nothing
								)
							2:
							 	(
								span = obj.max.x - obj.min.x
								targetScale = targetHeight / span
								scaleText obj targetScale
								)
								
							3:
							 	(
								span = obj.max.z - obj.min.z
								targetScale = targetHeight / span
								scaleText obj targetScale
								)
							) 
		

					-- set up objects to move
						obj.pos.controller = Position_XYZ ()

						c = bezier_float ()
						obj.pos.controller.Z_Position.controller = c

						key1 = addNewKey c ( ((d*(i-1))) as Time )
						key2 = addNewKey c ( ((d*(i-1)) + 1) as Time )
						key3 = addNewKey c ( ((d*(i-1)) +d) as Time )
						key4 = addNewKey c ( ((d*(i-1)) +d +1) as Time )
						

					-- convert all the keys to type: #step / #linear
						key1.inTangentType = #linear
						key1.outTangentType = #linear
						key2.inTangentType = #linear
						key2.outTangentType = #linear
						key3.inTangentType = #linear
						key3.outTangentType = #linear
						key4.inTangentType = #linear
						key4.outTangentType = #linear
						
					
					-- Centre the object if requested
						if textPlacement.centre.checked then (
							obj.pivot.z = (obj.max.z - obj.min.z) / 2 + obj.min.z
						)

						key1.value = spacing
						key2.value = 0
						key3.value = 0
						key4.value = -spacing
	
					-- Update progress bar
						textOptions.updatePB i names.count


				)
				sliderTime = 1
				print "Printing Object List..."
				print objectList
	)


	fn deleteTextObj =
		(
		for i = 1 to objectList.count do
			(
				obj = execute ("$'" + objectList[i] + "'")
				if obj != undefined then delete obj

			-- Update progress bar
				textOptions.updatePB i objectList.count
			)
			objectList = #()
		)

	on delLastBtn pressed do
		(
		deleteTextObj()
		)


	fn deleteAllTextObj =
		(
		for obj in objects do
			if (substring obj.name 1 4) == "Text" do
				delete obj
		)

	on delAllBtn pressed do deleteAllTextObj()


)



--------------------------------------------------------------------------------------------------------------------------------
-- Define tools & credits rollouts
--------------------------------------------------------------------------------------------------------------------------------


rollout tools "Tools" width:160 height:512
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button camBtn "Create Camera" pos:[8,8] width:74 height:16 toolTip:"Place a camera in the scene"
	button listBtn "List Objects" pos:[90,8] width:74 height:16 toolTip:"Print a list of all the objects to the Listener"

	--------------------------------------------------------------------------------------------------------------------------------
	-- Tools handlers
	--------------------------------------------------------------------------------------------------------------------------------

	on camBtn pressed do
		(
		if $Camera_SimpleCredits == undefined then
			(
			camSC = Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,-700,0])
			camSC.name = "Camera SimpleCredits"
			camSC.ignoreExtents = on
			)
		else
			(
			print "Camera already exists"
			)
			max vpt camera
		)


	on listBtn pressed do
		(
		for i = 1 to objectList.count do (print objectList[i])
		)
		
)



rollout credits "Dave Stewart" width:160 height:120
(
	--GroupBox grpBorder "" pos:[8,4] width:156 height:56
	label lbl1 "Design and Animation for Broadcast, Interactive and Digital Media.\r\rCustom 3dsmax scripts, Flash HTML and JavaScript." pos:[14,4] width:144 height:80
	button webBtn "www.davestewart.co.uk" width:156 height:16

	on webBtn pressed do
	(
	ShellLaunch "iexplore.exe" "http://www.davestewart.co.uk"
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
	addrollout data SCrof
	addrollout textPlacement SCrof
	addrollout textOptions SCrof
	addrollout textObjects SCrof
	addrollout tools SCrof
	addrollout credits SCrof
	
-- position & setup the floater
	SCrof.size=[200,843]
	SCrof.pos=[43,92]
	info.open=false
	tools.open=false
	credits.open=false



