fn fade vStart vEnd =
(
	for obj in (getCurrentSelection()) do
	(
		obj.visibility = true
		ctrl = obj[1].controller = bezier_float()
		local t = slidertime
		
		local k = addnewkey ctrl t
		k.value = vStart
		k.inTangentType = #slow
		k.outTangentType = #slow
		
		local k = addnewkey ctrl (t + 25)
		k.value = vEnd 
		k.inTangentType = #slow
		k.outTangentType = #slow
	)
)
	
fn fadeIn =
(
	fade 0 1
)
	
fn fadeOut =
(
	fade 1 0
)
	
fadeIn ()
fadeOut ()


