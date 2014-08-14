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
		local item	= cat.AddChildItem #PropertyItemNumber "Number" "45"
	)
)

createdialog ro1

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
