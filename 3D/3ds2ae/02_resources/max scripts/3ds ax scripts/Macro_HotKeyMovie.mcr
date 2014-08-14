macroScript HotkeyFlash category:"Help" internalCategory:"Help" tooltip:"Hotkey Flash Movie" 
(
	rollout rFlashError "Hotkey Map"
	(
		label lbl "Cannot create Flash ActiveX player, please get the \nlatest player from " height:50 offset:[100,10] across:2
		hyperLink hl "http://www.macromedia.com" address:"http://www.macromedia.com/software/flash/" color:blue hoverColor:red offset:[-50,24]
		button btn "Ok" height:25 width:60 offset:[0, -10]

		on btn pressed do destroyDialog rFlashError	
	)
	rollout rHotkeyFlash "Hotkey Map"
	( 
		activeXControl axFlash "ShockwaveFlash.ShockwaveFlash.5" height:300 width:600 align:#center offset:[0,-5]
		
	 	on rHotkeyFlash open do
		( 
			local vText = (getDir #maxroot) + "\\splash.cfg"
			local vMovie = (getDir #maxroot) + "\\splash.swf"
	
			local vData = ""
			local vStream = openFile vText
			axFlash.Menu = false
		 	while not eof vStream do vData += readLine vStream
			close vStream			
			axFlash.movie =  vMovie
		)	
	)
	on execute do
	(
		try
		(
			createDialog rHotkeyFlash width:600 height:300 escapeEnable:false
		)
		catch 
		( 			
			destroyDialog rHotkeyFlash
			createDialog rFlashError width:300 height:100 modal:true
		)
	)
)