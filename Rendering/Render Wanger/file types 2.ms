fn filterFileTypes showExtension =
(
	-- Script by Dave Stewart
	-- www.davestewart.co.uk

	-- Description.
		-- returns a sequence of file type descriptions and file type patterns 
		-- for use in "getOpenFileName" and "getSaveFileName" dialogue boxes.
		--
		-- eg: "Data(*.dat)|*.dat|Excel(*.csv)|*.csv|All|*.*|"
	
	-- Usage
		-- Edit the fileTypes array if your needs are different from the options shown here.
		--
		-- example usage:
		-- getOpenFileName caption:"Choose a file to open" types:(filterFileTypes false)
		--
		-- showExtension: [true / false]
		-- Will hide the displayed wildcard extensions in the dropdown list

	-- define filetypes
		local i
		local fileTypes=#(#(),#(),#())
		local all = ""
		local anim = ""
		local still = ""
		local vector = ""
		local str = ""

		-- Animation
			i=0
			fileTypes[1][i+=1]=#(	"AVI File",						"*.avi")
			fileTypes[1][i+=1]=#(	"MOV QuickTime File",			"*.mov")
			fileTypes[1][i+=1]=#(	"Autodesk Flic Image File",		"*.flc; *.fli; *.cel")

		-- Still
			i=0
			fileTypes[2][i+=1]=#(	"BMP Image File",				"*.bmp")
			fileTypes[2][i+=1]=#(	"JPEG File",					"*.jpg; *.jpe; *.jpeg")
			fileTypes[2][i+=1]=#(	"PNG Image File",				"*.png")
			fileTypes[2][i+=1]=#(	"SGI's Image File Format",		"*.rgb")
			fileTypes[2][i+=1]=#(	"RLA Image File",				"*.rla")
			fileTypes[2][i+=1]=#(	"RPF Image File",				"*.rpf")
			fileTypes[2][i+=1]=#(	"Targa Image File",				"*.tga; *.vda; *.icb; *.vst")
			fileTypes[2][i+=1]=#(	"TIF Image File",				"*.tif")

		-- Vector
			i=0
			fileTypes[3][i+=1]=#(	"Shockwave Flash SWF",			"*.swf")
			fileTypes[3][i+=1]=#(	"Adobe Illustrator AI",			"*.ai")
			fileTypes[3][i+=1]=#(	"Autocad DXF",					"*.dxf")
		
	-- build format strings
		for i = 1 to 3 do
		(
			for f in fileTypes[i] do all+= f[2] + "; "
		)
		for f in fileTypes[1] do anim+= f[2] + "; "
		for f in fileTypes[2] do still+= f[2] + "; "
		for f in fileTypes[3] do vector+= f[2] + "; "


	
	-- build types string
		str = stringstream ""

		format ("All formats|" +all+ "|") to:str

		for i = 1 to fileTypes.count do
		(
			-- Types heading...
				if i  == 1 then format ("Animation formats..." +"|" + anim + "|") to:str
				if i  == 2 then format ("Still formats..." +"|" + still + "|") to:str
				if i  == 3 then format ("Vector formats..." +"|" + vector + "|") to:str
			
			-- Types individually
				for f in filetypes[i] do
				(
					format ("      " + f[1])									to:str
					if showExtension == false then format (" (" +f[2]+")")		to:str
					format  ("|"+f[2] + "|")									to:str
				)
				
		)
		
		format "Any file (*.*)|*.*" to:str
	-- done	
		return str
)

getSaveFileName types:(filterFileTypes true)

