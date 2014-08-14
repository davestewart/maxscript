-------------------------------------------------------------------------------
-- LightUtilities_Globals.ms
-- v 2.91
-- Required File For LightUtilities.ms and LightControl.ms
-------------------------------------------------------------------------------
(
-- Common
-------------------------------------------------------------------------------

global has_scene_changed
global lu_operation_on_what

global lu_oldpos = [10,90]

lu_onwhat_value = 2

global lu_lights_floater
global lu_floater

global current_lights = #()
global previous_lights = #()
global o_selected_lights = #()

-- LightControl
-------------------------------------------------------------------------------

global luct_update_current_lights
global luct_sortbylighttype
global luct_update_scene
global luct_update_o_selected_lights
global luct_kill_ch
global luct_update_rollout
global luct_full_update
global luct_lights_select_func
global luct_rollout_function

global lrs = ""
global luct_auto_update_on = false
global luct_more1_value = false
global luct_more2_value = false
global luct_floater_width = 281
global luct_floater_height = 65
global luct_lighttotal

global luct_user_close = true
global luct_id1
global luct_id2

global luct_sortby_value = 1
global luct_show_hidden_value = true
global luct_show_frozen_value = true
global luct_show_unselected_value = true
global luct_show_uno_selected_value = true
global luct_show_instances_value = true
global luct_instances_in_bold_value = true

global luct_key = "O On         Name          Sel C   Mult      Sh    MapS       Con        SoftEdge   FarStart     FarEnd         ShadowType       Dens    Sample    D   S      Decay         DecayS      Bias"

global luct_rollout_rolledup_value = false
global luct_key_rollout_rolledup_value = true
global luct_opt_rollout_rolledup_value = true
global luct_oldpos = [262,90]

global luct_rollout
global luct_key_rollout
global luct_opt_rollout
global luct_floater = undefined

-- LightTools
------------------------------------------------------------------------------

global lut_lights_on_off
global lut_sselect_oselect
global lut_deletelights
global lut_isolate_lights
global luct_run_seperate_script

global lut_misc_rollout

-- LightCleaner
------------------------------------------------------------------------------

global luc_cone_on_off
global luc_attnn_on_off
global luc_attnf_on_off

global luc_conevalue = 3
global luc_attnnvalue = 3
global luc_attnfvalue = 3

global luc_rollout

-- LightViewer
------------------------------------------------------------------------------

global luv_collect_the_lights
global luv_make_copies_of_lights
global luv_delete_copies_of_lights
global luv_turn_all_lights_off

global luv_start
global luv_do_a_render
global luv_display_or_delete
global luv_put_it_back

global luv_seperate_start
global luv_seperate
global luv_seperate_end
global luv_together_start
global luv_together
global luv_together_end
global luv_cumulative_start
global luv_cumulative
global luv_cumulative_end

global luv_laststate = #()
global luv_lights = #()
global luv_display_list = #()

global luv_type_value = 1

global luv_tex_value = false
global luv_atm_value = false
global luv_aa_value = false
global luv_vfb_value = true
global luv_show_images_value = true
global luv_save_value = false
global luv_outdir = undefined

global luv_rollout

-- LightOrder
------------------------------------------------------------------------------

global luo_start
global luo_up
global luo_down
global luo_func
global luo_update

global luo_array = #()
global luo_cur_light = 1
global luos_light_labels = #()
global luos = ""

global luo_rollout

-- LightMultiChanger
------------------------------------------------------------------------------

global lum_do_the_change

global lum_do_onoff_value = false
global lum_do_color_value = false
global lum_do_multiplier_value = false
global lum_do_shadows_value = false
global lum_do_mapsize_value = false

global lum_do_contrast_value = false
global lum_do_sde_value = false
global lum_do_farstart_value = false
global lum_do_farend_value = false
global lum_do_shadowtype_value = false
global lum_do_shadowdensity_value = false
global lum_do_samplerange_value = false

global lum_do_diffuse_value = false
global lum_do_specular_value = false
global lum_do_decay_value = false
global lum_do_decaystart_value = false
global lum_do_bias_value = false

global lum_onoff_value = true
global lum_color_value = [255,255,255]
global lum_multiplier_value = 1.0
global lum_shadows_value = false
global lum_mapsize_value = 512

global lum_contrast_value = 0.0
global lum_sde_value = 50.0
global lum_farstart_value = 80.0
global lum_farend_value = 200.0
global lum_shadowtype_value = 1
global lum_shadowdensity_value = 1.0
global lum_samplerange_value = 4.0

global lum_diffuse_value = true
global lum_specular_value = true
global lum_decay_value = 1
global lum_decaystart_value = 40.0
global lum_bias_value = 0.1

global lum_mode_value = 1

global lum_rollout
)
-------------------------------------------------------------------------------