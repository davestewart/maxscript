global ro1

rollout ro1 "Microsoft ListView Control, version 6.0" width:231 height:259
(
	ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[13,7] width:300 height:200 
	button btn1 "Fill List" pos:[16,216] width:100 height:16
	button btn2 "Make Spheres" pos:[16,232] width:100 height:16
	button btn3 "showProperties" pos:[16,248] width:100 height:16
	button btn4 "showMethods" pos:[16,264] width:100 height:16

	button btn5 "Change List" pos:[116,216] width:100 height:16
	button btn6 "Add Items" pos:[116,232] width:100 height:16

	function axClick obj =
		(
		--select (getNodeByName obj)
		print obj
		)
/*
*/
	
	on ro1 open do
		(
		ax.MousePointer = #ccArrow 
		ax.GridLines = true 
		ax.AllowColumnReorder = true 
		ax.BorderStyle = #ccFixedSingle 
		ax.view = #lvwReport 
		--ax.Checkboxes=true
		ax.FullRowSelect = true
		
		chs = ax.columnHeaders
		
		--showProperties chs 
		--showMethods chs
		
		colLabels = #("Col_1","Col_2","Col_3","Col_4","Col_5")
		
		for i = 1 to 10 do
			(
			--print (colLabels[i])
			--execute(colLabels[i] + "=")
			chs.Add()
			--execute(colLabels[i] + ".text = " + colLabels[i] as string)

			)

--		hSetting = chs.Add() 
--		hTime = chs.Add() 
--		hSetting.text = "Render Setting" 
--		hTime.text = "Last render time"
		
		ax.MultiSelect = true
		
		)
	
	
	on ax click do
		(
		axClick ax.SelectedItem.text
		)

	
	on btn1 pressed do
		(
		lis = ax.listItems 
		for i=1 to 10 do 
			( 
			local li 
			li = lis.Add() 
			li.text = "Sphere0" + i as string
			)
		)

	on btn2 pressed do
		(
		--showProperties ax.ListItems
		Sphere()
		for i = 1 to 10 do copy $Sphere01 pos:[random -100 100,random -100 100,random -100 100]
		)
	
	on btn3 pressed do
		(
		showProperties ax
		format"\n"
		)
	on btn4 pressed do
		(
		showMethods ax
		format"\n"
		)

	on btn5 pressed do
		(
		for i = 1 to ax.ListItems.count do
			(
			ax.ListItems[i].text = random 0 500
			)
		)

	on btn6 pressed do
		(
		for i = 1 to 10 do
			(
			li = ax.listItems.Add() 
			str = "Item " + i as string
			li.text = str
			for j = 2 to 10 do
				(
				lsi = ax.ListItems[i].ListSubItems.add()
				str = str = "Item " + ((10*(i-1))+j) as string
				lsi.text = str
				)
			)
		)



	)


if axFloater != undefined then closerolloutfloater axFloater 
	axFloater = newRolloutFloater "Microsoft ListView Control, version 6.0" 350 380 10 10 
	addRollout ro1 axFloater


/*

ActiveX object properties
  .Arrange : ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )
  .ColumnHeaders : IColumnHeaders
  .DropHighlight : IListItem
  .DropHighlight : undefined, read-only
  .HideColumnHeaders : boolean
  .HideSelection : boolean
  .Icons : IVBDataObject
  .Icons : undefined, read-only
  .ListItems : IListItems
  .LabelEdit : ListLabelEditConstants( #lvwAutomatic | #lvwManual )
  .LabelWrap : boolean
  .MouseIcon : IPictureDisp
  .MousePointer : MousePointerConstants( #ccDefault | #ccArrow | #ccCross | #ccIBeam | #ccIcon | #ccSize | #ccSizeNESW | #ccSizeNS | #ccSizeNWSE | #ccSizeEW | #ccUpArrow | #ccHourglass | #ccNoDrop | #ccArrowHourglass | #ccArrowQuestion | #ccSizeAll | #ccCustom )
  .MultiSelect : boolean
  .SelectedItem : IListItem
  .SelectedItem : undefined, read-only
  .SmallIcons : IVBDataObject
  .SmallIcons : undefined, read-only
  .Sorted : boolean
  .SortKey : integer
  .SortOrder : ListSortOrderConstants( #lvwAscending | #lvwDescending )
  .View : ListViewConstants( #lvwIcon | #lvwSmallIcon | #lvwList | #lvwReport )
  .OLEDragMode : OLEDragConstants( #ccOLEDragManual | #ccOLEDragAutomatic )
  .OLEDropMode : OLEDropConstants( #ccOLEDropNone | #ccOLEDropManual )
  .Appearance : AppearanceConstants( #ccFlat | #cc3D )
  .BackColor : OLE_COLOR
  .BorderStyle : BorderStyleConstants( #ccNone | #ccFixedSingle )
  .Enabled : boolean
  .Font : IFontDisp
  .ForeColor : OLE_COLOR
  .hWnd : OLE_HANDLE
  .AllowColumnReorder : boolean
  .Checkboxes : boolean
  .FlatScrollBar : boolean
  .FullRowSelect : boolean
  .GridLines : boolean
  .HotTracking : boolean
  .HoverSelection : boolean
  .Picture : IPictureDisp
  .PictureAlignment : ListPictureAlignmentConstants( #lvwTopLeft | #lvwTopRight | #lvwBottomLeft | #lvwBottomRight | #lvwCenter | #lvwTile )
  .ColumnHeaderIcons : IVBDataObject
  .ColumnHeaderIcons : undefined, read-only
  .TextBackground : ListTextBackgroundConstants( #lvwTransparent | #lvwOpaque )
IListItem

List Item properties
  .Text : string
  .Ghosted : boolean
  .Height : float
  .Icon : undefined
  .Index : integer
  .Key : string
  .Left : float
  .Selected : boolean
  .SmallIcon : undefined
  .Tag : undefined
  .Top : float
  .Width : float
  .SubItems[Index:integer] : string
  .ListSubItems : IListSubItems
  .Checked : boolean
  .ForeColor : OLE_COLOR
  .ToolTipText : string
  .Bold : boolean
  
List Item methods
  .Add Index:undefined Key:undefined Text:undefined Icon:undefined SmallIcon:undefined
  .Clear()
  .Remove Index:undefined
*/
