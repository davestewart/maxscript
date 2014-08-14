---------------------------------------------------------------------------------------------------
-- declarations
---------------------------------------------------------------------------------------------------

global roExecuteCode, codeFloater, codeHelpFloater

rollout roConstants "Step 1 : Make declarations" width:392 height:100 rolledUp:true
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

	-------------------
	-- Handlers
	-------------------
	on btnGetListSel pressed do edtCode.text += getListenerSelText()
	on btnGetListAll pressed do
	(
		edtCode.text +=
		(
			setListenerSel #(0,-1)
			txt = getListenerSelText()
		)
	)

		--===============================================================================================
		-- Locals, Functions & Handlers for Floater (1 of 2)
		--
		-- All this code must be in the first rollout so that max knows what is going on...
		--===============================================================================================
	
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

		--===============================================================================================

)

rollout roObjectCode "Step 2 : Write object code" width:392 height:184
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
	edittext edtCode "" width:384 height:140 offset:[-12,0] text:codeText

	-------------------
	-- Handlers
	-------------------
	on btnGetListSel pressed do edtCode.text += getListenerSelText()

	on btnGetListAll pressed do
	(
		edtCode.text +=
		(
			setListenerSel #(0,-1)
			txt = getListenerSelText()
		)
	)


)
	

rollout roFinalCode "Final Code" width:392 height:184 rolledUp:true
(
	-------------------
	-- declarations
	-------------------
	local newWin

	-------------------
	-- Interface
	-------------------
	edittext edtCode "" width:384 height:140 offset:[-12,0]

	label lbl1 "Dump to Script window:" pos:[190,154] width:112 height:13 across:3
	button btnDumpNew "New" pos:[306,154] width:28 height:14
	button btnDumpPrev "Previous" pos:[334,154] width:48 height:14 enabled:false

	-------------------
	-- Handlers
	-------------------
	on btnDumpNew pressed do
	(
		newWin = newScript()
		format "%" (edtCode.text +"\n") to:newWin 
		btnDumpPrev.enabled = true
	)

	on btnDumpPrev pressed do
	(
		if newWin == undefined then newWin = newScript()
		format "%" (edtCode.text +"\n") to:newWin
	)

)


rollout roExecuteCode "Step 3 : Execute all" width:392 height:184
(
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	button btnDoCode "Apply Code to selected" height:32 width:376

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn tabulate str1 =
	(
		local t = "	"	-- tab character
		local r = "
"						-- return character
		local str2 = t + t
		while not (eof str1) do
		(
			char = (readChar str1)
			if char != "\n" then str2 += char
			else str2 += (r + t + t)
		)
		close str1
		return str2
	)

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
		
for obj in selection do
(
	try
	(
" + (tabulate (stringstream objCode)) + "
	)
	catch(format \"Partial code failiure on : %\\n\" obj.name)
	)"

		roFinalCode.edtCode.text = cmd

		undo "Apply code to multiple objects" on
		(
			try (execute cmd)
			catch (displayTempPrompt "Error in code syntax..." 2000)
		)
	)
)

rollout roCodeHelp "Instructions" width:392 height:184
(
--	local insStr="1.sdsd\nsdsd"
	label lbl1 "This script basically rewrites code that appears in the listener and lets you apply it to multiple objects by using a for...in loop. It's not rocket science, but it can be a bit of a timesaver, and quite useful for codeaphobics...

Just copy/paste code from the listener to Rollout 2, select some objects and then click Apply to see the results.

If you're feeling brave, try adding your own variables as illustrated in rollout 1.

FYI the try/catch thing makes sure your code doesn't generate any errors as it is applied to objects." align:#left width:380 height:184

		--===============================================================================================
		-- Locals, Functions & Handlers for Floater (2 of 2)
		--===============================================================================================

		on roCodeHelp open do roConstants.readSettings()

		--===============================================================================================


)




if codeFloater  != undefined then closerolloutfloater codeFloater 
codeFloater  = newRolloutFloater "Repetetive Code Tool" 415 440
addRollout roConstants codeFloater 
addRollout roObjectCode codeFloater 
addRollout roExecuteCode codeFloater 
addRollout roFinalCode codeFloater 
addRollout roCodeHelp codeFloater