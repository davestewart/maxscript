srcObj=pickObject prompt:"Pick source object"
trgObj=$
propArr=getPropNames srcObj

for prop in propArr do
(
	obj = trgObj.baseObject[prop]
	--format "obj:  %\n" obj
	try (
		val = getProperty srcObj.baseObject prop
		setProperty trgObj prop val
		format "OK:   % >>> %\n" prop srcObj.baseObject[prop].value
	)
	catch(
		--format "FAIL: %\n" prop 
	)
	)