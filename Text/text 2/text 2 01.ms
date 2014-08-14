plugin shape text3 
name:"Text 2" 
classID:#(0x26886d3f, 0x67885270)
category:"Shapes"
extends:text
( 
	local lastSize, meshObj
 
	parameters pblock rollout:params
		(
		size type:#float animatable:true ui:amount default:40.0
		)
	rollout params "HelperTest Parameters"
		(
		Spinner amount "Size:" range:[0, 1e9, 40]
		)
 
	on getDisplayMesh do 
		(
		format "Display\n"
		/*
		if size != lastSize do 
			(
			setMesh meshObj vertices: #([0,0,size*2],[size,0,0],[0,-size,0],[-size,0,0],[0,size,0]) \
			faces: #([1,3,2],[1,4,3],[1,5,4],[1,2,5])
 
			lastSize = copy size
			)
		meshObj
		*/
		)
	
	on create do
		(
		format "Create\n"
		--meshObj = delegate--.mesh
		show delgate
		--print meshObj
		)
	/*
	tool create 
		( 
		on mousePoint click do
			(
			--nodeTM.translation = gridPoint;#stop 
			format "Click\n"
			)
		)
	*/
	)	
