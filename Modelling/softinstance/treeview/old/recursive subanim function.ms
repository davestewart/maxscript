fn pad d=
	(
	local str = ""
	for i = 1 to d do str+="	"
	return str
	)

fn recurseSubAnims obj d=
	(
	d+=1
	n = obj.numSubs
	for i = 1 to n do
		(
		format "% %\n" (pad d) obj[i]
		recurseSubAnims obj[i] d
		)
	)

recurseSubAnims $ 0
$tube01.modified_object


getSubAnimName $.modifiers[#Taper] 3
exprformaxobject $[3]