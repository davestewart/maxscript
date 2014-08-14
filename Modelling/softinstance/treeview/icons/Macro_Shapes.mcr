-- Macro Scripts File
-- Created:  Nov 17 1998
-- Author:   Frank DeLise
-- Macro Scripts for Shapes
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript Lines 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Line Shape" 
            buttontext:"Line" 
            Icon:#("Splines",1)
(
   on execute do StartObjectCreation Line
   on isChecked return (mcrUtils.IsCreating Line)
)

macroScript Circle 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Circle Shape" 
            buttontext:"Circle" 
            Icon:#("Splines",2)
(
   on execute do StartObjectCreation Circle 
   on isChecked return (mcrUtils.IsCreating Circle)
)

macroScript Arc 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Arc Shape" 
            buttontext:"Arc" 
            Icon:#("Splines",3)
(
   on execute do StartObjectCreation Arc
   on isChecked return (mcrUtils.IsCreating Arc)
)

macroScript Ngon 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"NGon Shape" 
            buttontext:"NGon" 
            Icon:#("Splines",4)
(
   on execute do StartObjectCreation Ngon
   on isChecked return (mcrUtils.IsCreating Ngon)
)

macroScript Text 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Text Shape" 
            buttontext:"Text" 
            Icon:#("Splines",5)
(
   on execute do StartObjectCreation Text 
   on isChecked return (mcrUtils.IsCreating Text)
)

macroScript Rectangle 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Rectangle Shape" 
            buttontext:"Rectangle" 
            Icon:#("Splines",7)
(
   on execute do StartObjectCreation Rectangle 
   on isChecked return (mcrUtils.IsCreating Rectangle)
)

macroScript Ellipse 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Ellipse Shape" 
            buttontext:"Ellipse" 
            Icon:#("Splines",8)
(
   on execute do StartObjectCreation Ellipse 	
   on isChecked return (mcrUtils.IsCreating Ellipse)
)

macroScript Donut 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Donut Shape" 
            buttontext:"Donut" 
            Icon:#("Splines",9)
(
   on execute do StartObjectCreation Donut 
   on isChecked return (mcrUtils.IsCreating Donut)
)

macroScript Star 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Star Shape" 
            buttontext:"Star" 
            Icon:#("Splines",10)
(
   on execute do StartObjectCreation Star 
   on isChecked return (mcrUtils.IsCreating Star)
)

macroScript Helix 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Helix Shape" 
            buttontext:"Helix" 
            Icon:#("Splines",11)
(
   on execute do StartObjectCreation Helix 
   on isChecked return (mcrUtils.IsCreating Helix)
)
macroScript Section 
            category:"Shapes" 
            internalcategory:"Shapes" 
            tooltip:"Section Shape" 
            buttontext:"Section " 
            Icon:#("Splines",6)
(
   on execute do StartObjectCreation Section 
   on isChecked return (mcrUtils.IsCreating Section)
)

