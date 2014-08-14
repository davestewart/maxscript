-- Macro Scripts File
-- Created:  Nov 17 1998
-- Author:   Frank DeLise
-- Macro Scripts for Particles
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK


macroScript PArray
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"PArray Particle System" 
            buttontext:"PArray" 
            Icon:#("Particles",3)
(
    on execute do StartObjectCreation PArray
    on isChecked return mcrUtils.IsCreating PArray
)

macroScript PCloud
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"PCloud Particle System" 
            buttontext:"PCloud" 
            Icon:#("Particles",6)
(
    on execute do StartObjectCreation PCloud 
    on isChecked return mcrUtils.IsCreating PCloud
)

macroScript Blizzard
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"Blizzard Particle System" 
            buttontext:"Blizzard" 
            Icon:#("Particles",5)
(
    on execute do StartObjectCreation Blizzard 
    on isChecked return mcrUtils.IsCreating Blizzard
)

macroScript SuperSpray
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"Super Spray Particle System"
			buttontext:"Super Spray" 
            Icon:#("Particles",2)
(
    on execute do StartObjectCreation SuperSpray 
    on isChecked return mcrUtils.IsCreating SuperSpray
)

macroScript Spray
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"Spray Particle System" 
            buttontext:"Spray" 
            Icon:#("Particles",1)
(
    on execute do StartObjectCreation Spray
    on isChecked return mcrUtils.IsCreating Spray
)

macroScript Snow
            category:"Particle Systems" 
            internalcategory:"Particle Systems" 
            tooltip:"Snow Particle System" 
            buttontext:"Snow" 
            Icon:#("Particles",4)
(
    on execute do StartObjectCreation Snow 
    on isChecked return mcrUtils.IsCreating Snow
)
