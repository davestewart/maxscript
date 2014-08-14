-------------------------------------------------------------------------------
-- KillLayerMan.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 06/27/01
-- Modified On: 03/22/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Layerman, http://www.rezn8.com/gearhead/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Destroys all layerman information for the entire scene, both at the object
-- level and the scene level by destroying the perisstent lm info in the scene.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Destroys all layerman information for the entire scene, both at the object
-- level and the scene level by destroying the perisstent lm info in the scene.
--
-- v 1.10 Should also work now on Layerman 3 scenes.
--
-- v 1.11 Also deletes callbacks left by layerman 2.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if (queryBox "Do you wish to wipe all Layerman data from your scene?" title:"KillLayerMan") == true then 
(
	-- kills layerman 2 info
	
	LM_Data = undefined
	
	-- kills layerman 3 global track
	
	LID = getappdata globaltracks[1] 9901
	if LID != undefined then
	(
		LM = undefined
		execute (LID + " = undefined")
		deleteappdata globaltracks[1] 9901
	)
		
	-- kills layerman 2 and 3 change handlers
	
	callbacks.removeScripts #systemPreReset id:#LM_RemoveDataA
	callbacks.removeScripts #systemPreNew id:#LM_RemoveDataC
	callbacks.removeScripts #filePreOpen id:#LM_RemoveDataB
	callbacks.removeScripts #filePreMerge id:#LM_PreMergeFix
	callbacks.removeScripts #filePostMerge id:#LM_PostMergeFix
	
	deleteAllChangeHandlers id:#LM_Handle
	
	-- kills layerman floater
	
	if LM_Float != undefined then 
	(
		closeRolloutFloater LM_Float
		LM_Float = Undefined
	)
	
	-- kills appdata from objects
	
	for i in $* do
	(
		deleteappdata i 9901
		deleteappdata i 9902
	)
)
)
-------------------------------------------------------------------------------