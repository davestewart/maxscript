	global roOpts
	--local copyType = 0
	rollout roOpts "Options" width:128 height:88
		(
		button BtnCancel "Cancel" pos:[8,64] width:112 height:16
		radiobuttons rdo1 "" pos:[8,8] width:111 height:48 labels:#("Copy values only", "Copy controller", "Instance Controller") default:0
		on BtnCancel pressed do
			DestroyDialog roOpts
		on rdo1 changed state do
			(
			copyType = case state of
				(
				1:	1
				2:	2
				3:	3
				)
				DestroyDialog roOpts
			)
		)
	CreateDialog roOpts modal:true