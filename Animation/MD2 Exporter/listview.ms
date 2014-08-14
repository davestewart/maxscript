rollout roListView "ListView Selected"
(
	 
	fn initListView lv =
(
		-- props
			lv.gridLines = true
		
		--The following controls the display of details. We use defaults:
			lv.View = (dotNetClass "System.Windows.Forms.View").Details
			lv.fullRowSelect = true --same as in ActiveX 
			 
			layout_def = #("Animation Name", "Start Frame", "End Frame", "Steps", "Material")
	
		--add column with name and optional width
			for i in layout_def do
			lv.Columns.add i 96
) 
	 

	fn fillInSpreadSheet lv =
(
		 --array to collect the list items
			theRange = #()

		-- do it
			for o in selection do
		(
				 --First we create a ListViewItem object with the object's name:
					li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
			
				--Then we add all the sub-items with the desired string values:
					sub_li = li.SubItems.add ((classof o) as string)
					sub_li = li.SubItems.add (try((o.mesh.numverts) as string)catch("--"))
					sub_li = li.SubItems.add (try((o.mesh.numfaces) as string)catch("--"))
					sub_li = li.SubItems.add ((o.material) as string)
					append theRange li --we add the list item to the array
		)
		
		--when done, we populate the ListView
			lv.Items.AddRange theRange
) 
	 

	dotNetControl lv "System.Windows.Forms.ListView" width:490 height:190 align:#center 
	 
	on roListView open do 
(
		initListView lv
		fillInSpreadSheet lv
) 
	
	on lv DoubleClick e do
(
		format "%\n" e
)
	
)
try(destroyDialog roListView)catch()
createDialog roListView 500 200

roListView.lv.labelEdit = true
roListView.lv.items.item[0].BeginEdit()

roListView.lv.items.item[0].subItems.item[1].text = "jkjh"

--show roListView.lv.Sorting = 
showevents roListView.lv