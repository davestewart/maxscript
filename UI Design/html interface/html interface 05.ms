---------------------------------------------------------------------------------------------------
-- utility
---------------------------------------------------------------------------------------------------

clearlistener()
filein "maxHtmlStruct.ms"

---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

try(destroydialog ro1);catch()
rollout ro1 "HTML Interface" width:316 height:650
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local urlForm = "E:\\03_Scripting\\maxScript\\max 8\\html interface\\index4.html"
--	local urlForm = "index4.html"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	ActiveXControl axWeb "http://" pos:[4,4] width:300 height:276 AddressBar:true setupEvents:true

	edittext edt1 "" pos:[8,288] width:256 height:16 text:"Create a sphere"
	edittext edt2 "" pos:[8,304] width:256 height:16 text:"sphere radius:20"
	button btnCmd "Add" pos:[272,288] width:34 height:32
	
	edittext edt3 "" pos:[8,328] width:256 height:16 text:"Messagebox saying Hello World!'"
	edittext edt4 "" pos:[8,344] width:256 height:16 text:"messagebox \"Hello world!\""
	button btnFn "Add" pos:[272,328] width:34 height:32

	edittext edt5 "" pos:[8,368] width:256 height:16 text:"Search for \"3dsmax\" on Google"
	edittext edt6 "" pos:[8,384] width:256 height:16 text:"http://www.google.co.uk/search?q=\"3dsmax\""
	button btnLink "Add" pos:[272,368] width:34 height:32



	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
		-- go to the start page
			on ro1 open do
				( 
				axWeb.Navigate ("file://" + urlForm)
				)

		-- sample links
			on btnCmd pressed do maxHtml.addMaxLink axWeb edt1.text edt2.text
			on btnFn pressed do maxHtml.addMaxLink axWeb edt3.text edt4.text
			on btnLink pressed do maxHtml.addHtmlLink axWeb edt5.text edt6.text
			
			
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