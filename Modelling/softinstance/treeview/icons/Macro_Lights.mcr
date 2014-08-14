-- Macro Scripts File
-- Created:  Nov 17 1998
-- Modified: Fred Ruff April 22 2002
-- Author:   Frank DeLise
-- Macro Scripts for Lights
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript Omni_Light 
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            tooltip:"Omni Light"
			ButtonText:"Omni Light" 
            icon:#("Lights",3)
(
     on execute do StartObjectCreation OmniLight 
     on isChecked return mcrUtils.IsCreating OmniLight 
) 

macroScript Target_Spotlight 
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Target Spotlight" 
            tooltip:"Target Spotlight" 
            icon:#("Lights",1)
(
     on execute do StartObjectCreation Targetspot 
     on isChecked return mcrUtils.IsCreating Targetspot 
)

macroScript Target_Directional_Light 
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Target Directional Light" 
            tooltip:"Target Directional Light" 
            icon:#("Lights",2)
(
     on execute do StartObjectCreation TargetDirectionalLight 
     on isChecked return mcrUtils.IsCreating TargetDirectionalLight 
)

macroScript Free_Spotlight 
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Free Spotlight"
            tooltip:"Free Spotlight" 
            icon:#("Lights",4)
(
     on execute do StartObjectCreation FreeSpot 
     on isChecked return mcrUtils.IsCreating FreeSpot 
)

macroScript Directional_Light
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Directional Light"
            tooltip:"Free Directional Light" 
            icon:#("Lights",5)
(
     on execute do StartObjectCreation DirectionalLight 
     on isChecked return mcrUtils.IsCreating DirectionalLight 
)
--***********************************************************************************************
-- New Radiosity and Photometric Lights

macroScript Skylight
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Skylight"
            tooltip:"Skylight" 
(
     on execute do StartObjectCreation Skylight
     on isChecked return mcrUtils.IsCreating Skylight
)

macroScript Daylight
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Daylight"
            tooltip:"Daylight" 
(
     on execute do StartObjectCreation Daylight
     on isChecked return mcrUtils.IsCreating Daylight
)
macroScript IES_Sky
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"IES Sky"
            tooltip:"IES Sky" 
(
     on execute do StartObjectCreation IES_Sky
     on isChecked return mcrUtils.IsCreating IES_Sky
)
macroScript IES_Sun
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"IES Sun"
            tooltip:"IES Sun" 
(
     on execute do StartObjectCreation IES_Sun
     on isChecked return mcrUtils.IsCreating IES_Sun
)
macroScript TargetPoint
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Target Point"
            tooltip:"Target Point" 
(
     on execute do StartObjectCreation Target_Point
     on isChecked return mcrUtils.IsCreating Target_Point
)
macroScript FreePoint
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Free Point"
            tooltip:"Free Point" 
(
     on execute do StartObjectCreation Free_Point
     on isChecked return mcrUtils.IsCreating Free_Point
)

macroScript TargetLinear
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Target Linear"
            tooltip:"Target Linear" 
(
     on execute do StartObjectCreation Target_Linear
     on isChecked return mcrUtils.IsCreating Target_Linear
)
macroScript FreeLinear
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Free Linear"
            tooltip:"Free Linear" 
(
     on execute do StartObjectCreation Free_Linear
     on isChecked return mcrUtils.IsCreating Free_Linear
)
macroScript TargetArea
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Target Area"
            tooltip:"Target Area" 
(
     on execute do StartObjectCreation Target_Area
     on isChecked return mcrUtils.IsCreating Target_Area
)
macroScript FreeArea
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Free Area"
            tooltip:"Free Area" 
(
     on execute do StartObjectCreation Free_Area
     on isChecked return mcrUtils.IsCreating Free_Area
)

macroScript SunLight 
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
			ButtonText:"Sunlight System"
            tooltip:"Sunlight System" 
            icon:#("Systems",2)
(
     on execute do StartObjectCreation Sunlight
     on isChecked return mcrUtils.IsCreating Sunlight
)

--***********************************************************************************************
-- Light Commands
MacroScript Light_On
            ButtonText:"Light On"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Light On/Off Toggle" 
(
	On IsVisible Return Filters.Is_Light $ and (isProperty $ #on or (isProperty $ #delegate and isProperty $.delegate #on))
	on ischecked Do
		Try (if isProperty $ #on then $.on else $.delegate.on) 
		Catch ()
	
	On Execute Do
		Try 
		(	if isProperty $ #on then 
				$.on = not $.on 
			else 
				$.delegate.on = not $.delegate.on
		)
		Catch ()
)

MacroScript Light_Shadows
            ButtonText:"Cast Shadows"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Shadows On/Off Toggle" 
(

	On IsVisible Return Filters.Is_Light $ and (isProperty $.baseObject #castShadows or (isProperty $ #delegate and isProperty $.delegate #castShadows))
	on ischecked Do
		Try (if isProperty $.baseObject #castShadows then $.baseObject.castShadows else $.delegate.castShadows)
		Catch ()
	
	On Execute Do 
		Try 
		(	if isProperty $.baseObject #castShadows then 
				$.baseObject.castShadows = not $.baseObject.castShadows
			else 
				$.delegate.castShadows = not $.delegate.castShadows
		)
		Catch ()
)

MacroScript Light_AffectDiffuse
            ButtonText:"Affect Diffuse"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Affect Diffuse Toggle" 
(

	On IsVisible Return Filters.Is_Light $ and (isProperty $ #AffectDiffuse or (isProperty $ #delegate and isProperty $.delegate #AffectDiffuse))
	on ischecked Do
		Try (if isProperty $ #AffectDiffuse then $.AffectDiffuse else $.delegate.AffectDiffuse)
		Catch ()
	
	On Execute Do
		Try 
		(	if isProperty $ #AffectDiffuse then
				$.AffectDiffuse = not $.AffectDiffuse
			else 
				$.delegate.AffectDiffuse = not $.delegate.AffectDiffuse
		)	
		Catch ()
)

MacroScript Light_AffectSpecular
            ButtonText:"Affect Specular"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Affect Specular Toggle" 
(

	On IsVisible Return Filters.Is_Light $ and (isProperty $ #AffectSpecular or (isProperty $ #delegate and isProperty $.delegate #AffectSpecular))
	on ischecked Do
		Try (if isProperty $ #AffectSpecular then $.AffectSpecular else $.delegate.AffectSpecular) 
		Catch ()
	
	On Execute Do 
		Try 
		(	if isProperty $ #AffectSpecular then 
				$.AffectSpecular = not $.AffectSpecular
			else 
				$.delegate.AffectSpecular = not $.delegate.AffectSpecular
		) 
		Catch ()
)

MacroScript Light_AmbientOnly
            ButtonText:"Ambient Only"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Ambient Only Toggle" 
(

	On IsVisible Return Filters.Is_Light $ and (isProperty $ #AmbientOnly or (isProperty $ #delegate and isProperty $.delegate #AmbientOnly))
	on ischecked Do
		Try (if isProperty $ #AmbientOnly then $.AmbientOnly else $.delegate.AmbientOnly) 
		Catch ()
	
	On Execute Do
		Try 
		(	if isProperty $ #AmbientOnly then 
				$.AmbientOnly = not $.AmbientOnly
			else 
				$.delegate.AmbientOnly = not $.delegate.AmbientOnly
		)
		Catch ()
)

MacroScript Light_SelectTarget
            ButtonText:"Select Target"
            category:"Lights and Cameras"
            internalcategory:"Lights and Cameras"
            Tooltip:"Select Target (Lights)" 
(

	On IsVisible Return Filters.Is_Light $
	On Execute Do Try(if $.target != undefined do select $.Target) Catch()

)

