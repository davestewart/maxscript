---------------------------------------------------------------------------------------------------
-- Flash Character Selection Test
--
-- Author:		Dave Stewart
-- Date:		5th March 2002
-- Version:		0.5
-- MAX:			4.x
--
-- Description:		Sample file to show how Flash can control objects in max by placing an
--					interactive .swf in a rollout.
--
-- Note:			
--
---------------------------------------------------------------------------------------------------

rollout rFlash "Character Select" width:162 height:252
(


	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

		-- IMPORTANT!!!!
		-- make sure the next line points to the flash object in your scripts directory...

		local flashFile = "E:/05 - Scripting/MaxScript/projects/Flash/character/character.swf"
		local args = #()	-- this is the array that will be populated by arguments from the Flash object
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[13,7] width:200 height:250
	label lbl1 "Last Selected: " width:200 height:16
	button btn1	"Bring up selected object's material" width:200 height:16
	button btnGetFlashFile "Select new Flash file" width:200 height:16

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- set the Flash object
		on rFlash open do
		( 
			axFlash.movie = flashFile  
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
		)

	-- receive Flash commands
		on axFlash FSCommand str1 str2 do
		( 
			case str1 of
			(
				"dummy":
					case str2 of
					(
						"hand left":	obj = $'cone hand dummy L'
						"hand right":	obj = $'cone hand dummy R'
						"foot left":	obj = $'cone Foot dummy L'
						"foot right":	obj = $'cone Foot dummy R'
						"body":			obj = $'cone root'
					)
				"body":
					case str2 of
					(
						"hand left":	obj = $'cone hand L'
						"hand right":	obj = $'cone hand R'
						"foot left":	obj = $'cone Foot L'
						"foot right":	obj = $'cone Foot R'
						"body":			obj = $'cone head'
					)
				"details":
					case str2 of
					(
						"eyes":			obj = $'cone eyes'
					)
			)
			try
			(
				select obj
				lbl1.text = "Last Selected: " + selection[1].name as string
			)
			catch
			(
				format "Attempted to select %\n" str2
			)
		)

		on btn1 pressed do
		(
			found = false
			for i = 1 to meditMaterials.count do
			(
				try (
					if meditMaterials[i].name == $.material.name then
					(
						medit.SetActiveMtlSlot i true
						max mtledit
						found = true
					)
				)
				catch
				(
					if $ != undefined AND $.material == undefined then found = true
				)
			)
			if NOT found AND $ != undefined AND $.material != undefined then
			(
				if queryBox "Material not found in Editor. Do you want to put it in Slot 1?" then
				(
					medit.PutMtlToMtlEditor $.material 1
					medit.SetActiveMtlSlot 1 true
					max mtledit
				)
			)
		)

		on btnGetFlashFile pressed do
		(
			flashFile = getOpenFileName caption:"Select *.ms Script File" types:"Macromedia Flash Files (*.swf)|*.swf" ()
			axFlash.movie = flashFile
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
		)


)
if flashFloater != undefined then closerolloutfloater flashFloater
	flashFloater = newRolloutFloater "Character Select" 250 385
addRollout rFlash flashFloater
