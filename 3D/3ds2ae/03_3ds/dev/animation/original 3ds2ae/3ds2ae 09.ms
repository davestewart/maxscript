---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
global ro1

fn max2AESel =
(
	ro1.sel=(getcurrentselection())[1]
	ro1.handleSelection()
)

rollout ro1 "Options" width:232 height:336
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	local sel, obj, objClass
	local compHeight, compWidth
	local data
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
	local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grp3ds "3dsmax" pos:[8,8] width:216 height:40
	checkbutton btnLock "L" pos:[200,24] width:16 height:16 tooltip:"Press to lock"
	label lblObj "Pick an object, camera or light..." pos:[16,24] width:184 height:16

	GroupBox grpAE "After Effects" pos:[8,56] width:216 height:80
	dropdownList ddCompPreset "" pos:[16,80] width:140 height:21 items:#("Custom Output Size...", "Current Settings...", "PAL (720 x 576)", "PAL (1024 x 756)")
	dropdownList ddAEVersion "" pos:[156,80] width:60 height:21 items:#("6.5", "6.0", "5.5", "5.0")
	spinner spnCompWidth "Width: " pos:[32,108] width:80 height:16 range:[0,9999,400] type:#integer scale:1
	spinner spnCompHeight "Height: " pos:[136,108] width:80 height:16 range:[0,9999,400] type:#integer scale:1

	GroupBox grpExport "Properties" pos:[8,144] width:216 height:72
	checkbox chkPos "Position" pos:[16,160] width:96 height:16 checked:true
	checkbox chkRot "Rotation" pos:[16,176] width:96 height:16 checked:true
	checkbox chkScale "Scale" pos:[16,192] width:96 height:16
	checkbox chkCam "Camera properties" pos:[112,160] width:104 height:16 checked:true enabled:false
	checkbox chkLight "Light properties" pos:[112,176] width:104 height:16 checked:true enabled:false

	GroupBox grpAnimRange "Animation Range" pos:[8,224] width:216 height:72
	dropdownList ddAnimRange "" pos:[16,240] width:200 height:21 items:#("Single frame", "Current range", "Custom...")
	spinner spnAnimFrom "From: " pos:[32,268] width:80 height:16 range:[0,9999,0] type:#integer scale:1
	spinner spnAnimTo "To: " pos:[144,268] width:70 height:16 range:[0,9999,100] type:#integer scale:1

	button btnExport "Export..." pos:[8,304] width:216 height:24

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn handleSelection=
	(
		if NOT btnLock.state then
		(
			obj=sel
			if sel!=undefined then
			(
				lblObj.text=obj.name
				objClass=superclassof obj
			)
			else(
				lblObj.text="Pick an object, camera or light..."
			)
			chkLight.enabled= 	objClass==light
			chkCam.enabled=	objClass==camera
			btnExport.enabled=(obj!=undefined)
		)
	)


	fn setAnimRange=
	(
		local animRange=#()
		animRange=case ddAnimRange.selection of
		(
			1:	#(sliderTime,sliderTime)
			2:	#(animationrange.start,animationrange.end)
			3:	#(spnAnimFrom.value,spnAnimTo.value)
		)
		spnAnimFrom.value=animRange[1]
		spnAnimTo.value=animRange[2]
	)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

-- 3dsmax

	on ro1 open do 
	(
		callbacks.addScript #selectionSetChanged "max2AESel()" id:#max2aeCallback
		ddAnimRange.selection=2
		setAnimRange()
		max2AESel()
	)

	on ro1 close do callbacks.removeScripts id:#max2aeCallback

	on btnLock changed state do handleSelection()

/*
	on btnObj pressed do
	(
		obj=pickObject message:"Pick an object, light or camera..."
		btnObj.text=obj.name
		objClass=superclassof obj

		chkLight.enabled= 	objClass==light
		chkCam.enabled=	objClass==camera
	)
*/

-- After Effects

	on ddCompPreset selected item do
	(
		local xy=#()
		xy=case ddCompPreset.selection of
		(
			1:	#(spnCompWidth.value,spnCompHeight.value)
			2:	#(renderwidth,renderheight)
			3:	#(720,576)
			4:	#(1024,576)
		)
		spnCompWidth.value=xy[1]
		spnCompHeight.value=xy[2]
	)

	on spnCompWidth changed val do ddCompPreset.selection=1
	on spnCompHeight changed val do ddCompPreset.selection=1


-- Animation range

	on ddAnimRange selected sel do setAnimRange()

	on spnAnimFrom changed val do
	(
		ddAnimRange.selection=3
		if spnAnimFrom.value >= spnAnimTo.value then spnAnimTo.value = spnAnimFrom.value
	)

	on spnAnimTo changed val do
	(
		ddAnimRange.selection=3
		if spnAnimTo.value <= spnAnimFrom.value then spnAnimFrom.value = spnAnimTo.value
	)

-- Export

	on btnExport pressed do
	(
		clearListener()

		local posData=rotXData=rotYData=rotZData=scaleData=camData=lightData=data=""
-- data		

		if chkPos.checked then posData="\nPosition\n	Frame	X pixels	Y pixels	Z pixels\n"

		if chkRot.checked then
		(
			rotXData="\nRotation\n	Frame	degrees\n"
			rotYData="\nX Rotation\n	Frame	degrees\n"
			rotZData="\nY Rotation\n	Frame	degrees\n"
			rotData="\nOrientation\n	Frame	degrees\n"
		)

		if chkScale.checked then scaleData="\nScale\n	Frame	X percent	Y percent	Z percent\n"
		if chkCam.checked AND ((classof obj)==Targetcamera) then camData="\nPoint of Interest\n	Frame	X pixels	Y pixels	Z pixels\n"
		if chkLight.checked AND ((classof obj)==light) then lightData=""

		if isvalidnode obj then
		(
			for t = spnAnimFrom.value to spnAnimTo.value do
			(
				at time t
				(
					if (spnAnimTo.value-spnAnimFrom.value==0) OR ddAnimRange.selection==1 then f=""
					else f=t
					in coordsys #world
					(
					-- position
						if chkPos.checked then
						(
							px=obj.pos.x	;if abs px < 0.1 then px=0
							py=obj.pos.y	;if abs py < 0.1 then py=0
							pz=obj.pos.z	;if abs pz < 0.1 then pz=0
							posData+="	"+
								f as string+"	"+
--								(px+(spnCompWidth.value/2)) as string+"	"+
--								(py+(spnCompHeight.value/2)) as string+"	"+
								(px) as string+"	"+
								(-pz) as string+"	"+
								(py) as string+"\n"
						)

					-- rotation
						if chkRot.checked AND (classof obj)!=Targetcamera then
						(
							in coordsys #world rot=obj.rotation as eulerangles

							rx=rot.x	;if abs rx < 0.1 then rx=0
							ry=rot.y	;if abs ry < 0.1 then ry=0
							rz=rot.z	;if abs rz < 0.1 then rz=0
							--format "% % %\n" rx ry rz

							rotData+="	"+
								f		as string+"	"+
								(rx)	as string+"	"+
								(-rz)	as string+"	"+
								(ry)	as string+"\n"
						)

					-- scale
						if chkScale.checked then
						(
						)
		
					-- camera data
						if chkCam.checked AND (classof obj)==Targetcamera then
						(
							px=obj.target.pos.x
							py=obj.target.pos.y
							pz=obj.target.pos.z
							camData+="	"+f as string+"	"+(px) as string+"	"+(-pz) as string+"	"+(py) as string+"\n"
						)
		
					-- light data
				)
			)
		)


-- final data gathering
	data+=posData + rotData + scaleData + camData + lightData

format "Adobe After Effects % Keyframe Data				
				
	Units Per Second	%		
	Source Width	%		
	Source Height	%		
	Source Pixel Aspect Ratio	1		
	Comp Pixel Aspect Ratio	1		
				
%
End of Keyframe Data\n" ddAEVersion.selected framerate spnCompWidth.value spnCompHeight.value data
		)
	)
)

if AEFloater != undefined then closerolloutfloater AEFloater
	AEFloater = newRolloutFloater "After Effects Data Exporter" 244 366 250 100
addRollout ro1 AEFloater

