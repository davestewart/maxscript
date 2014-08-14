trg = $.pos.controller[1].controller
exprformaxobject trg





global scriptExpr = ""

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
				scriptExpr = temp + ".controller"
			)
			else(
				getSubAnims src[sa] trg temp
			)
		)
	)
)
	
function getScriptExpr trg =
(
	-- get the source object if unsupplied
		if src == unsupplied do
		(
			local expr = exprformaxobject trg explicitNames:true
			src = execute (filterstring expr ".")[1]
		)

	-- recurse through src and attempt to find target controller
		getSubAnims src trg ("$" + src.name)
		
	-- return the final script path
		scriptExpr
)



expr = getScriptExpr trg
--scriptExpr 


--getSubAnims src undefined ""
