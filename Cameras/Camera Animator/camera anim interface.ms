rollout r1 "Untitled" width:176 height:520
	(
	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
		groupBox grpTemplate "Template cameras" pos:[8,8] width:160 height:320
		
			multiListBox lbxTemplateCameras "" pos:[16,24] width:144 height:21 items:#("1", "2", "3", "4", "5", "6") multiSelect:true
			button btnDown "Down" pos:[16,288] width:72 height:16
			button btnUp "Up" pos:[88,288] width:64 height:16
			button btnPick "Pick new order" pos:[16,304] width:136 height:16
		
	
		groupBox grpAnimation "Animation" pos:[8,336] width:160 height:168
		
			spinner spnHold "Hold time (frames)" pos:[32,360] width:128 height:16 range:[0,100,0] type:#integer
			spinner spnMove "Move time (frames)" pos:[27,376] width:133 height:16 range:[0,100,0] type:#integer
	
			checkbox chkTangents "" pos:[144,400] width:16 height:16
			label lblTangents "Set tangents to slow" pos:[44,400] width:100 height:16
	
			button btnAnimate "Animate!" pos:[16,448] width:144 height:24
	
			checkbox chkTime "" pos:[144,480] width:16 height:16
			label lblTime "Update scene duration" pos:[32,480] width:112 height:16
			
			
	-----------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------
	
		fn compareByName v1 v2 =
			(
			v1 = v1.name
			v2 = v2.name
			case of
				(
				(v1 < v2): -1
				(v1 > v2): 1
				default: 0
				)
			)
		
		fn isCamera obj =
			(
			return superclassof obj == camera
			)
		
		function getAnimatedCamera =
			(
			)
		
		function getTemplateCameras =
			(
			
			
			arr = pickObject message:"Select cameras" count:#multiple filter:isCamera select:true forceListenerFocus:false
			
			
			)
		
		/*
		arr = getCurrentSelection()
		qsort arr compareByName
		print arr
		
		pickobject
		
		arr = #($camera01)
		fn getPos =
			(
			print arr
			return arr[arr.count].pos
			)
*/
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
	)
createdialog r1