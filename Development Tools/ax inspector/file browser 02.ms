destroydialog ro1

rollout ro1 "File browser"
(

	---------------------------------------------------------------------------------------
	-- interface

		activeXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" height:384 width:292 align:#left
		button btnOpen "Open files" size:[48,16] offset:[8,0] align:#right
		--on ax Click do format "handler: Click\n"
	

	---------------------------------------------------------------------------------------
	-- variables

		local filePath		= "c:\\temp\\"
		local filePattern	= "*.*"
		local itemCurrent


	---------------------------------------------------------------------------------------
	-- utility functions

		fn replaceAll strStr strOut strIn =
		(
			local strTemp = ""
			local arrTemp = filterstring strStr strOut
			for i = 1 to arrTemp.count do
			(
				strTemp += arrTemp[i]
				if i < arrTemp.count then strTemp += strIn
			)
			return strTemp
		)
	
	---------------------------------------------------------------------------------------
	-- interface functions

		fn getDirListing =
		(
			return #(1,2,3)
		)

		fn populateList =
		(
			
			-- files
			
				struct fsFile (name,path,size,type,date)
				
				local strFS				= filePath + filePattern
				local arrFS				= #()
				local arrDirs			= getDirectories strFS
				local arrFiles			= getFiles strFS
	
				local chs				= ax.columnHeaders
		
			-- ax control
			
				
			
				local hName				= chs.Add()
				local hSize				= chs.Add()
				local hType				= chs.Add()
				local hDate				= chs.Add()

				--  .Add Index:undefined Key:undefined Text:undefined Width:undefined Alignment:undefined Icon:undefined
	

				hName.text			= "Name"
				hName.width			= 250*24
				
				hSize.text			= "Size"
				hSize.Alignment 	= #lvwColumnRight

				
				hType.text			= "Type"
				hDate.text			= "Date Modified"
				  
				local items			= ax.listItems



			for i = 1 to arrDirs.count do
			(
				local f, li
				local folderPath	= arrDirs[i]
				local folder		= filterString folderPath "\\"
				local folder		= folder[folder.count]
				print folder

				li = items.Add()
				li.text				= folder
				li.tag				= folderPath
				--li.bold
			)




			for i = 1 to arrFiles.count do
			(
				local f, li
				local file			= arrFiles[i]
				li = items.Add()
				
				/*
				f					= fsFile()
				
				f.name				= strFile
				
				print f.name
				f.path				= strFS + name
				f.size				= (getFileSize f.path) / 1024 
				f.type				= (filterstring f.name ".")[2]
				f.date				= getFileModDate f.path

				*/
				li.text				= filenameFromPath file
				li.tag				= getFilenamePath file

				lsi					= li.ListSubItems.Add()
				lsi.text			= (((getFileSize file)+512) / 1024) as string+ " KB"

				lsi					= li.ListSubItems.Add()
				lsi.text			= getFilenameType file

				lsi					= li.ListSubItems.Add()
				lsi.text			= getFileModDate file

			)
				

/*
			for li in ax.listItems do li.bold = true
			li = ax.HitTest 100 1500
			if li != undefined do
			(
				showProperties		li
				li.text				= "Just Hit Tested"
				showEvents 			controlR92.ax
				showMethods 		controlR92.ax
			)
				
*/
		)



		fn getSelectedItems ax=
		(
			local selectedItems = #()
			for i = 1 to ro1.ax.listitems.count do
			(
				local item = ro1.ax.listitems[i]
				if item.selected == true then
				(
					append selectedItems item
				)
			)
			return selectedItems 
		)


		fn styleList =
		(
			ax.MousePointer			= #ccArrow
			ax.font					= "Tahoma"
			ax.GridLines			= false
			ax.AllowColumnReorder	= true
			ax.BorderStyle			= #ccFixedSingle
			ax.view					= #lvwReport
			ax.MultiSelect 			= true
		)


		fn viewBitmap item=
		(
			local f = item.tag + item.text
			local f = replaceAll f "\\" "\\\\"
			local bm = openbitmap f
			display bm
			display bm
		)

	---------------------------------------------------------------------------------------
	-- handlers

		on ro1 resized size do
		(
			ax.size			= size - [16,40]
			btnOpen.pos		= size - [68,28]
		)
			
		on ro1 open do
		(
			--ax.size = [ro1.width-16,ro1.height-8]
			ro1.resized [ro1.width,ro1.height]
			styleList()
			populateList()
	
			--showProperties ax
			--showProperties chs
			--showMethods chs
		)
			
			
		on ax ItemClick Item do
		(
			itemCurrent				= item
		)

		on ax DblClick do
		(
			viewBitmap itemCurrent
			--messagebox bm
		)
			
		on btnOpen pressed do
		(
			local selectedItems 	= getSelectedItems ax
			for item in selectedItems do viewBitmap item
		)

)

createdialog ro1 400 300 10 10 modal:false style:#(#style_resizing,#style_titlebar,#style_sysmenu)

--show ro1.ax
--b = openbitmap "c:/temp/37a0eb.jpg"

--display b
--showbitmap "c:/temp/37a0eb.jpg"
