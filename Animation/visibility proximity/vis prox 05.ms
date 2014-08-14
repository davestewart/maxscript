rollout roProx "Visibility Painter" width:192 height:224
(
	---------------------------------------------------------------------------
	-- interface
	
	GroupBox grp1 "1 - Proximity" pos:[8,8] width:176 height:64
	pickbutton pckObj "Proximity Node" pos:[16,24] width:160 height:16 message:"hello" toolTip:"This is the node that will affect the other objects' visibility"
	spinner spnDist "Distance" pos:[84,48] width:92 height:16 range:[0,1000,100] type:#integer
		
	GroupBox grp2 "2 - Assign Visibility Controllers" pos:[8,80] width:176 height:40
	button btnAssign "Assign (Script controllers)" pos:[16,96] width:160 height:16 toolTip:"Assign scripted controllers to select objects that will have their visibility animated according to the Proximity Node"
		
	GroupBox grp3 "3 - Convert Visibility Controllers" pos:[8,128] width:176 height:64
	button btnConvert "Convert (to bezier-float)" pos:[16,144] width:160 height:16 toolTip:"Convert scripted controllers to bezier (quicker, more reliable, and visibility is held)"
	spinner spnFade "Fade time (frames)" pos:[64,168] width:112 height:16 range:[1,100,1] type:#integer
	
	button btnHelp "Help" pos:[8,200] width:176 height:16

	---------------------------------------------------------------------------
	-- functions
	
		local prox
	
		fn assign=
			(
			local distMin=spnDistMin.value
			local distMax=spnDistMax.value
			local ctrl
			for obj in $ do 
				(
				-- string
					local str=""
					str+="obj1=$"+prox.name+"\n"
					str+="obj2=$'"+obj.name as string +"'\n"
					str+="distMin="+(distMin as float) as string+"\n"
					str+="distMax="+(distMax as float) as string+"\n"
					str+="dist=distance obj1.pos obj2.pos\n"
					str+="if dist < distMin then (distMin-dist)/distMin else 0"
				-- controller
					obj.visibility=true
					obj.visibility.controller=float_script()
					ctrl=obj.visibility.controller
					ctrl.script=str
				)
			)
	
		fn convert=
			(
			for obj in $ do
				(
				-- get controller
					local ctrl = obj.visibility.controller
			
				-- base variable
					local keyTime = 0
			
				-- loop through time and get existing values from script controller
					for t = animationRange.start to animationRange.end do
						(
						at time t if ctrl.value == 1 then
							(
							if keytime == 0 then keyTime = t
							exit
							)
						)
			
				-- assign new controller, keys and values
					ctrl=obj.visibility.controller=bezier_float()
					if keyTime > 0 then
						(
						addnewkey ctrl keyTime
						addnewkey ctrl (keyTime+spnFade.value)
						ctrl.keys[1].value=0
						ctrl.keys[2].value=1
						)
				)
			)	
	
	---------------------------------------------------------------------------
	-- handlers
	

		

	on pckObj picked object do
		(
		prox = object
		pckObj.text = object.name
		)
	on btnAssign pressed do
		(
		if isvalidnode prox then 
			(
			assign()
			try
				(
				)
			catch
				(
				Messagebox "Failed to assign script controllers..."
				)
			)
		else
			(
			messagebox "Invalid Proximity Node. Pick again."
			)
		)

	on btnConvert pressed do
		(
		try
			(
			convert()
			)
		catch
			(
			Messagebox "Failed to convert script controllers..."
			)
		)
	on btnHelp pressed do
		(
		local str
		str=	"Visibility Painter"
		str+=	"--------------------------------------------\n"
		str+=	"This script does several things. "
		messagebox str
		)
)
-- create
	destroydialog roProx
	createdialog roProx 192 222
	