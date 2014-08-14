struct maxHtml
	(

	axCtrl = "",
		
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
	,

	fn parseUrl url =
		(
		local str, fnName, fnArgs
		
		if findstring url "maxscript:" != undefined AND findstring url ";void(0)" != undefined then
			(
			-- get the base command
				url	= maxHtml.replaceAll url "javascript:'" ""
				url	= maxHtml.replaceAll url "maxscript:" ""
				url	= maxHtml.replaceAll url "';void(0)" ""
				
			-- replace entities
				url	= maxHtml.replaceAll url "%20" " "

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


	,
	fn addHtmlLink axCtrl text link id:unsupplied class:unsupplied =
		(
		if class == unsupplied then class = ""
		if id == unsupplied then id = ""
		--link = maxHtml.replaceAll link "\"" "\\\""
		local url	= "javascript:addLink('" +link+ "','" +text+ "','" +id+ "','"+class+"')"
		axCtrl.Navigate url
		)
		
		
	,
	fn addMaxLink axCtrl text cmd id:unsupplied class:unsupplied =
		(
		if class == unsupplied then class = ""
		if id == unsupplied then id = ""
		cmd = maxHtml.replaceAll cmd "'" "\\'"
		text = maxHtml.replaceAll text "'" "\\'"
		local url	= "javascript:maxLink('" +cmd+ "','" +text+ "','" +id+ "','"+class+"')"
		
		--format "%\n" url
		
		axCtrl.Navigate url
		)
		
		
	,
	fn setBgColor axCtrl =
		(
		local col	= (colorMan.getColor #background) * 255
		local colStr= "rgb(" +((col[1] as integer) as string)+ "," +((col[2] as integer) as string) + "," +((col[3] as integer) as string)+ ")"
		local url	= "javascript:document.body.style.backgroundColor='"+colStr+"';void(0)"
		
		axCtrl.Navigate url

		)

	)