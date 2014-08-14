-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Name			Transformation Presets
-- Description	Adds a rollout to any object that allows you to store and retrieve transforms.
-- 				Useful for things like IK chains, or setting and getting camera positions
--
--				Original idea from this thread: http://forums.cgsociety.org/showthread.php?f=98&t=632251
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.7
-- max version:	7
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
/*
-- history:		16 May 2008 - created

				17 May 2008	- added abiilty to rename presets
							- added support for switching between target and free cameras
							- converted script to macroscript
							
				18 May 2008	- added abilty to save and restore an IK chain's swivel angle
							- added "Remove" ui option
							- updated a naming bug when updating
							
-- to do:		- Reorder items
				- copy / paste transform list from / to objects
				- import / export transforms
				- grab list fom keyframes
*/
-------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------
-- Macroscript
-------------------------------------------------------------------------------------------------------------------------------

macroScript TransformPresets
	category:"Animation Tools"
	buttonText:"Add transform presets"
	tooltip:"Transform presets"
	(
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- CA definition
	-------------------------------------------------------------------------------------------------------------------------------
	
		--if transformPresetsCA == undefined do 
		transformPresetsCA = attributes transformPresetsAtts
			(
			parameters main rollout:params
				(
				targetTransforms type:#matrix3tab tabSize:0 tabSizeVariable:true
				objectTransforms type:#matrix3tab tabSize:0 tabSizeVariable:true
				listboxNames type:#stringtab tabSize:0 tabSizeVariable:true
				)
			 
			rollout params "Transform Presets"
				(
				
				-------------------------------------------------------------------------------------------------------------------------------
				-- variables
				-------------------------------------------------------------------------------------------------------------------------------
		
					local obj
		
				-------------------------------------------------------------------------------------------------------------------------------
				-- interface
				-------------------------------------------------------------------------------------------------------------------------------
				
					GroupBox grpNames "Presets" pos:[4,8] width:152 height:196
						listbox lbxNames "" pos:[12,24] width:136 height:13
					
					GroupBox grpManage "Manage" pos:[4,208] width:152 height:104
						editText edtName "" pos:[8,224] width:140 height:17
						button btnAdd "Add" pos:[12,248] width:136 height:16
						button btnUpdate "Update" pos:[12,264] width:136 height:16
						button btnDelete "Delete" pos:[12,288] width:136 height:16
					
					GroupBox grpRemove "Remove" pos:[4,320] width:152 height:40
						button btnRemove "Remove" pos:[12,336] width:136 height:16

				-------------------------------------------------------------------------------------------------------------------------------
				-- functions
				-------------------------------------------------------------------------------------------------------------------------------
				
					-- name
					
						function setName index =
							(
							edtName.text = lbxNames.items[index]
							)
							
						function getName update:false =
							(
							if update == true then
								(
								if lbxNames.selection != 0 then edtName.text--lbxNames.items[lbxNames.selection]
								else ""
								)
							else(
								if edtName.text == "" then "Transform " + (lbxNames.items.count + 1) as string
								else edtName.text
								)
							)
							
					-- list
					
						function updateItems =
							(
							local items		= for name in listboxNames collect name
							lbxNames.items	= items
							)
						
					-- transforms
					
						function getTransform obj index =
							(
							-- object
								obj.transform = objectTransforms[index]
								
							-- target
								local trgTransform = targetTransforms[index]
								
								-- IK chain object
									if classof obj == IK_Chain_Object then
										(
										local a		= (quattoeuler trgTransform.rotation).z
										local ctrl	= obj.transform.controller 
										if isproperty ctrl "swivelAngle" do setproperty ctrl "swivelAngle" a
										)
										
								-- targetted objects
									else if obj.target != undefined AND trgTransform != undefined do
										(
										obj.target.transform = trgTransform
										)
							)
							
						function setTransform obj name index: =	
							(
							-- new transform
								if index == unsupplied then
									(
									local tm = matrix3 1
									append listboxNames ""
									append objectTransforms tm
									append targetTransforms tm
									index = objectTransforms.count
									)
										
							-- get target transforms

								-- variables
									local trgTransform	= matrix3 0
									
								-- IK chain object
								-- store the swivel angle property in the z rotation property of the target matrix
									if classof obj == IK_Chain_Object then
										(
										local ctrl		= obj.transform.controller 
										local a			= if isproperty ctrl "swivelAngle" then getproperty ctrl "swivelAngle" else 0
										trgTransform	= rotateZMatrix a
										)
										
								-- free camera
								-- store a virtual target 100 units in front of the camera
									else if superclassof obj == Camera AND obj.target == undefined then
										(
										local pos = in coordsys obj obj.pos + ([0,0,-100] * obj.transform)
										trgTransform.pos		= pos
										)
										
								-- targetted object
								-- store the target transform
									else if obj.target != undefined then
										(
										trgTransform = obj.target.transform
										)
									
								-- normal object
								-- store the object transform as the (non-existant) target transform
									else
										(
										trgTransform = obj.transform
										)


							-- assign transforms
								listboxNames[index]		= name
								objectTransforms[index]	= obj.transform
								targetTransforms[index]	= trgTransform
								
							-- update
								updateItems()
							)
							
						function deleteTransform obj index =
							(
							deleteItem objectTransforms index
							if obj.target != undefined do deleteItem targetTransforms index
							deleteItem listboxNames index
							updateItems()
							)
							
						
				-------------------------------------------------------------------------------------------------------------------------------
				-- handlers
				-------------------------------------------------------------------------------------------------------------------------------
				
					on btnAdd pressed do
						(
						local obj = $
						local name = getName update:false
						if obj != undefined AND name != "" do
							(
							setTransform obj name
							lbxNames.selection = lbxNames.items.count
							edtName.text = ""
							)
						)
					
					on btnUpdate pressed do
						(
						local index = lbxNames.selection
						if index != 0 do
							(
							local obj = $
							local name = getName update:true
							if obj != undefined AND name != "" do setTransform obj name index:index
							)
						)
						
					on btnDelete pressed do
						(
						local obj = $
						local sel = lbxNames.selection
						if obj != undefined AND sel > 0 do deleteTransform obj sel
						)
					
					on params open do
						(
						updateItems()
						getName()
						)
						
					on lbxNames selected index do setName index
		
					on lbxNames doubleclicked index do
						(
						local obj = $
						if obj != undefined do getTransform obj index
						)
						
					on btnRemove pressed do
						(
						if queryBox "Are you sure you want to remove this rollout?" == true do
							(
							local defs = custAttributes.getDefs $ baseObject:true
							for def in defs do
								(
								if def.name == #transformPresetsAtts do custAttributes.delete $ def baseObject:true
								)
							
							)
						)
				)
			)
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- apply CA
	-------------------------------------------------------------------------------------------------------------------------------
	
		on isEnabled do $ != undefined
		on execute do if $ != undefined do custAttributes.add $ transformPresetsCA baseObject:true
	)

/*
custAttributes.delete $ 1 baseObject:true
macros.run "Animation Tools" "TransformPresets"
*/