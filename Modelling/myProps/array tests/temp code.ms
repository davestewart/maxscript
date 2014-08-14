/*
-------------------------------------------------------------------------------------------------
-- Temp Code Start
---------------------------------------------------------------------------------------------------


	data = structObjInfo obj:mySelection[obj] name:mySelection[obj].name stack:mySelection[obj].modifiers

		--print obj.modifiers[mod].name as String
		/*
		for prop in mod do
		(
			
		)
		*/



curMod = 1
curModName = $.modifiers[position]
curModProps = getPropNames $.modifiers[position]

myModTest = myMod position:curMod name:curModName props:curModProps 


Object





---------------------------------------------------------------------------------------------------
-- Temp Code End
-------------------------------------------------------------------------------------------------
*/


for p in getPropNames $ do format "% = %\n" p (getProperty $ p) 