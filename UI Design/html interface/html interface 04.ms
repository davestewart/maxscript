clearlistener()
---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

try(destroydialog ro1);catch()
rollout ro1 "HTML Interface" width:316 height:650
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local urlForm = "E:\\03_Scripting\\maxScript\\max 8\\html interface\\index3.html"
	--local urlForm = "E:\\03_Scripting\\maxScript\\max 8\\html interface\\frame.html"

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
	-- Functions
	---------------------------------------------------------------------------------------------------

		fn replaceAll str outStr inStr =
			(
			local str = #(str,"")
	
			while findstring str[1] outStr != undefined do
				(
			-- get variables
				local s1 = 1
				local s2 = (findstring str[1] outStr) + (-1)
				local s3 = (findstring str[1] outStr) + outStr.count
	
			-- build str[2]
				str[2]+= substring str[1] s1 s2
				str[2]+= inStr
				
			-- reduce str[1]
				str[1]= substring str[1] s3 str[1].count
				)
			str[2]+=str[1]
			return str[2]
			)


		fn checkUrl url =
			(
			local str, fnName, fnArgs
			
			
			print url
			
			if findstring url "maxscript:" != undefined AND findstring url ";void(0)" != undefined then
				(
				-- get the base command
					url	= replaceAll url "javascript:'" ""
					url	= replaceAll url "maxscript:" ""
					url	= replaceAll url "';void(0)" ""
					
				-- replace entities
					url	= replaceAll url "%20" " "

				print url

				-- execute it	
/*
				fnName = substring str 1 ((findstring str " ") - 1)
				fnArgs = substring str (fnName.count + 2) str.count
				
				execute (fnName + " " + fnArgs)
				*/
				try(
					execute (" " + url)
					)
				catch(
					--if querybox "There was a syntax error in your passed maxscript command. Try again?" then execute (" " + url)
					format "--html > max error:\n	%\n" url
					)
				)
			)


		fn addHtmlLink text link id:unsupplied class:unsupplied =
			(
			if class == unsupplied then class = ""
			--link = replaceAll link "\"" "\\\""
			local url	= "javascript:addLink('" +link+ "','" +text+ "')"
			axWeb.Navigate url
			)
			
			
		fn addMaxLink text cmd id:unsupplied class:unsupplied =
			(
			if class == unsupplied then class = ""
			messagebox cmd
			cmd = replaceAll cmd "'" "\\'"
			text = replaceAll text "'" "\\'"
			local url	= "javascript:maxLink('" +cmd+ "','" +text+ "','"+class+"')"
			
			format "%\n" url
			
			axWeb.Navigate url
			)
			
			
		fn setBgColor =
			(
			local col	= (colorMan.getColor #background) * 255
			local colStr= "rgb(" +((col[1] as integer) as string)+ "," +((col[2] as integer) as string) + "," +((col[3] as integer) as string)+ ")"
			local url	= "javascript:document.body.style.backgroundColor='"+colStr+"';void(0)"
			
			axWeb.Navigate url

			)
			
		-- format "% %\n " "\"" "\\\""

	
	---------------------------------------------------------------------------------------------------
	-- Test functions
	---------------------------------------------------------------------------------------------------

		function test str =
			(
			messagebox (str as string)
			)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
		on ro1 open do
			( 
			axWeb.Navigate ("file://" + urlForm)
			)

		on btnCmd pressed do addMaxLink edt1.text edt2.text

		on btnFn pressed do addMaxLink edt3.text edt4.text
			
		on btnLink pressed do addHtmlLink edt5.text edt6.text
			
			
		on btnBg pressed do setBgColor()

		on axWeb NavigateComplete2 pDisp url do
			(
			if urlForm == url then setBgColor()
			)


		on axWeb BeforeNavigate2 pDisp url Flags TargetFrameName PostData Headers Cancel do
			(
			--format " pDisp : %\n url : %\n Flags : %\n TargetFrameName : %\n PostData : %\n Headers : %\n Cancel : %\n " pDisp url Flags TargetFrameName PostData Headers Cancel 

			checkUrl url
			
			)

)

enableAccelerators = false
createdialog ro1

/*
showmethods ro1.axWeb
show ro1.axWeb

setproperty ro1.axWeb #height 500
ro1.axWeb.Resizable = true


ro1.axWeb.PutProperty "height" 500

ro1.axWeb.AddressBar
*/

enableaccellerators