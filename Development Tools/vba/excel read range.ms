-- functions
	fn xlOpenFile fileName =
		(
		-- variables
			local xl, wb, ws
			
		-- OLE
			xl = CreateOLEObject "Excel.Application"
			xl.Workbooks.Open fileName
			wb = xl.activeWorkbook
			
		-- return
			return wb
		)
		
	fn xlCloseFile wb =
		(
		wb.close
		)
		
	fn xlReadRange ws range: =
		(
		-- variables
			local arr = #()
			local x, y, w, h, row
			
		-- sheet / range
			if range != unsupplied then
				rng = ws.range range
			else
				rng = ws.usedRange
				
			w = rng.columns.count
			h = rng.rows.count
	
		-- data		
			for y = 1 to h do
				(
				row = #()
				for x = 1 to w do
					(
					row[x] = (rng.cells y x).value
					)
				append arr row
				)
		
		-- return
			return arr
		)
		
		
-- code
	(
	-- varibales
		local fileName		= "C:\\temp\\test 4.xls"
	
		local rangeName		= "myRange"	-- a named range
		local rangeRef		= "A1:C4"	-- a range reference
	
	-- open file	
		local wb			= xlOpenFile fileName
		local ws			= wb.activesheet
		
	-- get data
		local allData		= xlReadRange ws
		local someData		= xlReadRange ws range:rangeName
		local someData2		= xlReadRange ws range:rangeRef
		
	-- print data
		print allData
		print someData
		print someData2
		
	-- close file
		xlCloseFile wb
	)