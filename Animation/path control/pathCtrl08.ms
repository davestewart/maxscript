plugin modifier pathCtrl
name:"PathCtrl" 
classID:#(0x90478bea, 0x8a1a88fe)
(
	local params
	local shapeFilt = fn shapeFilt obj = superClassOf obj == Shape 

	
	parameters main rollout:params 
	( 
		splObj type:#node animatable:false
		length type:#float animatable:true

		distance type:#float animatable:true ui:spnDist
		pathPercent type:#float animatable:true ui:spnPC
		
		on length set val do pathPercent = distance/length

		on distance set val do
		(
			pathPercent = distance/length
			params.pb1.value= (distance/length)*100
			params.updateInterface()
		)


	) 
	rollout params "Parameters" width:160 height:200
(

		local distCtrl=bezier_float()
		local pcCtrl=float_script()
		local updatePathPercent

	-- interface
	------------------------------------------------------------

		groupBox grp1 "Setup" pos:[4,4] width:158 height:84
			pickbutton pkbSpline "Pick Spline..." pos:[8,24] width:150 height:16 filter:shapeFilt
			checkbox chk1 "Assign controller" pos:[12,48] width:144 height:16 checked:true
			checkbox chk2 "Show vertex ticks" pos:[12,64] width:144 height:16 checked:true

		groupBox grp2 "Path" pos:[4,96] width:158 height:88
			spinner spnDist "Distance: " pos:[40,120] width:112 height:16 range:[-9999,9999,10]  controller:distCtrl
			spinner spnPC "Percent: " pos:[45,136] width:107 height:16 enabled:false range:[-999,999,0] controller:pcCtrl
			progressBar pb1 "ProgressBar" pos:[8,168] width:144 height:8 value:50 orient:#horizontal

	-- functions
	------------------------------------------------------------
		global getSplineLength
			fn getSplineLength obj=
			(
				local len = getSegLengths obj 1
				len = len[len.count]
				return len
			)

		global splineUpdate
			fn splineUpdate pluginInstance=
			(
				pluginInstance.length=getSplineLength pluginInstance.splObj
			)

		fn updatePathPercent=
		(
			pathPercent = this.distance/this.length
		)
		
		fn getPercent =
		(
			return distance/length
		)

		fn updateInterface =
		(
			try(
				pkbSpline.text=this.splObj.name
				params.grp2.text="Path (length: " + length as string + ")"
			)
			catch(
				format"%\n" "Couldn't update interface..."
			)
		)


		fn vertexTicks obj=
		(
			if chk2.checked then obj.vertexTicks = on
			else obj.vertexTicks = off
		)

	-- handlers
	------------------------------------------------------------


		on params open do updateInterface()

		on pkbSpline picked obj do
		(

			-- spline stuff
				convertToSplineShape obj
				vertexTicks obj
	
			-- controller stuff
				if chk1.checked then
				(
					execute ("$.pos.controller=path follow:true path:$" +obj.name as string+" axis:2 constantVel:true")
					$.pos.controller=position_list()
				)
	
			-- spline info
				this.splObj = obj
				this.length=getSplineLength splObj
				updateInterface()
	
			-- change handlers			
				try(
					format "%\n" "Setting Up Change Handler"
					when geometry this.splObj changes do splineUpdate pathCtrl
				)
				catch(
					format "%\n" "Change Handler ERROR"
				)

			-- wire parameters
				paramWire.connect $.modifiers[#PathCtrl][#pathPercent] $.pos.controller.Path_Constraint.controller[#Percent] "pathPercent"
		)

		on btn1 pressed do global plug = this
		
		on chk2 changed state do vertexTicks()
)
	on create do
	(
		global pathCtrl = undefined
		global pathCtrl=this
		print ("> " +pathCtrl as string)
	)

) 

