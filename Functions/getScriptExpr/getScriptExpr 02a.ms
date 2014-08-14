function exprForController =
(
	-- storage
		local expr = ""
		
	-- nested function
		function getSubAnims src trg path =
		(
			local sas = getSubAnimNames src
			if sas != undefined do
			(
				for sa in sas do
				(
					local ctrl = src[sa].controller
					local temp = path + "[#" + sa + "]"
		
					if ctrl != undefined AND ctrl == trg then
					(
						-- success!
						expr = temp + ".controller"
					)
					else(
						-- failure
						getSubAnims src[sa] trg temp
					)
				)
			)
		)
		
		-- get the source object if unsupplied
			local obj = exprformaxobject trg explicitNames:true
			local src = execute (filterstring obj ".")[1]
	
		-- recurse through src and attempt to find target controller
			getSubAnims src trg ("$" + src.name)
			
		-- return the final script path
			expr 
)

-- objects
	trg        = $.pos.controller[2].controller -- second controller in a position list
	trg        = $.radius.controller
	
-- get the expression
	expr    = exprForController trg
	trg == (execute expr)

-- results
	-- "$Teapot01[#transform][#position][#Pos_2].controller"
	-- true

