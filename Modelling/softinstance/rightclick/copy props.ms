srcObj=pickObject prompt:"Pick source object"
trgObj=$
--pickObject prompt:"Pick Target object"

propArr=getPropNames srcObj

for prop in propArr do
	(
	obj = trgObj.baseObject[prop]
	--format "obj:  %\n" obj
	try (
		trgObj.baseObject[prop].value = srcObj.baseObject[prop].value
		format "OK:   % >>> %\n" prop srcObj.baseObject[prop].value
		)
	catch(
		--format "FAIL: %\n" prop 
		)
	)
//$.baseObject[#Emitter_Rad_Len].value