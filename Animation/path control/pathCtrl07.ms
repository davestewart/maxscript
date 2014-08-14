plugin modifier pathCtrl
name:"PathCtrl" 
classID:#(0x90478bea, 0x8a1a88fe)
(
	
	local distCtrl=bezier_float()
	local pcCtrl=float_script()
	local updatePathPercent
	
	parameters main rollout:params 
	( 
		splObj type:#node animatable:false
		length type:#float animatable:true

		distance type:#float animatable:true ui:spnDist
		pathPercent type:#float animatable:true ui:spnPC
		
		on length set val do pathPercent = distance/length
		on distance set val do pathPercent = distance/length


	) 
	rollout params "Parameters" width:162 height:133
	(

	-- interface
	------------------------------------------------------------

		pickButton pkbSpline "Pick Spline..." pos:[8,8] width:144 height:16
		label lbl1 "Spline Length: " pos:[8,32] width:144 height:16

		spinner spnDist "Distance: " pos:[40,48] width:112 height:16 range:[-9999,9999,10] controller:distCtrl
		spinner spnPC "Percent: " pos:[45,68] width:107 height:16 enabled:false range:[-999,999,0] controller:pcCtrl

		button btn1 "Me" width:120 height:16 


	-- functions
	------------------------------------------------------------
		global getSplineLength 


		fn updatePathPercent=
		(
			pathPercent = this.distance/this.length
		)
		
		fn getSplineLength obj=
		(
			local len = getSegLengths obj 1
			len = len[len.count]
			return len
		)

		fn getPercent =
		(
			return distance/length
		)

		fn updateInterface =
		(
			try(
				pkbSpline.text=this.splObj.name
				params.lbl1.text="Length: " + this.length as string
			)
			catch()
		)

		global splineUpdate
		fn splineUpdate pluginInstance=
		(
			pluginInstance.length=getSplineLength pluginInstance.splObj
		)


	-- handlers
	------------------------------------------------------------

		on pkbSpline picked obj do
		(
			splObj = obj
			length=getSplineLength obj
			updateInterface()
			
			try(
				format "%\n" "Setting Up Change Handler"
				when geometry this.splObj changes do splineUpdate pathCtrl
			)
			catch(
				format "%\n" "Change Handler ERROR"
			)

			paramWire.connect $.modifiers[#PathCtrl][#pathPercent] $.pos.controller.Path_Constraint.controller[#Percent] "pathPercent"

		)

		on btn1 pressed do global plug = this

		on params open do updateInterface()
	
	)

	on create do
	(
		--pathPercent.script="hello\n0"
		print ("> " +this as string)
		global pathCtrl = this
	)

) 

