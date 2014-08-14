-- Macro Scripts File
-- Created:  Jan 10 1999
-- Modified: Jan 28, 1999
-- Author:   Frank DeLise
-- Macro Scripts for Helpers
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript Dummy 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Dummy Object"
			ButtonText:"Dummy" 
            Icon:#("Helpers",1)
(
    on execute do StartObjectCreation Dummy
    on isChecked return mcrUtils.IsCreating Dummy 
)

macroScript Point 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Point Object" 
			ButtonText:"Point"
            Icon:#("Helpers",2)
(
    on execute do StartObjectCreation Point
    on isChecked return mcrUtils.IsCreating Point 
)

macroScript Protractor 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Protractor Object"
			ButtonText:"Protractor" 
            Icon:#("Helpers",3)
(
    on execute do StartObjectCreation Protractor
    on isChecked return mcrUtils.IsCreating Protractor
)

macroScript Grid 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Grid Object"
			ButtonText:"Grid" 
            Icon:#("Helpers",4)
(
    on execute do StartObjectCreation Grid
    on isChecked return mcrUtils.IsCreating Grid 
)

--**********************************************************
-- Added 11/9/2000 FR
-- Grid Right Click Menus
macroScript ActivateGrid 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Activate Grid (Context)"
			ButtonText:"Activate Grid" 

(
	On IsEnabled Return (if activegrid != $ do true)
	On IsVisible Return Filters.Is_Grid $

	On Execute Do Try(ActiveGrid = $)Catch()
)
macroScript ActivateHomeGrid 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Activate HomeGrid (Context)"
			ButtonText:"Activate HomeGrid" 
(
	On IsEnabled Return (if activegrid != undefined do true)
	On IsVisible Return Filters.Is_Grid $

	On Execute Do Try(max activate home grid)Catch()
)

--**********************************************************
macroScript Tape 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Tape Measure Object"
			ButtonText:"Tape Measure" 
            Icon:#("Helpers",5)
(
    on execute do StartObjectCreation Tape
    on isChecked return mcrUtils.IsCreating Tape 
)

macroScript Compass 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Compass Object"
			ButtonText:"Compass" 
            Icon:#("Helpers",6)
(
    on execute do StartObjectCreation Compass
    on isChecked return mcrUtils.IsCreating Compass 
)

macroScript Boxgizmo 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Box Gizmo (Atmospheres)"
			ButtonText:"Box Gizmo" 
            Icon:#("AtmosApp",1)
(
    on execute do StartObjectCreation BoxGizmo
    on isChecked return mcrUtils.IsCreating BoxGizmo 
)

macroScript CylGizmo 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Cylinder Gizmo (Atmospheres)"
			ButtonText:"Cylinder Gizmo" 
            Icon:#("AtmosApp",2)
(
    on execute do StartObjectCreation CylGizmo
    on isChecked return mcrUtils.IsCreating CylGizmo 
)

macroScript SphereGizmo 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Sphere Gizmo (Atmospheres)"
			ButtonText:"Sphere Gizmo" 
            Icon:#("AtmosApp",3)
(
    on execute do StartObjectCreation SphereGizmo
    on isChecked return mcrUtils.IsCreating SphereGizmo 
)

macroScript CamPoint 
            category:"Helpers and Gizmos" 
            internalcategory:"Helpers and Gizmos" 
            tooltip:"Camera Point Object"
			ButtonText:"Camera Point" 
            Icon:#("CamP",1)
(
    on execute do StartObjectCreation CamPoint
    on isChecked return mcrUtils.IsCreating CamPoint 
)

