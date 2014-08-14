fn parseNumber str all:false type:Integer=
	(
	local n,i
	n=(filterstring str "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")[1]
	i=(findstring str n)-1
	str=substring str 1 i
	return if all then #(str,n as type) else n as type
	)

parseNumber "object13"
--13

parseNumber "object13" type:string
--"13"

parseNumber "object13" all:true
--#("object", 13)

parseNumber "object13" all:true type:string
--#("object", "13")

parseNumber "o bj 13.056" all:true
--13.056
"1s" as float

"1m1s1f" as integer 