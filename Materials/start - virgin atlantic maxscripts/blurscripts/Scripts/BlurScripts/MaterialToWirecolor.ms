-------------------------------------------------------------------------------
-- MaterialToWirecolor.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 06/28/00
-- Modified On: 06/28/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes all selected objects and makes their wireframe color the same as 
-- the diffuse color of any materials the objects may have applied.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global get_diffuse_color

-- Variables

-- Functions

fn get_diffuse_color mat = 
(
	if classof mat == Standardmaterial or classof mat == Standard then return mat.diffuse
	else if classof mat == RaytraceMaterial or classof mat == Raytrace then return mat.diffuse
	else if classof mat == Multimaterial or classof mat == Toon_Assistant then get_diffuse_color mat[1]
	else if classof mat == Blend or classof mat == Blendmaterial then get_diffuse_color mat.map1
)

-- Script

for i in selection do
(
	mycolor = color 165 165 165
	if i.material != undefined then 
	(
		mycolor = (get_diffuse_color i.material)
	)
	i.wirecolor = mycolor
)
)
-------------------------------------------------------------------------------