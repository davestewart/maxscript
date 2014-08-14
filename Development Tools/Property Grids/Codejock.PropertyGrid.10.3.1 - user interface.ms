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
		local item	= cat.AddChildItem #PropertyItemNumber "Number" 45
		)
	)

createdialog ro1