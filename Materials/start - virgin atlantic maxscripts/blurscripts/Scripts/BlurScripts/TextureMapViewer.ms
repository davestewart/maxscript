-------------------------------------------------------------------------------
-- TextureMapViewer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 09/29/00
-- Modified On: 12/18/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a Map that's in your mat editor and applies to it to selection of
-- objects, renders the scene, then reassigns the old material back to your
-- objects. This is useful if say you have a procedural mask (like noise) 
-- that's deep inside a map tree, and you just want to see what the map by 
-- itself will look like on your final object. Think of it as something similar 
-- to the "Show Map In Viewport" function, except it works with procedurals
-- and does a full render.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a Map that's in your mat editor and applies to it to selection of
-- objects, renders the scene, then reassigns the old material back to your
-- objects. This is useful if say you have a procedural mask (like noise) 
-- that's deep inside a map tree, and you just want to see what the map by 
-- itself will look like on your final object. Think of it as something similar 
-- to the "Show Map In Viewport" function, except it works with procedurals
-- and does a full render.
--
-- v 1.10 Now works a little differently. First, you don't have to have a texmap
-- in the currently selected slot all by itself, you can have it as part of a 
-- material tree. Next, it doesn't just do selected objects, but any object that
-- has your current material assigned to it. Defaults to self illumination at
-- 100%. Cleaned the code.
--
-- v 1.11 Fixed the bug where turning off atmospherics in a maxscript render turns 
-- off atmospherics for the current renderer as well.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global tmv_view

global tmv_floater
global tmv_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

tmv_si = 100

-- Functions

fn tmv_view = 
	(
	v_objs = #()
	tmv_hide_these = #()
	cur_objs = (unhiddenobj())
	cur_mat = meditMaterials[medit.GetActiveMtlSlot()]
	cur_tex = (medit.GetCurMtl())

	if superclassof cur_tex == textureMap then
		(
		new_mat = Standard()
		new_mat.specularlevel = 0
		new_mat.Glossiness = 0
		new_mat.useSelfIllumColor = off
		new_mat.selfIllumAmount = tmv_si
		new_mat.Ambient = color 0 0 0
		new_mat.diffuse = color 0 0 0
		new_mat.specular = color 0 0 0
		new_mat.diffuseMap = cur_tex

		disableSceneRedraw()
		
		try
			(		
			for i in cur_objs do
				(
				if i.material == cur_mat then append v_objs i
				)
			if v_objs.count == 0 then (MessageBox "No objects with that material are currently visible." title:"TextureMapViewer")
			else
				(
				tmv_hide_these = remove_from_array_by_items cur_objs v_objs
				
				for i in tmv_hide_these do i.ishidden = true
				
				for i in v_objs do i.material = new_mat
				temp1 = rendAtmosphere
				render vfb:on antiAliasing:false mapping:true renderatmosphericeffects:false imageMotionBlur:false objectMotionBlur:false
				rendAtmosphere = temp1
				for i in v_objs do i.material = cur_mat
				
				for i in tmv_hide_these do i.ishidden = false
				)
			)
		catch
			(
			for i in v_objs do i.material = cur_mat
			for i in tmv_hide_these do i.ishidden = false
			enableSceneRedraw()
			completeRedraw()
			)
		enableSceneRedraw()
		completeRedraw()
		)
	else (MessageBox "Please pick a slot that contains a texturemap" title:"TextureMapViewer")
	)

-- Script

rollout tmv_rollout "TextureMapViewer"
	(
	spinner si_spinner "Self Illumination: " range:[0,100,tmv_si] type:#integer fieldWidth:40 align:#center
	on si_spinner changed val do tmv_si = val
	
	button doit "View Texmap" width:145 align:#center toolTip:"View Texmap"
	on doit pressed do tmv_view()
	)

if tmv_floater != undefined then CloseRolloutFloater tmv_floater
tmv_floater = newRolloutFloater "TextureMapViewer v1.11" 190 118
addRollout tmv_rollout tmv_floater
)
-------------------------------------------------------------------------------