-- functions
-- 	getPos
-- 	getRot
-- 	getScale
-- 	getRollAngle
-- 	getCamZoom
-- 	getLightIntensity
-- 	getLightConeAngle
-- 	getLightConeFeather
-- 	getColor
-- 	getTime


-- 	getControllerKeyValueString prop

-- 		declarations
--  			frames
-- 			tArr, vArr
-- 			tStr, vStr

-- 		according to prop

-- 			frames
-- 				getKeyFrames prop
-- 				getInbetweenFrames

-- 			for all frames
-- 				getTime -> tArr
-- 				getValue prop -> vArr

-- 			build tStr
-- 			build vStr

-- jsx script

-- 	open filestream

-- 	write core jsx functions
-- 	
-- 	for each node
-- 		 	
-- 		Plane
-- 		Rectangle
-- 		Text
-- 		Helper
-- 		Camera
-- 		Spot
-- 		Omni
-- 		Directional
-- 	
-- 			declare jsx stringstream

-- 				write base properties
-- 					name
-- 					class
-- 					width / height
-- 					color
-- 	
-- 				for checked controllers
-- 					pos
-- 					rot
-- 					scale
-- 					target
-- 					props
-- 					
-- 						getControllerKeyValueString prop
-- 					
-- 				add to objArr
-- 			
-- 			write stringsteam to filestream

-- 	run object looper
-- 	
-- 	warnings
-- 	
-- 	delete script
-- 	
-- 	close filestream
-- 	
-- call after effects with script file