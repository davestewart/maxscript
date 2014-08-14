fn showHier obj d=
	(
-- if this is the root then print the name
	if d==1 then format "%\n" obj.name

-- get children and sort
	local arr = #()
	for c in obj.children do append arr c.name
	arr = sort arr

--print the hierarchy
	for c in arr do
		(
		local str=""
		if (getNodeByName c).isFrozen then str+=">"
		for i = 1 to d do str+=" "
		format "%\n" (str + c)
		showHier (getNodeByName c) (d+1)
		)
	)

