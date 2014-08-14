fn filterFileTypes =
(
	-- Script by Dave Stewart
	-- www.davestewart.co.uk

	-- Description.
		-- returns a sequence of file type descriptions and file type patterns 
		-- for use in "getOpenFileName" and "getSaveFileName" dialogue boxes.
		--
		-- eg: "Data(*.dat)|*.dat|Excel(*.csv)|*.csv|All|*.*|"
	
	-- Usage
		-- Edit the fileTypes array to include
		-- getOpenFileName caption:"Choose a file to open" types:(filterFileTypes())

	-- define filetypes
		local i=0
		local fileTypes=#()
		local allTypes = ""
		local str

		fileTypes[i+=1]=#(	"Animation Types...",						"*.avi")
		fileTypes[i+=1]=#(	"  AVI File",						"*.avi")
		fileTypes[i+=1]=#(	"  MOV QuickTime File",			"*.mov")
		fileTypes[i+=1]=#(	"  Autodesk Flic Image File",		"*.flc; *.fli; *.cel")
		fileTypes[i+=1]=#(	"BMP Image File",				"*.bmp")
		fileTypes[i+=1]=#(	"JPEG File",					"*.jpg; *.jpe; *.jpeg")
		fileTypes[i+=1]=#(	"PNG Image File",				"*.png")
		fileTypes[i+=1]=#(	"SGI's Image File Format",		"*.rgb")
		fileTypes[i+=1]=#(	"RLA Image File",				"*.rla")
		fileTypes[i+=1]=#(	"RPF Image File",				"*.rpf")
		fileTypes[i+=1]=#(	"Targa Image File",				"*.tga; *.vda; *.icb; *.vst")
		fileTypes[i+=1]=#(	"TIF Image File",				"*.tif")
		fileTypes[i+=1]=#(	"Shockwave Flash SWF",			"*.swf")
		fileTypes[i+=1]=#(	"Adobe Illustrator AI",			"*.ai")
		fileTypes[i+=1]=#(	"Autocad DXF",					"*.dxf")
		
	-- get all formats string
		for f in fileTypes do allTypes+= f[2] + "; "
	
	-- start building formats string
		str = stringstream ""

		format ("All formats|" +allTypes+ "|") to:str
		
		for i = 1 to fileTypes.count do
		(
			for f in filetypes[i] do format  (f +"|") to:str
		)
		
		format "Any file (*.*)|*.*" to:str
	-- done	
		return str
)

getSaveFileName types:(filterFileTypes())

