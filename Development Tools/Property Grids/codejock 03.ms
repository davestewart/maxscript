----------------------------------------------------------------------------------
-- Rollout (UI) Code
----------------------------------------------------------------------------------

rollout ro1 "Codejock.PropertyGrid.10.3.1" width:360 height:320
	(
	----------------------------------------------------------------------------------
	-- UI
	
		activeXControl ax1 "Codejock.PropertyGrid.10.3.1" pos:[8,8] width:344 height:304
		
	----------------------------------------------------------------------------------
	-- variables
	
		
	----------------------------------------------------------------------------------
	-- fns
	
		fn getType prop =
			(
			case (classof prop) of
				(
				String: 0		--String
				Integer: 1		--Number
				BooleanClass: 2	--Bool
				Color: 3		--Color
				"Font": 4
				Float: 5		--Double
				"Date": 6
				Bitmaptexture: 7--Picture
				Array: 8		--Enum
				Array: 9		--Enum
				"Category": 10
				default: -1
				)
			)	

		fn setType str type =
			(
			type = case type of
				(
				"String":		str as String
				"Integer":		str as Integer
				"BooleanClass":	str as BooleanClass
				"Color":
					(
					local arr = filterstring str ";"
					color (arr[1] as float) (arr[2] as float) (arr[3] as float) 
					)
				"Font":			4
				"Float":		str as Float
				"Date":			6
				"Bitmaptexture":str as Bitmaptexture
				"Array": 		str as Array
				"Category":		10
				default: -1
				)
			)	

	
	
	----------------------------------------------------------------------------------
	-- functions
	
		fn test1 = 
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
			
		
		local obj
			
			
		fn test2 =
			(
			if $ != undefined then
				(
				obj = $
				local cat	= ax1.AddCategory $.name
				cat.expanded = true
				
				-- appearance
					local catApp	= cat.AddChildItem 10 "Appearance"
					catApp.expanded = true
					local props = #(#material,#wirecolor)
					for prop in props do
						(
						local label	= prop as string
						local value	= getProperty obj prop
						local type	= getType value
						
						local item	= catApp.AddChildItem type label (value as string)
						item.tag	= (classof value) as string
						)
	
				-- properties
					local catProps	= cat.AddChildItem 10 "Properties"
					catProps.expanded = true
					local props = getpropnames $
					for prop in props do
						(
						local label	= prop as string
						local value	= getProperty obj prop
						local type	= getType value
						
						local item	= catProps.AddChildItem type label (value as string)
						item.tag	= (classof value) as string
						)
						
				)
			)
		----------------------------------------------------------------------------------
	-- handlers
	
		on ro1 open do
			(
			test2()
			)
			
		  on ax1 RequestEdit Item Cancel do
		  	(
			enableAccellerators = false
			print "edit: " + Item.caption
		  	)
	
		  on ax1 AfterEdit Item strValue Cancel do
		  	(
			enableAccellerators = true
			local prop	= Item.caption
			local value	= setType strValue Item.tag
			setproperty obj prop value
		  	)
	
	)
createdialog ro1


showmethods ro1.ax1.categories[1]

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

obj = ro1.ax1
obj.ViewForeColor = color 0 0 0
obj.ViewCategoryForeColor = color 80 80 80
obj.ViewCategoryBackColor = color 255 200 200
obj.ToolBarVisible = true
obj.NavigateItems = true

show obj.selected.value
.CheckBoxStyle = True

obj = obj[1]

showproperties obj 
showmethods obj 
showevents obj

i = cat.AddChildItem "PropertyItemString" "Age" "45"
ro1.ax1.Categories[1].AddChildItem ()
item	= cat.AddChildItem #PropertyItemNumber "Number" 45"

*/
