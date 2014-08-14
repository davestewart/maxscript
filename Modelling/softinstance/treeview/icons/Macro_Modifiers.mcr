--- Macro Scripts File
-- Created:  Nov 17 1998
-- Modified: April 22 2002 Fred Ruff
-- Author:   Frank DeLise
-- Macro Scripts for Modifiers
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
-- Requires AddmodFunc.ms

macroScript Bend 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            ButtonText:"Bend"
			tooltip:"Bend Modifier" 
            Icon:#("Standard_Modifiers",1)
(
	on execute do AddMod Bend
	on isEnabled return mcrUtils.ValidMod Bend
)

macroScript Taper 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Taper"
            tooltip:"Taper Modifier" 
            Icon:#("Standard_Modifiers",2)
(
	on execute do AddMod Taper
	on isEnabled return mcrUtils.ValidMod Taper
)

macroScript MeshSmooth 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"MeshSmooth"
            tooltip:"MeshSmooth Modifier" 
            Icon:#("Standard_Modifiers",19)
(
	on execute do AddMod MeshSmooth
	on isEnabled return mcrUtils.ValidMod MeshSmooth
)

macroScript Ripple 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Ripple"
            tooltip:"Ripple Modifier" 
            Icon:#("Standard_Modifiers",9)
(
	on execute do AddMod Ripple
	on isEnabled return mcrUtils.ValidMod Ripple
)

macroScript Wave 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Wave"
            tooltip:"Wave Modifier" 
            Icon:#("Standard_Modifiers",8)
(
	on execute do AddMod Wave
	on isEnabled return mcrUtils.ValidMod Wave
)

macroScript Edit_Mesh 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Edit Mesh Modifier"
			ButtonText:"Edit Mesh" 
            Icon:#("Max_Edit_Modifiers",1)
(
	on execute do AddMod Edit_Mesh
	on isEnabled return mcrUtils.ValidMod Edit_Mesh
)

macroScript Edit_Spline 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Edit Spline Modifier"
			ButtonText:"Edit Spline"
            Icon:#("Max_Edit_Modifiers",11)
(
	on execute do AddMod Edit_Spline
	on isEnabled return mcrUtils.ValidMod Edit_Spline
)

macroScript Relax 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Relax"
            tooltip:"Relax Modifier" 
            Icon:#("Standard_Modifiers",21)
(
	on execute do AddMod Relax
	on isEnabled return mcrUtils.ValidMod Relax
)

macroScript Edit_Patch 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Edit Patch Modifier"
			ButtonText:"Edit Patch" 
            Icon:#("Max_Edit_Modifiers",2)
(
	on execute do AddMod Edit_Patch
	on isEnabled return mcrUtils.ValidMod Edit_Patch
)

macroScript Twist 
            category:"Modifiers"
            internalcategory:"Modifiers"
			ButtonText:"Twist" 
            tooltip:"Twist Modifier" 
            Icon:#("Standard_Modifiers",4)
(
	on execute do AddMod Twist
	on isEnabled return mcrUtils.ValidMod Twist
)

macroScript Extrude 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Extrude"
            tooltip:"Extrude Modifier" 
            Icon:#("Standard_Modifiers",13)
(
	on execute do AddMod Extrude
	on isEnabled return mcrUtils.ValidMod Extrude
)

macroScript Lathe 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Lathe"
            tooltip:"Lathe Modifier" 
            Icon:#("Standard_Modifiers",14)
(
	on execute do AddMod Lathe
	on isEnabled return mcrUtils.ValidMod Lathe
)

macroScript Bevel 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Bevel"
            tooltip:"Bevel Modifier" 
            Icon:#("Standard_Modifiers",17)
(
	on execute do AddMod Bevel
	on isEnabled return mcrUtils.ValidMod Bevel
)

macroScript Stretch 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Stretch"
            tooltip:"Stretch Modifier" 
            Icon:#("Standard_Modifiers",5)
(
	on execute do AddMod Stretch
	on isEnabled return mcrUtils.ValidMod Stretch
)

macroScript Face_Extrude 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Face Extrude Modifier"
			ButtonText:"Face Extrude" 
            Icon:#("Max_Edit_Modifiers",5)
(
	on execute do AddMod Face_Extrude
	on isEnabled return mcrUtils.ValidMod Face_Extrude
)

macroScript Optimize 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Optimize"
            tooltip:"Optimize Modifier" 
            Icon:#("Standard_Modifiers",34)
(
	on execute do AddMod Optimize
	on isEnabled return mcrUtils.ValidMod Optimize
)

macroScript Displace 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
			ButtonText:"Displace"
            tooltip:"Displace Modifier" 
            Icon:#("Standard_Modifiers",18)
(
	on execute do AddMod Displace
	on isEnabled return mcrUtils.ValidMod Displace
)

macroScript Linked_xform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Linked XForm Modifier"
			ButtonText:"Linked XForm" 
            Icon:#("Standard_Modifiers",32)
(
	on execute do AddMod Linked_xform
	on isEnabled return mcrUtils.ValidMod Linked_xform
)

macroScript Affect_Region 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Affect Region Modifier"
			ButtonText:"Affect Region" 
            Icon:#("Standard_Modifiers",15)
(
	on execute do AddMod Affect_Region
	on isEnabled return mcrUtils.ValidMod Affect_Region
)

macroScript Uvwmap 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"UVW Map Modifier"
			ButtonText:"UVW Map" 
            Icon:#("Material_Modifiers",4)
(
	on execute do AddMod Uvwmap
	on isEnabled return mcrUtils.ValidMod Uvwmap
)

macroScript Volumeselect 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Volume Select Modifier" 
			ButtonText:"Volume Select"
            Icon:#("Max_Edit_Modifiers",4)
(
	on execute do AddMod VolumeSelect
	on isEnabled return mcrUtils.ValidMod VolumeSelect
)

macroScript Material_ID 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Material Modifier"
			ButtonText:"Material" 
            Icon:#("Material_Modifiers",2)
(
	on execute do AddMod Materialmodifier
	on isEnabled return mcrUtils.ValidMod Materialmodifier
)

macroScript Smooth 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Smooth Modifier"
			ButtonText:"Smooth" 
            Icon:#("Standard_Modifiers",23)
(
	on execute do AddMod smooth
	on isEnabled return mcrUtils.ValidMod smooth
)

macroScript Normalmodifier 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Normal Modifier" 
			ButtonText:"Normal Modifier"
            Icon:#("Max_Edit_Modifiers",6)
(
	on execute do AddMod Normalmodifier
	on isEnabled return mcrUtils.ValidMod Normalmodifier
)

macroScript Skin 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Skin Modifier" 
			ButtonText:"Skin"
            Icon:#("Standard_Modifiers",26)
(
	on execute do AddMod Skin
	on isEnabled return mcrUtils.ValidMod Skin
)

macroScript Unwrap_UVW 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Unwrap UVW Modifier" 
			ButtonText:"Unwrap UVW"
            Icon:#("Material_Modifiers",6)
(
	on execute do AddMod Unwrap_UVW
	on isEnabled return mcrUtils.ValidMod Unwrap_UVW
)

macroScript Push 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Push Modifier"
			ButtonText:"Push" 
            Icon:#("Standard_Modifiers",36)
(
	on execute do AddMod Push
	on isEnabled return mcrUtils.ValidMod Push
)

macroScript Trim_Extend 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Trim/Extend Modifier"
			ButtonText:"Trim/Extend"
            Icon:#("Max_Edit_Modifiers",14)
(
	on execute do AddMod Trim_Extend
	on isEnabled return mcrUtils.ValidMod Trim_Extend
)

macroScript Squeeze 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Squeeze Modifier"
			ButtonText:"Squeeze" 
            Icon:#("Standard_Modifiers",6)
(
	on execute do AddMod Squeeze
	on isEnabled return mcrUtils.ValidMod Squeeze
)

macroScript Delete_Spline 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Delete Spline Modifier"
			ButtonText:"Delete Spline" 
            Icon:#("Max_Edit_Modifiers",12)
(
	on execute do AddMod DeleteSplineModifier
	on isEnabled return mcrUtils.ValidMod DeleteSplineModifier
)

macroScript CrossSection 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"CrossSection Modifier"
			ButtonText:"CrossSection" 
            Icon:#("Surface_Tools",1)
(
	on execute do AddMod CrossSection
	on isEnabled return mcrUtils.ValidMod CrossSection
)

macroScript Surface 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Surface Modifier"
			ButtonText:"Surface" 
            Icon:#("Surface_Tools",2)
(
	on execute do AddMod surface
	on isEnabled return mcrUtils.ValidMod surface
)

macroScript Lattice 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Lattice Modifier"
			ButtonText:"Lattice" 
            Icon:#("Max_Edit_Modifiers",8)
(
	on execute do AddMod Lattice
	on isEnabled return mcrUtils.ValidMod Lattice
)

macroScript Fillet_Chamfer 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Fillet/Chamfer Modifier"
			ButtonText:"Fillet/Chamfer" 
            Icon:#("Max_Edit_Modifiers",13)
(
	on execute do AddMod Fillet_Chamfer
	on isEnabled return mcrUtils.ValidMod Fillet_Chamfer
)

macroScript Morpher 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Morpher Modifier"
			ButtonText:"Morpher" 
            Icon:#("Standard_Modifiers",24)
(
	on execute do AddMod Morpher
	on isEnabled return mcrUtils.ValidMod Morpher
)

macroScript Normalize_Spline 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Normalize Spline Modifier"
			ButtonText:"Normalize Spline" 
            Icon:#("Max_Edit_Modifiers",13)
(
	on execute do AddMod Normalize_Spline
	on isEnabled return mcrUtils.ValidMod Normalize_Spline
)

macroScript FFD_2x2x2 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD 2x2x2 Modifier" 
			ButtonText:"FFD 2x2x2"
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_2x2x2
	on isEnabled return mcrUtils.ValidMod FFD_2x2x2
)

macroScript FFD_4x4x4 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD 4x4x4 Modifier"
			ButtonText:"FFD 4x4x4" 
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_4x4x4
	on isEnabled return mcrUtils.ValidMod FFD_4x4x4
)

macroScript FFD_3x3x3 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD 3x3x3 Modifier"
			ButtonText:"FFD 3x3x3" 
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFD_3x3x3
	on isEnabled return mcrUtils.ValidMod FFD_3x3x3
)

macroScript CameraMap 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Camera Map Modifier"
			ButtonText:"Camera Map" 
            Icon:#("Deform_Modifiers",1)
(
	on execute do AddMod CameraMap
	on isEnabled return mcrUtils.ValidMod CameraMap
)


macroScript XForm 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"XForm Modifier"
			ButtonText:"XForm" 
            Icon:#("Standard_Modifiers",31)
(
	on execute do AddMod XForm
	on isEnabled return mcrUtils.ValidMod XForm
)

macroScript Slice 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Slice Modifier"
			ButtonText:"Slice" 
            Icon:#("Standard_Modifiers",30)
(
	on execute do AddMod slicemodifier
	on isEnabled return mcrUtils.ValidMod slicemodifier
)

macroScript FFD_Select 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD Select Modifier"
			ButtonText:"FFD Select" 
            Icon:#("Standard_Modifiers",12)
(
	on execute do AddMod FFD_Select
	on isEnabled return mcrUtils.ValidMod FFD_Select
)

macroScript Melt 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Melt Modifier"
			ButtonText:"Melt" 
            Icon:#("Standard_Modifiers",20)
(
	on execute do 
	(	try (AddMod Melt) Catch(MessageBox "Melt not installed!" Title:"Modifiers")
	)
	on isEnabled return mcrUtils.ValidMod Melt
)

macroScript STL_Check 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"STL Check Modifier"
			ButtonText:"STL Check" 
            Icon:#("Standard_Modifiers",33)
(
	on execute do AddMod STL_Check
	on isEnabled return mcrUtils.ValidMod STL_Check
)

macroScript Cap_Holes 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Cap Holes Modifier"
			ButtonText:"Cap Holes" 
            Icon:#("Standard_Modifiers",29)
(
	on execute do AddMod Cap_Holes
	on isEnabled return mcrUtils.ValidMod Cap_Holes
)

macroScript Preserve 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Preserve Modifier"
			ButtonText:"Preserve" 
            Icon:#("Standard_Modifiers",35)
(
	on execute do AddMod Preserve
	on isEnabled return mcrUtils.ValidMod Preserve
)

macroScript Spline_Select 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Spline Select Modifier" 
			ButtonText:"Spline Select"
            Icon:#("Max_Edit_Modifiers",10)
(
	on execute do AddMod SplineSelect
	on isEnabled return mcrUtils.ValidMod SplineSelect
)

macroScript Material_By_Element 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Material By Element Modifier"
			ButtonText:"Material By Element" 
            Icon:#("Material_Modifiers",3)
(
	on execute do AddMod MaterialByElement
	on isEnabled return mcrUtils.ValidMod MaterialByElement
)

macroScript UVW_Xform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"UVW XForm Modifier"
			ButtonText:"UVW XForm"
            Icon:#("Material_Modifiers",5)
(
	on execute do AddMod UVW_Xform
	on isEnabled return mcrUtils.ValidMod UVW_Xform
)

macroScript PatchDeform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Patch Deform Modifier"
			ButtonText:"Patch Deform" 
            Icon:#("Deform_Modifiers",3)
(
	on execute do AddMod PatchDeform
	on isEnabled return mcrUtils.ValidMod PatchDeform
)

macroScript NSurf_Sel 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"NURBS Surface Selection Modifier"
			ButtonText:"NURBS Surface Select" 
            Icon:#("Max_Edit_Modifiers",16)
(
	on execute do AddMod NSurf_Sel
	on isEnabled return mcrUtils.ValidMod NSurf_Sel
)

macroScript Vertex_Paint 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Vertex Paint Modifier"
			ButtonText:"Vertex Paint" 
            Icon:#("Standard_Modifiers",37)
( 
	on execute do
	(	if ((AddMod VertexPaint) == true) then  -- it worked, do so logical presets
		(
			for i = 1 to selection.count do
			(
				selection[i].showvertexcolors = true
				selection[i].vertexcolorsshaded = true
				selection[i].wirecolor = white
			)
		)
		-- else do nothing
	)

	on isEnabled return mcrUtils.ValidMod VertexPaint
)

macroScript Skew 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Skew Modifier"
			ButtonText:"Skew" 
            Icon:#("Standard_Modifiers",3)
(
	on execute do AddMod Skew
	on isEnabled return mcrUtils.ValidMod Skew
)

macroScript Mesh_Select 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Mesh Select Modifier"
			ButtonText:"Mesh Select" 
            Icon:#("Max_Edit_Modifiers",3)
(
	on execute do AddMod Mesh_Select
	on isEnabled return mcrUtils.ValidMod Mesh_Select
)

macroScript SurfDeform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Surf Deform Modifier" 
			ButtonText:"Surf Deform"
            Icon:#("Deform_Modifiers",5)
(
	on execute do AddMod SurfDeform
	on isEnabled return mcrUtils.ValidMod SurfDeform
)


macroScript Disp_Approx 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Disp Approx Modifier"
			ButtonText:"Disp Approx"
            Icon:#("Max_Edit_Modifiers",18)
(
	on execute do AddMod Disp_Approx
	on isEnabled return mcrUtils.ValidMod Disp_Approx
)

macroScript Bevel_Profile 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Bevel Profile Modifier"
			ButtonText:"Bevel Profile" 
            Icon:#("Standard_Modifiers",16)
(
	on execute do AddMod Bevel_Profile
	on isEnabled return mcrUtils.ValidMod Bevel_Profile
)

macroScript PathDeform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Path Deform Modifier" 
			ButtonText:"Path Deform"
            Icon:#("Deform_Modifiers",7) 
(
	on execute do AddMod PathDeform
	on isEnabled return mcrUtils.ValidMod PathDeform
)

macroScript FFDBox 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD Box Modifier"
			ButtonText:"FFD Box"
            Icon:#("Standard_Modifiers",10)
(
	on execute do AddMod FFDBox
	on isEnabled return mcrUtils.ValidMod FFDBox
)

macroScript FFDCyl 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"FFD Cylinder Modifier" 
			ButtonText:"FFD Cylinder"
            Icon:#("Standard_Modifiers",11)
(
	on execute do AddMod FFDCyl
	on isEnabled return mcrUtils.ValidMod FFDCyl
)

macroScript Tessellate 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Tessellate Modifier"
			ButtonText:"Tessellate" 
            Icon:#("Max_Edit_Modifiers",7)
(
	on execute do AddMod Tessellate
	on isEnabled return mcrUtils.ValidMod Tessellate
)

macroScript Spherify 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Spherify Modifier"
			ButtonText:"Spherify" 
            Icon:#("Standard_Modifiers",22)
(
	on execute do AddMod Spherify
	on isEnabled return mcrUtils.ValidMod Spherify
)

macroScript Flex 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Flex Modifier"
			ButtonText:"Flex" 
            Icon:#("Standard_Modifiers",27)
(
	on execute do AddMod Flex
	on isEnabled return mcrUtils.ValidMod Flex
)

macroScript Mirror 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Mirror Modifier"
			ButtonText:"Mirror" 
            Icon:#("Standard_Modifiers",28)
(
	on execute do AddMod Mirror
	on isEnabled return mcrUtils.ValidMod Mirror
)

macroScript DeleteMesh 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Delete Mesh Modifier"
			ButtonText:"Delete Mesh"
            Icon:#("Max_Edit_Modifiers",9)
(
	on execute do AddMod DeleteMesh
	on isEnabled return mcrUtils.ValidMod DeleteMesh
)

macroScript Noise 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Noise Modifier"
			ButtonText:"Noise" 
            Icon:#("Standard_Modifiers",7)
(
	on execute do AddMod Noisemodifier
	on isEnabled return mcrUtils.ValidMod Noisemodifier
)

-- Added new r4 modifiers 
--***********************************************************************************************

macroScript DeletePatch 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Delete Patch Modifier" 
			ButtonText:"Delete Patch"
(
	on execute do AddMod DeletePatch
	on isEnabled return mcrUtils.ValidMod DeletePatch
)
macroScript PatchSelect 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Patch Select Modifier" 
			ButtonText:"Patch Select" 
(
	on execute do AddMod Patch_Select
	on isEnabled return mcrUtils.ValidMod Patch_Select
)
macroScript PointCache 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Point Cache Modifier" 
			ButtonText:"Point Cache"
(
	on execute do AddMod Point_Cache
	on isEnabled return mcrUtils.ValidMod Point_Cache
)
macroScript HSDSModifier 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"HSDS Modifier" 
			ButtonText:"HSDS Modifier"
(
	on execute do AddMod HSDS_Modifier
	on isEnabled return mcrUtils.ValidMod HSDS_Modifier
)
macroScript ConvertToPatch 
           category:"Modifiers" 
           internalcategory:"Modifiers" 
            tooltip:"Convert To Patch Modifier" 
			ButtonText:"Convert To Patch"
(
	on execute do AddMod ConvertToPatch
	on isEnabled return mcrUtils.ValidMod ConvertToPatch
)
macroScript SpaceCameraMap 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Camera Map (WSM)"
			ButtonText:"* Camera Map" 
            Icon:#("Deform_Modifiers",1)
(
	on execute do addModifier $ (SpaceCameraMap ())
	on isEnabled return (superclassof $ == GeometryClass)
)
macroScript SpaceSurfDeform 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"SurfDeform (WSM)" 
			ButtonText:"* Surf Deform"
            Icon:#("Deform_Modifiers",5)
(
	on execute do addModifier $ (SpaceSurfDeform ())
	on isEnabled return (superclassof $ == GeometryClass)
)

macroScript PolySelect 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Poly Select Modifier" 
			ButtonText:"Poly Select" 
(
	on execute do AddMod Poly_Select
	on isEnabled return mcrUtils.ValidMod Poly_Select
)
--***********************************************************************************************
-- added max 5 modifiers

macroScript Subdivide 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Subdivide" 
			ButtonText:"Subdivide" 
(
	on execute do AddMod Subdivide 
	on isEnabled return mcrUtils.ValidMod Subdivide 
)

macroScript WSubdivide 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Subdivide (WSM)" 
			ButtonText:"* Subdivide" 
(
	on execute do AddMod subdivideSpacewarpModifier 
	on isEnabled return mcrUtils.ValidMod subdivideSpacewarpModifier
)
macroScript EditNormals 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Edit Normals " 
			ButtonText:"Edit Normals " 
(
	on execute do AddMod EditNormals 
	on isEnabled return mcrUtils.ValidMod EditNormals 
)
macroScript Symmetry 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Symmetry" 
			ButtonText:"Symmetry" 
(
	on execute do AddMod Symmetry
	on isEnabled return mcrUtils.ValidMod Symmetry
)
macroScript VertexWeld 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"Vertex Weld " 
			ButtonText:"Vertex Weld " 
(
	on execute do AddMod Vertex_Weld 
	on isEnabled return mcrUtils.ValidMod Vertex_Weld 
)
macroScript SplineIkControl 
            category:"Modifiers" 
            internalcategory:"Modifiers" 
            tooltip:"SplineIkControl " 
			ButtonText:"SplineIkControl " 
(
	on execute do AddMod Spline_Ik_Control 
	on isEnabled return mcrUtils.ValidMod Spline_Ik_Control 
)
