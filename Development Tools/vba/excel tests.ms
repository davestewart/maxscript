
fn ReadExcelData excelFile sheet col row=
(
	local filenames = #()
	
	--xl.Workbooks.Open excelFile
	
	-- get the Workbook. Workbook apparently is the open file.
	if xl.Workbooks.count > 0 do -- number of open files.
(
		thisWorkbook = xl.Workbooks 1
		
		-- get the Worksheet. The "tab" of the spreadsheet.
		thisWorksheet = thisWorkbook.Worksheets sheet
		
		totalRows = thisWorksheet.usedRange.rows.count
		x	= (thisWorksheet.cells row col).value
		
		xl.call "testSubroutine" "Hello!"
)
	-- Shut it all down
	--xl.quit()
	releaseOLEObject xl
	releaseAllOLEObjects() -- probably optional, but who knows?
	
	return x
)
t	= ReadExcelData "c:\\temp\\test.xls" 1 1 1
format "Data is: %\n" t


excelFile = "c:\\temp\\test 3.xls"

xl = CreateOLEObject "Excel.Application"
xl.Workbooks.Open excelFile

wb = xl.activeWorkbook
ws = wb.activesheet

x = xl.Application.run "Sheet1.test" --"dave"

xl.Workbooks.Open

wb.names "result" = "test"

wb.close

wb.Names.Add Name:="result", RefersToR1C1:= =""This is the result"""

wb.Names.Add "result" "Dave"
x = wb.Names.Item "result"
x.value

ws.usedRange.columns.count

xl.application.call
