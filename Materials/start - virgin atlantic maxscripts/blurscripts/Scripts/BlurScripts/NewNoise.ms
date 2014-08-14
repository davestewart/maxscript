-------------------------------------------------------------------------------
-- NewNoise.ms
-- By Neil Blevins (neil@soulburn3d.com)
-- v 1.00
-- Created On: 09/18/00
-- Modified On: 11/03/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- The same as the regular noise modifier, except it strips away some unnecessary
-- features (not unnecessary in all situations, just in most) and binds the
-- x y z of strength into a single spinner that affects all axes equally.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
plugin modifier NewNoiseMod 
name:"NewNoise" 
classID:#(0x97c03ce4, 0x84837fb4)
extends:Noisemodifier replaceUI:true
	( 
	parameters main rollout:params 
		( 
		noiseseed type:#integer animatable:true ui:noiseseed default:0
		on noiseseed set val do delegate.seed = val
		noisescale type:#float animatable:true ui:noisescale default:5
		on noisescale set val do delegate.scale = val
		overallstrength type:#float animatable:true ui:overallstrength default:2
		on overallstrength set val do delegate.strength = [val,val,val]
		) 

	rollout params "Parameters" 
		( 
		group "NewNoise:"
		(
		spinner noiseseed "Seed:" range:[0,9999999,0]
		spinner noisescale "Scale" range:[0,9999999,5]
		spinner overallstrength "Strength:" range:[-9999999,9999999,2]
		)
		) 
	
	on create do
		(
 		Delegate.scale = 5
 		Delegate.strength = [2,2,2]
		)
	)
)
-------------------------------------------------------------------------------