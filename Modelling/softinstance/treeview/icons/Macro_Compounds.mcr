-- Macro Scripts File
-- Created:  Jan 1 1999
-- Modified  March 2 1999
-- Author:   Frank DeLise
-- Macro Scripts for Compound Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript Morph 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Morph Compound Object" 
            buttontext:"Morph" 
            Icon:#("Compound",1)
(
    on execute do (
      If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first" Title:"Morph"
	)
	Else 
	(
	StartObjectCreation Morph
	)
    )
   on isChecked return (mcrUtils.IsCreating Morph)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)

macroScript Conform 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Conform Compound Object" 
            buttontext:"Conform" 
            Icon:#("Compound",2)
(
    on execute do (
        If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first" Title:"Conform"
	)
	Else 
	(
	StartObjectCreation Conform
	)
    )
   on isChecked return (mcrUtils.IsCreating Conform)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)

macroScript ShapeMerge 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"ShapeMerge Compound Object" 
            buttontext:"ShapeMerge" 
            Icon:#("Compound",3)
(
    on execute do (
        If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first " Title:"ShapeMerge"
	)
	Else 
	(
	StartObjectCreation ShapeMerge
	)
    )
   on isChecked return (mcrUtils.IsCreating ShapeMerge)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)

macroScript Terrain 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Terrain Compound Object" 
            buttontext:"Terrain" 
            Icon:#("Compound",4)
(
    on execute do (
        If SuperClassof $ != shape then
	(
	MessageBox "Please Select a Shape first" Title:"Terrain"
	)
	Else 
	(
	StartObjectCreation Terrain 
	)
   )
   on isChecked return (mcrUtils.IsCreating Terrain)
   on isEnabled return not (SuperClassof $ != shape )

)

macroScript Loft 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Loft Compound Object" 
            buttontext:"Loft" 
            Icon:#("Compound",8)
(
    on execute do (
        If SuperClassof $ != shape then
	(
	MessageBox "Please Select a Shape first" Title:"Loft"
	)
	Else 
	(
	StartObjectCreation Loft
	)
    )
   on isChecked return (mcrUtils.IsCreating Loft)
   on isEnabled return not (SuperClassof $ != shape )

)

macroScript Scatter 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Scatter Compound Object" 
            buttontext:"Scatter" 
            Icon:#("Compound",5)
(
    on execute do (
        If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first " Title:"Scatter"
	)
	Else 
	(
	StartObjectCreation Scatter
	)
    )
   on isChecked return (mcrUtils.IsCreating Scatter)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)

macroScript Connect 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Connect Compound Object" 
            buttontext:"Connect" 
            Icon:#("Compound",6)
(
    on execute do (
        If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first " Title:"Connect"
	)
	Else 
	(
	StartObjectCreation Connect
	)
    )
   on isChecked return (mcrUtils.IsCreating Connect)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)

macroScript Boolean 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Boolean Compound Object" 
            buttontext:"Boolean" 
            Icon:#("Compound",7)
(
    on execute do (
        If SuperClassof $ != GeometryClass and SuperClassof $ != Shape then
	(
	MessageBox "Please Select an Object or Shape first " Title:"Boolean"
	)
	Else 
	(
	StartObjectCreation Boolean2
	)
   )
   on isChecked return (mcrUtils.IsCreating Boolean2)
   on isEnabled return not (SuperClassof $ != GeometryClass and SuperClassof $ != Shape )

)


