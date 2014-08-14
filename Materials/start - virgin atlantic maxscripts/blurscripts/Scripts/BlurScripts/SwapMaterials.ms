---------------------------------------
--SwapMaterials.ms
--by Brandon Davis (brandon@blur.com)
--v 1.0
--created on 18 June 2001
--tested using MAX 4.2
---------------------------------------

---------------------------------------
--Required Files: none

---------------------------------------
--Description:
--Simple down and dirty way to store two materials to assign to objects in your scene.
--Quickens the process of swapping materials for mattes.
---------------------------------------

---------------------------------------
--To do: add dynamic material slots.
---------------------------------------

(
-- globals

global sm_rollout
global sm_floater

-- Variables

currentMat = undefined
matOne = undefined
matTwo = undefined

-- Functions

fn process = 
(
	if currentMat == undefined then MessageBox "You need to store a material first"
	else 
	(
		for i in selection do
		(
			i.material = currentMat
		)
	)
)

-- Rollouts

rollout sm_rollout "Parameters" width:162 height:84
(
	materialButton mbut "Get Material" pos:[10,7] width:94 height:21 
	checkbutton mat1 "Material 1" pos:[9,33] width:144 height:21 enabled:false 
	checkbutton mat2 "Material 2" pos:[9,59] width:144 height:21 enabled:false
	button btn2 "Assign" pos:[112,8] width:40 height:21

	on mbut picked mtl do
(
			currentMat = mtl
			mat1.enabled = true
			mat2.enabled = true
			if mat2.state == true then 
			(
				mat2.caption = mtl.name
				matTwo = mtl
			)
			else
			(
				mat1.caption = mtl.name
				matOne = mtl
				mat1.state = true
			)
				
	)
	on mat1 changed state do
(
			if state == true then
	            (
				mat2.enabled = true
	            mat2.state = false
	            currentMat = matOne
				--print currentMat
	            )
			else mat2.state = true
	)
	on mat2 changed state do
(
			if state == true then
	            (
	             mat1.state = false
	             currentMat = matTwo
				--print currentMat
	            )
	
			else mat1.state = true
	)
	on btn2 pressed do process()
)
if sm_floater != undefined then CloseRolloutFloater sm_floater
sm_floater = newRolloutFloater "Swap Materials v1.0" 200 150
addRollout sm_rollout sm_floater
)
