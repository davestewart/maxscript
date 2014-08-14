plugin modifier pathControl21
name:"Path Control 21" 
classID:#(0x399e7392, 0x6fae933c)

--extends:normalize_spline 
--replaceUI:true version:1 
( 
	parameters main rollout:params 
	(
		distance type:#float animatable:true ui:spnDist default:0
		pathPercent type:#float animatable:true ui:spnPercent default:0
		spline type:#node ui:pkbSpline
		/*
		on spnDist set val do delegate.length = val
		
		on create do
		(
			local length
		)
		*/
	)

	rollout params "Parameters" width:160 height:128
	(

		local spnCtrl = bezier_float()
		local pcCtrl = bezier_float()
		local pc, pcStr
		local segArr, len

	--INTERFACE
	--------------------------------------------------------------------------------

		groupBox grp1 "Spline" pos:[4,4] width:158 height:68
			pickButton pkbSpline "Pick Spline..." pos:[8,24] width:150 height:16
			label lblSpline "Length:" pos:[8,48] width:144 height:16

		groupBox grp2 "Animation" pos:[4,80] width:158 height:60
			spinner spnDist "Distance: " pos:[74,96] width:80 height:16 range:[-9999,9999,0] controller:spnCtrl
			spinner spnPercent "Percent: " pos:[74,116] width:80 height:16 range:[-9999,9999,0] controller:pcCtrl


	--HANDLERS
	--------------------------------------------------------------------------------

		on pkbSpline picked obj do
		(
			this.spline = obj
			segArr = getSegLengths obj 1
			len = segArr[segArr.count]
			lblSpline.text = "Length: " + len as string
			pkbSpline.text = obj.name
		)

		on spnDist changed val do
		(
			pc=(val/len)
			spnPercent.value = pc*100
		)

		on spnPercent changed val do
		(
			dist=len*val
			spnDist.value = dist/100
		)

	)

	on load do
	(
		print (">" + this as string)
		show this
		--this.params.pkbSpline.text = this.spline.name
	)

)
	
/*
$.pos.controller[2].path
*/
	