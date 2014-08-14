struct fsFile (name,path,size,type,date)

struct fsFile (name,size,type,date)


f = fsFile()

show ro1.ax.ListItems[1].listsubitems[1]
show ro1.ax.ListItems[1].ListSubItems


show ro1.ax.ListItems[3].ListSubItems.count

showmethods ro1.ax.ListItems[3]

show ro1.ax.columnheaders[1]


show ro1.ax



ro1.ax.SmallIcons


showEvents ro1.ax

on ax ItemClick Item do 



ro1.ax.Appearance		=#ccFlat
ro1.ax.FlatScrollBar	=true
ro1.ax.BorderStyle		=#(#ccNone,#ccFixedSingle)[1]
ro1.ax.View				=#(#lvwIcon,#lvwSmallIcon,#lvwList,#lvwReport)[3]
a=true
if a then print "OK!"



show ro1.ax
.listitems
show ro1.ax.SelectedItem

selectedItems = #()
for i = 1 to ro1.ax.listitems.count do
(
	local item = ro1.ax.listitems[i]
	if item.selected == true then
	(
		append selectedItems item
	)
)
ax.HideColumnHeaders