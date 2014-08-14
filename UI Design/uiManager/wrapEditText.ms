rollout r1 "Untitled" width:162 height:300
(


	editText edt1 "" pos:[4,8] width:148 height:48 wraptext:true
	
	function arrayImpode arr delimiter =
	(
		local str = ""
		for i = 1 to arr.count do
		(
			str += arr[i] as string
			if i < arr.count do str += delimiter
		)
		str
	)
	
	function wrapEditText edt =
	(
		local delim		= " "
		local lines 	= #()
		local line		= ""
		local exts		= point2 0 0
		
		
		local words		= filterstring edt.text "\n"
		words			= arrayImpode words ""
		words			= filterstring words delim
		
		for word in words do
		(
			line	+= word + delim
			exts	= getTextExtent line
			if exts.x > edt.width do
			(
				append lines line
				line = ""
			)
		)
			
		lines = join #(line) lines
		--print lines
		--print (arrayImpode lines delimiter:"\n")
		edt.text = arrayImpode lines "\n"
	)
	
	on edt1 changed text do wrapEditText edt1
	
)
createdialog r1

