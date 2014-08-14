rollout rAccelState "State" 
( 
	checkButton accelState "Test" 
	on rAccelState open do 
	( 
		accelState.text = if (enableAccelerators) then "Enabled" else "Disabled" 
		accelState.checked = enableAccelerators 
	) 
	on accelState changed state do 
	( 
		enableAccelerators = state 
		accelState.text = if (enableAccelerators) then "Enabled" else "Disabled" 
	) 
) 

rollout roColor "Color Picker" width:100 height:100
(
	colorPicker cp1 "" width:90 height:90 pos:[4,4]

	on cp1 changed col do
	(
		curItem.value = (color col.b col.g col.r)
	)
	on roColor open do
	(
		messagebox "opened"
		local col =(color 255 0 0)
		cp1.changed col
	)
)

rollout rProp "Property Grid" 
( 

-- interface
	activeXControl axProp "{DBB2628C-1E1F-48EF-8004-31A16D92A564}" height:300 width:401 align:#left 
--	activeXControl axProp "{304c3e22-16aa-11d4-a300-0080ad783220}" height:151 width:401 align:#left 

	button btnSet "Set properties" width:400 height:16
	
	button btnProps "Props" width:130 height:16 align:#left across:3
	button btnMethods "Methods" width:130 height:16 align:#left
	button btnEvents "Events" width:130 height:16 align:#left


	on btnSet pressed do 
	(
	--rProp.axProp.Nodes.Add "hel"
	

		local Category = axProp.AddCategory "Misc (Active)"


		Category.Flags=#ItemHasComboButton
		Category.Constraints.Add "Active"
		Category.Constraints.Add "Inactive"
		Category.Value="Misc"
		

		Category.AddChildItem 0 "Text" "Hello"
		Category.AddChildItem 1 "Boolean"
		Category.AddChildItem 2 "Boolean"
		Category.AddChildItem 3 "BgColor" "&H0FF00FF"--(color 128 128 128)
		Category.AddChildItem 4 "Font"

		Category2 = axProp.AddCategory "Misc"
		Category2.AddChildItem 0 "Text" "Hello"
		Category2.AddChildItem 1 "Boolean"
		Category2.AddChildItem 2 "Boolean"
		Category2.AddChildItem 3 "BgColor" "&H0FF00FF"--(color 128 128 128)
		Category2.AddChildItem 4 "Font"


		local ItemAlign = Category2.AddChildItem 0 "Align" "Left"
		ItemAlign.Flags = #ItemHasComboButton
		--rProp.axProp.Categories[1].childs[3].flags
		ItemAlign.Constraints.Add "Left"
		ItemAlign.Constraints.Add "Center"
		ItemAlign.Constraints.Add "Right"
		Category.Expanded = True
		Category2.Expanded = True

--		PropertyGrid_ValueChanged Nothing
/*
*/
	-- styling
	local styles=#("xtpGridThemeDefault", "xtpGridThemeNativeWinXP", "xtpGridThemeOffice2003", "xtpGridThemeCool", "xtpGridThemeSimple", "xtpGridThemeDelphi")
	axProp.VisualTheme = styles[4] as name


	)

--show rProp.axProp.categories[1]
on axProp ValueChanged Item do
(
	if item.type==#PropertyItemString then
		item.caption=item.value + " ("+item.value as string+")"
	format ">%\n" item.type
 )

on axProp RClick Item do 
(
--	if item == Categories[1].childs[2]
--		messagebox item.index as string
	show item
	if item.type==#PropertyItemColor then
	(
		global curItem=item
		--messagebox "Item is Color"
		createdialog roColor 100 100 mouse.screenpos[1] mouse.screenpos[2] modal:true


	)

)

--rProp.

	on btnProps pressed do showproperties axProp
	on btnMethods pressed do showmethods axProp
	on btnEvents pressed do showevents axProp

) 
propFloater = newRolloutFloater "Grid" 450 450 10 10 
addRollout rProp propFloater 
addRollout rAccelState propFloater 
