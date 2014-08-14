---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------


filein "maxHtml.ms"


try(destroydialog ro1);catch()
rollout ro1 "HTML Interface" width:552 height:624
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local urlForm = "E:\\03_Scripting\\maxScript\\max 8\\html interface\\final\\html-demo.html"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	ActiveXControl axWeb "http://" pos:[4,4] width:540 height:468 AddressBar:true setupEvents:true
	GroupBox grp1 "Add your own commands to the HTML page here. (Note: no single quotes ( ' ) yet!)" pos:[8,480] width:536 height:136
	edittext txt1 "" pos:[16,496] width:480 height:16
	edittext cmd1 "" pos:[16,512] width:480 height:16
	button btn1 "Add" pos:[504,496] width:34 height:32
		
	edittext txt2 "" pos:[16,536] width:480 height:16
	edittext cmd2 "" pos:[16,552] width:480 height:16
	button btn2 "Add" pos:[504,536] width:34 height:32
		
	edittext txt3 "" pos:[16,576] width:480 height:16
	edittext cmd3 "" pos:[16,592] width:480 height:16
	button btn3 "Add" pos:[504,576] width:34 height:32
	
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
		-- go to the start page
			on ro1 open do
				( 
				if doesFileExist urlForm then
					(
				-- setup ax
					axWeb.Navigate ("file://" + urlForm)
				-- setup sample commands
					txt1.text = "Create a sphere"
					cmd1.text = "sphere radius:20"
						
					txt2.text = "Messagebox saying Hello World!'"
					cmd2.text = "messagebox \"Hello world!\""
					
					txt3.text = "Search for \"3dsmax\" on Google"
					cmd3.text = "http://www.google.co.uk/search?q=\"3dsmax\""
					)
				else
					(
					messagebox "The demo file 'html-demo.html' could not be found.\nEdit the variable 'urlForm' at the head of this script to point towards the file 'html-demo.html'."
					)
					
				)

		-- sample links
			on btn1 pressed do maxHtml.addMaxLink  axWeb txt1.text cmd1.text id:"maxDefined"
			on btn2 pressed do maxHtml.addMaxLink  axWeb txt2.text cmd2.text id:"maxDefined"
			on btn3 pressed do maxHtml.addHtmlLink axWeb txt3.text cmd3.text id:"maxDefined"
			
			
		-- set bg color on initial page load
			on axWeb NavigateComplete2 pDisp url do
				(
				--if urlForm == url then maxHtml.setBgColor axWeb
				)
	

		-- intercept urls
			on axWeb BeforeNavigate2 pDisp url Flags TargetFrameName PostData Headers Cancel do
				(
				maxHtml.parseUrl url
				)
	
)

enableAccelerators = false
createdialog ro1