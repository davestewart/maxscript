utility Credits2 "Simple Credits Maker2" width:162 height:1000
(

	checkbox chk1 "Text on 2 lines" pos:[8,8] width:144 height:16 checked:true
	edittext edt1 "" pos:[16,176] width:128 height:264
	GroupBox grp1 "Names" pos:[8,88] width:144 height:360
	button btn1 "Build Names" pos:[7,555] width:144 height:16
	
	
	radiobuttons rdo1 "Scaling options" pos:[8,488] width:82 height:62 labels:#("Scale width", "Scale height", "None")


	
	------------------------------------------------------------------------------------------
	-- Edit this section to do your thang
	------------------------------------------------------------------------------------------
	
	
	
	-- sets the array
	
	-- copy your names into this field, making sure that each one is in quotes, and each one is separated by commas
		--names = #("Alex Hill", "Alex Pearce", "Alistair Nicol", "Andrew Wilson", "Andy Holmes", "Annette Mehler", "Becky Rowe", "Ben Rassmussen", "Ben Rowe", "Ben Short", "Brian Grindley", "Bryn Bache", "Charlie Asl", "Cathrine Andrews", "Caroline Dove", "Charlie Meachin", "Charlotte Ansell", "Clint ", "Daniel Felstead", "Darren Lever", "Darren Watts", "Dipali Shah", "Dom Northam", "Ellie Curry", "Emma Thompson", "Fiona Tam", "Frazer Hurrell", "Graham Clarkin", "Helen Aliston", "Ina Barnes", "Jane Willy", "Jack Sandham", "James Curry", "James Manning", "Jamie Patterson", "Jason Graham", "Jen & Paddy ", "Jen Findahl", "Jeremy Head", "Jo Donnelly", "Judy Cahill", "Jules Hill", "Kary ", "Kary ", "Katie Newman", "Kevin ASL", "Kris Toone", "Laura Hughes", "Lauren Tipper", "Louise Branch", "Leo Stavropoulos", "Lou WANG", "Martin Lansinger", "Mason O'Dell", "Mathew Wilson", "Matt Jackson", "Matt Revill", "Matt Willey", "Matthew May", "Nick Watmough", "Nicky Gibson", "Olly Hill", "Paddy Haslehurst", "Pete Thompson", "Parbinder Jemahl", "Phil Oatley", "Phung Luu", "Rob Kelly", "Rosa Pilsworth", "Ryan O'Dell", "Sam Berido", "Sam Perry", "Sam Noon", "Stef Brickell", "Sonia German", "Simon Edwin", "Simon Robson", "Steve Clarke", "Steve Yorke", "Tracy Duggan", "Zac Franks")
		--names = #("Alex Hill")
	
	-- set other globals
/*		carriageReturn = 1
		scaleText = 1
		spacing = 1000
		targetWidth = 600
*/	
	
	
	------------------------------------------------------------------------------------------
	-- Main Code - don't touch this
	------------------------------------------------------------------------------------------
	
	on btn1 pressed do
	(
		print edt1.text 

	)
	
	on btn2 pressed do
	(
		
		--sets the animation range
			animationRange = interval 0 a.count
		
		
		-- creates the objects & positions them
			for i = 1 to names.count do (
				
				-- build text & set up text formatting
					obj = text size:100 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					obj.alignment = 2
				
				-- name new item
					if i < 10 then (obj.name = "Name 0" + i as String + " : " + names[i])
					else (obj.name = "Name " + i as String + " : " + names[i])
				
				
				
					
				-- put in carriage returns
					if carriageReturn == 1 then (
						displayText = names[i]
						spaceIndex = findString displayText " " -- find any spaces
						obj.text = replace displayText spaceIndex 1 "\r"
					)
					else
						(
						obj.text  = names[i]
					)
				
		
				-- Set up scaling
					if scaleText == 1 then (
						objWidth = obj.max.x - obj.min.x
						targetScale = targetWidth / objWidth
						addModifier obj (XForm())
						obj.modifiers[#XForm].gizmo.scale *= [targetScale ,targetScale ,targetScale ]
					)
		
				
		
		
				-- set up objects to move
					obj.pos.controller = Position_XYZ ()
				
					addNewKey obj.pos.controller.Z_Position.controller ((i-1) as Time)
					addNewKey obj.pos.controller.Z_Position.controller (i as Time)
					addNewKey obj.pos.controller.Z_Position.controller ((i+1) as Time)
				
					obj.pos.controller.Z_Position.controller.keys[1].value = spacing
					obj.pos.controller.Z_Position.controller.keys[2].value = 0
					obj.pos.controller.Z_Position.controller.keys[3].value = -spacing
			
			)
		)
)