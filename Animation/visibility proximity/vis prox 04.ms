rollout roProx "Visibility by Proximity" width:192 height:176
(
	---------------------------------------------------------------------------
	-- interface
	
		GroupBox grp1 "1 - Proximity" pos:[8,8] width:176 height:64
		pickbutton pckObj "Proximity Node" pos:[16,24] width:160 height:16 message:"hello" toolTip:"This is the node that will affect the other objects' visibility"
		spinner spnDist "Distance" pos:[44,48] width:132 height:16 range:[0,1000,100] type:#integer
		
		GroupBox grp2 "2 - Assign Visibility Controllers" pos:[8,80] width:176 height:40
		button btnAssign "Assign (Script controllers)" pos:[16,96] width:160 height:16 toolTip:"Assign scripted controllers to select objects that will have their visibility animated according to the Proximity Node"
		
		GroupBox grp3 "3 - Convert Visibility Controllers" pos:[8,128] width:176 height:64
		button btnConvert "Convert (to bezier-float)" pos:[16,144] width:160 height:16 toolTip:"Convert scripted controllers to bezier"
		spinner spnFade "Fade in over (n) frames" pos:[24,168] width:152 height:16 type:#integer range:[1,100,1]
	


	---------------------------------------------------------------------------
	-- functions
	
		fn assign=
		(
			local dist=spnDist.value
			local prox=pckObj.name
			local ctrl
			for obj in $ do 
			(
				-- string
					local str=""
					str+="obj1=$"+prox.name+"\n"
					str+="obj2=$'"+obj.name as string +"'\n"
					str+="if distance obj1.pos obj2.pos < "+dist as string+" then 1 else 0"
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
			pckObj.text = object.name
		) 

		on btnAssign pressed do
		(
			try
			(
				assign()
			)
			catch err
			(
				Messagebox "Failed to assign script controllers..."
			)
		)
		
		on btnConvert pressed do
		(
			try
			(
				convert()
			)
			catch err
			(
				Messagebox "Failed to convert script controllers..."
			)
		)

)
destroydialog roProx
createdialog roProx 192 200
