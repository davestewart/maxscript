rollout ro1 "Apply this code to the selected objects..." width:392 height:184
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	button btnGetText "Get Listener text" pos:[192,8] width:88 height:16

	radiobuttons rdo1 "" pos:[8,8] width:133 height:16 labels:#("Selection", "Pick") columns:2
	button btnDoCode "Execute >" pos:[288,8] width:56 height:16
	label lblStatus "-" pos:[352,8] width:32 height:16 enabled:true

	edittext edt1 "" pos:[0,32] width:384 height:144  --text:"pos+= (random -40 40)" 
	edittext edt2 "" width:384 height:144 offset:[-12,0] enabled:false text:"test"

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	--
	--	THIS CODE WORKS! USE IT AS A TEMPLATE
	--
	--	obj = $Sphere01.name
	--	cmd="pos+=20"
	--	execute("$" + obj + "." + cmd)


	fn replaceAll strAll strOut strIn =
	(
		while ((i=findstring strAll strOut) != undefined) do
		(
			strAll = replace strAll i strOut.count strIn
		)
		return strAll
	)

	fn doCode=
	(
		cmd=edt1.text
		for obj in selection do (
			try(
				tempObj = obj.name
				execute("$" + tempObj + "." + cmd)
				--lblStatus.text = "OK"
			)
			catch (
				--lblStatus.text = "Error!"
			)
		)
	)
	
	fn doCode2=
	(
		cmd=edt1.text
		for obj in selection do (
			print cmd
			try(
				execute cmd
				lblStatus.text = "OK"
			)
			catch (
				lblStatus.text = "Error!"
			)
		)
	)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnGetText pressed do
	(
		edt1.text += getListenerSelText()
	)

	on btnDoCode pressed do
	(
		--edt2.text = replaceAll edt1.text "$" "obj"
		edt2.text = edt1.text
		doCode2()
	)

)

if ro1 != undefined then destroyDialog ro1
myDialog = CreateDialog ro1 width:390 height:340 style:#(#style_minimizebox,#style_titlebar,#style_sysmenu)



