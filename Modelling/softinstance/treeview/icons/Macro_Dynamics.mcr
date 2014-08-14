-- Macro Scripts File
-- Created:  April 2 1999
-- Author:   Frank DeLise
-- Macro Scripts for Dynamics
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript Damper 
            category:"Objects" 
            internalcategory:"Objects" 
            tooltip:"Damper Dynamics Objects" 
            buttontext:"Damper" 
            icon:#("DynObj",2) 
(
	on execute do (Try(StartObjectCreation Damper)Catch() )
        on isChecked return (mcrUtils.IsCreating Damper)
)

macroScript Spring 
	category:"Objects" 
	internalcategory:"Objects" 
	tooltip:"Spring Dynamics Object" 
	buttontext:"Spring" 
	icon:#("DynObj", 1)
(
	on execute do (Try(StartObjectCreation Spring)Catch())
        on isChecked return (mcrUtils.IsCreating Spring)
)

