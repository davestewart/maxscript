plugin modifier pathControl21
name:"Path Control 21" 
classID:#(0x399e7392, 0x6fae933c)
	( 
	local distCtrl = bezier_float()
	local pcCtrl = bezier_float()
	local lenCtrl = bezier_float()
	local pc, pcStr
	local segArr, len

	parameters main rollout:params 
		(
		distance type:#float animatable:true ui:spnDist default:0
		pathPercent type:#float animatable:true
		spline type:#node ui:pkbSpline
		splineLength type:#float animatable:false ui:spnLength default:0

		/*
		on spnDist set val do delegate.length = val
		
		on create do
			(
			local length
			)
		*/

		on spline set obj do
			(
			try(this.pkbSpline.text = obj.name)
			catch()
			) 
		)

	rollout params "Parameters" width:160 height:128
		(


	--INTERFACE
	--------------------------------------------------------------------------------

		groupBox grp1 "Spline" pos:[4,4] width:158 height:68
			pickButton pkbSpline "Pick Spline..." pos:[8,24] width:150 height:16
			--label lblSpline "Length:" pos:[8,48] width:144 height:16
			spinner spnLength "Spline Length: " pos:[62,48] width:92 height:16 range:[0,9999,0] controller:lenCtrl enabled:false

		groupBox grp2 "Animation" pos:[4,80] width:158 height:60
			spinner spnDist "Distance: " pos:[74,96] width:80 height:16 range:[-9999,9999,0] controller:distCtrl


	--HANDLERS
	--------------------------------------------------------------------------------

		fn getSplineLength obj =
			(
			segArr = getSegLengths obj 1
			len = segArr[segArr.count]
			return len
			)


		on pkbSpline picked obj do
			(
			this.spline = obj
			len = getSplineLength obj
			spnLength.value = len
			pkbSpline.text = obj.name
			
			when geometry obj changes do
				(
				--this.len = getSplineLength obj
				this.splineLength.value = random 0 30--getSplineLength obj
				)
			)

		on spnDist changed val do
			(
			pc=(val/len)
			spnPercent.value = pc
			)

		)

	on load do
		(
		print (">" + this as string)
		show this
		--this.params.pkbSpline.text = this.spline.name
		)
	on update do
		(
		try(print (this.spline.name))
		catch()
		)

	)
	
/*
$.pos.controller[2].path
*/
	