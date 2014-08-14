----------------------------------------------------------------------------------
-- Rollout (UI) Code
----------------------------------------------------------------------------------

rollout ro1 "Codejock.PropertyGrid.10.3.1" width:360 height:320
(
	activeXControl ax1 "Codejock.PropertyGrid.10.3.1" pos:[8,8] width:344 height:304
	on ro1 open do
	(
		--   .AddCategory Title:string
		local cat	= ax1.AddCategory "New Category"

		--   .AddChildItem Type:PropertyItemType( #PropertyItemString | #PropertyItemNumber | #PropertyItemBool | #PropertyItemColor | #PropertyItemFont | #PropertyItemDouble | #PropertyItemDate | #PropertyItemPicture | #PropertyItemEnum | #PropertyItemEnumFlags | #PropertyItemCategory ) Title:string Value:undefined
		local arr = #(	#PropertyItemString,
						#PropertyItemNumber,
						#PropertyItemBool,
						#PropertyItemColor,
						#PropertyItemFont,
						#PropertyItemDouble,
						#PropertyItemDate,
						#PropertyItemPicture,
						#PropertyItemEnum,
						#PropertyItemEnumFlags,
						#PropertyItemCategory)

		for i = 1 to arr.count do
		(
			local type	= i - 1
			local label	= (arr[i] as string)
			local value	= (random 0 100) as string
			local item	= cat.AddChildItem type label value
			
			if label == "PropertyItemEnum" do
			(
				item.Constraints.Add "1-point"
				item.Constraints.Add "2-point"
				item.Constraints.Add "4-corner pin"
			)

		)
			
	)
		
	  on ax1 RequestEdit Item Cancel do
	  (
		enableAccellerators = false
		print "edit: " + Item.caption
	  )

)

createdialog ro1


/*
item = ro1.ax1.categories[1].Childs[9]
show ro1.ax1
item.Constraints.Add "1-point"
item.Constraints.Add "2-point"
item.Constraints.Add "4-corner pin"

item.Constraints.Clear()

item = ro1.ax1.categories[1].Childs[8]
s = stringstream ""
show item to:s
display 
b = bitmap 10 10
 item.PicturePath
apropos "bitmap"
item.height = 10

viewbitmap

showevents ro1.ax1--.categories[1].Childs[9]

ro1.ax1.VisualTheme = #xtpGridThemeNativeWinXP 
--: XTPPropertyGridVisualTheme( #xtpGridThemeDefault | #xtpGridThemeNativeWinXP | #xtpGridThemeOffice2003 | #xtpGridThemeCool | #xtpGridThemeSimple | #xtpGridThemeDelphi | #xtpGridThemeWhidbey )

*/

----------------------------------------------------------------------------------
-- Error code produced
----------------------------------------------------------------------------------
/*
Rollout:ro1
-- Error occurred in ro1.open()
--  Frame:
--   cat: IPropertyGridItem
--   Item: undefined
>> MAXScript Rollout Handler Exception: -- Runtime error: ComObject method call failed, AddChildItem() <<
true
OK
*/
enableAccellerators = true

/*


ro1.ax1.categories.remove 2

obj = ro1.ax1--.Categories[1]
obj = ro1.ax1.Categories
obj = ro1.ax1.Categories

obj = obj[1]

showproperties obj 
showmethods obj 
showevents obj

i = cat.AddChildItem "PropertyItemString" "Age" "45"
ro1.ax1.Categories[1].AddChildItem ()
item	= cat.AddChildItem #PropertyItemNumber "Number" 45"

*/
