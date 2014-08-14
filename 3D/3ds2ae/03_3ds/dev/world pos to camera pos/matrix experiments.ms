pfp=$'PF Source 01'.getParticlePosition 5
pfm=matrix3 [1,0,0] [0,1,0] [0,0,1] pfp

------------------------------------------------------------------------------------
-- this is the template
$point01.transform
in coordsys $camera01 $point01.pos
------------------------------------------------------------------------------------
/*
pfm.pos
in coordsys $camera01 pfm.pos


newMatrix.transform=$point01.transform

in coordsys $camera01 mtx.translationpart
*/

------------------------------------------------------------------------------------
-- this one sets the coordsys to the camera and returns the position in relation to it
mtx = copy $point01.transform
mtx.pos* (inverse $camera01.transform)
------------------------------------------------------------------------------------



------------------------------------------------------------------------------------
-- this one sets the coordsys to the camera and moves the point

cmtx=($camera01.transform)
in coordsys cmtx $point01.pos.x+=-10

pos=[0,0,0]
pmtx=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]

in coordsys cmtx pmtx.pos.x+=-10

------------------------------------------------------------------------------------


trans=xformMat $point01.transform $camera01.transform

trans=$point01.transform * $camera01.transform


in coordsys trans $point01.pos.x+=10

$point01.pos.x+=10
/*
Returns the transform matrix transformed into a particular space. For example, say you have a rotation 
you want to apply, but you want to perform the rotation in another coordinate system. 

To do this, you typically transform into the space of the coordinate system, then apply the transformation, 
and then transform out of that coordinate system. 

This method transformats matrix transform_matrix3 into the space of matrix space_matrix3. 

The resulting matrix3 value is calculated as space_matrix3 * transform_matrix3 * inverse(space_matrix3). 
*/

$camera01.transform * transform_matrix3 * inverse(space_matrix3).


$.transform

mat=$point01.transform
mat.rotationpart
mat.translationpart
mat.scalerotationpart
mat.scalepart
mat.determinantsign


nodeTM