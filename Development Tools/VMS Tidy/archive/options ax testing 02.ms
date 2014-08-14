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

	GroupBox grp1 "Auto-Rename / renumber" pos:[8,8] width:192 height:128
	label lbl1 "Renumber / rename controls that start with the following..." pos:[16,24] width:176 height:32
	ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,48] width:176 height:80 

	GroupBox grpOther "Other" pos:[8,144] width:192 height:72
	checkbox chk1 "Comment dubious code" pos:[16,160] width:136 height:16
	radiobuttons rdo1 "Dubious code" pos:[16,184] width:149 height:30 labels:#("Comment", "Delete") columns:2

	button btnDone "Done" pos:[8,224] width:192 height:16
/*
	on VMSTidyOptions open do
(
	local str=""
	for s in (getpropnames VMSTidy.VMSTidyControlList) do str+=((s as string) + "; ")
	--edtRename.text=str
)
*/
	on r1 open do 
	(
		-- style
			ax.MousePointer = #ccArrow 
			ax.GridLines = true 
			ax.AllowColumnReorder = false 
			ax.BorderStyle = #ccFixedSingle 
			ax.view = #lvwReport

		-- set headers
			ch = ax.columnHeaders 
			hPrefix = ch.Add index:"Prefix"
			hControlName = ch.Add index:"Control"
	
		-- populate
			list = ax.listItems
			for i=1 to controlTypeArr.count do 
			(
				local itemHead, itemBody
				itemHead = list.Add index:(controlTypeArr[i][2] as string)
				itemBody = itemHead.listsubitems.add index:(controlTypeArr[i][1] as string)
			) 
	
		-- update interface
			r1.ax.columnHeaders[1].position=2
			r1.ax.refresh()
	)

	on ax BeforeLabelEdit arg do enableAccelerators=false
	on ax AfterLabelEdit arg1 arg2 do enableAccelerators=true
) 
rax = newRolloutFloater "Microsoft ListView Control, version 6.0" 350 300 10 10 
addRollout r1 rax
