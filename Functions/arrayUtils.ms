struct arrayUtils
(
	function shrink arr = 
	(
		for i = arr.count - 1 to 1 by -1 do
		(
			if arr[i] == arr[i + 1] do deleteItem arr i
		)
		arr
		),
	
	function implode arr delimiter =
	(
		local str = ""
		for i = 1 to arr.count do
		(
			str += arr[i] as string
			if i < arr.count do str += delimiter
		)
		str
	)

)
	
arrayUtils.shrink #(1,1,2,3,5,6,8,8,9)

arrayUtils.implode #(1,1,2,3,5,6,8,8,9) " - "


