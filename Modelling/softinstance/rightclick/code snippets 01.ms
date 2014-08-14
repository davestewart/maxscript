srcObj = $
obj = srcObj.modifiers[2]
propArr=getPropNames obj
prop = propArr[8]
propClass = classof (getproperty obj prop)


srcObj.modifiers[obj.name][prop]

--for p in obj[prop] do print p

getSubAnimNames obj[prop]


for p in (getSubAnimNames obj[prop]) do print p



srcObj = undefined
obj = undefined
propArr = undefined
prop = undefined
propClass = undefined


srcObj.modifiers[obj.name][prop]

--for p in obj[prop] do print p

getSubAnimNames obj[prop]


for p in (getSubAnimNames obj[prop]) do print p


function printNode obj level=
(
	format "%\n" obj
	format "%\n" (classof obj)
)


n = 1
printNode $.modifiers[n] n