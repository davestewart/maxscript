rollout r1 "Microsoft ListView Control, version 6.0" 
(
	local controlTypeArr=#(
		#("angle", "ang"),
		#("activeXControl", "ax act"),
		#("bitmap", "bmp"),
		#("button", "btn"),
		#(#checkbox, "chk"),
		#(#checkbutton, "chb ckb"),
		#(#colorpicker, "cp cpk"),
		#(#combobox, "cbx"),
		#(#curvecontrol, "curv crv"),
		#(#dropdownlist, "ddl dd"),
		#(#edittext, "edt"),
		#(#groupBox, "grp"),
		#(#hyperLink, "hyp"),
		#(#imgTag, "img"),
		#(#label, "lbl"),
		#(#listbox, "lbx"),
		#(#mapbutton, "mapbutton"),
		#(#materialbutton, "materialbutton"),
		#(#multilistbox, "mlbx mList "),
		#(#pickbutton, "pck pickbutton"),
		#(#popUpMenu, "pop popUpMenu"),
		#(#progressbar, "pb"),
		#(#radiobuttons, "rdo"),
		#(#slider, "sld"),
		#(#spinner, "spn"),
		#(#subRollout, "sub subRoll"),
		#(#timer, "tmr")
	)

activeXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" height:100 width:220 align:#left 

--on ax Click do format "handler: Click\n" 
--on ax DblClick do format "handler: DblClick\n" 

on r1 open do 
( 
	showProperties ax 
	-- style
		ax.MousePointer = #ccArrow 
		ax.GridLines = true 
		ax.AllowColumnReorder = false 
		ax.BorderStyle = #ccFixedSingle 
		ax.view = #lvwReport
	-- set headers
		chs = ax.columnHeaders 
		--showProperties chs 
		--showMethods chs
		hPrefix = chs.Add index:"Prefix"
		hControlName = chs.Add index:"Control"

	-- populate
		list = ax.listItems 
		for i=1 to controlTypeArr.count do 
		( 
			local li 
			li = list.Add() 
			li.text = controlTypeArr[i][2] as string
			li2=li.listsubitems.add()
			li2.text=controlTypeArr[i][1] as string
		) 

	-- update
		r1.ax.columnHeaders[1].position=2
		r1.ax.refresh()
/*
	-- styling
		for li in ax.listItems do li.bold = true 

	-- hit test
		li = ax.HitTest 100 1500 
		if li != undefined do 
		( 
			showProperties li 
			li.text = "Just Hit Tested" 
			showEvents r1.ax 
			showMethods r1.ax 
		) 
*/
) 
) 
rax = newRolloutFloater "Microsoft ListView Control, version 6.0" 350 300 10 10 
addRollout r1 rax

/*
show r1.ax.ListItems[1].subItems
lix=r1.ax.ListItems[1].listsubitems.add()
lix.text="hkkjhk"

r1.ax.Arrange=#lvwAutoTop --: ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )
 r1.ax.ColumnHeaders.clear() --: IColumnHeaders
showmethods r1.ax.ColumnHeaders
r1.ax.ColumnHeaders[1].Alignment--=#lvwColumnRight 
r1.ax.ColumnHeaders.Add index:2
r1.ax.ColumnHeaders._NewEnum()
show r1.ax
r1.ax.SortOrder=#lvwDescending
r1.ax.AllowColumnReorder
.startlabeledit()
r1.ax.Column
showmethods r1.ax
print (getpropnames r1.ax.columnHeaders[1])
r1.ax.columnHeaders[1].position=2
r1.ax.refresh()
r1.ax.columnHeaders[2].width=2500
r1.ax.columnHeaders[1].width=5000
r1.ax.FullRowSelect=false
show r1.ax.items[1]
*/
