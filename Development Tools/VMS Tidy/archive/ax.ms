---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:384 height:312
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

--str="MSHTML:<HTML><BODY><object classid=clsid:{3B7C8860-D78F-101B-B9B5-04021C009402} height=400 width=400></object></BODY></HTML>"

--str="{3B7C8860-D78F-101B-B9B5-04021C009402}"
	activeXControl "{3B7C8860-D78F-101B-B9B5-04021C009402}" height:200 width:300
--	activeXControl ax "{562F499D-186B-42E7-B112-23D82883D542}" height:200 width:300


/*
"Microsoft Rich Textbox Control 6.0 (SP6)"
"RICHTEXT.RichtextCtrl.1"
"{3B7C8860-D78F-101B-B9B5-04021C009402}" 
--	button btn1 "Button" width:368 height:16
--activeXControl ax "{05589FA1-C356-11CE-BF01-00AA0055595A}" height:200 width:300 align:#left 
*/


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

)
if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 800 400 10 10
addRollout ro1 myFloater

