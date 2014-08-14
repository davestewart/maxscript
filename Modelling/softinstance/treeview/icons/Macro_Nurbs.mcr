-- Macro Scripts File
-- Created:  Nov 17 1998
-- Author:   Frank DeLise
-- Macro Scripts for NURBS
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript Point_Curve 
            category:"NURBS" 
            internalcategory:"NURBS" 
            tooltip:"NURBS Point Curve" 
            buttontext:"NURBS Point Curve" 
            Icon:#("NURBScurve",1)
(
   on execute do StartObjectCreation Point_Curve
   on isChecked return mcrUtils.IsCreating Point_Curve
)

macroScript CV_Curve 
            category:"NURBS" 
            internalcategory:"NURBS" 
            tooltip:"NURBS CV Curve" 
            buttontext:"NURBS CV Curve" 
            Icon:#("NURBScurve",2)
(
   on execute do StartObjectCreation CV_Curve
   on isChecked return mcrUtils.IsCreating CV_Curve 
)
