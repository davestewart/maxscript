/*
------------------------------
OnionCode
David Humpherys
Blur Studios
daveh@blur.com
------------------------------
.75  	-made OnionRoll Global and created a refreshUI method to update the interface from outside of this macroscript
	-fixed a import rezn8 bug that had objects undefined
.77	- fixed the rename in the properties.  now updates the layer in line
.78	- fixed a complete max crash that occured when a messagebox conflicted with a button push
.79	- added callbacks to remove dialog on reopen
	- added a preference to open the organize on create new
.80	- addd the remove empty layers to the manage layers
	- added a edit text field as another way to change the name of a layer in the 
.85    - add shift freeze to change all layer	
.90	- big code shift.. added a new set of custom attributes and restructured how the data sits.
	- made the organize layer box bigger, and removed the minimize maxmize buttons
	- tweaked the drag drop mechanism for better accuracy
	- tweaked the callbacks to close dialog on merge, and destroy data on new.
	- added a debug mode to the preferences that prints out information in the listener
.91 	- fixed a small bug in layer properties dialog open
	- the world layer now updates on hide / freeze all.
.92	- added small cheat to push the dialog position into positive numbers..
.92 	- tweaked a small thing in addLayer that was messing up the indexing.
.93	- added control + shift click on > selects all in group
.94	- fixed a bug...via a new fuction that scans the scene for layer names and removes ones that don't exist in max layers
	- swaped out .isselected with deselect so that items in subobject mode wouldn't undo themselves.
.95	- fixed some problems that happen with the rollout problem and size.(dave)
	- corrected the addition of objects to a layer.  they now hide/freee appropriatly.
	- fixed the shift-click world layer bug (leo)
	- extended the tooltips (flap)
	- added a 'get orphaned objects' to collect any xrefed objects with layer info
.96	- added a few lines to clear the alternate material holder when you uncheck it and at startup
	- copy the material to the material bucket holder no matter what....
.97	- a small change, a big improvement.  no longer Copying the alternate materials into the material holder.
	- addded a progress bar to the bottom instead of an additional rollout popup...that was annoying.
.98	- did a small tweak to hide objects and freeze them when added to a layer
.99	- reworked ca's so that they couldn't be animatable.
	- added a kill to remove all information
	- turned on the world layer active when uncheck a regular layer
1.00	- added alternate properties
	- added a few warnings about toggleing alt properties and materials
	- added a help to the alt properties.
1.01 --fixed strange bug that kevin had with hiding groups
1.02 --fixed a bug with setting the motion blur on a layer.
	--fixed a bug typing in the organize dialog
	--another attempt to make the drag drop better.
1.03 --fixed a ui bug that caused the alt materials to not uncheck properly.
1.04 --small tweak in the alt mterial copy.. now a reference
1.05 --fix for renaming layer
1.06 --fix for deleteing groups in the organizer
	--sped up the 'remove empty layers' function by not refreshing the dialog
1.07 --fix small typo that prevented the progress bar from working on hide
1.10 --tons of small tweaks and fixes.
	--seperated code structure into peices.   
	--added catch if you try and add an object to a layer and the object has it's alt material on it.
	

TODO: 	
	-if it can't find the layer by the name in the globaldata then it deletes it from globaldata
	-set a flag on objects that have alt material.   if they are added to a layer prompt the user to
		first remove the layer from alternate material status?...
	-- need to add a uber-cleanup method

*/
Global OnionLayerMoreMenu		--required to be global because the rollout is created as a string and executed...therefore in global scope.
Global OnionPath = (getdir #scripts)+"\\_blurScripts\\Onion\\"
Global Onion
Global OnionRoll
Global PREF_Debug_Mode
Global OnionOrganize
(
	local PREF_UI_ActiveLayerCheckColor
	local PREF_UI_HideCheckColor
	local PREF_UI_XRefCheckColor
	local PREF_DisXRScene
	local PREF_PromptOnNew
	local PREF_Inherit_Wire
	local PREF_Inherit_Display 
	local PREF_Inherit_Render 
	local PREF_Inherit_Blur 
	local PREF_Debug_Mode = true
--	local OnionRoll
	local OnionLayer
	
	Rollout OnionAbout "theOnion"
(
		label lab2 "beta v1.07" align:#left
		hyperlink hyp0 "theOnion" align:#right address:"http://www.blur.com/blurbeta" color:blue offset:[0,-19]
		hyperlink hyp1 "Blur Studios" align:#right address:"http://www.blur.com" color:blue
		hyperlink hyp2 "David Humpherys" address:"mailto:daveh@blur.com?subject=theOnion User Comments" align:#right color:blue
)
	Rollout OnionPrefRoll "Onion Preferences"
(
		local INIFILE =  "C:\\max5\\scripts\\_blurScripts\\Onion\\Onion.ini"
		
		groupbox grp1 "UI Colors" width:130 height:100 pos:[10,10] 
		colorpicker hideCheckCol "Layer Hide:" pos:[28,30] align:#right
		--use layer color as check color 
		colorpicker activeCheckCol "Active Layer:" pos:[20,55] align:#right
		colorpicker xrefCheckCol "XRef Visible:" pos:[22,80] align:#right
		
		groupbox grp3 "Inherit On Assignment" width:130 height:100 pos:[150,10]
		checkbox use_wirecolor "Wirecolor" pos:[160,30]
		checkbox use_display "Display Settings" pos:[160,50]
		checkbox use_render "Render Settings" pos:[160,70]
		checkbox use_mb "Motion Blur Settings" pos:[160,90]

		
		groupbox grp2 "General" width:270 height:90 pos:[10,120] 
		checkbox displayXRefScene "Show XRef Scenes as a Group" pos:[20,140]
		checkbox promptOnNew "Organize After Create" pos:[20,160]
		checkbox debugMode "Debug Mode" pos:[20,180]


		on OnionPrefRoll open do
	(
			hideCheckCol.color = PREF_UI_HideCheckColor
			activeCheckCol.color = PREF_UI_ActiveLayerCheckColor
			xrefCheckCol.color = PREF_UI_XRefCheckColor
			displayXRefScene.checked = PREF_DisXRScene 
			use_wirecolor.checked = PREF_Inherit_Wire
			use_display.checked = PREF_Inherit_Display 
			use_render.checked = PREF_Inherit_Render 
			use_mb.checked = PREF_Inherit_Blur
			promptOnNew.checked = PREF_PromptOnNew
			debugMode.checked = PREF_Debug_Mode
	)
		on hideCheckCol changed col do
	(
			PREF_UI_HideCheckColor = col
			setINISetting INIFile "UICOLORS" "LayerHideCheckColor" (col.r as string + "," + col.g as string + "," + col.b as string )
	)
		on activeCheckCol changed col do
	(
			PREF_UI_ActiveLayerCheckColor = col
			setINISetting INIFile "UICOLORS" "ActiveLayerCheckColor" (col.r as string + "," + col.g as string + "," + col.b as string )
	)
		on xrefCheckCol changed col do
	(
			PREF_UI_XRefCheckColor = col
			setINISetting INIFile "UICOLORS" "XRefCheckColor" (col.r as string + "," + col.g as string + "," + col.b as string )
	)
		on displayXRefScene changed state do
	(
			PREF_DisXRScene = state
			setINISetting INIFile "OPTIONS" "DisplayXRefScene" (state as string)
	)
		on use_wirecolor changed state do
	(
			PREF_Inherit_Wire = state
			setINISetting INIFile "OPTIONS" "InheritWireColor" (state as string)
	)
		on use_display changed state do
	(	
			PREF_Inherit_Display = state
			setINISetting INIFile "OPTIONS" "InheritDisplay" (state as string)
	)
		on use_render changed state do
	(
			PREF_Inherit_Render = state
			setINISetting INIFile "OPTIONS" "InheritRender" (state as string)
	)
		on use_mb changed state do
	(
			PREF_Inherit_Blur = state
			setINISetting INIFile "OPTIONS" "InheritBlur" (state as string)
	)
		on promptOnNew changed state do
	(
			PREF_PromptOnNew = state
			setINISetting INIFile "OPTIONS" "PromptNameOnNew" (state as string)
	)
		on debugMode changed state do
	(
			PREF_Debug_Mode = state
			setINISetting INIFile "OPTIONS" "DebugMode" (state as string)
	)
)
	
		

	Rollout OnionLayerProperties "Layer Properties"
(
		function changeProp prop val = 
	(
			if (PREF_Debug_Mode)  then print ("FN: changeProp prop: " + prop as string + " val: " + val as string )
			L = layermanager.getLayerFromName (globaltracks.oniondata.pickedlayer)
			setProperty L prop val
			if (isProperty objects[1] prop) then
		(
			--	createdialog OnionProgress
				disablesceneredraw()

				local theobjs = for i = 1 to objects.count where objects[i].layer.name == L.name collect objects[i]
				setProperty theobjs prop val
				/*
				case prop of 
			(

					default: ( setProperty theobjs prop val )
			)
				*/
				enablesceneredraw()
			--	destroydialog onionProgress
		)
	)
		groupBox grp1 "Layer Information" pos:[9,16] width:375 height:44 --76
		editText UI_LayerName "Name:" pos:[20,36] width:150 --text:L.name
		on UI_LayerName entered txt do 
	( 
			L = layermanager.getlayerFromName (globaltracks.oniondata.pickedlayer)
			L.setName txt
			
			--get the index from the name
			local Lind = finditem globaltracks.oniondata.layerName globaltracks.oniondata.pickedlayer
			local grp = onion.getGroupFromLayer Lind
			
			--change the button text
			execute ("grp" +grp as string+ ".LToggle_" +Lind as string + ".text = \"" + txt + "\"") 
			
			--change the name 
			globaltracks.oniondata.layerName[ Lind ] = txt
			globaltracks.oniondata.pickedlayer = txt
	)


		colorPicker UI_WireColor "WireColor" pos:[180,36] width:80 height:15 --color:LM.Layers[ LM.PropChange ].wirecolor
		on UI_WireColor changed val do ( changeProp  #wirecolor  (val) )

		dropdownlist Ui_Display "" pos:[275, 32] width:100 items:#("Viewport", "Bounding box", "Wireframe", "Shaded")
		on UI_Display selected val do (changeProp #display (val-1) )

		groupBox grp3 "Rendering Control" pos:[9,67] width:192 height:168
		checkbox UI_renderable "Renderable" pos:[16,85] width:84 height:16 
		on UI_renderable changed state do ( changeProp  #renderable  state )
		spinner UI_Visibility "Visibility:" pos:[135,86] width:60 height:16 range:[0,1, 0]
		on UI_Visibility changed val do ( changeProp  #visibility val )
		checkbox UI_inheritVisibility "Inherit Visibility" pos:[16,103] width:93 height:16 
		on UI_inheritVisibility changed state do ( changeProp  #inheritVisibility state )
		checkbox UI_primaryVisibility "Visible to Camera" pos:[16,121] width:105 height:16 
		on UI_primaryVisibility changed state do ( changeProp  #primaryVisibility  state )
		checkbox UI_secondaryVisibility "Visible to Reflection/Refraction" pos:[16,139] width:170 height:16 
		on UI_secondaryVisibility changed state do (  changeProp  #secondaryVisibility state )
		checkbox UI_receiveShadows "Receive Shadows" pos:[16,157] width:123 height:16
		on UI_receiveShadows changed state do (  changeProp  #receiveShadows state )
		checkbox UI_castShadows "Cast Shadows" pos:[16,175] width:123 height:16 
		on UI_castShadows changed state do ( changeProp  #castShadows  state )
		checkbox UI_applyAtmospherics "Apply Atmospherics" pos:[16,193] width:123 height:16 
		on UI_applyAtmospherics changed state do (  changeProp   #applyAtmospherics  state )
		checkbox UI_renderOccluded "Render Occluded Objects" pos:[16,211] width:153 height:16
		on UI_renderOccluded changed state do ( changeProp  #renderOccluded state )
		
		groupBox grp4 "Display Properties" pos:[213,67] width:172 height:240
		checkbox UI_boxMode "Display as Box" pos:[220,85] width:118 height:16
		on UI_boxMode changed state do ( changeProp  #boxMode  state )
		checkbox UI_backFaceCull "Backface Cull" pos:[220,103] width:93 height:16
		on UI_backFaceCull changed state do ( changeProp  #backFaceCull state )
		checkbox UI_allEdges "Edges Only" pos:[220,121] width:105 height:16 
		on UI_allEdges changed state do ( changeProp  #alledges ( not state) )
		checkbox UI_vertexTicks "Vertex Ticks" pos:[220,139] width:138 height:16
		on UI_vertexTicks changed state do ( changeProp   #vertexTicks state )
		checkbox UI_showTrajectory "Trajectory" pos:[220,157] width:123 height:16 
		on UI_showTrajectory changed state do ( changeProp   #showTrajectory state )
		checkbox UI_xray "See-Through" pos:[220,175] width:123 height:16
		on UI_xray changed state do ( changeProp  #xray state )
		checkbox UI_ignoreExtents "Ignore Extents" pos:[220,193] width:123 height:16  
		on UI_ignoreExtents changed state do ( changeProp  #ignoreExtents  state )
		checkbox UI_showFrozenInGray "Show Frozen in Gray" pos:[220,211] width:153 height:16 
		on UI_showFrozenInGray changed state do ( changeProp  #showFrozenInGray  state )
		checkbox UI_showVertexColors "Vertex Color" pos:[220,229] width:80 height:16 
		on UI_showVertexColors changed state do ( changeProp   #showVertexColors  state )
		checkButton UI_vertexColorsShaded "Shaded" pos:[330,229] width:47 height:18 
		on UI_vertexColorsShaded changed state do ( changeProp  #vertexColorsShaded  state )
		
		groupBox UI_MBGrp "Motion Blur" pos:[8,243] width:192 height:63
		radioButtons UI_motionblur "" pos:[17,282] width:184 height:16 labels:#("None", "Object", "Image") columns:3 
		on UI_motionblur changed state do 
	( 
			case state of
		(
				1:( changeProp #motionblur  #none )
				2:( changeProp #motionblur  #object )
				3:( changeProp #motionblur  #image )
		)
	)
		checkbox UI_motionBlurOn "Enabled" pos:[16,261] width:100 height:16 
		on UI_motionBlurOn changed state do ( changeProp   #motionBlurOn  state )
		spinner UI_imageMotionBlurMultiplier "Multiplier" pos:[125,261] width:65 height:16 range:[0,1, 0 ]
		on UI_imageMotionBlurMultiplier changed val do ( changeProp   #imageMotionBlurMultiplier val )
		
	
		button UI_PropDone "Close" pos:[306,315] width:79 height:26
		button UI_PropHelp "Help" pos:[20,315] width:80 height:26
		on UI_PropDone pressed do destroyDialog OnionLayerProperties  	
		on UI_PropHelp pressed do messageBox "Toggle each of properties of the layer to change the property of the objects on the layer.\nOnly the properties you change will be effected."
		on OnionLayerProperties open do
	(
			if (PREF_Debug_Mode)  then print ("ROLLOUT OPEN: OnionLayerProperties " + globaltracks.oniondata.pickedlayer )
			L = layermanager.getlayerFromName (globaltracks.oniondata.pickedlayer)
			if L != undefined do
		(
				case L.display of
			(
					#viewport: UI_Display.selection = 1
					#boundingbox: UI_Display.selection = 2
					#wireframe: UI_Display.selection = 3
					#shaded: UI_Display.selection = 4
			)
	
				UI_LayerName.text = L.name
				UI_WireColor.color = L.wirecolor
				UI_renderable.checked = L.renderable 
				UI_inheritVisibility.checked  = L.inheritvisibility 
				UI_primaryVisibility.checked = L.primaryvisibility
				UI_secondaryVisibility.checked = L.secondaryvisibility 
				UI_receiveShadows.checked = L.receiveshadows
				UI_castShadows.checked = L.castshadows
				UI_applyAtmospherics.checked  = L.applyatmospherics 
				UI_renderOccluded.checked = L.renderoccluded
				
				UI_boxMode.checked = L.boxMode
				UI_backFaceCull.checked = L.backfacecull 
				UI_allEdges.checked = L.allEdges
				UI_vertexTicks.checked = L.vertexticks 
				UI_showTrajectory.checked = L.showtrajectory
				UI_xray.checked = L.xray
				UI_ignoreExtents.checked = L.ignoreExtents
				UI_showFrozenInGray.checked = L.showfrozeningray 
				UI_showVertexColors.checked = L.showvertexcolors 
				UI_vertexColorsShaded.checked = L.vertexcolorsshaded
				
				case L.motionblur of
			(
					#none: UI_motionblur.state = 1
					#object: UI_motionblur.state = 2
					#image: UI_motionblur.state = 3
			)
				UI_motionBlurOn.checked = L.motionbluron
				UI_imageMotionBlurMultiplier.value = L.imagemotionblurmultiplier 
		)
			--else destroydialog OnionLayerProperties
	)
)
	

	
	Rollout OnionAltMatRoll "Onion Alternate Material"
(
		local layInd
		
		label lbl1 "Material:" pos:[5,10]
		materialbutton altMatButton "Click to pick material" width:180 pos:[50,5]
		button putToMatEdt "Put Material in Editor" pos:[5,35] enabled:false
		spinner slotNumber "Slot Number" type:#integer range:[1,24,1] pos:[160,38] width:70 enabled:false
		
		on altMatButton picked mat do
	(
			--use the pickedlayer attribute to push the material into the CA
			globaltracks.oniondata.AltMaterial[layInd  ] =  mat
			destroydialog OnionAltMatRoll 
	)
		on putToMatEdt pressed do
	(
			setMeditMaterial slotNumber.value globaltracks.oniondata.AltMaterial[ layInd  ] 
	)
		on OnionAltMatRoll open do
	(
			layInd = finditem globaltracks.oniondata.layername globaltracks.oniondata.pickedlayer
			
			if globaltracks.oniondata.isAltMaterial[ layInd ] then messageBox "This layer is currently in Alternate Material Mode. \nThe changes you make here will not be made to the objects until you toggle Alt Materials on and off."

			if globaltracks.oniondata.AltMaterial[ layInd ] != undefined then
		(
				altMatButton.text =  globaltracks.oniondata.AltMaterial[ layInd  ].name
				putToMatEdt.enabled = true
				slotNumber.enabled = true
		)
	)
)
	
	Rollout OnionAltPropRoll "Onion Alternate Property"
(
		local layInd
		group "Properties"
	(
			checkbox UI_Userenderable align:#left
			checkbox UI_renderable "Renderable" width:84 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UseinheritVisibility  align:#left
			checkbox UI_inheritVisibility "Inherit Visibility"  width:93 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UseprimaryVisibility  align:#left
			checkbox UI_primaryVisibility "Visible to Camera"  width:105 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UsesecondaryVisibility align:#left
			checkbox UI_secondaryVisibility "Visible to Reflection/Refraction"  width:170 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UsereceiveShadows align:#left
			checkbox UI_receiveShadows "Receive Shadows"  width:123 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UsecastShadows align:#left
			checkbox UI_castShadows "Cast Shadows" width:123 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UseapplyAtmospherics align:#left
			checkbox UI_applyAtmospherics "Apply Atmospherics"  width:123 height:16 align:#left offset:[30,-20] enabled:false
			checkbox UI_UserenderOccluded align:#left
			checkbox UI_renderOccluded "Render Occluded Objects"width:153 height:16 align:#left offset:[30,-20] enabled:false
	)
		
		on UI_Userenderable changed state do UI_renderable.enabled = state
		on UI_UseinheritVisibility changed state do UI_inheritVisibility.enabled = state
		on UI_UseprimaryVisibility changed state do UI_primaryVisibility.enabled = state
		on UI_UsesecondaryVisibility changed state do UI_secondaryVisibility.enabled = state
		on UI_UsereceiveShadows changed state do UI_receiveShadows.enabled = state
		on UI_UsecastShadows changed state do UI_castShadows.enabled = state
		on UI_UseapplyAtmospherics changed state do UI_applyAtmospherics.enabled = state
		on UI_UserenderOccluded changed state do UI_renderOccluded.enabled = state
		
		
		on OnionAltPropRoll open do
	(
			layInd = finditem globaltracks.oniondata.layername globaltracks.oniondata.pickedlayer
			UseAltString = globaltracks.oniondata.UseAltProperty[ layInd ]
			AltString = globaltracks.oniondata.AltProperty[ layInd ]
			
			--check to see if it's in that mode
			if globaltracks.oniondata.isAltProperty[ layInd ] then messageBox "This layer is currently in Alternate Property Mode. \nThe changes you make here will not be made to the objects until you toggle Alt Properties on and off."
	
			val = if UseAltString[1] == "1" then true else false
			UI_Userenderable.checked =  val
			UI_renderable.enabled =  val
			val = if UseAltString[2] == "1" then true else false
			UI_UseinheritVisibility.checked = val
			UI_inheritVisibility.enabled = val
			val = if UseAltString[3] == "1" then true else false
			UI_UseprimaryVisibility.checked =  val
			UI_primaryVisibility.enabled =  val
			val = if UseAltString[4] == "1" then true else false
			UI_UsesecondaryVisibility.checked = val
			UI_secondaryVisibility.enabled = val
			val = if UseAltString[5] == "1" then true else false
			UI_UsereceiveShadows.checked = val
			UI_receiveShadows.enabled = val
			val = if UseAltString[6] == "1" then true else false
			UI_UsecastShadows.checked =  val
			UI_castShadows.enabled =  val
			val = if UseAltString[7] == "1" then true else false
			UI_UseapplyAtmospherics.checked =  val
			UI_applyAtmospherics.enabled =  val
			val = if UseAltString[8] == "1" then true else false
			UI_UserenderOccluded.checked = val
			UI_renderOccluded.enabled = val
	
	
			val = if AltString[1] == "1" then true else false
			UI_renderable.checked =  val
			val = if AltString[2] == "1" then true else false
			UI_inheritVisibility.checked = val
			val = if AltString[3] == "1" then true else false
			UI_primaryVisibility.checked =  val
			val = if AltString[4] == "1" then true else false
			UI_secondaryVisibility.checked = val
			val = if AltString[5] == "1" then true else false
			UI_receiveShadows.checked = val
			val = if AltString[6] == "1" then true else false
			UI_castShadows.checked =  val
			val = if AltString[7] == "1" then true else false
			UI_applyAtmospherics.checked =  val
			val = if AltString[8] == "1" then true else false
			UI_renderOccluded.checked = val
	)
		on OnionAltPropRoll close do
	(
			ObjString = "11111111"
			if UI_renderable.checked == false do ObjString[1] = "0"
			if UI_inheritVisibility.checked == false do ObjString[2] = "0"
			if UI_primaryVisibility.checked == false do ObjString[3] = "0"
			if UI_secondaryVisibility.checked == false do ObjString[4] = "0"
			if UI_receiveShadows.checked == false do ObjString[5] = "0"
			if UI_castShadows.checked == false do ObjString[6] = "0"
			if UI_applyAtmospherics.checked == false do ObjString[7] = "0"
			if UI_renderOccluded.checked == false do ObjString[8] = "0"		
			globaltracks.oniondata.AltProperty[ layInd ] = ObjString
			
			UseObjString = "11111111"
			if UI_Userenderable.checked == false do UseObjString[1] = "0"
			if UI_UseinheritVisibility.checked == false do UseObjString[2] = "0"
			if UI_UseprimaryVisibility.checked == false do UseObjString[3] = "0"
			if UI_UsesecondaryVisibility.checked == false do UseObjString[4] = "0"
			if UI_UsereceiveShadows.checked == false do UseObjString[5] = "0"
			if UI_UsecastShadows.checked == false do UseObjString[6] = "0"
			if UI_UseapplyAtmospherics.checked == false do UseObjString[7] = "0"
			if UI_UserenderOccluded.checked == false do UseObjString[8] = "0"		
			globaltracks.oniondata.UseAltProperty[ layInd ] = UseObjString	

	
	)
	
)
	
	RCMenu OnionLayerMoreMenu
(
		menuItem miAddSelected "Add Selected to Layer"
		menuItem miSelect "Select Layer"
		menuItem miSelectObj "Select Objects on Layer" 
		Seperator sep01
		menuItem miDeleteLay "Delete Layer" 
		menuItem miDeleteBoth "Delete Layer and Objects" 
		seperator sep02
		menuItem miDefineAltMat "Pick Alternate Material"
		menuItem miDefineAltProp "Define Alternate Properties"
		seperator sep03
		menuItem miProp "Layer Properties"
		on miProp picked do (createdialog OnionLayerProperties 398 350 modal:true)
		
		on miAddSelected picked do ( 
			layInd = finditem globaltracks.oniondata.layername globaltracks.oniondata.pickedLayer
			if globaltracks.oniondata.isAltMaterial[ layInd ] or globaltracks.oniondata.isAltProperty[ layInd ] then
				messageBox "Cannot add the object to the layer.  The Layer is in an Alternate Mode. \nToggle the Layer out of Alternate mode to add objects"
			else Onion.addObjectsToLayer selection (globaltracks.oniondata.pickedLayer) 
	)

		on miSelect picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miSelect picked")
			Onion.selectOnion ( layerManager.getLayerFromname globaltracks.oniondata.pickedLayer)
	)
		on miSelectObj picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miSelectObj picked")
			fn SF obj  = (obj.layer.name == globaltracks.oniondata.pickedLayer )
			local MyAry= selectByName title:" Select Objects" buttonText:"Select" filter:SF 
			If MyAry != undefined then Select MyAry
	)
		on miDefineAltMat picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miDefineAltMat picked")
			 createdialog OnionAltMatRoll 240 80
	)
		on miDefineAltProp picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miDefineAltProp picked")
			createdialog OnionAltPropRoll 250 200
	)
		on miDeleteLay picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miDeleteLay picked")
			local rootlayer = layerManager.getLayer 0
			local theLay = layerManager.getLayerFromName globaltracks.oniondata.pickedLayer
			--push all the items into the first layer
			local addobjs = for i in objects where i.layer.name == theLay.name collect i 
			onion.addObjectsToLayer addobjs rootlayer.name
			--delete the layer
			onion.deleteLayer theLay
	)
		on miDeleteBoth picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miDeleteBoth picked")
			ans = querybox "Are you sure you want to delete the Objects and the Layer?"
			if ans then
		(
				local theLay = layerManager.getLayerFromName globaltracks.oniondata.pickedLayer
				--delete the objects
				local deletelist =#()
				for i in objects where i.layer.name == theLay.name do append deletelist i
				delete deletelist
				--delete the layer
				onion.deleteLayer theLay
		)
	)
)
	
	RCMenu OnionMoreMenu
(
		SubMenu "Manage Layers"
	(
			MenuItem miGetLayerManager "Import REZN8 Layer Manager Data"
		--	MenuItem miOrganize "Organize Layers" enabled:false
		--	MenuItem miAlphabetize "Alphebetize Layers" enabled:false
			Seperator sep03
			MenuItem miAquireSelSet "Aquire Selection Sets" 
			MenuItem miCreateSelSet "Create Selection Sets" 
			Seperator sep02
			MenuItem miRemoveEmpty "Remove Empty Layers" 
			Seperator sep04
			MenuItem miGetOrphans "Get Orphaned Objects"
			Seperator sep05
			MenuItem miKillEverything "Kill All Onion Data"
			
	)
		SubMenu "Visibility / Selection"
	(
			MenuItem miHideAll "Hide All Layers" 
			MenuItem miUnHideAll "Unhide All Layers"  
			MenuItem miInvert "Invert Hide/Unhide"
			Seperator sep01
			MenuItem miFreezeAll "Freeze All Layers" 
			MenuItem miUnFrezzeAll "Thaw All Layers"
			MenuItem miInvertFreeze "Invert Freeze/Thaw"
	)
	
		Seperator sep_fin
		MenuItem miPref "Preferences"
		on miPref picked do createDialog OnionPrefRoll 290 220 modal:true
		MenuItem miabout "About" 
		on miabout picked do createdialog OnionAbout 300 60
		

		on miGetLayerManager picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miGetLayerManager picked")
			local LMVar = getappdata globaltracks[1] 9901
			if LMVar != undefined then
		(
				local LM = execute (getappdata globaltracks[1] 9901)
				local error = false
				clearlistener()
				for L = 1 to LM.Layers.count do
			(
					local newLay = Layermanager.NewLayerFromName LM.Layers[ L ].LayerName
					if newLay == undefined then
				(
						print ("could not import " + LM.Layers[ L ].LayerName + " because the layer name is not unique" )
						error = true
				)
					else
				(
						local theObjs = for obj in LM.Layers[ L ].ObjectHandleArray collect (maxops.getnodebyhandle obj)
						
						onion.addObjectsToLayer theObjs newLay.name
						newLay.on = not LM.Layers[ L ].ishidden
						newLay.lock = LM.Layers[ L ].isfrozen						
						onion.addLayer newLay
				)
			)
				destroydialog OnionRoll
				Onion.ShowUI()
				if error == true then messagebox "There were errors on import.  see listener for details"
		)
			else MessageBox "There is no Layer Manager Data in this scene"
	)
	
	--	on miXRefUi picked do (
	--		LM.xrefLayers = ( not (miXRefUI.checked) )
	--		LM.UI.MakeRollout()
	--)
	
		function UpdateAllCheckBoxes CheckBoxString Value =
	(
			if (PREF_Debug_Mode)  then print ("FN: UpdateAllCheckBoxes CheckBoxString: " + CheckBoxString  + " Value: " + Value as string )
			case CheckBoxString of
		(
				"LToggle": (OnionRoll.worldToggle.checked = Value)
				"Lay_Freeze":(OnionRoll.Lay_Freeze1.checked = Value)
		)
			
			for i = 1 to globaltracks.oniondata.GroupName.count do
		(
				local intAry = onion.getLayersInGroup i	
				for L in intAry do --make sure the checkboxes are done 
			(
					execute ("grp" +i as string+ "." +CheckBoxString + "_" + L as string + ".checked = " + Value as string ) 
			)
		)
	)
		on miHideAll picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miHideAll picked")	
			setWaitCursor()
			DisableSceneRedraw()
			hide objects
			max select none
			for L = 1 to layermanager.count do 
		(
				t = layermanager.getlayer (L-1)
				t.on = false			
		)
			---update all checkboxes
			UpdateAllCheckBoxes "LToggle" false
			EnableSceneRedraw()
			SetArrowCursor()
			redrawviews()
	)
		on miUnHideAll picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miUnHideAll picked")
			setWaitCursor()
			DisableSceneRedraw()
			unhide objects

			for L = 1 to layermanager.count do 
		(
				t = layermanager.getlayer (L-1)
				t.on = true			
		)
			---update all checkboxes
			UpdateAllCheckBoxes "LToggle" true
			EnableSceneRedraw()
			SetArrowCursor()
	)
		on miInvert picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miInvert picked")
			setWaitCursor()
			DisableSceneRedraw()
			for i = 1 to globaltracks.oniondata.GroupName.count do
		(
				local intAry = Onion.getLayersInGroup i
				for L = 1 to intAry.count do --make sure the checkboxes are done 
			(
					t = layermanager.getlayerFromName intAry[ L ]			
					if t.on == true then
				(
						t.on = false
						onion.setHide i L true
						execute ("grp" +i as string+ ".LToggle_" + L as string + ".checked = false" ) 
				)
					else
				(
						t.on = true
						onion.setHide i L false
						execute ("grp" +i as string+ ".LToggle_" + L as string + ".checked = true" ) 
				)
			)
		)
			EnableSceneRedraw()
			SetArrowCursor()
			redrawviews()
	)
		on miFreezeAll picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miFreezeAll picked")
			setWaitCursor()
			DisableSceneRedraw()
			freeze objects
			max select none
			for L = 1 to layermanager.count do 
		(
				t = layermanager.getlayer (L-1)
				t.lock = true			
		)
			---update all checkboxes
			UpdateAllCheckBoxes "Lay_Freeze" true
			EnableSceneRedraw()
			SetArrowCursor()
			redrawviews()
	)
		on miUnFrezzeAll picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miUnFrezzeAll picked")
			setWaitCursor()
			DisableSceneRedraw()
			unfreeze objects
			max select none
			for L = 1 to layermanager.count do 
		(
				t = layermanager.getlayer (L-1)
				t.lock = false			
		)
			---update all checkboxes
			UpdateAllCheckBoxes "Lay_Freeze" false
			EnableSceneRedraw()
			SetArrowCursor()
			redrawviews()
	)
		on miInvertFreeze picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miInvertFreeze picked")
			setWaitCursor()
			DisableSceneRedraw()
			
			for i = 1 to globaltracks.oniondata.GroupName.count do
		(
				local intAry = Onion.getLayersInGroup i
				for L = 1 to intAry.count do --make sure the checkboxes are done 
			(
					t = layermanager.getlayerfromName intAry[ L ]
					
					if t.lock == true then
				(
						t.lock = false
						onion.setFreeze i L false
						execute ("grp" +i as string+ ".Lay_Freeze_"+ "_" + L as string + ".checked = false" ) 
				)
					else
				(
						t.lock = true
						onion.setFreeze i L true
						execute ("grp" +i as string+ ".Lay_Freeze_" + "_" + L as string + ".checked = true" ) 
				)
			)
		)
			EnableSceneRedraw()
			SetArrowCursor()
			redrawviews()
	)
			
		on miRemoveEmpty picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miRemoveEmpty picked")
			--start with 2 so i don't delete the 0 layer
			for L = LayerManager.count to 2 by -1 do
		(
				--try and delete it
				theLay = LayerManager.getlayer (L-1)
				onion.deleteLayer theLay refresh:false
		)
			destroydialog OnionRoll
			Onion.ShowUI()
	)
		/*
		on miAlphabetize picked do
	(
			if LM.Layers.count > 1 then 
		(
				local NewLayerArray =#()
				NewLayerArray[1] = copy LM.Layers[1]
				local LayNames = #()
				local unsorted_LayNames = for L in LM.Layers collect L.LayerName
				for L = 2 to LM.Layers.count where LM.Layers[L].isgroupMember == false do append LayNames LM.Layers[L].LayerName
				sort LayNames
				local num = 2
				for L = 1 to LayNames.count do
			(
					--find the layer it corresponds with
					Ind = finditem unsorted_LayNames LayNames[L]
					if LM.Layers[Ind].isgroupHead == true then
				(
						append NewLayerArray (copy LM.Layers[Ind])
						local add = 1
						local sub = 1
						while sub == 1 and (Ind+add) < LM.Layers.count do
					(
							if LM.Layers[Ind+add].isGroupMember == false then 
						(
								sub = 0
								continue
						)
							append NewLayerArray LM.Layers[Ind+add]
							add += 1
					)
				)
					else append NewLayerArray  ( copy LM.Layers[Ind] )
					num +=1
			)
				LM.Layers = NewLayerArray
				LM.UI.MakeRollout()
		)
	)
		*/
		on miAquireSelSet picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miAquireSelSet picked")
			disablesceneredraw()
			for S = 1 to SelectionSets.count do
		(
				--make a new one in the max system
				L = LayerManager.NewLayer()
				--add it to the First group--"main"
				L.setName (getNamedSelSetName S)
				onion.addObjectsToLayer selectionsets[S] L.Name
		)
			enablesceneredraw()
			destroydialog OnionRoll
			Onion.ShowUI()
	)
		on miCreateSelSet picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miCreateSelSet picked")
			for L = 1 to LayerManager.count do
		(
				max select none
				Lay = LayerManager.getLayer (L-1)
				Lay.select true
				selectionsets[ Lay.name ] = selection
		)
	)
		on miGetOrphans picked do
	(
			if (PREF_Debug_Mode)  then print ("RCMENU: miGetOrphans picked")
			disableSceneredraw()
			theList = #()
			for i = 1 to layermanager.count do
		(
				l = layermanager.getlayer (i-1)
				append theList l.name
		)
			for i in objects where i.layer.name != undefined do
		(
				name = i.layer.name
				if (finditem theList name) ==  0 then
			(
					--make a new one in the max system
					L = LayerManager.NewLayer()
					--add it to the First group--"main"
					L.setName name
--					onion.addObjectsToLayer selectionsets[S] L.Name

					append theList name
			)
				--add the node to the layer..just to be sure.
				(layerManager.GetLayerFromName name).addnode i
		)
			enablesceneredraw()
			destroydialog OnionRoll
			Onion.aquireMaxLayers()
			Onion.doLayerCleanup()
			Onion.ShowUI()
			
	)
		on miKillEverything picked do
	(
			qry = QueryBox "This will remove all grouping and alternate materials. \nYour Layers will rebuild themselves. \nAre you sure you want to do this?"
			if qry do Onion.Kill()
	)
)
	
	rollout OnionOrganize "Orgainize Layers"
(
		local labelEditing = false
		local drag_node
		local drop_node
		local nameChange_Node
		
		button newGroup "Add Group" width:65 pos:[5,5]  tooltip:"Add Group"
		button delGroup "Delete Group" width:70 pos:[70,5]  tooltip:"Delete Group" 
		button help "?" width:15 pos:[140,5] tooltip:"Help"
		edittext namefield "" width:154 pos:[1,31]
		activeXControl tvAX "MSComctlLib.TreeCtrl.2" width:270 height:325 pos:[5,50]
		button done "OK" align:#right
		
		function initOrganizeTree =
	(
			if (PREF_Debug_Mode)  then print ("FN: initOrganizeTree" )	
			tvAX.lineStyle = #tvwRootLines --#tvwTreeLines
			tvAX.indentation = 0
			tvAX.pathseparator = "."
			tvAX.OLEDragMode = #ccOLEDragAutomatic
			tvAX.OLEDropMode = #ccOLEDropManual
			---tvAX.enabled = false
			tvAX.LabelEdit = #tvwManual --lock out named editing in the treeview
			tvAX.hideSelection = false
	)
		
		function buildTreeFromOnionData =
	(
			if (PREF_Debug_Mode)  then print ("FN: buildTreeFromOnionData" )
			--organize groups
			grpInd = finditem globaltracks.oniondata.GroupOrder G
			for g = 1 to globaltracks.oniondata.grouporder.count do
		(
				grpInd = finditem globaltracks.oniondata.GroupOrder G
				local gnode = tvAX.nodes.add()
				gnode.text = globaltracks.oniondata.GroupName[ grpInd  ]
				gnode.expanded = true
				gnode.tag = ( "g," + grpInd  as string )
				gnode.key = ( "g," + grpInd  as string )
				local LayerIndArray = onion.getLayersInGroup grpInd 
				strAry = onion.getLayerOrder LayerIndArray
				for L in strAry do
			(
					local LayerRef =  onion.GetLayerReference L
					Lnode = tvAX.nodes.add gnode.index 4 "" LayerRef.name
					Lnode.tag = ("l," + L as string)
			)
		)
	)
		
		fn getHitNode = 
	(
			--if (PREF_Debug_Mode)  then print ("FN: getHitNode" )
			local p = getCursorPos tvAX
			local calib = 15
			tvAX.HitTest ((p.x-2)*calib) ((p.y-2)*calib)	
	)
		
		on newGroup pressed do
	(
			local temp = for i in globaltracks.oniondata.groupOrder collect i
			sort temp
			append globaltracks.oniondata.GroupOrder ( temp[ temp.count] + 1)
			append globaltracks.oniondata.GroupName "New Group"
			tvAX.nodes.clear()
			buildTreeFromOnionData()
	)
		on delGroup pressed do
	(
			if (PREF_Debug_Mode)  then print ("EVENT: delGroup pressed" )
			if tvAX.selecteditem != undefined then
		(
				local tag = tvAx.selecteditem.tag
				if tag[1] == "g" then
			(
					groupInd =(  ( (filterstring tvAx.selecteditem.key ",")[2] ) as integer )
					if (PREF_Debug_Mode)  then print ("\tgroup index " + groupInd as string )
					--check to see if there is more than one group
					if globaltracks.oniondata.groupName.count == 1 then
				(
						messagebox "You must have at least one group"
				)
					else
				(
						LayAry = onion.getLayersInGroup groupInd
						
						if LayAry.count == 0 then
					(
							grpO = globaltracks.oniondata.groupOrder[ groupInd ]
							
							for g = 1 to globaltracks.oniondata.groupOrder.count do
						(
								if globaltracks.oniondata.groupOrder[g]  >= grpO do globaltracks.oniondata.groupOrder[g] -= 1			
						)

							deleteitem globaltracks.oniondata.groupOrder groupInd 
							deleteitem globaltracks.oniondata.groupName groupInd
							
							--go through all layers and if their group index is greater than grpind -1
							for L = 1 to globaltracks.oniondata.layergroup.count do
						(
								if globaltracks.oniondata.layergroup[ L ] > groupInd then globaltracks.oniondata.layergroup[ L ] -= 1
						)
					)
						
						else
					(
							messagebox "The group must be empty to remove it."
					)
						tvAX.nodes.clear()
						buildTreeFromOnionData()
				)
			)
				else messagebox "Select a group first."
		)
			else messagebox "Select a group first."
	)
		on help pressed do
	(
			messagebox "Right-Click to change the name of a layer or group.\n\nDrag and drop layers and groups to re-order them."
		
	)
		on tvAX mouseDown button shift x y do
	(
			if (PREF_Debug_Mode)  then print ("EVENT: tvAX mousedown")
			if button == 1 then
		(
				drag_node = getHitNode()
				
				if (PREF_Debug_Mode) and drag_node != undefined  then print ("\tNode:" + drag_node.text)
		)	
	)
		on tvAX OLEStartDrag data effects do
	(
			if (PREF_Debug_Mode)  then print ("EVENT: tvAX OLEStartDrag ")
			drag_node = getHitNode()
	--		if drag_node.text != tvax.selectedItem then drag_node = tvax.selectedItem
	--		if drag_node == undefined then drag_node = getHitNode()
			if (PREF_Debug_Mode)  then print ("\tnode: " + drag_node.text)
		--	if drag_node == undefined or drag_node.
	)
		on tvAX OLEDragOver data Effect Button Shift x y State do
	(
			--if (PREF_Debug_Mode)  then print ("EVENT: tvAX OLEDragOver ")
			drop_node = getHitNode()
			if drop_node != undefined then tvax.selectedItem = drop_node --hightlight
	)

		on tvAX OLEDragDrop data effect button key x y do
	(
			if (PREF_Debug_Mode)  then print ("EVENT: tvAX OLEDragDrop")
			if drop_node != undefined and drag_node != undefined then
		(
				local dragID 
				local dropID
				if drop_node.tag != drag_node.tag then	--to prevent dragging something over itself.
			(
					if drop_node.tag[1] == "g" then  ---dropping on group
				(
						dropID =  ( (filterstring drop_node.key ",")[2] ) as integer	
						if drag_node.tag[1] == "g" then  --drag a group onto a group
					(
							if (PREF_Debug_Mode)  then print ("\tdraging group on to group " )
							if (PREF_Debug_Mode)  then print ("\tgroupOrder before: " + globaltracks.oniondata.groupOrder as string )				
							dragID =  ( (filterstring drag_node.key ",")[2] ) as integer
							--just reorder the group order
							dropOrder = globaltracks.oniondata.groupOrder[ dropID ]
							dragOrder = globaltracks.oniondata.groupOrder[ dragID ]
							if dragOrder > dropOrder then
						(
								for l in globaltracks.oniondata.groupOrder do
							(
									if globaltracks.oniondata.groupOrder[ l ] > dropOrder then
										if globaltracks.oniondata.groupOrder[ l ] < dragOrder then globaltracks.oniondata.groupOrder[ l ] += 1
							)
								--change the drop
								globaltracks.oniondata.groupOrder[ dragID ] = dropOrder +1
						)
							else 
						(
								for l in globaltracks.oniondata.groupOrder do
							(
									if globaltracks.oniondata.groupOrder[ l ] > dragOrder then
										if globaltracks.oniondata.groupOrder[ l ] <= dropOrder then globaltracks.oniondata.groupOrder[ l ] -= 1
							)
								--change the drop
								globaltracks.oniondata.groupOrder[ dragID ] = dropOrder	
						)
							if (PREF_Debug_Mode)  then print ("\groupOrder after: " + globaltracks.oniondata.groupOrder as string )	
					)
						else --drag a layer onto a group
					(
							if (PREF_Debug_Mode)  then print ("\tdraging layer on to  a group " )
							if (PREF_Debug_Mode)  then print ("\tlayerGroup before: " + globaltracks.oniondata.layerGroup as string )	
							if (PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerIndex as string )	
							dragID = ( (filterstring drag_node.tag ",")[2] ) as integer
							--push all the layers above drag layer down 
							grp = onion.getGroupFromLayer dragID
							layerInds = onion.getLayersInGroup grp
							dragOrder = globaltracks.oniondata.layerindex[ dragID ]	
							for l in layerInds do 
								if globaltracks.oniondata.layerindex[ l ] > dragOrder then globaltracks.oniondata.layerindex[ l ] -= 1
								
							--push all the layers in the drop group above the drop up
							--grp = onion.getGroupFromLayer dropID
							layerInds = onion.getLayersInGroup dropID
							dropOrder = globaltracks.oniondata.layerindex[ dropID ]
							for l in layerInds do globaltracks.oniondata.layerindex[ l ] += 1
							--set the drop group ind to the drag group index
							globaltracks.oniondata.layergroup[ dragID ] =  dropID
							--set the drop layer +1 drag layer index
							globaltracks.oniondata.layerindex[ dragID ] = 1
							if (PREF_Debug_Mode)  then print ("\tlayerGroup after: " + globaltracks.oniondata.layerGroup as string )
							if (PREF_Debug_Mode)  then print ("\tlayerIndex after: " + globaltracks.oniondata.layerIndex as string )
					)
				)
					else -- dropping on layer
				(
						dropID = ( (filterstring drop_node.tag ",")[2] ) as integer
						if drag_node.tag[1] != "g" then --dropping layer on a layer
					(
							dragID = ( (filterstring drag_node.tag ",")[2] ) as integer
							--if the parent index of the drag and drop objects are the same then the reorder is happening inside the same group
							if drag_node.parent.index == drop_node.parent.index then
						(
								if (PREF_Debug_Mode)  then print ("\tdraging layer to layer in same group" )
								if (PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerindex as string )
								--get the layers in that group
								grp = onion.getGroupFromLayer dragID
								layerInds = onion.getLayersInGroup grp
								dropOrder = globaltracks.oniondata.layerindex[ dropID ]
								dragOrder = globaltracks.oniondata.layerindex[ dragID ]
								if dragOrder > dropOrder then
							(
									for l in layerInds do
								(
										if globaltracks.oniondata.layerindex[ l ] > dropOrder then
											if globaltracks.oniondata.layerindex[ l ] < dragOrder then globaltracks.oniondata.layerindex[ l ] += 1

								)
									--change the drop
									globaltracks.oniondata.layerindex[ dragID ] = dropOrder +1
							)
								else 
							(
									for l in layerInds do
								(
										if globaltracks.oniondata.layerindex[ l ] > dragOrder then
											if globaltracks.oniondata.layerindex[ l ] <= dropOrder then globaltracks.oniondata.layerindex[ l ] -= 1

								)
									--change the drop
									globaltracks.oniondata.layerindex[ dragID ] = dropOrder			
							)
								if (PREF_Debug_Mode)  then print ("\tlayerIndex after: " + globaltracks.oniondata.layerindex as string )
						)
							else
						(
								if (PREF_Debug_Mode)  then print ("\tdraging layer to layer outside group on to layer" )
								if (PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerindex as string )
								--push all the layers above drag layer down 
								grp = onion.getGroupFromLayer dragID
								layerInds = onion.getLayersInGroup grp
								dragOrder = globaltracks.oniondata.layerindex[ dragID ]	
								for l in layerInds do 
									if globaltracks.oniondata.layerindex[ l ] > dragOrder then globaltracks.oniondata.layerindex[ l ] -= 1
								--push all the layers in the drop group above the drop up
								grp = onion.getGroupFromLayer dropID
								layerInds = onion.getLayersInGroup grp
								dropOrder = globaltracks.oniondata.layerindex[ dropID ]
								for l in layerInds do 
									if globaltracks.oniondata.layerindex[ l ] > dropOrder then globaltracks.oniondata.layerindex[ l ] += 1
								--set the drop group ind to the drag group index
								globaltracks.oniondata.layergroup[ dragID ] =  globaltracks.oniondata.layergroup[ dropID ]
								--set the drop layer +1 drag layer index
								globaltracks.oniondata.layerindex[ dragID ] = globaltracks.oniondata.layerIndex[ dropID ] +1
						)
							
					)
						else messagebox "Can't drop a Layer Group onto a Layer"
				)
			)
				--clear the tv
				tvAX.nodes.clear()
				buildTreeFromOnionData()
	
		)
			
	)
		on tvAX mouseup button shift x y do
	(
			if (PREF_Debug_Mode)  then print ("EVENT: tvAX mouseup")
			if button == 2 then
		(
				tvAX.StartLabelEdit()
				done.enabled = false
				nameChange_Node = tvAX.selectedItem.index
		)
	)

		on tvAX click do
	(
		--	labelEditing = false
			if (PREF_Debug_Mode)  then print ("EVENT: tvAX click")
			if tvAx.selectedItem != undefined then
		(
				namefield.text = tvAX.selectedItem.text
				nameChange_Node = tvAX.selectedItem.index
		)
			else
		(
				namefield.text = ""
				nameChange_Node = undefined
		)
			if keyboard.shiftpressed == true then
		(
				tvAX.StartLabelEdit()
				done.enabled = false
				nameChange_Node = tvAX.selectedItem.index
		)
			
		
	)
		on namefield changed txt do
	(
			if tvAX.selectedItem != undefined then
				 tvAX.selectedItem.text = txt
	)
		on namefield entered txt do
	(
			 if tvAX.selectedItem != undefined then
			 (
				 tvAX.selectedItem.text = txt	 
				 --get the tag of the selected item
				local tag = tvAx.Nodes[ nameChange_Node ].tag
				
				if tag[1] == "g" then
			(
					local ID =(  ( (filterstring tvAx.Nodes[ nameChange_Node ].tag ",")[2] ) as integer )
					globaltracks.oniondata.GroupName[ ID ] = txt
			)
				else --it's a layer
			(
					local L =  layerManager.getLayerFromName globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ]
					local changeIT = L.setname txt
					if changeIT then globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ] = txt
					else messagebox "WARNING: Name change will not take effect\nName must be unique to all other layers"
			)
		)
	)
		/*
		on tvAX dblclick do 
	(

	)
		*/
		on tvAX AfterLabelEdit cncl newstring do
	(
			done.enabled = true
			--get the tag of the selected item
			local tag = tvAx.Nodes[ nameChange_Node ].tag
			if tag[1] == "g" then
		(
				local ID =(  ( (filterstring tvAx.Nodes[ nameChange_Node ].tag ",")[2] ) as integer )
				globaltracks.oniondata.GroupName[ ID ] = newstring
		)
			else --it's a layer
		(
				local L =  layerManager.getLayerFromName globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ]
				local changeIT = L.setname newstring
				if changeIT then globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ] = newstring
				else messagebox "WARNING: Name change will not take effect\nName must be unique to all other layers"
		)
	)
		on done pressed do
	(
			destroydialog OnionOrganize 
			destroydialog OnionRoll
			Onion.showUI()
	)
		
		on OnionOrganize open do
	(
			initOrganizeTree()
			buildTreeFromOnionData()
			--showProperties tvAX 
	)
		on OnionOrganize close do
	(
			destroydialog OnionRoll
			Onion.showUI()
	)
		on OnionOrganize resized p2 do
	(
			done.pos.x = p2.x - 40
			done.pos.y = p2.y - 20
			tvAX.size.x = p2.x-10
			tvAx.size.y = (p2.y - 75)
	)
	
)
	


	
	Rollout OnionRoll "theOnion"
(
		
		button CreateNewLayer height:26 width:44 pos:[2,5] ToolTip:"Create New Layer" images:#(OnionPath + "Onion_Buttons_I.bmp", OnionPath + "Onion_Buttons_M.bmp",4,1,1,1,1) 
		button CreateNewLayer_FromSel "" height:26 width:68 pos:[47,5] ToolTip:"Create New Layer From Selected Objects" images:#(OnionPath + "Onion_Buttons_I.bmp", OnionPath + "Onion_Buttons_M.bmp",4,2,2,2,2) 	
		button organize "O" height:26 width:48 pos:[115,5] ToolTip:"Organize Layers" images:#(OnionPath + "Onion_Buttons_I.bmp", OnionPath + "Onion_Buttons_M.bmp",4,3,3,3,3) 
		button OnionMore "" height:26 width:35 pos:[163,5] ToolTip:"Expanded Menu" images:#(OnionPath + "Onion_Buttons_I.bmp", OnionPath + "Onion_Buttons_M.bmp",4,4,4,4,4) 
	
		checkbutton worldActive "" width:23 height:17  highlightcolor:PREF_UI_ActiveLayerCheckColor pos:[2, 34] checked:((layermanager.getlayer 0).current) tooltip:"Make Current"
		checkbutton worldToggle "World Layer" width:155 height:17 align:#left pos:[26,34] checked:((layermanager.getlayer 0).on) tooltip:"Hide"
		checkbutton worldFreeze "" height:17 width:17 pos:[181,34] images:#(OnionPath + "Onion_Controls_I.bmp",OnionPath + "Onion_Controls_M.bmp", 10,1,5,1,5) tooltip:"Freeze" checked:((layermanager.getlayer 0).lock)
		
		progressbar pb pos:[4, 34]  width:191 height:10 color:([251,196,45] as color) --visible:false
		
--		checkbutton Lay_Matte1 "" height:17 width:17 pos:[156,34]   images:#(OnionPath + "Onion_Controls_I.bmp",OnionPath + "Onion_Controls_M.bmp", 10,2,6,2,6)
--		button LCon1 "" width:9 height:17 pos:[175,34] images:#(OnionPath + "Onion_Controls_I.bmp",OnionPath + "Onion_Controls_M.bmp", 10,4,4,4,4) 
		
		
		
		subrollout ui_param_area pos:[2,60] width:196 height:180
		
		on organize pressed do createdialog OnionOrganize  280 400  style:#(#style_titlebar, #style_sysmenu, #style_resizing) modal:true --#style_minimizebox
	
		on CreateNewLayer pressed do
	(
			--make a new one in the max system
			L = LayerManager.NewLayer()
			--add it to the First group--"main"
			Onion.addLayer L
			destroydialog OnionRoll
			Onion.showUI()
			
			--give option to name an place
			if PREF_PromptOnNew then createdialog OnionOrganize 280 400  style:#(#style_titlebar, #style_sysmenu, #style_resizing) modal:true --#style_minimizebox

	)
		on CreateNewLayer_FromSel pressed do
	(
			--make a new one in the max system
			L = LayerManager.NewLayer()
			--add it to the First group--"main"
			Onion.addLayer L
			destroydialog OnionRoll
			Onion.showUI()
			
			onion.addObjectsToLayer selection  L.name
			
			if PREF_PromptOnNew then createdialog OnionOrganize 280 400  style:#(#style_titlebar, #style_sysmenu, #style_resizing) modal:true --#style_minimizebox
		--	local theLay = layerManager.getLayer ( layerManager.count - 1)
		--	for obj in selection do theLay.addnode obj
	)
		
		on worldActive changed state do ( 
			if state == true then ((layerManager.getlayer 0).current = state) 
			Onion.setActiveLayer 0
	)
		
		on worldToggle changed state do Onion.setHide 0 (not state)
		on worldFreeze  changed state do Onion.setFreeze 0 (state)
		
		on OnionMore pressed do PopupMenu OnionMoreMenu rollout:OnionRoll
		
		on OnionRoll moved loc do 
	( 
			globaltracks.oniondata.floaterposition = [ loc.x , loc.y , globaltracks.oniondata.floaterposition.z ]
	)
		on OnionRoll resized p2 do 
	(
			OnionRoll.width = 200
			ui_param_area.height = (p2.y - 75)
			globaltracks.oniondata.floaterposition = [ globaltracks.oniondata.floaterposition.x , globaltracks.oniondata.floaterposition.y , p2.y ]
			pb.pos.y = (globaltracks.oniondata.floaterposition.z - 12)
	)
		on OnionRoll open do 
	(
			ui_param_area.height = (globaltracks.oniondata.floaterposition.z - 75)
			pb.pos.y = (globaltracks.oniondata.floaterposition.z - 12)
			
	)
)
	

	
	

	
	Struct Onion
(
		/*
		Layers = #(),
		uiPosition = [300,300],
		function setUIPosition newPos =
	(
		
		),
		*/

		function kill =
	(
			if (custAttributes.getdef globaltracks 1).name == "OnionData" then custAttributes.delete globaltracks 1
			else
		(			
				globaltracks.oniondata.layername = #()
				globaltracks.oniondata.layerindex = #()
				globaltracks.oniondata.layergroup = #()
				globaltracks.oniondata.groupName = #()
				globaltracks.oniondata.GroupOrder = #()
				globaltracks.oniondata.AltMaterial = #()
				globaltracks.oniondata.isAltMaterial = #()
				globaltracks.oniondata.MaterialHolder = #()
				globaltracks.oniondata.isAltProperty = #()
				globaltracks.oniondata.AltProperty = #()
				globaltracks.oniondata.UseAltProperty = #()
			
		)
			destroydialog OnionRoll
		),

		function getLayersInGroup GroupIndex =
	(
			if (PREF_Debug_Mode)  then print ("FN: getLayersInGroup " + GroupIndex as string )
			local grparray =#()
			for g = 1 to globaltracks.oniondata.LayerGroup.count where globaltracks.oniondata.LayerGroup[ g ] == GroupIndex do append grparray g 
			return grparray
		),
		function getGroupLayersFromLayer LayerIndex =
	(
			if (PREF_Debug_Mode)  then print ("FN: getGroupLayersFromLayer " + LayerIndex as string )
			local grpInd = globaltracks.oniondata.LayerGroup[ LayerIndex ]
			local grpArray = #()
			for g = 1 to globaltracks.oniondata.LayerGroup.count where globaltracks.oniondata.LayerGroup[ g ] == grpInd do append grpArray g
			return grpArray
		),
		function getGroupFromLayer LayerIndex =
	(
			if (PREF_Debug_Mode)  then print ("FN: getGroupFromLayer " + LayerIndex as string )
			return globaltracks.oniondata.LayerGroup[ LayerIndex ]
		),
		
		function StringArrayAsIntArray SArray =
	(
			if (PREF_Debug_Mode)  then print ("FN: StringArrayAsIntArray SArray: " + SArray as string )
			local split = filterstring SArray ","
			local IntArray = #()
			for i in split do append IntArray (i as integer)
			return IntArray 
		),	
		function GetLayerReference layInd =
	(
			if (PREF_Debug_Mode)  then print ("FN: GetLayerReference layInd: " + layInd as string )
			if layInd == 0 then return (LayerManager.getlayer 0)
			else
		(
				lmref = layerManager.getLayerFromName globaltracks.oniondata.LayerName[ layInd ]
				if lmref != undefined then return lmref
				else 
			(
					if (PREF_Debug_Mode)  then print ("\t couldn't get a reference to the layer: " + layInd as string )
					return undefined
			)
		)

		),
		function collectObjects lmRef useGroup:false= 
	(
			if (PREF_Debug_Mode)  then print ("FN: collectObjects lmRef: " + lmRef.name )
			local objArray = #()
			if useGroup == true then
		(
				--find the group
				layInd = finditem globaltracks.oniondata.layername lmRef.name
				--get the layers in the group
				layAry = getGroupLayersFromLayer layInd
				--make an array of strings for each layer name in the lay ary
				LayNameArray = #()
				for L in layAry do append LayNameArray globaltracks.oniondata.layername[ L ]
				--get the objects that are on any of those layers
				for obj in objects where (finditem LayNameArray obj.layer.name) > 0 do  ( append objArray Obj )
		)
			else for obj in objects where obj.layer.name == lmRef.name do ( append objArray Obj )		
			return objArray
		),
		
		function setOnionProperty propName propVal lmRef=
	(
			if (PREF_Debug_Mode)  then print ("FN: setOnionProperty propName: " + propName  + " propVal: " + propVal as string + " lmRef: " + lmRef.name )
			setWaitCursor()
			DisableSceneRedraw()
			local objAry = collectObjects lmRef:lmRef
			for maxObj in objAry do
		(
				if propName == #hide then deselect maxObj 
				setProperty maxObj propName propVal
		)
			EnableSceneRedraw()
			SetArrowCursor()
			setSaveRequired true
		),
		function HideLayer lmref= 
	( 
			if (PREF_Debug_Mode)  then print ("FN: HideLayer lmRef:" + lmref.name )
			setWaitCursor()
			DisableSceneRedraw()
			lmRef.on = false
			count = 0
			objAry = #()

			for i in objects where i.layer.name ==  lmRef.name do 
		(	
				append objAry i
				count +=1
				--removed these 2 due to a strange bug kevin had with groups on his machine but not mine.
		--		i.ishidden = true 
		--		deselect i
				OnionRoll.pb.value = ( count / (objects.count as float) ) * 100
		)

			objAry.ishidden = true
			deselect objAry
			
			EnableSceneRedraw()
			SetArrowCursor()
			OnionRoll.pb.value = 0
		),	
		function UnHideLayer lmref = 
	( 
			if (PREF_Debug_Mode)  then print ("FN: UnHideLayer lmRef:" + lmref.name )
			setWaitCursor()
			DisableSceneRedraw()
			lmRef.on = true
			count = 0
			for i in objects where i.layer.name == lmRef.name do 
		(
				count +=1
				i.ishidden = false
				OnionRoll.pb.value = ( count / (objects.count as float) ) * 100
		)
			EnableSceneRedraw()
			SetArrowCursor()
			OnionRoll.pb.value = 0
		),
		function setHide layInd state = 
	( 
			if (PREF_Debug_Mode)  then print ("FN: setHide layInd:" + layInd as string +" state: " + state as string)
			if keyboard.shiftpressed == true and layInd != 0 then
		(
				local intArray = getGroupLayersFromLayer layInd
				if (PREF_Debug_Mode)  then print ("\tintArray: " + intArray as string)
				local grp = getGroupFromLayer layInd
				if (PREF_Debug_Mode)  then print ("\tgrp: " + grp as string)
				for L in intArray do
			(
					lmRef = GetLayerReference L
					if state == true then HideLayer lmRef
					else UnHideLayer lmRef
					execute ("grp" + grp as string +".LToggle_" + L as string + ".checked = " + (not state) as string)	
			)
		)
			else
		(
				--get the reference to the layer
				lmRef = GetLayerReference layInd
				if state == true then HideLayer lmRef
				else UnHideLayer lmRef
		)
		),
		
		
		function setFreeze layInd state =
	(
			if (PREF_Debug_Mode)  then print ("FN: setFreeze layInd:" + layInd as string +" state: " + state as string)		
			if keyboard.shiftpressed == true then
		(
				local intArray = getGroupLayersFromLayer layInd
				if (PREF_Debug_Mode)  then print ("\tintArray: " + intArray as string)
				local grp = getGroupFromLayer layInd
				if (PREF_Debug_Mode)  then print ("\tgrp: " + grp as string)
				for L in intArray do
			(
					lmRef = GetLayerReference L
					setWaitCursor()	
					DisableSceneRedraw()
					if (state) then lmRef.lock = true 
					else lmRef.lock = false		
					for i in objects where i.layer.name == lmRef.name do i.isFrozen = state 
					EnableSceneRedraw()
					SetArrowCursor()
					execute ("grp" + grp as string +".Lay_Freeze_" + L as string + ".checked = " + state as string)
			)	
		)
			else
		(	
				lmRef = GetLayerReference layInd
				setWaitCursor()
				DisableSceneRedraw()
				if (state) then lmRef.lock = true 
				else lmRef.lock = false		
				for i in objects where i.layer.name == lmRef.name do i.isFrozen = state 
				EnableSceneRedraw()
				SetArrowCursor()
		)
		),
		
		function selectOnion lmRef =
	(
			if (PREF_Debug_Mode)  then print ("FN: selectOnion lmRef: " + lmRef.name)
			setWaitCursor()
			DisableSceneRedraw()
			max select none
			local selectAry
			
			if keyboard.controlpressed == true then selectAry = collectObjects lmRef	useGroup:true
			else selectAry = collectObjects lmRef	
	
			select selectAry
			EnableSceneRedraw()
			SetArrowCursor()
		),	
		
		
		
		
--i have to pass in the index of the material here because the lmref doesn't contain any reference to alternate material.
		function SetAltMat layInd state grp =
	(
			if (PREF_Debug_Mode)  then print ("FN: SetAltMat layInd: " + layInd as string+ " state: " + state as string )	
			
			lmRef = onion.GetLayerReference layInd
					
			SetWaitCursor()
			disableSceneRedraw()	
			if state == true then
		(
				--check to see if the alternate material has been defined.
				if globaltracks.oniondata.altmaterial[ layInd ] == undefined then 
			(
					messagebox "Set Alernate Material Aborted.  You must define the alternate material first."
					--now i need to uncheck the checked thingy
					execute ( "grp" + grp as string + ".Lay_Matte_" + layInd as string + ".checked = false")
			)
				else
			(
					globaltracks.oniondata.isAltMaterial[ layInd ] = true
					justcopied = #()
					--walk through all the objects on that layer
					for i = 1 to objects.count do
				(
						if objects[ i ].layer.name == lmref.name and \
							(superclassof objects[ i ] == Geometryclass or superclassof objects[ i ] == Shape) \
							and classof objects[ i ] != TargetObject do
					(
							--push the name of the material onto to appdata of the object
							if objects[ i ].material == undefined then setappdata objects[ i ] 1108 "undefined"
							else setappdata objects[ i ] 1108 objects[ i ].material.name
							--look for a material by the same name in the reference
							if objects[ i ].material != undefined do
						(
								--check to see if i've copied it already in this alt mat move
								if (finditem justcopied objects[i].material.name) == 0 then
							(
									local found = false
									for m = 1 to  globaltracks.oniondata.MaterialHolder.count do
								(
										if globaltracks.oniondata.MaterialHolder[m].name == objects[ i ].material.name do
									(
											 found = true
											 globaltracks.oniondata.MaterialHolder[m] =  (objects[ i ].material)
											 exit
									)
								)
									if found == false then
								(
										append globaltracks.oniondata.MaterialHolder (objects[ i ].material)
								)
									append justcopied objects[i].material.name
							)
						)
							--push the alternate material onto the object
							objects[ i ].material = globaltracks.oniondata.altmaterial[ layInd ]
							
					)
						OnionRoll.pb.value = ( i / (objects.count as float) ) * 100


				)
			)

		)
			else  --unchecking alt material...restore the orig material
		(
				globaltracks.oniondata.isAltMaterial[ layInd ] = false
				--ADD progresss code
				
				
				for i = 1 to objects.count do
			(
					if objects[ i ].layer.name == lmref.name and \
						(superclassof objects[ i ] == Geometryclass or superclassof objects[ i ] == Shape) \
						and classof objects[ i ] != TargetObject do
				(
				
						local o = objects[ i ]
						if getappdata o 1108 == "undefined" then o.material = undefined
						else
					(
							---find the material
							altMatInd = 0
							for i = 1 to globaltracks.oniondata.MaterialHolder.count do
						(
								if globaltracks.oniondata.MaterialHolder[ i ].name == getappdata o 1108 then
							(
									altMatInd = i
									exit
							)
						)
							if altMatInd == 0 then messagebox "Something terribile has happened.  The material has been lost."
							else
						(
								--seach the scene for an object that has the same material on it..
								local found = 0
								for i in objects where i.material != undefined do
							(
									if i.material.name == globaltracks.oniondata.MaterialHolder[ altMatInd ].name do 
								(
										found = i
										exit
								)	
							)
								if found == 0 then o.material = globaltracks.oniondata.MaterialHolder[ altMatInd ]
								else o.material = found.material
						)
					)
				)
					OnionRoll.pb.value = ( i / (objects.count as float) ) * 100
			)
				--check to see if any other layers are in alt mode, and if not, clear out the alternate material array
				if (finditem globaltracks.oniondata.isAltMaterial true) == 0 then
					globaltracks.oniondata.MaterialHolder = #()

		)	
			enableSceneRedraw()		
			--gc()
			SetArrowCursor()
			OnionRoll.pb.value = 0.0
		),		
		
		function SetAltProp layInd state =
	(
			if (PREF_Debug_Mode)  then print ("FN: SetAltProp layInd: " + layInd as string+ " state: " + state as string )	
			
			lmRef = onion.GetLayerReference layInd
					
			SetWaitCursor()
			disableSceneRedraw()	
			if state == true then
		(
				--set the objects in alternate property mode
				globaltracks.oniondata.isAltProperty[ layInd ] = true

				local AltString = globaltracks.oniondata.AltProperty[ layInd ]
				local UseAltString = globaltracks.oniondata.UseAltProperty[ layInd ]
	
				--walk through all the objects on that layer and set the properties
				for i = 1 to objects.count do
			(
					if objects[ i ].layer.name == lmref.name do
				(			
						--set the properties on the object it self so that i can get them back
						ObjString = "11111111"
						if getProperty objects[i] #renderable == false do ObjString[1] = "0"
						if getProperty objects[i] #inheritVisibility == false do ObjString[2] = "0"
						if getProperty objects[i] #primaryVisibility  == false do ObjString[3] = "0"
						if getProperty objects[i] #secondaryVisibility == false do ObjString[4] = "0"
						if getProperty objects[i] #receiveShadows == false do ObjString[5] = "0"
						if getProperty objects[i] #castShadows  == false do ObjString[6] = "0"
						if getProperty objects[i] #applyAtmospherics  == false do ObjString[7] = "0"
						if getProperty objects[i] #renderOccluded == false do ObjString[8] = "0"		
						setappdata objects[ i ] 1110 ObjString
						
						if UseAltString[1] == "1" then
					(
							val = if AltString[1] == "1" then true else false
							setProperty objects[i] #renderable val
					)
						if UseAltString[2] == "1" then
					(
							val = if AltString[2] == "1" then true else false
							setProperty objects[i] #inheritVisibility val
					)
						if UseAltString[3] == "1" then
					(
							val = if AltString[3] == "1" then true else false
							setProperty objects[i] #primaryVisibility  val
					)
						if UseAltString[4] == "1" then
					(
							val = if AltString[4] == "1" then true else false
							setProperty objects[i] #secondaryVisibility val
					)
						if UseAltString[5] == "1" then
					(
							val = if AltString[5] == "1" then true else false
							setProperty objects[i] #receiveShadows val
					)
						if UseAltString[6] == "1" then
					(
							val = if AltString[6] == "1" then true else false
							setProperty objects[i] #castShadows  val
					)
						if UseAltString[7] == "1" then
					(
							val = if AltString[7] == "1" then true else false
							setProperty objects[i] #applyAtmospherics  val
					)
						if UseAltString[8] == "1" then
					(
							val = if AltString[8] == "1" then true else false
							setProperty objects[i] #renderOccluded val
					)
				)
					OnionRoll.pb.value = ( i / (objects.count as float) ) * 100
			)
		)
			else
		(
				--return the objects out of alt propert mode
				globaltracks.oniondata.isAltProperty[ layInd ] = false

				--walk through all the objects on that layer and set the properties
				for i = 1 to objects.count do
			(
					if objects[ i ].layer.name == lmref.name do
				(			
						print "here"
						AltString = getAppdata objects[i] 1110
						val = if AltString[1] == "1" then true else false
						setProperty objects[i] #renderable val
						val = if AltString[2] == "1" then true else false
						setProperty objects[i] #inheritVisibility val
						val = if AltString[3] == "1" then true else false
						setProperty objects[i] #primaryVisibility  val
						val = if AltString[4] == "1" then true else false
						setProperty objects[i] #secondaryVisibility val
						val = if AltString[5] == "1" then true else false
						setProperty objects[i] #receiveShadows val
						val = if AltString[6] == "1" then true else false
						setProperty objects[i] #castShadows  val
						val = if AltString[7] == "1" then true else false
						setProperty objects[i] #applyAtmospherics  val
						val = if AltString[8] == "1" then true else false
						setProperty objects[i] #renderOccluded val
				)
					OnionRoll.pb.value = ( i / (objects.count as float) ) * 100
			)				
		)
			enableSceneRedraw()		
			--gc()
			SetArrowCursor()
			OnionRoll.pb.value = 0.0		
		),
		
		
		function SetActiveLayer layInd active:true=
	(
			if (PREF_Debug_Mode)  then print ("FN: SetActiveLayer layInd: " + layInd as string )	
			if (active) then
		(
				lmref = GetLayerReference layInd
				lmref.current  = true
				OnionRoll.worldActive.checked = (layermanager.getlayer 0).current
				for G = 1 to globaltracks.oniondata.GroupName.count do
			(
					local LayerNameArray = getLayersInGroup G
					for L in LayerNameArray do
				(
						local cLay = getLayerReference L
						execute ( "grp" + G as string + ".LayAct_"  + L as string + ".checked = " + cLay.current as string )
				)
			)
		)
			else 
		(
				--turn on the 0 layer

				lmref = GetLayerReference 0
				lmref.current  = true
				OnionRoll.WorldActive.checked = true
		)
			
		),

		function getLayerOrder LayerIndArray =
	(
			if (PREF_Debug_Mode)  then print ("FN: getLayerOrder LayerIndArray:" + LayerIndArray as string )
			local matchArray = #()
			local orderedArray = #()
			--build an array that matches the input array
			for L in LayerIndArray do append matchArray globaltracks.oniondata.LayerIndex[ L ]
			--reorder the input array to the order of the match array
			for c = 1 to LayerIndArray.count do
		(
				ind = finditem matchArray c
				append orderedArray LayerIndArray[ ind ]
		)
			return orderedArray
		),
		
		function createGroupRoll GroupIndex =
	(	
			if (PREF_Debug_Mode)  then print ("FN: createGroupRoll " + GroupIndex as string )
			local LayersInGroup = getLayersInGroup GroupIndex 	--get a list of layer indexs that the group contain
			if (PREF_Debug_Mode)  then print ("\t LayersInGroup = " + LayersInGroup as string )
			rcRoll = rolloutCreator ( "grp"+GroupIndex as string ) ( globaltracks.oniondata.GroupName[ GroupIndex  ] )
			rcRoll.begin()
			Ypos = 5
			
			local LayerIndArray  = getLayerOrder LayersInGroup
			
			for L in LayerIndArray do
		(
				LayRef = GetLayerReference L
				if LayRef != undefined then
			(
					local buttonNumber = ("_"+ L as string)
					YPosS = Ypos as string
					
					local LayActString = (" width:10 height:17 highlightcolor:"+PREF_UI_ActiveLayerCheckColor as string + " pos:[ 2 ,"+ YPosS+"] checked:" + LayRef.current as string + " tooltip:\"Set as current layer\"" )
					rcRoll.addControl #checkbutton (("LayAct"+buttonNumber)as name) "" paramStr:LayActString
					rcRoll.addHandler (("LayAct"+buttonNumber)as name) #changed paramStr:"state" codestr:("Onion.SetActiveLayer " + L as string + " active:state")
			
					--Layer Toggle Checkbutton		
					local LToggleString = (" highlightcolor:"+PREF_UI_HideCheckColor as string +" width:111 height:17 align:#left pos:[ 13 ,"+ YPosS+"]  tooltip:\"Toggle Layer On/Off     Shift-Click to effect whole group\" checked:"+ LayRef.on as string )
					rcRoll.addControl #checkbutton (("LToggle"+buttonNumber)as name) (LayRef.name) paramStr:LToggleString --Layers[L].lmRef.Name --
					rcRoll.addHandler (("LToggle"+buttonNumber) as name) #changed paramStr:"state" codestr:("Onion.sethide " + L as string + " " + "(not state) " )
				
					--Layer Freeze Checkbutton
					local Lay_FreezeString = (" height:17 width:15 pos:[125,"+YPosS+"] images:#(OnionPath + \"Onion_Controls_I.bmp\",OnionPath + \"Onion_Controls_M.bmp\", 10,1,5,1,5)  checked:" + LayRef.lock as string + " tooltip:\"Freeze Layer\" ")
					rcRoll.addControl #checkbutton (("Lay_Freeze"+buttonNumber)as name) "" paramStr:Lay_FreezeString
					rcRoll.addHandler (("Lay_Freeze"+buttonNumber )as name) #changed paramStr:"state" codestr:("Onion.setFreeze " + L as string + " state" )
			
					--Layer Alt Material Checkbutton
					local Lay_MatteString = (" height:17 width:15 pos:[140,"+YPosS+ "]   images:#(OnionPath + \"Onion_Controls_I.bmp\",OnionPath + \"Onion_Controls_M.bmp\", 10,2,6,2,6) tooltip:\"Alternate Material\" checked:(globaltracks.oniondata.isAltMaterial[" + L as string + "] )")	
					rcRoll.addControl #checkbutton (("Lay_Matte"+buttonNumber )as name) "" paramStr:Lay_MatteString
					rcRoll.addHandler (("Lay_Matte"+buttonNumber )as name) #changed paramStr:"state" codestr:("Onion.setAltMat "+ L as string +" state " + GroupIndex as string  )

					--Layer Alt Prop Checkbutton
					local Lay_PropString = (" height:17 width:15 pos:[155,"+YPosS+ "]   checked:(globaltracks.oniondata.isAltProperty[" + L as string + "] ) images:#(OnionPath + \"Onion_Controls_I.bmp\",OnionPath + \"Onion_Controls_M.bmp\", 10,3,7,3,7) tooltip:\"Alternate Property\" ")	
					rcRoll.addControl #checkbutton (("Lay_Prop"+buttonNumber )as name) "" paramStr:Lay_PropString
					rcRoll.addHandler (("Lay_Prop"+buttonNumber )as name) #changed paramStr:"state" codestr:("Onion.setAltProp "+ L as string +" state" )
		
					--Layer Expanded Menu
					LConString = (" width:9 height:17 pos:[171," + YPosS+ "] images:#(OnionPath + \"Onion_Controls_I.bmp\",OnionPath + \"Onion_Controls_M.bmp\", 10,4,4,4,4)  tooltip:\"Extended Menu      Shift-Click to Select Layer    Ctrl-Shift-Click to Select Group\"  ")
					rcRoll.addControl #button (("LCon"+buttonNumber)as name) ">" paramStr:LConString
					local expandedMenuString = ("globaltracks.oniondata.pickedLayer =  globaltracks.oniondata.layerName[" + L as string +" ] 
						if keyboard.shiftPressed == true then (
							DisableSceneRedraw()
							Onion.selectOnion (Onion.GetLayerReference " + L as string + ")
							EnableSceneRedraw()
					)
						else(
							Popupmenu OnionLayerMoreMenu 
						)" 
				)
			
					rcRoll.addHandler (("LCon"+buttonNumber)as name) #pressed codeStr:expandedMenuString 
			
					Ypos += 22
			)
				else if (PREF_Debug_Mode)  then print ("ERROR: createGroupRoll couldn't get a layer reference to groupIndex: " + GroupIndex as string )
		)
			rcRoll.end()
			
			return rcRoll.def
		),

	
		function createXRefGroup =
	(
			if (PREF_Debug_Mode)  then print "FN: createXRefGroup()"
			rci= rolloutCreator "XRScene" "XRef Scenes"
			rci.begin()
			Ypos = 5
			
			for XR = 1 to xrefs.getXRefFileCount() do
		(
				local XRfile = xrefs.getxreffile XR
				local XRfileName = filenamefromPath (XRfile.filename)
				local XRfileHid = XRFile.hidden
				local XRfileEnab = not (XRFile.disabled)

				rci.addControl #checkbox (("XRENab"+ XR as string) as name) "" paramStr:("pos:[2," + Ypos as string + "] width:15 checked:"+ XRfileEnab as string +" \n" )					
				local XRVisString = ("highlightcolor:" + PREF_UI_XRefCheckColor as string + " checked:"+ (NOT XRfile.hidden) as string + " width:150  height:17  align:#left pos:[20,
						"+Ypos as string+"]   checked:"+XRfileHid as string + " tooltip:\"Toggle XRef Visibility\"\n" )
				rci.addControl #checkbutton (("XRVis"+ XR as string) as name) XRfileName paramStr:XRVisString
				
				rci.addHandler (("XRENab"+ XR as string) as name) #changed paramStr:"state" codestr:("
					Temp = xrefs.getxreffile " + XR as string + "
					Temp.hidden = (not state)")
				rci.addHandler (("XRVis"+ XR as string) as name) #changed paramStr:"state" codestr:("
					Temp = xrefs.getxreffile " + XR as string + "
					Temp.disabled = (not state)")
				
				Ypos+=20
		)
			rci.end()
			return rci.def
		),
		
		function showUI =
	(
			if (PREF_Debug_Mode)  then print "FN: showUI()"
			if OnionRoll.open == false then
		(
				local FP = globaltracks.OnionData.FloaterPosition
				
				--check the floater position for negative #'s or numbers outside the size of the screen
				if fp.x < 0 or fp.x > sysinfo.desktopsize.x then
					FP = [ 200, fp.y, fp.z]
				if fp.y < 0 or fp.y > (sysinfo.desktopsize.y-60) then
					FP = [ fp.x, 200, fp.z]				
				if fp.z == 0 then FP =  [ fp.x, fp.y, 300 ]				

				globaltracks.OnionData.FloaterPosition = FP
				
				createdialog onionroll 200 FP.Z FP.x FP.y style:#(#style_titlebar, #style_sysmenu, #style_resizing, #style_minimizebox)
				for G = 1 to globaltracks.oniondata.GroupOrder.count do		--G == the index into all the other arrays
			(	
					grpInd = finditem globaltracks.oniondata.GroupOrder G
					--define a group rollout
					grpRoll = createGroupRoll grpInd  				
					--add it to the rollout
					addSubRollout OnionRoll.ui_param_area grpRoll 
			)
				if ( PREF_DisXRScene == true ) then
			(
					xrefRoll = createXRefGroup()
					addSubRollout OnionRoll.ui_param_area xrefRoll
			)
		)
		),
	
		function showPrefUI = ( createdialog OnionPrefRoll 400 200 ),
		function addObjectsToLayer ObjectAry MaxLayerName = 
	(
			if (PREF_Debug_Mode)  then print ("FN: addObjectsToLayer Objectary: " + ObjectAry as string + " MaxLayerName: " + MaxLayerName as string )
			local theLay = layerManager.getLayerFromName MaxLayerName
			--check to see if i'm in alt material mode
			

			
			for obj in ObjectAry where obj != undefined do 
		(
				theLay.addnode obj
		
				
				--update settings	
				if ( PREF_Inherit_Wire ) then obj.wirecolor = theLay.wirecolor
				if ( PREF_Inherit_Display ) then
			(
					if isproperty obj #boxmode do obj.boxmode = theLay.boxmode
					if isproperty obj #backfacecull do obj.backfacecull = theLay.backfacecull
					if isproperty obj #alledges do obj.alledges = not theLay.alledges
					if isproperty obj #vertexticks do obj.vertexticks = theLay.vertexticks
					if isproperty obj #showtrajectory do obj.showtrajectory = theLay.showTrajectory
					if isproperty obj #xray do obj.xray = theLay.xray
					if isproperty obj #ignoreExtents do obj.ignoreExtents = theLay.ignoreExtents
					if isproperty obj #showfrozeningray do obj.showfrozeningray = theLay.showfrozeningray 
					if isproperty obj #showvertexcolors do obj.showvertexcolors = theLay.showvertexcolors
					if isproperty obj #vertexcolorsshaded do obj.vertexcolorsshaded = theLay.vertexcolorsshaded 
			)
				if ( PREF_Inherit_Render ) then
			(
					if isproperty obj #visibility do obj.visibility =theLay.visibility 
					if isproperty obj #renderable do obj.renderable =theLay.renderable 
					if isproperty obj #inheritvisibility do obj.inheritvisibility =theLay.inheritvisibility 
					if isproperty obj #primaryvisibility do obj.primaryvisibility =theLay.primaryvisibility 
					if isproperty obj #secondaryvisibility do obj.secondaryvisibility =theLay.secondaryvisibility 
					if isproperty obj #receiveshadows do obj.receiveshadows =theLay.receiveshadows 
					if isproperty obj #castshadows do obj.castshadows =theLay.castshadows 
					if isproperty obj #applyatmospherics do obj.applyatmospherics =theLay.applyatmospherics 
					if isproperty obj #renderoccluded do obj.renderoccluded =theLay.renderoccluded 
			)
				if ( PREF_Inherit_Blur ) then
			(
					if isproperty obj #imagemotionblurmultiplier do obj.imagemotionblurmultiplier =theLay.imagemotionblurmultiplier 
					if isproperty obj #motionbluron do obj.motionbluron =theLay.motionbluron 
					if isproperty obj #motionblur do obj.motionblur =theLay.motionblur 
			)
		)
			if theLay.on == false then
		(
				ObjectAry.isHidden = true
				ObjectAry.isSelected = false
		)
			if theLay.lock == true then 
		(
				ObjectAry.isSelected = false
				ObjectAry.isFrozen = true
		)
			
			
		),
		function refreshUI =
	(
			destroydialog OnionRoll
			showUI()
		),
		function makeSelectionSetsFromLayers =
	(
		
		),
		function makeLayersFromSelectionSets =
	(
		
		),

		function deleteLayer lmRef refresh:true = 
	(
			if (PREF_Debug_Mode)  then print ("FN: deleteLayer lmRef: " + lmref.name)
			local name = lmRef.name
			--check and make sure the current layer isn't the active layer...if it is..force it back to world layer
			if lmRef.current = true then
		(
				local L = layermanager.getLayer 0
				L.current = true
		)
			local deleted = LayerManager.deleteLayerByName lmRef.name
			--remove the index from the globaltracks 
			if deleted == true then
		(
				local delLayInd = finditem globaltracks.oniondata.layerName name 
				--get the layers in the grouplayer
				local laysInGrp = getGroupLayersFromLayer delLayInd 
				local layInd = globaltracks.oniondata.LayerIndex[ delLayInd ]
				
				for l in laysInGrp do
					if globaltracks.oniondata.layerIndex[ l ] >= layInd do
						globaltracks.oniondata.layerIndex[ l ] -= 1
				
				deleteitem globaltracks.oniondata.layerName delLayInd 
				deleteitem globaltracks.oniondata.LayerIndex delLayInd
				deleteitem globaltracks.oniondata.LayerGroup delLayInd
				deleteitem globaltracks.oniondata.AltMaterial delLayInd
				deleteitem globaltracks.oniondata.isAltMaterial delLayInd
				deleteitem globaltracks.oniondata.isAltProperty delLayInd
				deleteitem globaltracks.oniondata.AltProperty delLayInd
				
				if refresh then
			(
					destroydialog OnionRoll
					Onion.ShowUI()
			)
		)
			else print ("Could not delete layer: " + name as string)
		),
		
		function addLayer lmRef=
	(
			if (PREF_Debug_Mode)  then print ("FN: addLayer " + lmRef.name)
			append globaltracks.oniondata.LayerName 	lmRef.name					--add the name to the array
			append globaltracks.oniondata.LayerGroup  1							--put it in the first group that HAS to exist
			
			if globaltracks.oniondata.LayerIndex.count == 0 then
				append globaltracks.oniondata.LayerIndex 1
			else
		(
				local grpLayer = getLayersInGroup 1
				append globaltracks.oniondata.LayerIndex  (grpLayer.count)		--it's been added to the base group so use it's count
		)
			append globaltracks.oniondata.isAltMaterial false						--add it not in alt material mode
			append globaltracks.oniondata.altMaterial undefined						--add an undefined material.
			append globaltracks.oniondata.isAltProperty  false
			append globaltracks.oniondata.AltProperty "11111110"
			append globaltracks.oniondata.UseAltProperty "00000000"
		),
		
		function aquireMaxLayers =
	(
			if (PREF_Debug_Mode)  then print "FN: aquireMaxLayers()"
			-- scan the scene for new layers
			if LayerManager.count > 1 do
		(
				for LM = 2 to LayerManager.count do
			(
					local Lay = layerManager.getLayer (LM-1)
					--if it doesn't find an existing layer of the same name, build the layer
					if ( finditem globaltracks.oniondata.Layername lay.name ) == 0 then addLayer Lay
			)
		)
		),
		
		--search all the onionlayers for a suitable max layer
		function doLayerCleanup =
	(
			if (PREF_Debug_Mode)  then print "FN: doLayerCleanup()"
			local delarry = #()
			for L = 1 to globaltracks.oniondata.layername.count do
		(
				lmref = layermanager.getLayerfromname globaltracks.oniondata.layername[ L ]
				if lmref == undefined then
			(
					---eeeek. no matching layer was found...remove that layer!
					if (PREF_Debug_Mode)  then print "\tfound wacked layer..deleting it."
					append delarry L
			)	
		)
			if delarry.count > 0 then 
		(
				for L = delarry.count to 1 by -1 do
			(
					--get the layers in the grouplayer
					local laysInGrp = getGroupLayersFromLayer delarry[L]  
					local layInd = globaltracks.oniondata.LayerIndex[ delarry[L] ]
					
					for g in laysInGrp do
						if globaltracks.oniondata.layerIndex[g ] >= layInd do
							globaltracks.oniondata.layerIndex[g ] -= 1
					
					deleteitem globaltracks.oniondata.layerName delarry[L] 
					deleteitem globaltracks.oniondata.LayerIndex delarry[L] 
					deleteitem globaltracks.oniondata.LayerGroup delarry[L] 
					deleteitem globaltracks.oniondata.AltMaterial delarry[L] 
					deleteitem globaltracks.oniondata.isAltMaterial delarry[L] 
			)
		)
			if (finditem globaltracks.oniondata.isAltMaterial true) == 0 then
				globaltracks.oniondata.MaterialHolder = #()
			

		),
		
		function setupCallbacks =
	(
			if (PREF_Debug_Mode)  then print "FN: setupCallbacks()"
			callbacks.removeScripts id:#Onion
			callbacks.addScript #systemPreReset		"destroyDialog OnionRoll" 	id:#Onion
			callbacks.addScript #systemPreNew		"destroyDialog OnionRoll; if (custAttributes.getdef globaltracks 1).name == \"OnionData\" then custAttributes.delete globaltracks 1"	id:#Onion
			callbacks.addScript #filePreOpen			"destroyDialog OnionRoll" 	id:#Onion
			callbacks.addScript #filePreMerge		"destroyDialog OnionRoll" 	id:#Onion
		),
			
		function addOnionData =
	(
			if (PREF_Debug_Mode)  then print "FN: addOnionData()"
			OnionData = attributes "OnionData"	
		(
			--	version
				parameters main rollout:blank
			(		
					--version .99 i added the animatable:false tag to these
					OnionVersion type:#float animatable:false
					FloaterPosition type:#Point3 default:[300,300,300] animatable:false
					GroupName type:#StringTab tabSizeVariable:true	animatable:false				--Array of strings.  Each one a group name. #("a","b",c")
					GroupOrder type:#IntTab tabSizeVariable:true animatable:false					--Order that the groups appear in.  ex: #(3,1,2) -> "c" first "a", "b"
					LayerName type:#StringTab tabSizeVariable:true	animatable:false				--Array of strings.  Order 
					LayerGroup type:#IntTab tabSizeVariable:true animatable:false					--Array of ints...what group index the layer is a part of
					LayerIndex type:#IntTab tabSizeVariable:true animatable:false					--
					AltMaterial type:#materialTab tabSizeVariable:true animatable:false				--store each alternate material in the index of the layer
					isAltMaterial type:#boolTab tabSizeVariable:true default:false animatable:false	
					MaterialHolder type:#materialTab tabSizeVariable:true	animatable:false			--store copies of scene materials
					pickedLayer type:#String animatable:false	
					--version 1.00 added below
					UseAltProperty type:#stringTab  tabSizeVariable:true	animatable:false
					AltProperty type:#stringTab  tabSizeVariable:true	animatable:false
					isAltProperty  type:#boolTab tabSizeVariable:true default:false animatable:false	
			)
				rollout blank "blank"
			(
			)
		)
		
			custAttributes.add globaltracks OnionData 
			
			-- setup add the basics
			globaltracks.oniondata.GroupName[1] = "Main"		--set the first group name
			globaltracks.oniondata.GroupOrder[1] = 1			--set the first group order
			globaltracks.oniondata.OnionVersion =1.00
		),
		function updateDataStruct =
	(
			grpNameTemp =#()
			for i in globaltracks.oniondata.GroupName do append grpNameTemp (i as string)
			 
			grpOrderTemp = #()
			for i in globaltracks.oniondata.GroupOrder do append grpOrderTemp (i as integer)

			layNameTemp = #()
			for i in globaltracks.oniondata.LayerName do append layNameTemp (i as string)
			
			layGrpTemp = #()
			for i in globaltracks.oniondata.LayerGroup do append layGrpTemp (i as integer)
			
			layIndTemp = #()
			for i in globaltracks.oniondata.LayerIndex do append layIndtemp (i as integer)
			
			isAltTemp = #()
			for i in globaltracks.oniondata.isAltmaterial do append isAltTemp i 
			
			AltMatTemp = #()
			for i in globaltracks.oniondata.AltMaterial do append AltMatTemp i
			
			matHoldTemp = #()
			for i in globaltracks.oniondata.MaterialHolder do append matHoldTemp i

			--delete the CA
			custAttributes.delete globaltracks 1
			if (PREF_Debug_Mode)  then print "FN: init - deleted CA"
			addOnionData()
			
			globaltracks.oniondata.GroupOrder = #()
			globaltracks.oniondata.GroupName = #()
			for i in grpNameTemp do
				append globaltracks.oniondata.GroupName i
			for i in grpOrderTemp do
				append globaltracks.oniondata.GroupOrder i
			for i in layNameTemp do
				append globaltracks.oniondata.LayerName i
			for i in layGrpTemp do
				append globaltracks.oniondata.LayerGroup i
			for i in layIndTemp do
				append globaltracks.oniondata.LayerIndex i
			for i in isAltTemp do
				append globaltracks.oniondata.isAltmaterial i
			for i in AltMatTemp do
				append globaltracks.oniondata.AltMaterial i
			for i in matHoldTemp do
				append globaltracks.oniondata.MaterialHolder i
		),
		function init =
	(
			if PREF_Debug_Mode != undefined then
				if (PREF_Debug_Mode)  then print "FN: init()"
			--NOTE THIS COLOR INFORMATION SHOULD ONLY BE GRABBED ONCE PER MAX FILE...PUT INTO CA or GDATA
			if PREF_UI_HideCheckColor == undefined then
		(
				local INIFile = ( OnionPath + "Onion.ini" )
				--get the settings from the INI
				local HideCheckColorAry = StringArrayAsIntArray ( getINISetting INIFile "UICOLORS" "LayerHideCheckColor" )
				PREF_UI_HideCheckColor = ([ HideCheckColorAry[1], HideCheckColorAry[2], HideCheckColorAry[3] ] as color )
					
				local ActiveLayerCheckAry = StringArrayAsIntArray ( getINISetting INIFile "UICOLORS" "ActiveLayerCheckColor" )
				PREF_UI_ActiveLayerCheckColor  = ([ ActiveLayerCheckAry[1], ActiveLayerCheckAry[2], ActiveLayerCheckAry[3] ] as color )
				
				local XRefCheckColorAry = StringArrayAsIntArray ( getINISetting INIFile "UICOLORS" "XRefCheckColor" )
				PREF_UI_XRefCheckColor  = ([ XRefCheckColorAry[1], XRefCheckColorAry[2], XRefCheckColorAry[3] ] as color )
				
				PREF_DisXRScene = (getINISetting INIFile "OPTIONS" "DisplayXRefScene")
				if PREF_DisXRScene == "false" then PREF_DisXRScene = false else PREF_DisXRScene = true
				
				PREF_Inherit_Wire = (getINISetting INIFile "OPTIONS" "InheritWireColor")
				if PREF_Inherit_Wire== "false" then PREF_Inherit_Wire= false else PREF_Inherit_Wire= true
				
				PREF_Inherit_Display = (getINISetting INIFile "OPTIONS" "InheritDisplay")
				if PREF_Inherit_Display == "false" then PREF_Inherit_Display = false else PREF_Inherit_Display = true
				
				PREF_Inherit_Render = (getINISetting INIFile "OPTIONS" "InheritRender")
				if PREF_Inherit_Render == "false" then PREF_Inherit_Render = false else PREF_Inherit_Render = true
				
				PREF_Inherit_Blur = (getINISetting INIFile "OPTIONS" "InheritBlur")
				if PREF_Inherit_Blur == "false" then PREF_Inherit_Blur = false else PREF_Inherit_Blur = true
		
				PREF_PromptOnNew  = (getINISetting INIFile "OPTIONS" "PromptNameOnNew")
				if PREF_PromptOnNew == "false" then PREF_PromptOnNew  = false else PREF_PromptOnNew = true		
				
				PREF_Debug_Mode = (getINISetting INIFile "OPTIONS" "DebugMode")
				if PREF_Debug_Mode == "false" then PREF_Debug_Mode  = false else PREF_Debug_Mode = true

		)
			--check version of the onion data and remove if it's old.
			if not (isProperty globaltracks #oniondata) then addOnionData()
			else if not (isProperty globaltracks.oniondata #OnionVersion) then
		(
				--push people up to the new version.
				if (custAttributes.getdef globaltracks 1).name == "OnionData" then 
			(	
			
					--push people up to the new version.
					if (custAttributes.getdef globaltracks 1).name == "OnionData" then 
					(	custAttributes.delete globaltracks 1
						addOnionData()
						messageBox "The OnionData in this scene has been updated.  However, the grouping has been lost.\nPlease re-organize your layers and save the file.   Sorry for the inconvience."
				)
					else messageBox "a mysterious force has prevented you from upgrading the onion.  seek help."		
			)
		)
			--version 0.99 removed the animatable tag on the layer properties			
			if globaltracks.oniondata.OnionVersion < 1.0 then
		(
				if (custAttributes.getdef globaltracks 1).name == "OnionData" then 
			(
					updateDataStruct()
					for i = 1 to globaltracks.oniondata.layername.count do
				(
						append globaltracks.oniondata.isAltProperty  false
						append globaltracks.oniondata.AltProperty "11111110"
						append globaltracks.oniondata.UseAltProperty "00000000"
				)
					messageBox "Thank you for using the Onion.\nThe OnionData in this scene has been updated to version 1.0.\nAlternate Properties are now possible.\n - Dave H - "				
			)
				else messageBox "a mysterious force has prevented you from upgrading the onion.  seek help."
		)
			
			--add any layers that exist from where ever...when ever.
			aquireMaxLayers()
			doLayerCleanup()
	)
)
	
)
--should take this outta global scope
gc()
if Onion != undedfined then
(
	Onion = Onion()
)
Onion.init()
Onion.showUI()
Onion.setupCallbacks()


