-- MacroScript to Render to RamPlayer 
-- Author:   Alexander Bicalho 
--**************************************************************** 
-- MODIFY THIS AT YOUR OWN RISK 
-- This utility will allow you to render directly to the RamPlayer 
-- 
MacroScript RAM_Render category:"Tools" tooltip:"Render to Ram" 
	( 
	-- declare local variables and define some functions 
		local r_dialogue 
		local get_names existFile 
		function get_names name a = append a name 
		function existFile fname = (getfiles fname).count != 0 

	-- create the rollout definition 
		rollout r_size "Render Parameters" 
			( 
			local p = 95 
			local p2 = p+78 
			group "Time Output" 
				( 
				radiobuttons r_time columns:1 align:#left labels:#("Single","Active Time Segment","Range:" ) 
				spinner nth "Every Nth Frame:" pos:[215,24] fieldwidth:50 type:#integer range:[0,10000,1] enabled:false 
				spinner r_from fieldwidth:60 pos:[75,56] type:#integer range:[0,10000,1] enabled:false 
				spinner r_to "To:" fieldwidth:60 pos:[152,56] type:#integer range:[0,10000,100] enabled:false 
				)
			group "Render Size" 
				( 
				spinner rw "Width " fieldwidth:60 pos:[15,p+08] type:#integer range:[0,10000,320] 
				spinner rh "Height " fieldwidth:60 pos:[12,p+32] type:#integer range:[0,10000,240] 
				spinner aspect "Aspect " fieldwidth:60 pos:[10,p+56] type:#float range:[0,20,1.0] 
				button s160 "160x120" pos:[125,p+06] width:75 height:19 
				button s256 "256x243" pos:[125,p+30] width:75 height:19 
				button s320 "320x240" pos:[205,p+06] width:75 height:19 
				button s512 "512x486" pos:[205,p+30] width:75 height:19 
				button s640 "640x480" pos:[285,p+06] width:75 height:19 
				button s720 "720x486" pos:[285,p+30] width:75 height:19 
				button conf_render "Configure" pos:[125,p+54] width:115 height:19 
				button wipe "Purge Files" pos:[245,p+54] width:115 height:19 
				button go "Render" pos:[125,p+78] width:235 height:19 
				) 
			label abt0 "Render to RAM" pos:[8,p2+31] 
			label abt1 "Version 0.2a" pos:[8,p2+46] 
			label abt2 "Alexander Esppeschit Bicalho" pos:[225,p2+31] 
			label abt3 "abicalho@brasilmail.com" pos:[249,p2+46] 
			-- define the rollout event handlers 
			on wipe pressed do 
				( 
				local tempfilename_a = (getdir #image) + "\\ramplayertemp_a.avi" 
				local tempfilename_b = (getdir #image) + "\\ramplayertemp_b.avi" 
				if existfile tempfilename_a then deletefile tempfilename_a 
				if existfile tempfilename_b then deletefile tempfilename_b 
				) 
			on r_time changed state do 
				( 
				case state of 
					( 
					1: nth.enabled = r_from.enabled = r_to.enabled = false 
					2: ( 
					nth.enabled = true 
					r_from.enabled = r_to.enabled = false 
					) 
					3: nth.enabled = r_from.enabled = r_to.enabled = true 
					) 
				) 
			on s160 pressed do (rw.value=160; rh.value=120; aspect.value=1.0) 
			on s320 pressed do (rw.value=320; rh.value=240; aspect.value=1.0) 
			on s256 pressed do (rw.value=256; rh.value=243; aspect.value=1.266) 
			on s512 pressed do (rw.value=512; rh.value=486; aspect.value=1.266) 
			on s640 pressed do (rw.value=640; rh.value=480; aspect.value=1.0) 
			on s720 pressed do (rw.value=720; rh.value=486; aspect.value=0.9) 
			on conf_render pressed do (max render scene) 
			on go pressed do 
				( 
				local tempfilename_a = (getdir #image) + "\\ramplayertemp_a.avi" 
				local tempfilename_b = (getdir #image) + "\\ramplayertemp_b.avi" 
				if existfile tempfilename_b then 
					( 
					deletefile tempfilename_a 
					copyfile tempfilename_b tempfilename_a 
					tempfilename = tempfilename_b 
					) 
				else 
				( 
				if existfile tempfilename_a then 
				tempfilename = tempfilename_b 
				else 
					( 
					tempfilename = tempfilename_a 
					tempfilename_b = "" 
					) 
				) 
				case r_time.state of 
				( 
				1: ( render outputheight:rh.value outputwidth:rw.value pixelaspect:aspect.value outputfile:tempfilename vfb:off ) 
				2: ( render outputheight:rh.value outputwidth:rw.value pixelaspect:aspect.value outputfile:tempfilename vfb:off nthframe:nth.value framerange:#active ) 
				3: ( render outputheight:rh.value outputwidth:rw.value pixelaspect:aspect.value outputfile:tempfilename vfb:off nthframe:nth.value fromframe:r_from.value toframe:r_to.value ) 
				) 
				ramplayer tempfilename_a tempfilename_b 
				closerolloutfloater r_dialogue 
				) -- end of on go pressed 
			) -- end of rollout r_size 

	-- close the old rollout floater if it exists 
		try(closerolloutfloater r_dialogue)catch()

	-- put up new rollout floater and add rollout to it. 
		r_dialogue = newrolloutfloater "Render to RAM" 400 300 
		addrollout r_size r_dialogue 

	-- end of Macro Script, rollout takes over... 
	) 

macros.run "Tools" "RAM_Render"
