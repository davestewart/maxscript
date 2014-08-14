-- Macro Scripts File
-- Created:  Jan 10 1999
-- Author:   Frank DeLise
-- Macro Scripts for Systems
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript Bones 
            category:"Inverse Kinematics" 
            internalcategory:"Inverse Kinematics" 
            tooltip:"Bones IK Chain" 
            buttontext:"Bones IK Chain" 
            Icon:#("Systems",1)
(
    on execute do  StartObjectCreation Bones 
    on isChecked return mcrUtils.IsCreating Bones 
)

