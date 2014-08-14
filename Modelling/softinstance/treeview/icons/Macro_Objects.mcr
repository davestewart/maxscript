-- Macro Scripts File
-- Created:  Nov 17 1998
-- Modified: April 2 1999 12:25pm
-- Author:   Frank DeLise
-- Macro Scripts for Objects
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript GeoSphere 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"GeoSphere Object"
			ButtonText:"GeoSphere" 
            icon:#("Standard",7) 
(
	on execute do (Try(StartObjectCreation GeoSphere) Catch() )
        on isChecked return (mcrUtils.IsCreating GeoSphere)
)

macroScript Box 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Box Object" 
			ButtonText:"Box"
            icon:#("standard", 1)
(
	on execute do StartObjectCreation Box
        on isChecked return (mcrUtils.IsCreating Box)
)

macroScript Sphere 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Sphere Object"
			ButtonText:"Sphere" 
            icon:#("standard", 2)
(
	on execute do StartObjectCreation Sphere 
        on isChecked return (mcrUtils.IsCreating Sphere)
)

macroScript Cylinder 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Cylinder Object"
			ButtonText:"Cylinder" 
            icon:#("Standard",3)
(
	on execute do StartObjectCreation Cylinder 
        on isChecked return (mcrUtils.IsCreating Cylinder)
)

macroScript Torus 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Torus Object"
			ButtonText:"Torus" 
            icon:#("Standard",4)
(
	on execute do StartObjectCreation Torus 
        on isChecked return (mcrUtils.IsCreating Torus)
)

macroScript Torus_Knot 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Torus Knot Object"
			ButtonText:"Torus Knot" 
            icon:#("Extended",7)
(
	on execute do StartObjectCreation Torus_Knot 
        on isChecked return (mcrUtils.IsCreating Torus_Knot)
)

macroScript Quadpatch 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Quad Patch Object"
			ButtonText:"Quad Patch" 
            icon:#("Patches",1)
(	
	on execute do StartObjectCreation Quadpatch
        on isChecked return (mcrUtils.IsCreating Quadpatch)
)

macroScript Tripatch 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Tri Patch Object"
			ButtonText:"Tri Patch" 
            icon:#("Patches",2)
(
	on execute do StartObjectCreation Tripatch 
        on isChecked return (mcrUtils.IsCreating Tripatch)
)

macroScript Tube 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Tube Object"
			ButtonText:"Tube" 
            icon:#("Standard",8)
(
	on execute do StartObjectCreation Tube 
        on isChecked return (mcrUtils.IsCreating Tube)
)

macroScript plane 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Plane Object"
			ButtonText:"Plane" 
            icon:#("Standard",10)
(
	on execute do StartObjectCreation Plane
        on isChecked return (mcrUtils.IsCreating Plane)
)

macroScript L_Ext 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"L-Extrusion Object"
			ButtonText:"L-Extrusion" 
            icon:#("Extended",10)
(
	on execute do StartObjectCreation L_Ext
        on isChecked return (mcrUtils.IsCreating L_Ext)
)

macroScript Spindle 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Spindle Object"
			ButtonText:"Spindle" 
            icon:#("Extended",4)
(
	on execute do StartObjectCreation Spindle 
        on isChecked return (mcrUtils.IsCreating Spindle)
)

macroScript ChamferBox 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"ChamferBox Object"
			ButtonText:"Chamfer Box" 
            icon:#("Extended",2)
(	
	on execute do StartObjectCreation ChamferBox 
        on isChecked return (mcrUtils.IsCreating ChamferBox)
)

macroScript OilTank 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Oil Tank Object"
			buttontext:"Oil Tank" 
            icon:#("Extended",3)
(	
	on execute do StartObjectCreation OilTank 
        on isChecked return (mcrUtils.IsCreating OilTank)
)

macroScript RingWave 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"RingWave Object"
			ButtonText:"RingWave" 
            icon:#("Extended",6)
(
	on execute do StartObjectCreation RingWave 
        on isChecked return (mcrUtils.IsCreating RingWave)
)

macroScript C_Ext 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"C-Extrusion Object"
			ButtonText:"C-Extrusion" 
            icon:#("Extended",11)
(
	on execute do StartObjectCreation C_Ext 
        on isChecked return (mcrUtils.IsCreating C_Ext)
)

macroScript Gengon 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Gengon Object"
			ButtonText:"Gengon" 
            icon:#("Extended",5)
(
	on execute do StartObjectCreation Gengon 
        on isChecked return (mcrUtils.IsCreating Gengon)
)

macroScript Prism 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Prism Object" 
			ButtonText:"Prism"
            icon:#("Extended",12) 
(
	on execute do StartObjectCreation Prism 
        on isChecked return (mcrUtils.IsCreating Prism)
)

macroScript Capsule 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Capsule Object"
			ButtonText:"Capsule" 
            icon:#("Extended",9)
(
	on execute do StartObjectCreation Capsule 
        on isChecked return (mcrUtils.IsCreating Capsule)
)


macroScript Point_Surf 
            category:"NURBS" 
            internalcategory:"NURBS" 
			tooltip:"Point Surface Object (NURBS)" 
			ButtonText:"Point Surface"
            icon:#("NURBSSurface",1)
(
	on execute do (Try(StartObjectCreation Point_Surf) Catch () )
        on isChecked return (mcrUtils.IsCreating Point_Surf)
)

macroScript CV_Surf 
            category:"NURBS" 
            internalcategory:"NURBS" 
            tooltip:"CV Surface Object (NURBS)"
			ButtonText:"CV Surface" 
            icon:#("NURBSSurface",2)
(
	on execute do (Try(StartObjectCreation NURBSSurf) Catch())
        on isChecked return (mcrUtils.IsCreating NURBSSurf)
)

macroScript Pyramid 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Pyramid Object"
			ButtonText:"Pyramid" 
            icon:#("Standard",9)
(
	on execute do StartObjectCreation Pyramid 
        on isChecked return (mcrUtils.IsCreating Pyramid)
)

macroScript ChamferCyl 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Chamfer Cylinder Object"
			ButtonText:"Chamfer Cylinder" 
            icon:#("Extended",8)
(
	on execute do StartObjectCreation ChamferCyl 
        on isChecked return (mcrUtils.IsCreating ChamferCyl)
)

macroScript Cone 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Cone Object" 
			ButtonText:"Cone"
            icon:#("Standard",6)
(
	on execute do StartObjectCreation Cone
        on isChecked return (mcrUtils.IsCreating Cone)
)

macroScript Teapot 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Teapot Object"
			ButtonText:"Teapot" 
            icon:#("Standard",5)
(
	on execute do StartObjectCreation Teapot 
        on isChecked return (mcrUtils.IsCreating Teapot)
)

macroScript Hedra 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Hedra Object"
			ButtonText:"Hedra" 
            icon:#("Extended",1)
(
	on execute do StartObjectCreation Hedra 
        on isChecked return (mcrUtils.IsCreating Hedra)
)
macroScript Hose 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Hose Object"
			ButtonText:"Hose" 
(
	on execute do StartObjectCreation Hose 
        on isChecked return (mcrUtils.IsCreating Hose)
)

