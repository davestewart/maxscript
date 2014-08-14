-- (c) Pietro Salerno 2007 info@3rdpole.com
-- align particle (z upper) to vertex normal ( plus stick to vertex position )

on ChannelsUsed pCont do
(
  pCont.useOrientation = true
  pCont.usePosition = true
  pCont.useSpeed = true
)

on Init pCont do 
(
 global obj = $Container
 global vCount = getNumVerts obj
)

on Proceed pCont do 
(

  for i in 1 to vCount do
    (
    
	-- particle creation
    pCont.particleIndex = i
   
	-- particle position (stick it)
	vpos = getVert obj i
    pCont.particlePosition = vpos
	
	-- particle align , align particle to vertex normal
	-- It rocks!!!???
	
	nvert = getnormal obj i
    yangle = -asin (nvert[1])
	xangle = -atan2(-nvert[2]) (nvert[3])
	pCont.particleorientation= [xangle,yangle,0]

    )

)

on Release pCont do 
(
)
