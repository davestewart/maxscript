-- SubObject Mode MacroScript File
--
-- Created:  		June 14 2000
-- Last Updated: 	Jan 3 2002 Fred Ruff - Changed to SubObject Level macros.
--
-- Author :   Frank DeLise
-- Version:  3ds max 4
--
-- 
-- SubObject operations Macroscript file.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- 



MacroScript SubObject_1
ButtonText:"Vertex\Knot"
Category:"Modifier Stack" 
internalCategory:"Modifier Stack" 
Tooltip:"Sub-Object Level 1"
Icon:#("SubObjectIcons",1)
(
	On Execute do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		Try(If SubObjectLevel != 1 then SubObjectLevel = 1 Else SubObjectLevel = 0)Catch()
	)
) 
MacroScript SubObject_2
ButtonText:"Edge/Segment"
Category:"Modifier Stack" 
internalCategory:"Modifier Stack" 
Tooltip:"Sub-Object Level 2"
Icon:#("SubObjectIcons",2)
(
	On Execute do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		Try(If SubObjectLevel != 2 then SubObjectLevel = 2 Else SubObjectLevel = 0)Catch()
	)
) 
MacroScript SubObject_3
ButtonText:"Face/Border/Spline/Patch"
Category:"Modifier Stack" 
internalCategory:"Modifier Stack" 
Tooltip:"Sub-Object Level 3"
Icon:#("SubObjectIcons",3)
(
	On Execute do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		Try(If SubObjectLevel != 3 then SubObjectLevel = 3 Else SubObjectLevel = 0)Catch()
	)
) 
MacroScript SubObject_4
ButtonText:"Polygon/PatchElement"
Category:"Modifier Stack" 
internalCategory:"Modifier Stack" 
Tooltip:"Sub-Object Level 4"
Icon:#("SubObjectIcons",4)
(
	On Execute do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		Try(If SubObjectLevel != 4 then SubObjectLevel = 4 Else SubObjectLevel = 0)Catch()
	)
) 

MacroScript SubObject_5
ButtonText:"Element"
Category:"Modifier Stack" 
internalCategory:"Modifier Stack" 
Tooltip:"Sub-object Level 5"
Icon:#("SubObjectIcons",5)
(
	On Execute do
	(
		If SubObjectLevel == undefined then Max Modify Mode
		Try(If SubObjectLevel != 5 then SubObjectLevel = 5 Else SubObjectLevel = 0)Catch()
	)
) 
 
