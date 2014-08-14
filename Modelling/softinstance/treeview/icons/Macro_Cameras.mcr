-- Macro Scripts File
-- Created:  Nov 17 1998
-- Modified: Jan 10 1999
-- Author:   Frank DeLise
-- MODIFY THIS AT YOUR OWN RISK
--
-- Macro Scripts for Cameras
--***********************************************************************************************


macroScript Free_Camera 
            category:"Lights and Cameras" 
            internalcategory:"Lights and Cameras" 
            tooltip:"Free Camera" 
            buttontext:"Free Camera" 
            Icon:#("Cameras",2)
(
   on execute do StartObjectCreation FreeCamera
   on isChecked return (mcrUtils.IsCreating FreeCamera)
)

macroScript Target_Camera 
            category:"Lights and Cameras" 
            internalcategory:"Lights and Cameras" 
            tooltip:"Target Camera" 
            buttontext:"Target Camera" 
            Icon:#("Cameras",1)
(
   on execute do StartObjectCreation TargetCamera
   on isChecked return (mcrUtils.IsCreating TargetCamera)
)
MacroScript Camera_SelectTarget
ButtonText:"Select Target"
category:"Lights and Cameras" 
internalcategory:"Lights and Cameras" 
Tooltip:"Select Target (Cameras)" 
(

	On IsVisible Return Filters.Is_Camera $
	On Execute Do Try(select $.Target) Catch()
)
