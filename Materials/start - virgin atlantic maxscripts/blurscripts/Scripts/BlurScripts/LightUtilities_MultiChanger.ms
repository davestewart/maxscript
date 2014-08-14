-------------------------------------------------------------------------------
-- LightUtilities_MultiChanger.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Functions

fn lum_do_the_change =
(
	disableSceneRedraw()
	try
	(
		for s in lu_operation_on_what() do
		(
			if lum_do_shadowtype_value == true then 
			(
				if lum_shadowtype_value == 1 then setproperty s "shadowgenerator" (shadowmap())
				else setproperty s "shadowgenerator" (raytraceShadow())
			)			
			
			if lum_do_onoff_value == true then 
			(
				s.enabled = lum_onoff_value
			)
			if lum_do_color_value == true then 
			(
				s.color = lum_color_value
			)
			if lum_do_multiplier_value == true then 
			(
				if lum_mode_value == 1 then s.multiplier = lum_multiplier_value
				else s.multiplier += lum_multiplier_value
			)
			if lum_do_shadows_value == true then 
			(
				s.baseobject.castshadows = lum_shadows_value
			)
			if lum_do_mapsize_value == true then 
			(
				if classof (getproperty s "shadowgenerator") == shadowmap then 
				(
					if lum_mode_value == 1 then s.mapsize = lum_mapsize_value
					else s.mapsize += lum_mapsize_value
				)
			)
	
			if lum_do_contrast_value == true then 
			(
				if lum_mode_value == 1 then s.contrast = lum_contrast_value
				else s.contrast += lum_contrast_value
			)
			if lum_do_sde_value == true then 
			(
				if lum_mode_value == 1 then s.softenDiffuseEdge = lum_sde_value
				else s.softenDiffuseEdge += lum_sde_value
			)
			if lum_do_farstart_value == true then 
			(
				if lum_mode_value == 1 then s.farAttenStart = lum_farstart_value
				else s.farAttenStart += lum_farstart_value
			)
			if lum_do_farend_value == true then 
			(
				if lum_mode_value == 1 then s.farAttenEnd = lum_farend_value
				else s.farAttenEnd += lum_farend_value
			)
			if lum_do_shadowdensity_value == true then 
			(
				if lum_mode_value == 1 then s.shadowMultiplier = lum_shadowdensity_value
				else s.shadowMultiplier += lum_shadowdensity_value
			)
			if lum_do_samplerange_value == true then 
			(
				if classof (getproperty s "shadowgenerator") == shadowmap then 
				(
					if lum_mode_value == 1 then s.sampleRange = lum_samplerange_value
					else s.sampleRange += lum_samplerange_value
				)
			)

			if lum_do_diffuse_value == true then 
			(
				s.affectDiffuse = lum_diffuse_value
			)
			if lum_do_specular_value == true then 
			(
				s.affectSpecular = lum_specular_value
			)
			if lum_do_decay_value == true then 
			(
				s.attenDecay = lum_decay_value
			)
			if lum_do_decaystart_value == true then 
			(
				if lum_mode_value == 1 then s.decayradius = lum_decaystart_value
				else s.decayradius += lum_decaystart_value
			)			
			if lum_do_bias_value == true then 
			(
				if classof (getproperty s "shadowgenerator") == shadowmap then 
				(
					if lum_mode_value == 1 then s.mapBias = lum_bias_value
					else s.mapBias += lum_bias_value
				)
			)
		)
	)
	catch
	(
		enableSceneRedraw()
		completeRedraw()
	)
	enableSceneRedraw()
	completeRedraw()
	luct_full_update()
)
	
-- Rollouts

rollout lum_rollout "LightMultiChanger"
(
	group "Main Parameters"
(
	checkbox lum_do_onoff "" across:2
	checkbox lum_onoff "On/Off" enabled:false checked:true align:#right
	
	checkbox lum_do_color "" across:2
	ColorPicker lum_color color:[255,255,255] fieldwidth:12 height:16 enabled:false align:#right

	checkbox lum_do_multiplier "" across:2
	spinner lum_multiplier "Multiplier: " range:[-1000,1000,1] fieldWidth:50 enabled:false align:#right

	checkbox lum_do_shadows "" across:2
	checkbox lum_shadows "Cast Shadows" enabled:false checked:false align:#right

	checkbox lum_do_mapsize "" across:2
	spinner lum_mapsize "Mapsize: " range:[0,10000,512] fieldWidth:50 enabled:false type:#integer align:#right
)
	
	group "Advanced Parameters"
(
	checkbox lum_do_contrast "" across:2
	spinner lum_contrast "Contrast: " range:[0.0,100.0,0.0] fieldWidth:50 enabled:false type:#float align:#right

	checkbox lum_do_sde "" across:2
	spinner lum_sde "Soften Diff. Edge: " range:[0.0,100.0,50.0] fieldWidth:50 enabled:false type:#float align:#right

	checkbox lum_do_farstart "" across:2
	spinner lum_farstart "Far Atten Start: " range:[0.0,9999999.0,80.0] fieldWidth:50 enabled:false type:#worldunits align:#right

	checkbox lum_do_farend "" across:2
	spinner lum_farend "Far Atten End: " range:[0.0,9999999.0,200.0] fieldWidth:50 enabled:false type:#worldunits align:#right

	checkbox lum_do_shadowtype "" across:2
	dropdownlist lum_shadowtype "" items:#("ShadowMap", "RayTrace") selection:1 enabled:false

	checkbox lum_do_shadowdensity "" across:2
	spinner lum_shadowdensity "Shadow Denisty: " range:[-10000.0,10000.0,1.0] fieldWidth:50 enabled:false type:#float align:#right

	checkbox lum_do_samplerange "" across:2
	spinner lum_samplerange "Sample Range: " range:[0.01,50.0,4.0] fieldWidth:50 enabled:false type:#float align:#right
)
	
	group "Extra Parameters"
(
	checkbox lum_do_diffuse "" across:2
	checkbox lum_diffuse "Diffuse" enabled:false checked:true align:#right

	checkbox lum_do_specular "" across:2
	checkbox lum_specular "Specular" enabled:false checked:true align:#right

	checkbox lum_do_decay "" across:2
	dropdownlist lum_decay "Decay:" items:#("None", "Inverse", "Inverse Square") selection:1 enabled:false

	checkbox lum_do_decaystart "" across:2
	spinner lum_decaystart "Decay Start: " range:[0.0,9999999.0,40.0] fieldWidth:50 enabled:false type:#worldunits align:#right

	checkbox lum_do_bias "" across:2
	spinner lum_bias "Shadow Map Bias: " range:[0.0,10000.0,0.1] fieldWidth:50 enabled:false type:#float align:#right
)

	on lum_do_onoff changed state do 
	(
		lum_onoff.enabled = state
		if lum_do_onoff.checked == true then lum_do_onoff_value = true
		else lum_do_onoff_value = false
	)
	on lum_onoff changed state do lum_onoff_value = state
	on lum_do_color changed state do 
	(
		lum_color.enabled = state
		if lum_do_color.checked == true then lum_do_color_value = true
		else lum_do_color_value = false
	)
	on lum_color changed new_col do lum_color_value = new_col
	on lum_do_multiplier changed state do 
	(
		lum_multiplier.enabled = state
		if lum_do_multiplier.checked == true then lum_do_multiplier_value = true
		else lum_do_multiplier_value = false
	)
	on lum_multiplier changed val do lum_multiplier_value = val
	on lum_do_shadows changed state do 
	(
		lum_shadows.enabled = state
		if lum_do_shadows.checked == true then lum_do_shadows_value = true
		else lum_do_shadows_value = false
	)
	on lum_shadows changed state do lum_shadows_value = state
	on lum_do_mapsize changed state do 
	(
		lum_mapsize.enabled = state
		if lum_do_mapsize.checked == true then lum_do_mapsize_value = true
		else lum_do_mapsize_value = false
	)
	on lum_mapsize changed val do lum_mapsize_value = val
	
	on lum_do_contrast changed state do 
	(
		lum_contrast.enabled = state
		if lum_do_contrast.checked == true then lum_do_contrast_value = true
		else lum_do_contrast_value = false
	)
	on lum_contrast changed val do lum_contrast_value = val
	on lum_do_sde changed state do 
	(
		lum_sde.enabled = state
		if lum_do_sde.checked == true then lum_do_sde_value = true
		else lum_do_sde_value = false
	)
	on lum_sde changed val do lum_sde_value = val
	on lum_do_farstart changed state do 
	(
		lum_farstart.enabled = state
		if lum_do_farstart.checked == true then lum_do_farstart_value = true
		else lum_do_farstart_value = false
	)
	on lum_farstart changed val do lum_farstart_value = val
	on lum_do_farend changed state do 
	(
		lum_farend.enabled = state
		if lum_do_farend.checked == true then lum_do_farend_value = true
		else lum_do_farend_value = false
	)
	on lum_farend changed val do lum_farend_value = val
	on lum_do_shadowtype changed state do 
	(
		lum_shadowtype.enabled = state
		if lum_do_shadowtype.checked == true then lum_do_shadowtype_value = true
		else lum_do_shadowtype_value = false
	)
	on lum_shadowtype selected i do lum_shadowtype_value = i
	on lum_do_shadowdensity changed state do 
	(
		lum_shadowdensity.enabled = state
		if lum_do_shadowdensity.checked == true then lum_do_shadowdensity_value = true
		else lum_do_shadowdensity_value = false
	)
	on lum_shadowdensity changed val do lum_shadowdensity_value = val
	on lum_do_samplerange changed state do 
	(
		lum_samplerange.enabled = state
		if lum_do_samplerange.checked == true then lum_do_samplerange_value = true
		else lum_do_samplerange_value = false
	)
	on lum_samplerange changed val do lum_samplerange_value = val
	
	on lum_do_diffuse changed state do 
	(
		lum_diffuse.enabled = state
		if lum_do_diffuse.checked == true then lum_do_diffuse_value = true
		else lum_do_diffuse_value = false
	)
	on lum_diffuse changed state do lum_diffuse_value = state
	on lum_do_specular changed state do 
	(
		lum_specular.enabled = state
		if lum_do_specular.checked == true then lum_do_specular_value = true
		else lum_do_specular_value = false
	)
	on lum_specular changed state do lum_specular_value = state
	on lum_do_decay changed state do 
	(
		lum_decay.enabled = state
		if lum_do_decay.checked == true then lum_do_decay_value = true
		else lum_do_decay_value = false
	)
	on lum_decay selected i do lum_decay_value = i
	on lum_do_decaystart changed state do 
	(
		lum_decaystart.enabled = state
		if lum_do_decaystart.checked == true then lum_do_decaystart_value = true
		else lum_do_decaystart_value = false
	)
	on lum_decaystart changed val do lum_decaystart_value = val
	on lum_do_bias changed state do 
	(
		lum_bias.enabled = state
		if lum_do_bias.checked == true then lum_do_bias_value = true
		else lum_do_bias_value = false
	)
	on lum_bias changed val do lum_bias_value = val

	group "Update Parameters"
	(
		dropdownlist lum_mode "" items:#("Absolute", "Relative") selection:lum_mode_value
		button lum_buttonupdate "Update Parameters" width:200 align:#center toolTip:"Update Parameters"
	)
	on lum_mode selected i do lum_mode_value = i
	on lum_buttonupdate pressed do lum_do_the_change()
)
)
-------------------------------------------------------------------------------