plugin Camera CamTest_DisplayMesh
name:"CamTest" 
classID:#(0x47db14ff, 0x4e9b5f90) 
category:"Standard" 
extends:FreeCamera 
	( 
	local lastR1, lastR2, meshObj
	parameters pblock rollout:params
		(
		radius1 type:#float animatable:true ui:r1_amount default:40.0
		radius2 type:#float animatable:true ui:r2_amount default:20.0
		)
	rollout params "CamTest Parameters"
		(
		Spinner r1_amount "Radius 1:" range:[0, 1e9, 40]
		Spinner r2_amount "Radius 2:" range:[0, 1e9, 20]
		)
	 
	on getDisplayMesh do 
		(
		if (meshObj == undefined) do
			(
			meshObj = createInstance torus radius1:radius1 radius2:radius2 mapCoords:false
			lastR1 = radius1; lastR2 = radius2
			)
		if radius1 != lastR1 do (meshObj.radius1 = radius1; lastR1 = radius1)
		if radius2 != lastR2 do (meshObj.radius2 = radius2; lastR2 = radius2)
		extrudeFace meshObj.mesh #{1..50} (30 * 0.5) 40 dir:#common
		scale meshObj.mesh [0.7,0.5,0.5]
		meshObj.mesh 
		)--end on getDisplayMesh
	 
	tool create 
	( 
	on mousePoint click do (nodeTM.translation = gridPoint;#stop )
	)--end tool
	 
	)--end plugin

