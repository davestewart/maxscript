---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:#cmdPanel height:311 -- #effectsDlg #mtlEditor
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	ActiveXControl axWeb "http://www.davestewart.co.uk" width:150 height:150 AddressBar:true
	button btn1 ""
	ActiveXControl axWin2 "MSHTML:<HTML><BODY><A href='javascript:window.location=\"http://images.google.com\"'>Close</A></BODY></HTML>" width:150 height:150 AddressBar:true

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
		on rFlash open do
		( 
		--	axFlash.movie = "MSHTML:<HTML><BODY>Hello</BODY></HTML>" fullscreen:true
--			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
		)

		on btn1 pressed do
		(
			showProperties axWeb
			axWeb.AddressBar = true
		)

)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater
