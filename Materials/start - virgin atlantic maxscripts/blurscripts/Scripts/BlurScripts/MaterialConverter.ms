-------------------------------------------------------------------------------
-- MaterialConverter.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.30
-- Created On: 06/02/00
-- Modified On: 06/20/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- To convert things to and from Ink N Paint or the Toon Assistant, you need to 
-- have blur's Toon Shader installed. Get it at http:/www.blur.com/blurbeta/
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Converts many different kinds of materials to other kinds of materials. As 
-- with all conversions between types that don't support everything the other
-- supports, some data will be lost, but the conversion should give you a good 
-- starting point and will help avoid you rebuilding your material from scratch
-- just to take advtantage of another material's properties.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- Several features in the Raytrace material, such as the shader type are still
-- not accessible via maxscript, and so cannot be converted properly bt this 
-- script. All vales that cannot be converted will be left at default.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Converts many different kinds of materials to other kinds of materials. 
-- As with all conversions between types that don't support everything the other
-- supports, some data will be lost, but the conversion should give you a good 
-- starting point and will help avoid you rebuilding your material from scratch
-- just to take advtantage of another material's properties.
--
-- v 1.10 Now compatible with R4.0.
--
-- v 1.20 Added ability to convert between standard and raytraced materials. It 
-- now returns an error message if the blurtoon shader is not installed. Cleaned
-- the code a bunch.
--
-- v 1.21 Fixed a bug that would crash the script when trying to convert a 
-- Multi-Layer Standard material to a raytrace material.
--
-- v 1.22 Moved ink_n_paint_test and toon_assistant_test to BSLib.
--
-- v 1.30 Fixed a bug in declaring the raytrace material that led to crashes in 
-- some instances.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global toon_error

global sub_toon
global toon_sub
global stand_ink
global ray_ink
global ink_stand
global ink_ray
global stand_ray
global ray_stand

global mc_conv_sub
global mc_conv_org
global mc_conv

global mc_rollout
global mc_info
global mc_floater

global conv_type = 1
global fromslot_value = 1
global toslot_value = 2
global sub_value = false

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn toon_error = 
	(
	MessageBox "You do not have Blur's Toon Shader installed. Please go to http://www.blur.com/blurbeta download it and install it." title:"MaterialConverter"
	)

fn sub_toon a =
	(
	if toon_assistant_test() == true then 
		(
		b = Toon_Assistant()
		sub_number = a.names.count
		b.materialList.count = sub_number
		b.name = a.name
		for i = 1 to sub_number do
			(
			b.materialList[i] = a.materialList[i]
			b.mapEnabled[i] = a.mapEnabled[i]
			if a.names[i] != undefined then b.names[i] = a.names[i]
			)
		return b
		)
	else
		(
		toon_error()
		return meditMaterials[toslot_value]		
		)
	)

fn toon_sub a =
	(
	sub_number = a.names.count
	b = Multimaterial()
	b.materialList.count = sub_number
	b.name = a.name
	for i = 1 to sub_number do
		(
		b.materialList[i] = a.materialList[i]
		b.mapEnabled[i] = a.mapEnabled[i]
		if a.names[i] != undefined then b.names[i] = a.names[i]
		)
	return b
	)

fn stand_ink a =
	(
	if ink_n_paint_test() == true then 
		(
		b = Ink__n_Paint ()
		b.name = a.name
		b.paint_color = a.diffuse
		b.shade_color = a.Ambient
		return b
		)
	else
		(
		toon_error()
		return meditMaterials[toslot_value]		
		)
	)

fn ray_ink a =
	(
	if ink_n_paint_test() == true then 
		(
		b = Ink__n_Paint ()
		b.name = a.name
		b.paint_color = a.diffuse
		b.shade_color = a.Ambient
		return b
		)
	else
		(
		toon_error()
		return meditMaterials[toslot_value]		
		)
	)

fn ink_stand a =
	(
	b = Standardmaterial ()
	b.name = a.name
	b.diffuse = a.paint_color
	b.Ambient = a.shade_color
	meditMaterials[toslot_value] = b
	)

fn ink_ray a =
	(
	try
		(
		b = RaytraceMaterial ()
		)
	catch
		(
		b = Raytrace ()
		)
	b.name = a.name
	b.diffuse = a.paint_color
	b.Ambient = a.shade_color
	return b
	)

fn stand_ray a = 
	(
	try
		(
		b = RaytraceMaterial ()
		)
	catch
		(
		b = Raytrace ()
		)
	b.name = a.name

--	a.shaderType

--	a.wire
--	a.faceMap
--	a.faceted
--	a.twoSided

	b.Ambient = a.Ambient		
	b.diffuse = a.Diffuse
	b.Spec__Color = a.Specular
		
	b.Self_Illum_Amount = a.selfIllumAmount
	b.Luminosity_Color_On = a.useSelfIllumColor
	b.Luminosity = a.selfIllumColor
		
	transamount = ((100 - a.opacity)*0.01)*255
	b.Transparecy = color transamount transamount transamount
		
	b.Specular_Level = a.specularLevel
	b.Glossiness = a.Glossiness
	if a.shaderbyName != "Multi-Layer" then b.Soften = a.Soften
		
	b.Wire_Size = a.wireSize*100
--	a.wireUnits
	b.Index_of_Refraction = a.ior*100

--	a.samplerEnable

	b.ambientMapEnable = a.ambientMapEnable
	b.ambientMapAmount = a.ambientMapAmount
	if a.ambientMap != undefined then b.ambientmap = a.ambientMap

	b.diffusemapEnable = a.diffuseMapEnable
	b.diffusemapAmount = a.diffuseMapAmount
	if a.diffuseMap != undefined then b.diffusemap = a.diffuseMap
		
	b.reflectionmapEnable = a.reflectionMapEnable
	b.reflectionmapAmount = a.reflectionMapAmount
	if a.reflectionMap != undefined then b.reflectionmap = a.reflectionMap

	b.transparencymapEnable = a.opacityMapEnable
	b.transparencymapAmount = a.opacityMapAmount
	if a.opacityMap != undefined then b.transparencymap = a.opacityMap

	b.luminositymapEnable = a.selfillumMapEnable
	b.luminositymapAmount = a.selfillumMapAmount
	if a.selfillumMap != undefined then b.luminositymap = a.selfillumMap

	b.specularmapEnable = a.specularMapEnable
	b.specularmapAmount = a.specularMapAmount
	if a.specularMap != undefined then b.specularmap = a.specularMap

	b.specularLevelMapEnable = a.specularLevelMapEnable
	b.specularLevelMapAmount = a.specularLevelMapAmount
	if a.specularLevelMap != undefined then b.specularLevelMap = a.specularLevelMap

	b.GlossinessmapEnable = a.glossinessMapEnable
	b.GlossinessmapAmount = a.glossinessMapAmount
	if a.glossinessMap != undefined then b.Glossinessmap = a.glossinessMap

	b.bumpMapEnable = a.bumpMapEnable
	b.bumpMapAmount = a.bumpMapAmount
	if a.bumpMap != undefined then b.bumpMap = a.bumpMap

	b.environmentMapEnable = a.reflectionMapEnable
	b.environmentMapAmount = a.reflectionMapAmount
	if a.reflectionMap != undefined then b.environmentMap = a.reflectionMap

	b.displacementMapEnable = a.displacementMapEnable
	b.displacementMapAmount = a.displacementMapAmount
	if a.displacementMap != undefined then b.displacementMap = a.displacementMap

	b.Bounce_Coefficient = a.bounce
	b.Static_Friction = a.staticFriction
	b.Sliding_Friction = a.slidingFriction

	return b
	)
	
fn ray_stand a = 
	(
	b = Standard ()
	b.name = a.name

--	a.shaderType

--	a.wire
--	a.faceMap
--	a.faceted
--	a.twoSided

	b.adLock = off
	b.dsLock = off

	b.Ambient = a.Ambient		
	b.Diffuse = a.diffuse
	b.Specular = a.Spec__Color
		
	b.selfIllumAmount = a.Self_Illum_Amount
	b.useSelfIllumColor = a.Luminosity_Color_On
	b.selfIllumColor = a.Luminosity
		
	b.opacity = 100-(((a.Transparecy.v)/255)*100)
		
	b.specularLevel = a.Specular_Level
	b.Glossiness = a.Glossiness
	b.Soften = a.Soften
		
	b.wireSize = a.Wire_Size*0.01
--	a.wireUnits
	b.ior = a.Index_of_Refraction*0.01

--	a.samplerEnable

	b.ambientMapEnable = a.ambientMapEnable
	b.ambientMapAmount = a.ambientMapAmount
	if a.ambientMap != undefined then b.ambientmap = a.ambientMap

	b.diffusemapEnable = a.diffuseMapEnable
	b.diffusemapAmount = a.diffuseMapAmount
	if a.diffuseMap != undefined then b.diffusemap = a.diffuseMap
		
	b.reflectionmapEnable = a.reflectionMapEnable
	b.reflectionmapAmount = a.reflectionMapAmount
	if a.reflectionMap != undefined then b.reflectionmap = a.reflectionMap

	b.opacityMapEnable = a.transparencymapEnable
	b.opacityMapAmount = a.transparencymapAmount
	if a.transparencymap != undefined then b.opacityMap = a.transparencymap

	b.selfillumMapEnable = a.luminositymapEnable
	b.selfillumMapAmount = a.luminositymapAmount
	if a.luminositymap != undefined then b.selfillumMap = a.luminositymap

	b.specularmapEnable = a.specularMapEnable
	b.specularmapAmount = a.specularMapAmount
	if a.specularMap != undefined then b.specularmap = a.specularMap

	b.specularLevelMapEnable = a.specularLevelMapEnable
	b.specularLevelMapAmount = a.specularLevelMapAmount
	if a.specularLevelMap != undefined then b.specularLevelMap = a.specularLevelMap

	b.GlossinessmapEnable = a.glossinessMapEnable
	b.GlossinessmapAmount = a.glossinessMapAmount
	if a.glossinessMap != undefined then b.Glossinessmap = a.glossinessMap

	b.bumpMapEnable = a.bumpMapEnable
	b.bumpMapAmount = a.bumpMapAmount
	if a.bumpMap != undefined then b.bumpMap = a.bumpMap

	b.displacementMapEnable = a.displacementMapEnable
	b.displacementMapAmount = a.displacementMapAmount
	if a.displacementMap != undefined then b.displacementMap = a.displacementMap

	b.bounce = a.Bounce_Coefficient
	b.staticFriction = a.Static_Friction
	b.slidingFriction = a.Sliding_Friction

	return b
	)
	
fn mc_conv_sub cur_mat =
	(
	if classof cur_mat == Multimaterial or classof cur_mat == Toon_Assistant then 
		(
		sub_number = cur_mat.names.count
		if classof cur_mat == Multimaterial then b = Multimaterial ()
		if classof cur_mat == Toon_Assistant then 
			(
			if toon_assistant_test() == true then 
				(
				b = Toon_Assistant()
				)
			else 
				(
				toon_error()
				return meditMaterials[toslot_value]
				)
			)
		b.materialList.count = sub_number
		b.name = cur_mat.name
		for i = 1 to sub_number do
			(
			b.materialList[i] = cur_mat.materialList[i]
			b.mapEnabled[i] = cur_mat.mapEnabled[i]
			if cur_mat.names[i] != undefined then b.names[i] = cur_mat.names[i]
			)
		for i = 1 to sub_number do
			(
			if conv_type == 1 and classof b.materialList[i] == Multimaterial then b.materialList[i] = sub_toon b.materialList[i]
			if conv_type == 2 and classof b.materialList[i] == Toon_Assistant then b.materialList[i] = toon_sub b.materialList[i]
			if conv_type == 3 and classof b.materialList[i] == StandardMaterial then b.materialList[i] = stand_ink b.materialList[i]
			if conv_type == 4 and classof b.materialList[i] == RaytraceMaterial then b.materialList[i] = ray_ink b.materialList[i]
			if conv_type == 5 and classof b.materialList[i] == Ink__n_Paint then b.materialList[i] = ink_stand b.materialList[i]
			if conv_type == 6 and classof b.materialList[i] == Ink__n_Paint then b.materialList[i] = ink_ray b.materialList[i]
			if conv_type == 7 and classof b.materialList[i] == StandardMaterial then b.materialList[i] = stand_ray b.materialList[i]
			if conv_type == 8 and classof b.materialList[i] == RaytraceMaterial then b.materialList[i] = ray_stand b.materialList[i]
			)
		meditMaterials[toslot_value] = b
		)
	else MessageBox "This slot is not a Multi/Sub-Object or Toon Assistant Material." title:"MaterialConverter"
	)

fn mc_conv_org cur_mat =
	(
	if conv_type == 1 then 
		(
		if classof cur_mat == Multimaterial then meditMaterials[toslot_value] = sub_toon cur_mat
		else MessageBox "This slot is not a Multi/Sub-Object Material." title:"MaterialConverter"
		)
	if conv_type == 2 then 
		(
		if classof cur_mat == Toon_Assistant then meditMaterials[toslot_value] = toon_sub cur_mat
		else MessageBox "This slot is not a ToonAssistant Material." title:"MaterialConverter"
		)
	if conv_type == 3 then
		(
		if classof cur_mat == Standard then meditMaterials[toslot_value] = stand_ink cur_mat
		else MessageBox "This slot is not a Standard Material." title:"MaterialConverter"
		)

	if conv_type == 4 then
		(
		if classof cur_mat == RaytraceMaterial then meditMaterials[toslot_value] = ray_ink cur_mat
		else MessageBox "This slot is not a Raytrace Material." title:"MaterialConverter"
		)

	if conv_type == 5 then
		(
		if classof cur_mat == Ink__n_Paint then meditMaterials[toslot_value] = ink_stand cur_mat
		else MessageBox "This slot is not an Ink 'N Paint Material." title:"MaterialConverter"
		)

	if conv_type == 6 then
		(
		if classof cur_mat == Ink__n_Paint then meditMaterials[toslot_value] = ink_ray cur_mat
		else MessageBox "This slot is not an Ink 'N Paint Material." title:"MaterialConverter"
		)

	if conv_type == 7 then 
		(
		if classof cur_mat == Standardmaterial then meditMaterials[toslot_value] = stand_ray cur_mat
		else MessageBox "This slot is not a Standard Material." title:"MaterialConverter"
		)

	if conv_type == 8 then 
		(
		if classof cur_mat == Raytracematerial then meditMaterials[toslot_value] = ray_stand cur_mat
		else MessageBox "This slot is not a Raytrace Material." title:"MaterialConverter"
		)
	)

fn mc_conv the_mat =
	(
	if sub_value == true then mc_conv_sub the_mat
	else mc_conv_org the_mat
	)

-- Script

rollout mc_rollout "MaterialConverter"
	(
	group "Input Output:"
	(
	spinner fromslot "Input Slot: " range:[1,24,1] type:#integer fieldWidth:27 align:#center across:2
	spinner toslot "Output Slot: " range:[1,24,2] type:#integer fieldWidth:27 align:#center
	)

	group ""
	(
	button sub_toon_b "Multi/Sub-Object --> Toon Assistant" width:200 align:#center toolTip:"Multi/Sub-Object --> Toon Assistant"
	button toon_sub_b "Toon Assistant --> Multi/Sub-Object" width:200 align:#center toolTip:"Toon Assistant --> Multi/Sub-Object"
	)

	group ""
	(
	button stand_ink_b "Standard --> Ink 'N Paint" width:200 align:#center toolTip:"Standard --> Ink 'N Paint"
	button ray_ink_b "Raytraced --> Ink 'N Paint" width:200 align:#center toolTip:"Raytraced --> Ink 'N Paint"
	button ink_stand_b "Ink 'N Paint --> Standard" width:200 align:#center toolTip:"Ink 'N Paint --> Standard"
	button ink_ray_b "Ink 'N Paint --> Raytraced" width:200 align:#center toolTip:"Ink 'N Paint --> Raytraced"
	)

	group ""
	(
	button stand_ray_b "Standard --> Raytraced" width:200 align:#center toolTip:"Standard --> Raytraced"
	button ray_stand_b "Raytraced --> Standard" width:200 align:#center toolTip:"Raytraced --> Standard"
	)
	
	group "Sub-Material Mode"
	(
	checkbox sub_mode_check "Sub-Material Mode On **" align:#center
	)

	on fromslot changed val do fromslot_value = val
	on toslot changed val do toslot_value = val

	on sub_toon_b pressed do 
		(
		conv_type = 1
		mc_conv meditMaterials[fromslot_value]
		)
	on toon_sub_b pressed do 
		(
		conv_type = 2
		mc_conv meditMaterials[fromslot_value]
		)
	on stand_ink_b pressed do 
		(
		conv_type = 3
		mc_conv meditMaterials[fromslot_value]
		)
	on ray_ink_b pressed do 
		(
		conv_type = 4
		mc_conv meditMaterials[fromslot_value]
		)
	on ink_stand_b pressed do 
		(
		conv_type = 5
		mc_conv meditMaterials[fromslot_value]
		)
	on ink_ray_b pressed do 
		(
		conv_type = 6
		mc_conv meditMaterials[fromslot_value]
		)
	on stand_ray_b pressed do 
		(
		conv_type = 7
		mc_conv meditMaterials[fromslot_value]
		)
	on ray_stand_b pressed do 
		(
		conv_type = 8
		mc_conv meditMaterials[fromslot_value]
		)
	
	on sub_mode_check changed state do 
		(
		if sub_mode_check.checked == true then sub_value = true
		else sub_value = false
		)
	)

rollout mc_info "**"
	(
	label label1 "Input slot is a Multi/Sub-object or Toon" align:#left
	label label2 "Assistant. Converts all instances of the" align:#left
	label label3 "selected material type within the Multi/" align:#left
	label label4 "Sub-object or Toon Assistant to the new" align:#left
	label label5 "material type." align:#left
	)

if mc_floater != undefined then CloseRolloutFloater mc_floater
mc_floater = newRolloutFloater "MaterialConverter v1.30" 250 465
addRollout mc_rollout mc_floater
addRollout mc_info mc_floater rolledUp:true
)
-------------------------------------------------------------------------------