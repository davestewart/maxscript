-- Macro Scripts File
-- Created:  Nov 17 1998
-- Modified: July 6 1999
-- Author:   Frank DeLise
-- Macro Scripts for SpaceWarps
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroScript SpaceBend 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Bend Space Warp "
            buttontext:"Bend Space Warp "
            Icon:#("SW_ModBased",1)
(
    on execute do StartObjectCreation SpaceBend
    on isChecked return mcrUtils.IsCreating SpaceBend
)

macroScript SpaceTaper 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Taper Space Warp " 
            buttontext:"Taper Space Warp " 
            Icon:#("SW_ModBased",2)
(
    on execute do StartObjectCreation SpaceTaper
    on isChecked return mcrUtils.IsCreating SpaceTaper
)

macroScript SpaceNoise 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Noise Space Warp " 
            buttontext:"Noise Space Warp " 
            Icon:#("SW_ModBased",3)
(
    on execute do StartObjectCreation SpaceNoise
    on isChecked return mcrUtils.IsCreating SpaceNoise
)

macroScript SpaceTwist 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Twist Space Warp " 
            buttontext:"Twist Space Warp " 
            Icon:#("SW_ModBased",4)
(
    on execute do StartObjectCreation SpaceTwist
    on isChecked return mcrUtils.IsCreating SpaceTwist
)

macroScript SpaceSkew 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Skew Space Warp" 
            buttontext:"Skew Space Warp" 
            Icon:#("SW_ModBased",5)
(
    on execute do StartObjectCreation SpaceSkew
    on isChecked return mcrUtils.IsCreating SpaceSkew
)

macroScript SpaceStretch 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Stretch Space Warp" 
            buttontext:"Stretch Space Warp" 
            Icon:#("SW_ModBased",6)
(
    on execute do StartObjectCreation SpaceStretch
    on isChecked return mcrUtils.IsCreating SpaceStretch
)

macroScript Ripple 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Ripple Space Warp" 
            buttontext:"Ripple Space Warp" 
            Icon:#("SW_GeoDef",6)
(
    on execute do StartObjectCreation SpaceRipple
    on isChecked return mcrUtils.IsCreating SpaceRipple
)


macroScript FFD_Cyl 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"FFD(Cyl) Space Warp" 
			ButtonText:"FFD(Cyl) Space Warp" 
            Icon:#("SW_GeoDef",5)
(
    on execute do StartObjectCreation SpaceFFDCyl
    on isChecked return mcrUtils.IsCreating SpaceFFDCyl
)


macroScript FFD_Box 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"FFD(Box) Space Warp"
			ButtonText:"FFD(Box) Space Warp"
            Icon:#("SW_GeoDef",1)
(
    on execute do StartObjectCreation SpaceFFDBox
    on isChecked return mcrUtils.IsCreating SpaceFFDBox
)

macroScript Motor 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Motor Space Warp" 
            buttontext:"Motor Space Warp" 
            Icon:#("SW_PartDyn",3)
(
    on execute do StartObjectCreation Motor
    on isChecked return mcrUtils.IsCreating Motor
)

macroScript Pbomb 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"PBomb Space Warp" 
            buttontext:"PBomb Space Warp" 
            Icon:#("SW_PartDyn",4)
(
    on execute do StartObjectCreation PBomb 
    on isChecked return mcrUtils.IsCreating PBomb 
)

macroScript Push 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Push Space Warp" 
            buttontext:"Push Space Warp" 
            Icon:#("SW_PartDyn",5)
(
    on execute do StartObjectCreation PushSpaceWarp 
    on isChecked return mcrUtils.IsCreating PushSpaceWarp 
)

macroScript SDynaFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"SDynaFlect Space Warp" 
            buttontext:"SDynaFlect Space Warp" 
            Icon:#("SW_DynInt",2)
(
    on execute do StartObjectCreation SDynaFlect
    on isChecked return mcrUtils.IsCreating SDynaFlect
)

macroScript PDynaFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"PDynaFlect Space Warp" 
            buttontext:"PDynaFlect Space Warp" 
            Icon:#("SW_DynInt",3)
(
    on execute do StartObjectCreation PDynaFlect 
    on isChecked return mcrUtils.IsCreating PDynaFlect 
)

macroScript UDynaFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"UDynaFlect Space Warp" 
            buttontext:"UDynaFlect Space Warp" 
            Icon:#("SW_DynInt",4)
(
    on execute do StartObjectCreation UDynaFlect 
    on isChecked return mcrUtils.IsCreating UDynaFlect 
)


macroScript POmniFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"POmniFlect Space Warp" 
            buttontext:"POmniFlect Space Warp" 
            Icon:#("SW_PartOnly",1)
(
    on execute do StartObjectCreation POmniFlect 
    on isChecked return mcrUtils.IsCreating POmniFlect 
)


macroScript SOmniFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"SOmniFlect Space Warp" 
            buttontext:"SOmniFlect Space Warp" 
            Icon:#("SW_PartOnly",5)
(
    on execute do StartObjectCreation SOmniFlect 
    on isChecked return mcrUtils.IsCreating SOmniFlect 
)


macroScript UOmniFlect 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"UOmniFlect Space Warp" 
            buttontext:"UOmniFlect Space Warp" 
            Icon:#("SW_PartOnly",2)
(
    on execute do StartObjectCreation UOmniFlect 
    on isChecked return mcrUtils.IsCreating UOmniFlect 
)

macroScript SDeflector 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"SDeflector Space Warp" 
            buttontext:"SDeflector Space Warp" 
            Icon:#("SW_PartOnly",6)
(
    on execute do StartObjectCreation SDeflector 
    on isChecked return mcrUtils.IsCreating SDeflector 
)

macroScript UDeflector 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"UDeflector Space Warp" 
            buttontext:"UDeflector Space Warp" 
            Icon:#("SW_PartOnly",7)
(
    on execute do StartObjectCreation UDeflector 
    on isChecked return mcrUtils.IsCreating UDeflector 
)



macroScript Wave 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Wave Space Warp" 
            buttontext:"Wave Space Warp" 
            Icon:#("SW_GeoDef",2)
(
    on execute do StartObjectCreation SpaceWave 
    on isChecked return mcrUtils.IsCreating SpaceWave 
)


macroScript Gravity 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Gravity Space Warp " 
            buttontext:"Gravity Space Warp " 
            Icon:#("SW_PartDyn",1)
(
    on execute do StartObjectCreation Gravity 
    on isChecked return mcrUtils.IsCreating Gravity 
)


macroScript Wind 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Wind Space Warp " 
            buttontext:"Wind Space Warp " 
            Icon:#("SW_PartDyn",2)
(
    on execute do StartObjectCreation Wind 
    on isChecked return mcrUtils.IsCreating Wind 
)


macroScript Displace 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Displace Space Warp" 
            buttontext:"Displace Space Warp" 
            Icon:#("SW_GeoDef",3)
(
    on execute do StartObjectCreation SpaceDisplace 
    on isChecked return mcrUtils.IsCreating SpaceDisplace 
)


macroScript Deflector 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Deflector Space Warp" 
            buttontext:"Deflector Space Warp" 
            Icon:#("SW_Partonly",4)
(
    on execute do StartObjectCreation Deflector 
    on isChecked return mcrUtils.IsCreating Deflector 
)


macroScript Bomb  
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Bomb Space Warp" 
            buttontext:"Bomb Space Warp" 
            Icon:#("SW_GeoDef",4)
(
    on execute do StartObjectCreation Bomb 
    on isChecked return mcrUtils.IsCreating Bomb 
)


macroScript Path_Follow 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Path Follow Space Warp" 
            buttontext:"Path Follow Space Warp" 
            Icon:#("SW_Partonly",3)
(
    on execute do StartObjectCreation Path_Follow
    on isChecked return mcrUtils.IsCreating Path_Follow
)

macroScript SpaceConform 
            category:"Space Warps" 
            internalcategory:"Space Warps" 
            tooltip:"Conform Space Warp" 
            buttontext:"Conform Space Warp" 
            Icon:#("SW_GeoDef",7)
(
    on execute do StartObjectCreation ConformSpacewarp 
    on isChecked return mcrUtils.IsCreating ConformSpacewarp 
)

