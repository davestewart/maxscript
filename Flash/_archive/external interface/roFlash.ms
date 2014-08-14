rollout roFlash "Flash Rollout" width:216 height:216
(
	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[8,8] width:200 height:200
	
	on rFlash open do 
	( 
		axFlash.movie = "box.swf"
		axFlash.movie = "box.swf"
	)
		
	on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : %\n" arg1
	on axFlash OnProgress arg1 do format "handler: OnProgress : %\n" arg1

)



createDialog roFlash 216 216


fn getPropsAndPropTypes obj = (
		propString = stringStream ""
		showproperties obj to:propString
		propString = propString as string
		propArray = filterString propString "\n"
		if (propArray.count == 0) then ( return #(#(),#()) )
		propNamesArray = #(); propNamesArray[propArray.count] = undefined
		propTypesArray = #(); propTypesArray[propArray.count] = undefined

		for i = 1 to propArray.count do (
			prop = propArray[i]
			prop = filterString prop ":"
			propNameString = (filterString prop[1] " ")[1]
			propNameString = trimLeft propNameString
			propNameString = trimRight propNameString
			propNamesArray[i] = (subString propNameString 2 -1) as name
			if (prop.count == 2) then (
				propTypeString = prop[2]
				propTypeString = trimLeft propTypeString
				propTypeString = trimRight propTypeString 
				propTypesArray[i] = propTypeString
		)
	)
		#(propNamesArray,propTypesArray)
)
	
f = roFlash.axFlash
props = (getPropsAndPropTypes f)[1]
for p in props do format (getProperty f p)

props = getPropNames f
for p in props do format "% : %\n" (p as string) (getProperty f p)

showmethods f

setproperty f "movie" "box.swf"

f.Movie = "box.swf"


