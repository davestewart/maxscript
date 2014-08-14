---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:316 height:650
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

	local urlForm = "E:\\03_Scripting\\maxScript\\max 8\\html interface\\index2.html"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	--ActiveXControl axWeb "http://www.davestewart.co.uk" width:150 height:150 AddressBar:true
	--ActiveXControl axWin2 "MSHTML:<HTML><BODY><A href='javascript:window.location=\"http://images.google.com\"'>Close</A></BODY></HTML>" width:150 height:150 AddressBar:true
	ActiveXControl axWeb "http://www.microsoft.com" width:300 height:500 pos:[4,4] AddressBar:true setupEvents:true
--	ActiveXControl axWow "{1352E2A2-FB3B-4D57-B73E-935C92B5DAA2}" width:300 height:500 AddressBar:true setupEvents:true
	
	button btnShow "Show" width:200
	button btnNav "Nav" width:200
	button btnAdd "Add" width:200

	button btnAddSphere "Sphere" width:200

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

		function test str =
			(
			messagebox (str as string)
			
			)

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


		fn setBgColor =
			(
			local col	= (colorMan.getColor #background) * 255
			local colStr= "rgb(" +((col[1] as integer) as string)+ "," +((col[2] as integer) as string) + "," +((col[3] as integer) as string)+ ")"
			local url	= "javascript:document.body.style.backgroundColor='"+colStr+"';void(0)"
			
			axWeb.Navigate url

			)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
		on ro1 open do
			( 
		--	axFlash.movie = "MSHTML:<HTML><BODY>Hello</BODY></HTML>" fullscreen:true
--			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
			axWeb.Navigate ("file://" + urlForm)
			--axWow.Navigate "file://E:/03_Scripting/maxScript/max 8/html interface/index.html"
			
			)

		on btnShow pressed do
			(
			print "PROPERTIES"
			showProperties axWeb
			print "METHODS"
			showMethods axWeb
			axWeb.AddressBar = true
			)

		on btnAdd pressed do
			(
			local link	= "http://www.google.com"
			local text	= "Google"
			local url	= "javascript:addLink('" +link+ "','" +text+ "')"
		--	axWeb.Navigate url
			axWeb.Navigate url
			)
		on btnBg pressed do setBgColor()

		on axWeb NavigateComplete2 pDisp url do
			(
			if urlForm == url then setBgColor()
			)

		--on axWeb BeforeNavigate2 pDisp:IWebBrowser URL:undefined Flags:undefined TargetFrameName:undefined PostData:undefined Headers:undefined &Cancel:boolean do ( ... )

		on axWeb BeforeNavigate2 pDisp url Flags TargetFrameName PostData Headers Cancel do
			(
			--format " pDisp : %\n url : %\n Flags : %\n TargetFrameName : %\n PostData : %\n Headers : %\n Cancel : %\n " pDisp url Flags TargetFrameName PostData Headers Cancel 
			
			local str, fnName, fnArgs
			
			if findstring url "maxCmd" != undefined AND findstring url "void(0)" != undefined then
				(
				str  = replaceAll URL "%20" " "
				str  = replaceAll str "javascript:'maxCmd: " ""
				str  = replaceAll str "';void(0)" ""
	
				fnName = substring str 1 ((findstring str " ") - 1)
				fnArgs = substring str (fnName.count + 2) str.count
				
/*
				print fnName
				print fnArgs
				print str
				*/
				
				execute (fnName + " " + fnArgs)
				)
			)

		on btnAddSphere pressed do
			(
			local cmd	= "sphere radius:20"
			local text	= "Make sphere"
			local url	= "javascript:addLink('javascript:maxCmd(\"" +cmd+ "\")','" +text+ "')"
		--	axWeb.Navigate url
			axWeb.Navigate url
			)
			


)

createdialog ro1
