for m in $.modifiers do
(
	propArr = getPropNames m
	for p in propArr do(
		 format "%\n" (execute(m+"."+p as string))
	)

)


for m = 1 to $.modifiers.count do
(
	propArr = getPropNames $.modifiers[m]
	for p in propArr do(
		 format "%\n" (execute(" classof $.modifiers["+m as string+"]."+p as string)==SubAnim)
	)
	/*
*/
)

