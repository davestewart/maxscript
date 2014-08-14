rollout ro1 "Untitled" width:432 height:296
(
	activeXControl ax "{46FFC6B5-D62D-4C11-A97B-F1205AF6ABCF}" pos:[8,8] width:416 height:224
)
createdialog ro1

--showmethods ro1.ax
--show ro1.ax

igrid=ro1.ax
igrid.AddCol "Column 1"
igrid.AddCol "Column 2"
for i = 1 To 10 do
   	(
	r=igrid.AddRow()
	print r
	--igrid.CellValue(i, 1) = i as string --+ ", 1"
	--igrid.CellValue(i, 2) = i as string --+ ", 2"
	)
/*
show igrid

igrid.RowKey[1]

showmethods igrid
igrid.SetCurCell 1 1
cell

igrid.currow=2
igrid.curcol=2
c=getIndexedProperty igrid #ColDefaultCell 1
c.vValue = "kuhkjhkjh"
c=getIndexedProperty igrid #SetCurCell 1


c=igrid.SetCurCell 5 2
c
*/

showallactivexcontrols()



igrid.CellValue[1][1] = "hello"
.CellValue(lRow, 1) = lRow & ", 1" 
getproperty igrid #cellValue
igrid.GridLines=#igGridLinesHorizontal