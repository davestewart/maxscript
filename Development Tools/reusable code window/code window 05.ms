---------------------------------------------------------------------------------------------------
-- declarations
---------------------------------------------------------------------------------------------------

global roExecuteCode, codeFloater, codeHelpFloater

rollout roConstants "Constants" width:392 height:100 rolledUp:true
(

	-------------------
	-- declarations
	-------------------
	local codeText = "r = (random -10.0 10.0)
c = color (random 0.0 255.0) (random 0.0 255.0) (random 0.0 255.0)"

	-------------------
	-- Interface
	-------------------
	edittext edtCode "" width:384 height:72 offset:[-12,0] text:codeText
	button btnGetText "Insert selected Listener text" height:14 offset:[8,0] align:#right

	-------------------
	-- Handlers
	-------------------
	on btnGetText pressed do edtCode.text += getListenerSelText()

		-------------------------------------------------------------------------------------------------
		-- Locals, Functions & Handlers for entire Floater
		-------------------------------------------------------------------------------------------------

		-- All this code must be in the first rollout so that max knows what is going on...
		
		-------------------------------------------------------------------------------------------------
	
		local INIfile = (getDir #plugcfg) + "\codeFloater.ini"
	
		fn writeSettings =
		(
			setINISetting INIfile "Floater" "pos" (codeFloater.pos as string)
			setINISetting INIfile "Floater" "size" (codeFloater.size as string)
	
			setINISetting INIfile "Rollouts" "roConstants" (roConstants.open as string)
			setINISetting INIfile "Rollouts" "roObjectCode" (roObjectCode.open as string)
			setINISetting INIfile "Rollouts" "roFinalCode" (roFinalCode.open as string)
			setINISetting INIfile "Rollouts" "roCodeHelp" (roCodeHelp.open as string)
		)
	
	
		fn readSettings =
		(
			codeFloater.pos = execute (getINISetting INIfile "Floater" "pos") as Point2
			codeFloater.size = execute (getINISetting INIfile "Floater" "size") as Point2

			-- adjustments, because max always puts it back a bit higher than it should be...
			codeFloater.pos += [0,9]
			codeFloater.size -= [0,9]
	
			roConstants.open = execute (getINISetting INIfile "Rollouts" "roConstants")
			roObjectCode.open = execute (getINISetting INIfile "Rollouts" "roObjectCode")
			roFinalCode.open = execute (getINISetting INIfile "Rollouts" "roFinalCode")
			roCodeHelp.open = execute (getINISetting INIfile "Rollouts" "roCodeHelp")
		)


		on roConstants close do writeSettings()
		on roConstants open do readSettings()

		-------------------------------------------------------------------------------------------------

)

rollout roObjectCode "Object Specific Code" width:392 height:184
(
	-------------------
	-- declarations
	-------------------
	local codeText = "$.pos.x += r
$.pos.y += r
$.pos.z += (random -10.0 10.0)
$.wirecolor = c"

	-------------------
	-- Interface
	-------------------
	edittext edtCode "" width:384 height:144 offset:[-12,0] text:codeText
	button btnGetText "Insert selected Listener text" height:14 offset:[8,0] align:#right

	-------------------
	-- Handlers
	-------------------
	on btnGetText pressed do edtCode.text += getListenerSelText()
)
	

rollout roFinalCode "Final Code" width:392 height:184 rolledUp:true
(
	edittext edtFinal "" width:384 height:144 offset:[-12,0]
)

rollout roCodeHelp "Instructions" width:392 height:184
(
	label lbl1 "sdlkjasdjlasdjlsadj" align:#left
)


rollout roExecuteCode "Execute Code" width:392 height:184
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
/*
	checkBox chk1 "Include Constants code in execution"
	checkBox chk2 "Format final code to Listener"
*/
	button btnDoCode "Apply Code to selected" height:32 width:380

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn replaceAll strAll strOut strIn =
	(
		while ((i=findstring strAll strOut) != undefined) do
		(
			strAll = replace strAll i strOut.count strIn
		)
		return strAll
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------



	on btnDoCode pressed do
	(
		objCode = replaceAll roObjectCode.edtCode.text "$" "obj"

		cmd = roConstants.edtCode.text + "
		
for obj in selection do (
	try(
		" + objCode + "
)
	catch()
	)"

		roFinalCode.edtFinal.text = cmd

		undo "Apply code to multiple objects" on
		(
			try (execute cmd)
			catch (displayTempPrompt "Error in code syntax..." 2000)
		)
	)
)




if codeFloater  != undefined then closerolloutfloater codeFloater 
codeFloater  = newRolloutFloater "Reusable Code" 415 440
addRollout roConstants codeFloater 
addRollout roObjectCode codeFloater 
addRollout roExecuteCode codeFloater 
addRollout roFinalCode codeFloater 
addRollout roCodeHelp codeFloater