on ChannelsUsed pCont do 
( 
pCont.useposition = true 
) 

on Init pCont do 
( 
global my_mesh = $'globe - base'
) 

on Proceed pCont do 
( 
if my_mesh != undefined AND isvalidnode my_mesh do 
	( 
	t = pCont.getTimeStart() as float 
	NumVerts = getNumVerts my_mesh 
	progressStart "Updating particle birth script..."

	if t < 0 do 
		( 
			for i = 1 to NumVerts do 
				(
				pCont.AddParticle() 
				pCont.particleIndex = pCont.NumParticles() 
				pCont.particleposition = polyop.getVert my_mesh i
						 
				progressUpdate ((i as float/ NumVerts ) * 100)
				if getProgressCancel() == true then setProgressCancel true
				)
			progressEnd()
		) 
	) 

) 

on Release pCont do () 