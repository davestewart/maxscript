--------------------------------------------------------------------------------------------------------------------------------
-- Simple Credits v.1.0
-- 9th August 2001
--
-- Designed for producing a sequence of text objects
-- which can then have modifiers applied to them
-- and be rendered off as separate images
--
-- Design & coding by Dave Stewart, inspiration by Rosa Pilsworth
--
-- http://www.davestewart.co.uk
--
-- animation, design, interaction
-- 3dsmax, Flash, HTML, After Effects
-- you name it, I've probably done it
--
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- Get Font Names script, by Swarmi Llama
--------------------------------------------------------------------------------------------------------------------------------

fn sortCaseInsensitive theArray asc:true =
(
	try
	(
		theArray=for arg in theArray collect (arg as name)
		sort theArray
		
		if NOT asc then
		(
			local theArrayTMP=copy theArray #noMap
			local revIdx=theArray.count
			for i = 1 to theArray.count do
			(
				theArray[revIdx]=theArrayTMP[i] as string
				revIdx-=1
			)
			theArray
		)
		else
		(		
			theArray=for arg in theArray collect (arg as string)
		)
	)
	catch(theArray=undefined)
)


fn ToUpper str = (
	try (
		str = copy str
		local lowerLetters = #("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
		local upperLetters = #("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
		for i = 1 to str.count do (
			str[i] = try ( upperLetters[(findItem lowerLetters str[i])] ) catch ( str[i] )
		)
		str
	) catch ( undefined )
)



fn getFontsFilenameArr fDir:(sysInfo.windowsDir+"\\Fonts\\") =
(
	setWaitCursor()
	
	sysFontsArr =#()
	sysFontsArr =getFiles (fDir+"*.ttf")
	sysFontsArr =sortCaseInsensitive sysFontsArr
	
	setArrowCursor()
	
	sysFontsArr
)


fn getFontName
		fDir:(sysInfo.windowsDir+"\\Fonts\\")
		ttf:"allegron"
		fFilename:undefined
		numLines:1000
		dbug:false
=
(
	setWaitCursor()
	
	ff	=if fFilename!=undefined then fFilename else (fDir+ttf+".ttf")
	
	df	=fOpen ff "rb"
	
	if dbug then format "START read...\n"
	if dbug then format "Filename: %\n" ff

	-- Search for END of font name.
	-- Note: There is no 'eof' for a binary, so 'numLines' is used as a hack, and seems to work since the tested ttf's
	-- are less that 1000 lines, and the font common name appears before the 1000th line.  Hack, ack, hack!  Oh well.
	searchStr		="mfgpctt"	-- This identifies the END of the font common name for SOME of the fonts
								-- (about 1/3 on my system when I tested it).
	fontNameLine	=""
	fontNameFound	=false
	for i=1 to numLines do
	(
		try
		(
			rs=readString df
			if dbug then format "%: %\n" i rs
			if rs!=undefined then
			(
				if findString rs searchStr !=undefined then
				(
					-- We are here if the search string was found indicating the location of the font common name.
					-- Get the line containing the font common name.
					fontNameLine=rs
					fontNameFound=true
					exit
				)
			)
		)
		catch(fontNameFound=false)
	)
	if dbug then format "END read.\n"
	
	fClose df
	
	-- Parse out the font common name!...
	if fontNameFound then
	(
		-- We are here if the search string was found indicating the location of the font common name.
		if dbug then format "fontNameLine=%\n" fontNameLine
		ssNum		=findString fontNameLine searchStr
		ss			=""
		fontNameRev	=""
		cnt=0
		
		-- Determine the start and length of the substring which is the font common name.
		while
		(
			cnt		+=1
			ssNum	-=1
			ss		 =subString fontNameLine ssNum 1
--			(ss as integer)==undefined OR ss==" "
			((toUpper ss) as integer)==undefined OR ss==" "	-- 'toUpper()' used as workaround,
															-- e.g "m" as integer returns '0',
															--     but "M" as integer returns 'undefined' !(?)
															-- Also, this test leads to incorrect results if a
															-- number is part of the font commong name :(,
															-- not sure how to avoid this(?)
--			ssAsInt=(toUpper ss) as integer; ssAsInt==undefined OR ssAsInt==0 or ss==" "
		)
		do
		(
			-- Nothing.
		)
		
		fontName=subString fontNameLine (ssNum+1) (cnt-1)	-- This is the "Money Maker"!
	)
	else fontName=undefined
	
	setArrowCursor()
	
	struct fontStruct (fName,cName)		-- fName=>filename; cName=>proper name.
	fontStruct fName:ff cName:fontName	-- Return a structure containing the filename AND the common name.
)
--------------------------
--------------------------

-- USAGE:

example=1	-- Set =0 to not run any example.
case example of
(
	1:
	(
		-- Get ALL the font filenames and common names.
		global gffAllArr, fontArr
		local gfn
		
		gffAllArr=getFontsFilenameArr()
		global fontAllArr=for f in gffAllArr where
			(
				gfn=getfontName fFilename:f
--				gfn.cName!=undefined
				true
			)
		collect gfn
		
		-- Write ALL the font filenames and common names to the Listener.
		format "\nfontAllArr (cnt=%)\n" fontAllArr.count
		for f in fontAllArr do format "%\n" f
		
		-- Filter out "failed" items.
		fontArr=for f in fontAllArr where (f.cName!=undefined) collect f
		
		-- Write the filtered font filenames and common names to the Listener.
		format "\nfontArr (cnt=%)\n" fontArr.count
		for f in fontArr do format "%\n" f
	)
)


--------------------------------------------------------------------------------------------------------------------------------
-- This bit tagged onto original Swarmi script ... by dave stewart
-- Just puts the Font Names into an array for the dropdown list
--------------------------------------------------------------------------------------------------------------------------------



fontList = #()

for i = 1 to fontArr.count do (

	item = fontArr[i].cName

	-- this bit highlights bad matches
	-- at least on my machine, this text is just the style
	-- NOT the font family... any ideas ?

		if substring item 1 1 == " " then item = "*" + item
		append fontList item
)



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
		\r* Note: At the moment, the only way to specify a font is to type the font name manually. The best method is to copy and paste the font name from an existing text object.
		" pos:[8,8] width:156 height:320
)

rollout data "Data" width:160 height:512
(
	edittext edt1 "" pos:[4,8] width:160 height:204

	-- set globals
		global objectList = #()


)


rollout textOptions "Text Options" width:176 height:493
(
	GroupBox grpPositioning "Positioning" pos:[8,8] width:156 height:56
		checkbox twoLines "Split text to two lines" pos:[16,24] width:128 height:16 checked:true
		checkbox centre "Centre text vertically" pos:[16,40] width:128 height:16 checked:false


	GroupBox grpScaling "Scaling" pos:[8,72] width:156 height:112
		radiobuttons scaleMethod "" pos:[16,88] width:94 height:48 labels:#("None", "All same width", "All same height") default:1
		radioButtons scaleType "" pos:[16,144] width:116 height:32 labels:#("XForm modifier", "Scale transform")


	--set up instanced controllers for text options
		global sizeCtrl = bezier_float ()
		global leadingCtrl = bezier_float ()
		global kerningCtrl = bezier_float ()

	GroupBox grpTypographic "Typographic" pos:[8,192] width:156 height:136
		dropdownList font "Font" pos:[16,208] width:146 height:40 items:fontList
		spinner size "Size" pos:[88,256] width:71 height:16 range:[0,1000,100] controller:sizeCtrl
		spinner leading "Leading" pos:[75,280] width:84 height:16 range:[-1000,1000,0] controller:leadingCtrl
		spinner kerning "Kerning" pos:[75,304] width:84 height:16 range:[-1000,1000,0] controller:kerningCtrl


	GroupBox grpRendering "Rendering" pos:[8,336] width:156 height:40
		spinner shapeSteps "Shape steps" pos:[75,352] width:84 height:16 range:[0,10,3] type:#integer


	GroupBox vptUpdate "Font / Shape update" pos:[8,382] width:156 height:42
		Button updateBtn "Update Now" pos:[16,400] width:66 height:16 toolTip:"Update font and shape steps now"
		checkButton interactiveBtn "Interactive" pos:[92,400] width:66 height:16 highlightColor:Green checked:true toolTip:"Interactive viewport update from spinners"
	


	--set up spinners on open
		on textOptions open do
			(
			sizeCtrl.value = 100
			)

	--------------------------------------------------------------------------------------------------------------------------------
	-- Font & Shape functions
	--------------------------------------------------------------------------------------------------------------------------------

	fn updateShapeSteps =
		(
		if objectList.count != 0 then
			(
			for i = 1 to objectList.count do
				(
				obj = execute ("$'" + objectList[i] + "'")
				if obj != undefined then obj.steps = shapeSteps.value
				)
			)
		tempShapeSteps = textOptions.shapeSteps.value
		)	


	fn updateFont =
		(
		if objectList.count != 0 then
			(
			for i = 1 to objectList.count do
				(
				obj = execute ("$'" + objectList[i] + "'")
				if obj != undefined then obj.font = font.selected
				)
			)
		tempFont = textOptions.font.text
		)

	--------------------------------------------------------------------------------------------------------------------------------
	-- Font & shape step handlers
	--------------------------------------------------------------------------------------------------------------------------------

	global tempShapeSteps = textOptions.shapeSteps.value
	global tempFont = textOptions.font.text

	on shapeSteps changed val do
		(
		if interactiveBtn.checked then updateShapeSteps()
		)


	on font selected true do
		(
		if interactiveBtn.checked then updateFont()
		)

	on updateBtn pressed do
		(
		-- Shape Steps
			-- only call function if spinner has changed from last time
			if textOptions.shapeSteps.value != tempShapeSteps then updateShapeSteps()

		-- Font
			-- only call function if dropdown has changed from last time
			if textOptions.font.text != tempFont then updateFont()
		)

)




--------------------------------------------------------------------------------------------------------------------------------
-- Define creation rollout
--------------------------------------------------------------------------------------------------------------------------------

rollout names "Names" width:160 height:56
(

	button namBtn "Create" pos:[8,8] width:156 height:16 toolTip:"Build all the objects"
	button delBtn "Delete" pos:[8,32] width:156 height:16 toolTip:"Delete all the objects"


	--------------------------------------------------------------------------------------------------------------------------------
	-- Creation handlers
	--------------------------------------------------------------------------------------------------------------------------------
	on namBtn pressed do
		(
			-- set other globals
				spacing = 1000
				objectList = #()

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
					animationRange = interval 0 (names.count + 1)
					)
	
	
			-- creates the objects & positions them
				for i = 1 to names.count do (
					

					-- build text
						obj = text size:textOptions.size.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
						obj.alignment = 2


					-- format text
						obj.font = textOptions.font.text as String
						obj.steps = textOptions.shapeSteps.value

						obj.size.controller = sizeCtrl
						obj.leading.controller = leadingCtrl
						obj.kerning.controller = kerningCtrl


					-- name new item
						if i < 10 then (obj.name = "Name 0" + i as String + " : " + names[i])
						else (obj.name = "Name " + i as String + " : " + names[i])
					

					--put item name in array for deleting
						append objectList obj.name



					-- colour new item
						objClr = [0,0,0] as Color
						objClr.b = ((i as Float / names.count) * 255)
						obj.wirecolor = objClr



					-- put in carriage returns
						if textOptions.twoLines.checked then
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
							case textOptions.scaleType.state of
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
						
						case textOptions.scaleMethod.state of
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
				print "Printing Object List..."
				print objectList
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
-- Define tools & credits rollouts
--------------------------------------------------------------------------------------------------------------------------------


rollout tools "Tools" width:160 height:512
(
	button camBtn "Create Camera" pos:[8,8] width:74 height:16 toolTip:"Place a camera in the scene"
	button listBtn "List Objects" pos:[90,8] width:74 height:16 toolTip:"Print a list of all the objects to the Listener"

	--------------------------------------------------------------------------------------------------------------------------------
	-- Tools handlers
	--------------------------------------------------------------------------------------------------------------------------------

	on camBtn pressed do
		(
		if $Camera_SimpleCredits == undefined then
			Freecamera fov:45 targetDistance:160 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,-700,0]) name:"Camera SimpleCredits"
			else print "Camera already exists"
			max vpt camera
		)


	on listBtn pressed do
		(
		for i = 1 to objectList.count do (print objectList[i])
		)
		
)

rollout credits "Credits" width:160 height:40
(
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
	addrollout textOptions SCrof
	addrollout names SCrof
	addrollout tools SCrof
	addrollout credits SCrof
	
-- position & setup the floater
	SCrof.size=[200,843]
	SCrof.pos=[43,92]
	info.open=false
	tools.open=false
	credits.open=false