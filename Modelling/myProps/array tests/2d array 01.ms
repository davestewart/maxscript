
myObjects = #()
myObjectsMods = #()
myObjectsModsProps = #()
myObjectsModsPropsClasses = #()
myObjectModsValues = #()

for i in objects do	append myObjects i -- put all the names into an array
myObjectsMods = myObjects[1].modifiers -- put all modifier names into array
 for i = 1 to 10 do append myObjectModsClasses i
for i in myObjects do append myObjectsMods (getPropNames i) -- put all property names into array





/*-------------------------------------------------------------------------------------------------
-- Temp Code Start
---------------------------------------------------------------------------------------------------








---------------------------------------------------------------------------------------------------
-- Temp Code End
-------------------------------------------------------------------------------------------------*/
