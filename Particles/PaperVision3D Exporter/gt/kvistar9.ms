plugin simpleObject Treetool 
name:"Treetool"
category:"UFA-Plugins"
classID:#(0xfb50b203, 0x3e80208d)

(
	local locker = false
	local sub_name = #()
	local arrnr = 16
	local arrnr_leaf = 9

	parameters pblock_trunk rollout:trunk
(
		sides_trunk ui:sides default:12 type:#worldunits animatable:false
		segs_trunk ui:steps default:20 type:#worldunits animatable:false
		thickness_trunk ui:thickness default:10 type:#worldunits animatable:true
		length_trunk ui:length default:250 type:#worldunits animatable:true
		noise_trunk ui:noise type:#worldunits animatable:true
		seed_trunk ui:seed type:#worldunits animatable:true
		bend_t ui:bend default:0 type:#worldunits animatable:true
		benddir_t ui:benddir default:0 type:#worldunits animatable:true
		bstart_trunk ui:bstart default:100 type:#worldunits animatable:true
		bstop_trunk ui:bstop default:250 type:#worldunits animatable:true
		taper_trunk ui:taper default:0.5 type:#worldunits animatable:true

)

	parameters pblock_branch rollout:branch
(
		sub_branches ui:sub type:#string 
		subb type:#floattab tabsizevariable:true
		sub_name_b type:#stringtab
		lengthstate type:#boolean
		
		memlength type:#floattab tabsizevariable:true
		membend type:#floattab tabsizevariable:true
		memdir type:#floattab tabsizevariable:true

		teee_l type:#floattab tabsize:100 tabsizevariable:true
		teee_b type:#floattab tabsize:100 tabsizevariable:true
		teee_d type:#floattab tabsize:100 tabsizevariable:true
)
	
	parameters pblock_leaf rollout:leaf
(
		leaf_type_l ui:leaf_type default:1 type:#worldunits animatable:false
		sub_leaf ui:sub type:#string 
		subb_leaf type:#floattab tabsizevariable:true

)
	
	parameters pblock_winds rollout:winds
(
		direction_winds ui:direction default:1 type:#worldunits animatable:true
		dir_strengt_winds ui:dir_strengt  default:20 type:#worldunits animatable:true
		dir_freq_winds ui:dir_freq default:1.5 type:#worldunits animatable:true
		wind_strength_winds ui:wind_strength default:20 type:#worldunits animatable:true
		wind_freq_winds ui:wind_freq default:2 type:#worldunits animatable:true
		min_wind_winds ui:min_wind default:10 type:#worldunits animatable:true
		w_dist_freq_winds ui:w_dist_freq default:2 type:#worldunits animatable:true
		w_dist_strength_winds ui:w_dist_strength default:10 type:#worldunits animatable:true
		windon_wind ui:windon type:#boolean
)

rollout trunk "Trunk" width:162 height:300
(
		spinner sides "Sides: " range:[3,30,12] type:#integer fieldwidth:40
		spinner steps "Segments: " range:[2,30,20] type:#integer fieldwidth:40
		spinner thickness "Thickness: " range:[5,50,10] type:#integer fieldwidth:40
		spinner length "Lengt: " range:[10,500,50] type:#integer fieldwidth:40
		spinner noise "Noise: " range:[-30,30,0] type:#float fieldwidth:40
		spinner seed "Noise size: " range:[-20,20,0] type:#float fieldwidth:40
		spinner bend "bend: " range:[0,90,0] type:#integer fieldwidth:40
		spinner benddir "Bend dir: " range:[0,360,0] type:#integer fieldwidth:40
		spinner bstart "Branches from heigth: " range:[0,1000,100] type:#integer fieldwidth:40
		spinner bstop "Branch to heigth: " range:[0,1000,250] type:#integer fieldwidth:40
		spinner taper "Taper: " range:[0.5,1,0.5] type:#float fieldwidth:40

)

rollout branch "Branch" width:162 height:300
(
		button creasub "New sub branch" width:110 
		dropdownlist sub "Sub branch:" 
		spinner sides "Sides: " range:[3,30,5] type:#integer fieldwidth:40 enabled:locker
		spinner steps "Segments: " range:[2,30,5] type:#integer fieldwidth:40 enabled:locker
		spinner thickness "Thickness: " range:[0.1,100,1] fieldwidth:40 enabled:locker
		spinner length "Lengt: " range:[5,1500,15] fieldwidth:40 enabled:locker
		spinner start "Branch from: " range:[0,1500,0] fieldwidth:40 enabled:locker
		spinner twidth "Branch to:" range:[0,1500,0] type:#float fieldwidth:40 enabled:locker
		spinner noise "Noise: " range:[0,30,0] fieldwidth:40 enabled:locker
		spinner noise_size "Noise size: " range:[0,5,0] type:#float fieldwidth:40 enabled:locker
		spinner noise_variation "Noise variation %: " range:[0,100,0] type:#integer fieldwidth:40 enabled:locker
		spinner noise_phase "Noise phase: " range:[0,10,0] type:#integer fieldwidth:40 enabled:locker
		spinner anim "Lag " range:[0,100,0] type:#integer fieldwidth:40 enabled:locker
		spinner bend "Bend: " range:[-180,180,0] fieldwidth:40 enabled:locker
		spinner benddir "Position seed: " range:[0,10000,1234] type:#integer fieldwidth:40 enabled:locker
		spinner amount "Branches: " range:[1,100,1] type:#integer fieldwidth:40 enabled:locker
		spinner bbend "Branch spread: f" range:[-90,90,0] type:#float fieldwidth:40 enabled:locker
		spinner bwidth "Branch direction: t" range:[-90,90,0] type:#float fieldwidth:40 enabled:locker
		button delbranch "Delete last branch" width:110 

		checkbutton lengthstate "Length curve control" checked:false
		CurveControl length_curve "Length curve control:" asPopup:true visible:false asPopup:true numCurves:2 height:0\ 
		width:0 uiFlags:#(#drawBG, #drawgrid, #upperToolbar, #lowerToolbar, #showReset, #constrainY, #xvalue)\
		x_range:[0,100] y_range:[0,1] scrollValues:[-0.5,1.5]

		checkbutton bendstate "Bend curve control" checked:false
		CurveControl bend_curve "Bend curve control:" asPopup:true visible:false asPopup:true numCurves:2 height:0\ 
		width:0 uiFlags:#(#drawBG, #drawgrid, #upperToolbar, #lowerToolbar, #showReset, #constrainY, #xvalue)\
		x_range:[0,100] y_range:[-1,1] scrollValues:[-1.5,1.5]

		checkbutton dirstate "Direction curve control" checked:false
		CurveControl direction_curve "Direction curve control:" asPopup:true visible:false asPopup:true numCurves:2 height:0\ 
		width:0 uiFlags:#(#drawBG, #drawgrid, #upperToolbar, #lowerToolbar, #showReset, #constrainY, #xvalue)\
		x_range:[0,100] y_range:[-1,1] scrollValues:[-1.5,1.5]

on branch open do
(
sub.items = sub_name
)

----------- Length curve controls

on lengthstate changed state do 
(
length_curve.visible = state
if lengthstate.state == true do 
(
local crv = length_curve.curves[1] 
crv.name = "length" as string 
crv.color = red 
if memlength[1] == undefined do memlength = #(0,1,100,1)
crv.numpoints = memlength.count/2

local cpval = #()
local cpinta = #()
local cpouta = #()
local a = 1
for j=1 to memlength.count by 2 do 
(
append cpval ([memlength[j],memlength[j+1]] as point2)
append cpinta [0,0] 
append cpouta [0,0] 
a += 1
)

local nr = cpval.count
for f = 1 to cpval.count do
(
local crv = length_curve.curves[1]
local cp = crv.points[nr] 
cp.value = cpval[nr]
cp.inTangent = cpinta[nr]
cp.outTangent = cpouta[nr] 
crv.points[nr] = cp
nr -= 1
)
zoom length_curve #all
)

-------- lengthstate true ends/ lengthstate false

if lengthstate.state == false do 
(
local crv = length_curve.curves[1]
memlength = #()
for f = 1 to crv.points.count do
(
append memlength crv.points[f].value[1] 
append memlength crv.points[f].value[2]  
)
)
)

-------- lengthstate false ends/ length value changed

on length_curve ptChanged ci val do
(
if lengthstate.state == true do
(
local crv = length_curve.curves[1]
teee_l = #()
for s = 1 to 100 do 
(
t = getvalue crv 0 s lookup:false
append teee_l t
)
)
)
----------- End of length curve controls

----------- Bend curve controls

on bendstate changed state do 
(
bend_curve.visible = state
if bendstate.state == true do 
(
local crv = bend_curve.curves[1] 
crv.name = "bend" as string 
crv.color = red 
if membend[1] == undefined do membend = #(0,1,100,1)
crv.numpoints = membend.count/2

local cpval = #()
local cpinta = #()
local cpouta = #()
local a = 1
for j=1 to membend.count by 2 do 
(
append cpval ([membend[j],membend[j+1]] as point2)
append cpinta [0,0] 
append cpouta [0,0] 
a += 1
)

local nr = cpval.count
for f = 1 to cpval.count do
(
local cp = crv.points[nr] 
cp.value = cpval[nr]
cp.inTangent = cpinta[nr]
cp.outTangent = cpouta[nr] 
crv.points[nr] = cp
nr -= 1
)
zoom bend_curve #all
)

-------- bendstate true ends/ bendstate false

if bendstate.state == false do 
(
local crv = bend_curve.curves[1]
membend = #()
for f = 1 to crv.points.count do
(
append membend crv.points[f].value[1] 
append membend crv.points[f].value[2]  
)
)
)

-------- bendstate false ends/ bend value changed

on bend_curve ptChanged ci val do
(
if bendstate.state == true do
(
local crv = bend_curve.curves[1]
teee_b = #()
for s = 1 to 100 do 
(
t = getvalue crv 0 s lookup:false
append teee_b t
)
)
)
----------- End of bend curve controls

----------- Direction curve controls

on dirstate changed state do 
(
direction_curve.visible = state
if state == true do 
(
local crv = direction_curve.curves[1] 
crv.name = "direction" as string 
crv.color = red 
if memdir[1] == undefined do memdir = #(0,1,100,1)
crv.numpoints = memdir.count/2

local cpval = #()
local cpinta = #()
local cpouta = #()
local a = 1
for j=1 to memdir.count by 2 do 
(
append cpval ([memdir[j],memdir[j+1]] as point2)
append cpinta [0,0] 
append cpouta [0,0] 
a += 1
)

local nr = cpval.count
for f = 1 to cpval.count do
(
local crv = direction_curve.curves[1]
local cp = crv.points[nr] 
cp.value = cpval[nr]
cp.inTangent = cpinta[nr]
cp.outTangent = cpouta[nr] 
crv.points[nr] = cp
nr -= 1
)
zoom direction_curve #all
)

-------- dirstate true ends/ dirstate false

if dirstate.state == false do 
(
local crv = direction_curve.curves[1]
memdir = #()
for f = 1 to crv.points.count do
(
append memdir crv.points[f].value[1] 
append memdir crv.points[f].value[2]  
)
)
)

-------- dirstate false ends/ dir value changed

on direction_curve ptChanged ci val do
(
if dirstate.state == true do
(
local crv = direction_curve.curves[1]
teee_d = #()
for s = 1 to 100 do 
(
t = getvalue crv 0 s lookup:false
append teee_d t
)
)
)
----------- End of Direction curve controls


			on delbranch pressed do 
			(
					del_1 = sub_name.count
					del_2 = subb.count/arrnr
					
					deleteitem sub_name del_1
					for de = 0 to arrnr-1 do deleteitem subb (arrnr-de+((del_2-1)*arrnr))
					sub.items = sub_name

			)

			on creasub pressed do
			(
					append subb sides.value
					append subb steps.value
					append subb thickness.value
					append subb length.value
					append subb noise.value
					append subb bend.value
					append subb benddir.value
					append subb amount.value
					append subb bbend.value
					append subb start.value
					append subb twidth.value
					append subb bwidth.value
					append subb anim.value
					append subb noise_size.value
					append subb noise_variation.value
					append subb noise_phase.value
					
					append sub_name ("sub branch " +((subb.count/arrnr) as string))
					sub.items = sub_name

					locker = true
					sides.enabled = true
					steps.enabled = true
					thickness.enabled = true
					length.enabled = true
					noise.enabled = true
					bend.enabled = true
					benddir.enabled = true
					amount.enabled = true
					bbend.enabled = true
					start.enabled = true
					twidth.enabled = true
					bwidth.enabled = true
					anim.enabled = true
					noise_size.enabled = true
					noise_variation.enabled = true
					noise_phase.enabled = true

			)
	
			on sub selected i do
			(
					local subnumber = i
					sub.items = sub_name
					sides.value = subb[1+((i-1)*arrnr)]
					steps.value = subb[2+((i-1)*arrnr)]
					thickness.value = subb[3+((i-1)*arrnr)]
					length.value = subb[4+((i-1)*arrnr)]
					noise.value = subb[5+((i-1)*arrnr)]
					bend.value = subb[6+((i-1)*arrnr)]
					benddir.value = subb[7+((i-1)*arrnr)]
					amount.value = subb[8+((i-1)*arrnr)]
					bbend.value = subb[9+((i-1)*arrnr)]
					start.value = subb[10+((i-1)*arrnr)]
					twidth.value = subb[11+((i-1)*arrnr)]
					bwidth.value = subb[12+((i-1)*arrnr)]
					anim.value = subb[13+((i-1)*arrnr)]
					noise_size.value = subb[14+((i-1)*arrnr)]
					noise_variation.value = subb[15+((i-1)*arrnr)]
					noise_phase.value = subb[16+((i-1)*arrnr)]

			)


					on sides changed val do subb[1+((sub.selection-1)*arrnr)] = sides.value
					on steps changed val do subb[2+((sub.selection-1)*arrnr)] = steps.value
					on thickness changed val do subb[3+((sub.selection-1)*arrnr)] = thickness.value
					on length changed val do subb[4+((sub.selection-1)*arrnr)] = length.value
					on noise changed val do subb[5+((sub.selection-1)*arrnr)] = noise.value
					on bend changed val do subb[6+((sub.selection-1)*arrnr)] = bend.value
					on benddir changed val do subb[7+((sub.selection-1)*arrnr)] = benddir.value
					on amount changed val do subb[8+((sub.selection-1)*arrnr)] = amount.value
					on bbend changed val do subb[9+((sub.selection-1)*arrnr)] = bbend.value
					on start changed val do subb[10+((sub.selection-1)*arrnr)] = start.value
					on twidth changed val do subb[11+((sub.selection-1)*arrnr)] = twidth.value
					on bwidth changed val do subb[12+((sub.selection-1)*arrnr)] = bwidth.value
					on anim changed val do subb[13+((sub.selection-1)*arrnr)] = anim.value
					on noise_size changed val do subb[14+((sub.selection-1)*arrnr)] = noise_size.value
					on noise_variation changed val do subb[15+((sub.selection-1)*arrnr)] = noise_variation.value
					on noise_phase changed val do subb[16+((sub.selection-1)*arrnr)] = noise_phase.value
)


rollout leaf "Leaf" width:162 height:300
(

		dropdownlist leaf_type "Leaf type:" items:#("Single plane","Duoplane")

		dropdownlist sub "Sub branch:" 

		spinner amount "Leaf amount: " range:[0,10000,1] type:#integer fieldwidth:40 enabled:true
		spinner heigth "Range from parent: " range:[0,1000,1] type:#integer fieldwidth:40 enabled:true
		spinner sizew "W Size: " range:[3,300,5] type:#integer fieldwidth:40 enabled:true
		spinner sizeh "L Size: " range:[3,300,5] type:#integer fieldwidth:40 enabled:true
		spinner random "Random size: " range:[0,100,0] fieldwidth:40 enabled:true
		spinner direct "Direction: " range:[0,90,0] type:#integer fieldwidth:40 enabled:true
		spinner rotf "Rotate to Z: " range:[-90,90,0] fieldwidth:40 enabled:true
		spinner rott "Rotate from Z: " range:[-90,90,0] fieldwidth:40 enabled:true
		spinner posaff "Positon scale: " range:[1,10,1] fieldwidth:40 enabled:true



				
			on leaf open do
			(	
					temp = #()
					temp2 = #()
					append temp ("Trunk" as string)
					temp2 = temp + sub_name
					sub.items = temp2
					temp = #()
					temp2 = #()

			)

				on leaf_type selected d do
			(
					leaf_type_l = d
			)			
	
			on sub selected i do
			(

					local subnumber = i
					temp = #()
					temp2 = #()
					append temp ("Trunk" as string)
					temp2 = temp + sub_name
					sub.items = temp2
					temp = #()
					temp2 = #()
					
					if subb_leaf[1+((i-1)*arrnr_leaf)] != undefined then amount.value = subb_leaf[1+((i-1)*arrnr_leaf)] else amount.value = subb_leaf[1+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[2+((i-1)*arrnr_leaf)] != undefined then heigth.value = subb_leaf[2+((i-1)*arrnr_leaf)] else heigth.value = subb_leaf[2+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[3+((i-1)*arrnr_leaf)] != undefined then direct.value = subb_leaf[3+((i-1)*arrnr_leaf)] else direct.value = subb_leaf[3+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[4+((i-1)*arrnr_leaf)] != undefined then sizeh.value = subb_leaf[4+((i-1)*arrnr_leaf)] else sizeh.value = subb_leaf[4+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[5+((i-1)*arrnr_leaf)] != undefined then sizew.value = subb_leaf[5+((i-1)*arrnr_leaf)] else sizew.value = subb_leaf[5+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[6+((i-1)*arrnr_leaf)] != undefined then random.value = subb_leaf[6+((i-1)*arrnr_leaf)] else random.value = subb_leaf[6+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[7+((i-1)*arrnr_leaf)] != undefined then rotf.value = subb_leaf[7+((i-1)*arrnr_leaf)] else rotf.value = subb_leaf[7+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[8+((i-1)*arrnr_leaf)] != undefined then rott.value = subb_leaf[8+((i-1)*arrnr_leaf)] else rott.value = subb_leaf[8+((i-1)*arrnr_leaf)] = 0
					if subb_leaf[9+((i-1)*arrnr_leaf)] != undefined then posaff.value = subb_leaf[9+((i-1)*arrnr_leaf)] else posaff.value = subb_leaf[9+((i-1)*arrnr_leaf)] = 0

			)


					on amount changed val do subb_leaf[1+((sub.selection-1)*arrnr_leaf)] = amount.value
					on heigth changed val do subb_leaf[2+((sub.selection-1)*arrnr_leaf)] = heigth.value
					on direct changed val do subb_leaf[3+((sub.selection-1)*arrnr_leaf)] = direct.value
					on sizew changed val do subb_leaf[4+((sub.selection-1)*arrnr_leaf)] = sizew.value
					on sizeh changed val do subb_leaf[5+((sub.selection-1)*arrnr_leaf)] = sizeh.value
					on random changed val do subb_leaf[6+((sub.selection-1)*arrnr_leaf)] = random.value
					on rotf changed val do subb_leaf[7+((sub.selection-1)*arrnr_leaf)] = rotf.value
					on rott changed val do subb_leaf[8+((sub.selection-1)*arrnr_leaf)] = rott.value
					on posaff changed val do subb_leaf[9+((sub.selection-1)*arrnr_leaf)] = posaff.value

)
	
rollout winds "Winds" width:162 height:300
(
		spinner direction "Direction" range:[0,360,0] type:#integer scale:1 fieldwidth:40
		spinner dir_strengt "Dir strength" range:[0,100,20] type:#integer scale:1 fieldwidth:40
		spinner dir_freq "Dir variation" range:[0,10,1.5] type:#float scale:0.1 fieldwidth:40
		spinner wind_strength "Wind Strength" range:[0,100,20] type:#integer scale:1 fieldwidth:40
		spinner wind_freq "Frequency" range:[0,10,2] type:#float scale:0.1 fieldwidth:40
		spinner min_wind "Min Wind" range:[0,30,10] type:#integer scale:1 fieldwidth:40
		spinner w_dist_freq "Frequency" range:[0,10,2] type:#float scale:0.1 fieldwidth:40
		spinner w_dist_strength "Variation" range:[0,30,10] type:#integer scale:1 fieldwidth:40
		checkbox windon "Apply Wind" checked:false align:#right



)

rollout fileio "File I / O" width:162 height:300
(

		button load "Load tree" width:110 height:21
		button save "Save tree" width:110 height:21


		on load pressed do 
		(
				sFileName = getOpenFileName caption:"Load settings" filename:"*.tre" types:"Tree Maker settings(*.tre)|(*.tre)"
			
				if sFileName == undefined then return false
				
				else 
				
				fInput = openFile sFileName mode:"r"
				
				if fInput == undefined then
				(
						MessageBox ( "Unable to open \"" + sFileName + "\" for input." ) 
						return false
				)
				
				sInput = readLine fInput
				if sInput != "Treetool Data File" then
				(
					 	close fInput
				
						MessageBox ( "\"" + sFileName + "\" didn't appear to contain tree maker data." )
						return false
				)
				
				sInput = readLine fInput
			
				while( not ( eof fInput ) ) do
				(
						sides_trunk				= readvalue fInput
						segs_trunk 				= readvalue fInput
						thickness_trunk 		= readvalue fInput
						length_trunk 			= readvalue fInput
						noise_trunk 			= readvalue fInput
						seed_trunk 				= readvalue fInput
						bend_t	 				= readvalue fInput
						benddir_t	 			= readvalue fInput
						bstart_trunk 			= readvalue fInput
						bstop_trunk 			= readvalue fInput
						taper_trunk 			= readvalue fInput
						memlength 				= readvalue fInput
						membend 				= readvalue fInput
						memdir 					= readvalue fInput
						direction_winds 		= readvalue fInput
						dir_strengt_winds 		= readvalue fInput
						dir_freq_winds 			= readvalue fInput
						wind_strength_winds		= readvalue fInput
						min_wind_winds 			= readvalue fInput
						w_dist_freq_winds		= readvalue fInput
						w_dist_strength_winds 	= readvalue fInput

						c = readvalue fInput
						subb = #()
						for a = 1 to c do append subb (readvalue fInput)

						leaf_type_l = readvalue fInput


						d = readvalue fInput
						subb_leaf = #()
						for a = 1 to d do append subb_leaf (readvalue fInput)

				)
					sub_name = #()
					for sn = 1 to (subb.count/arrnr) do append sub_name ("sub branch " +(sn as string))
					if sub_name.count > 0 do locker = true


				close fInput
				return true	
		)
	
			
		on save pressed do
		(
			
			 	sFileName = getSaveFileName caption:"Save settings" filename:"*.tre" types:"Tree Maker settings(*.tre)|(*.tre)"
			
				if( ( getFileNameType sFileName ) == "" ) then
				sFileName += ".txt"
			
				if( sFileName == undefined ) then
					return false
			
				fOutput = openfile sFileName mode:"w"
				if( fOutput == undefined ) then
			(
					MessageBox ( "Unable to open \"" + sFileName + "\" for output." )
					return false
			)
				
				---version
			
				format "%\n"							"Treetool Data File"		to:fOutput
				format "version %\n"					"0.5." 						to:fOutput
			
				---trunk
			
				format "%\n" sides_trunk	 to:fOutput
				format "%\n" segs_trunk 	 to:fOutput
				format "%\n" thickness_trunk to:fOutput
				format "%\n" length_trunk	 to:fOutput
				format "%\n" noise_trunk	 to:fOutput
				format "%\n" seed_trunk		 to:fOutput
				format "%\n" bend_t			 to:fOutput
				format "%\n" benddir_t		 to:fOutput
				format "%\n" bstart_trunk	 to:fOutput
				format "%\n" bstop_trunk	 to:fOutput
				format "%\n" taper_trunk	 to:fOutput
				format "%\n" memlength		 to:fOutput
				format "%\n" membend		 to:fOutput
				format "%\n" memdir			 to:fOutput
			
				---wind
			
				format "%\n" direction_winds		to:fOutput
				format "%\n" dir_strengt_winds		to:fOutput
				format "%\n" dir_freq_winds			to:fOutput
				format "%\n" wind_strength_winds	to:fOutput
				format "%\n" min_wind_winds			to:fOutput
				format "%\n" w_dist_freq_winds		to:fOutput
				format "%\n" w_dist_strength_winds	to:fOutput
--				format "%\n" windon_wind			to:fOutput
			
				---branches

				format "%\n" subb.count to:fOutput
				for a = 1 to subb.count do format "%\n" subb[a] to:fOutput

				---leafs
			
				format "%\n" leaf_type_l to:fOutput

				format "%\n" subb_leaf.count to:fOutput
				for a = 1 to subb_leaf.count do format "%\n" subb_leaf[a] to:fOutput
			
				flush fOutput
				close fOutput
			
				return true
		)
)

on load do 
(	
		if subb != undefined then
		(
				sub_name = #()
				for sn = 1 to (subb.count/arrnr) do append sub_name ("sub branch " +(sn as string))
				if sub_name.count > 0 do locker = true
		)
		else print "empty tree"
)




on buildMesh do
(
if posit == undefined do posit = [0,0,0]
ang = 360 / sides_trunk
subbranches = #()
subbleaf = #()

	local treeverts = #()
	local facearr = #()
	local matarr = #()
	local placearr =#()
	local leafplacearr =#()
	local leafremember = 0

-------- Wind generation

if windon_wind == true then 
(	
		benddir_trunk = (sin(currenttime  * dir_freq_winds) * dir_strengt_winds) +direction_winds
		bend_trunk = abs (sin (currenttime * wind_freq_winds) * wind_strength_winds) + min_wind_winds + abs (sin(currenttime * w_dist_freq_winds + w_dist_strength_winds))
)

	else 
	
(
		benddir_trunk = benddir_t
		bend_trunk = bend_t
)

-------- Wind generation end

-------- Rearranging arrays bor branches and leafs
	
for a = 1 to subb.count/arrnr do
(	
		temparr = #()
		for fr = 1 to arrnr do append temparr subb[fr+((a-1)*arrnr)]
		append subbranches temparr

)
for a = 1 to subb_leaf.count/arrnr_leaf do
(	
		temparr = #()
		for fr = 1 to arrnr_leaf do append temparr subb_leaf[fr+((a-1)*arrnr_leaf)]
	
		append subbleaf temparr

)

-------- Rearranging arrays bor branches and leafs end

for i = 1 to (segs_trunk + 1) do
(	
		dirscale = i / segs_trunk

		y = length_trunk / segs_trunk * (i-1)

		taper = (((i - 1 - (segs_trunk / 2 as float)) * -1) + segs_trunk / 2 as float) / (segs_trunk-1) as float
		noise =  noise_trunk * sin ((y - y / length_trunk) * seed_trunk)
		noise_x = sin (benddir_trunk * dirscale) * noise-- * (2 * segs_trunk - y) / segs_trunk
		noise_y = cos (benddir_trunk * dirscale) * noise-- * (2 * segs_trunk - y) / segs_trunk
		
		for j = 1 to sides_trunk do
		(



				------ calculates circle shape start ------

				add_x = sin (benddir_trunk * dirscale) * cos (ang * j) * thickness_trunk * taper
				add_y = cos (benddir_trunk * dirscale) * -cos (ang * j) * thickness_trunk * taper

				------ calculates circle shape ends  ------

				------ bend / direction calcs start      ------

				if bend_trunk < 0 or bend_trunk > 0 then r = length_trunk / (noise + bend_trunk) else r = length_trunk / (noise + bend_trunk + 0.1)  				

				x = -sin (ang * j) * thickness_trunk * taper + length_trunk * r


				if r != 0 then yr = y / r else yr = 0

				c  = cos yr
				s  = sin yr


				x_var = cos (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				y_var = sin (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				z_var = (x * s)


--------------

				append treeverts ([x_var + add_x + noise_x,y_var + add_y + noise_y,z_var])

				if i != (segs_trunk + 1) do
				(
						if j != sides_trunk then
						(
								append facearr [j + sides_trunk * (i-1),j + 1 + sides_trunk * (i-1),sides_trunk * i + j]
								append facearr [j + 1 + sides_trunk * (i-1),sides_trunk * i + j + 1,sides_trunk * i + j]
								append matarr 1
								append matarr 1
						)
						else
						(
								append facearr [j + sides_trunk * (i-1),j + sides_trunk * (i-1) - (sides_trunk-1),(1 + i) * sides_trunk]
								append facearr [j + sides_trunk * (i-1) - (sides_trunk-1),j + 1 + sides_trunk * (i-1),(1 + i) * sides_trunk]
								append matarr 1
								append matarr 1
						)
				)
		)
)

--- collects coordinates for branches generation 1

if subbranches[1] != undefined do
(

		for i = 1 to subbranches[1][8] do
		(
				seed i
				y = random bstart_trunk bstop_trunk
				level = ((y / length_trunk) * segs_trunk)
				dirscale = level / segs_trunk

				noise =  noise_trunk * sin ((y - y / length_trunk) * seed_trunk)
				noise_x = sin (benddir_trunk * dirscale) * noise-- * (2 * segs_trunk - y) / segs_trunk
				noise_y = cos (benddir_trunk * dirscale) * noise-- * (2 * segs_trunk - y) / segs_trunk

				if bend_trunk < 0 or bend_trunk > 0 then r = length_trunk / (noise + bend_trunk) else r = length_trunk / (noise + bend_trunk + 0.1)  				

				x = length_trunk * r 

				if r != 0 then yr = y / r else yr = 0

				c  = cos yr
				s  = sin yr

				x_var = cos (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				y_var = sin (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				z_var = (x * s)

				append placearr [x_var + noise_x,y_var + noise_y,z_var]

		)
)


--- collects coordinates for leafs on stem or stem top

if subbleaf[1] != undefined and subbleaf[1] != 0 do
(
		for i = 1 to subbleaf[1][1] do
		(
				seed i
				y = random subbleaf[1][2] length_trunk
				level = ((y / length_trunk) * segs_trunk)
				dirscale = level / segs_trunk

				noise =  noise_trunk * sin ((level - level * sin bend_trunk *  bend_trunk^2 / length_trunk) * seed_trunk)
				noise_x = cos (benddir_trunk * dirscale) * noise
				noise_y = sin (benddir_trunk * dirscale) * noise

				if bend_trunk < 0 or bend_trunk > 0 then r = length_trunk / (noise + bend_trunk) else r = length_trunk / (noise + bend_trunk + 0.1)  				

				x = length_trunk * r 

				if r != 0 then yr = y / r else yr = 0

				c  = cos yr
				s  = sin yr

				x_var = cos (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				y_var = sin (benddir_trunk * dirscale) * (r - x * c - r + length_trunk * r)
				z_var = (x * s)

			append leafplacearr [x_var + noise_y,y_var + noise_x,z_var]

		)
--- leaf algoritm
--- spike trees

for le = 1 to subbleaf[1][1] do
(
			ga = (le * (subbleaf[1][1] + 999)) * 6789
			seed ga
			randir = random 1 360
			h_l = (random (subbleaf[1][4] + (subbleaf[1][6]/100 * subbleaf[1][4])) (subbleaf[1][4] - (subbleaf[1][6]/100 * subbleaf[1][4])))
			w_l = (random (subbleaf[1][5] + (subbleaf[1][6]/100 * subbleaf[1][5])) (subbleaf[1][5] - (subbleaf[1][6]/100 * subbleaf[1][5])))

	local current_numverts = treeverts.count
	for c = 1 to 4 do
	(	
			if c == 1 then affection_xy = 0 else affection_xy = 0.4
			if c == 1 or c == 3 then affection24 = 0 else affection24 = 1
			if c == 2 then affection2 = 1 else affection2 = -1
			if c == 1 then affection_z = 0 else affection_z = 0.5
			if c == 3 then affection_xy = 1
			if c == 3 then affection_z = 2

			x_var = leafplacearr[le][1] + h_l * affection_xy * sin randir + w_l * affection24 * sin (randir + 90) * affection2
			y_var = leafplacearr[le][2] + h_l * affection_xy * cos randir + w_l * affection24 * cos (randir + 90) * affection2			
			z_var =	leafplacearr[le][3]	- (sin (subbleaf[1][3]+115)) * 3 * w_l * affection_z
			
			append treeverts ([x_var,y_var,z_var])
		
	)

	append facearr [current_numverts+4,current_numverts+3,current_numverts+2]
	append facearr [current_numverts+2,current_numverts+1,current_numverts+4]
	append matarr 10
	append matarr 10
)
	
)

local branches = 1
local barr = #()
local angle
local switch
local lastdir = #()
local lastdir1 = #()
local jb_con = 0
local forsta
local sista
local lutning
local forra_x
local forra_y
local forra_z
local lutningsarrbranch = #()


						
for name = 1 to sub_name.count do barr[name] = #()

for i = 1 to sub_name.count do 
(	
		local colection = 0

-------- Wind generation branches 

if windon_wind == true then 
(	
		benddir_trunk = (sin((currenttime + subbranches[i][13]) * dir_freq_winds) * dir_strengt_winds) +direction_winds
		bend_trunk = abs (sin ((currenttime + subbranches[i][13]) * wind_freq_winds) * wind_strength_winds) + min_wind_winds + abs (sin((currenttime + subbranches[i][13]) * w_dist_freq_winds + w_dist_strength_winds))
)

	else 
	
(
		benddir_trunk = benddir_t
		bend_trunk = bend_t
)

-------- Wind generation branches end

		lastdir1 = lastdir
		lastdir = #()
		if i == 1 do local remember = placearr
		for B = 1 to branches do
		(
				if i != 1 do
				(	

						placearr = barr[i]
				)
					
				for j = 1 to subbranches[i][8] do 
				(	
						local arrcount = facearr[facearr.count][3]
						if j == 1 or y == branches do y = 1
						if i == 1 do local jb_con = j 
						if i != 1 do jb_con = b + j * branches - branches
						if i == 2 do jb_con = b + j * subbranches[i-1][8] - subbranches[i-1][8]

						angb = 360 / subbranches[i][1]
												
						if i == 1 do
						(
								switch = 1
								seed (subbranches[i][7] * j * B * i)
								angle = (random 0 360) as float

						)

						if i != 1 do 
						(	
--								if ((j + b)/2) as float == ((j + b)/2) as integer then switch = -1 else switch = 1
--								if i == 3 then if ((j + b)/2) as float == ((j + b)/2) as integer then switch = -1 else switch = 1
								switch = -switch

								seed (subbranches[i][7] * j * B * i)

								seed (subbranches[i][7]* j * B * i)
								angle = lastdir1[jb_con] + 45 * switch-- + random 0 (switch * subbranches[i][9] / 2)

									)
local lutningsarr = #()

			---- Disables functions dealing with scaling furter out on branches for branch gen. 1 ----

			if i == 1 then heigthscaler =  placearr[jb_con][3] / length_trunk else heigthscaler = 1
			if i != 1 then posscale = 1 - placearr[jb_con][4] else posscale = 1

			---- Disables functions dealing with scaling furter out on branches for branch gen. 1 ----
			
			---- Checks distances for getting correct curve values and scaling further out on branch ----			

			dist_from_ground = 	(sqrt (placearr[jb_con][1]^2 + placearr[jb_con][2]^2 + placearr[jb_con][3]^2) / (10 * length_trunk))
			dir_from_branch = cos (angle + subbranches[i][9])  * bend_trunk * dist_from_ground

			---- Checks distances for getting correct curve values and scaling further out on branch ----
			
			---- Gets correct values from the curves ----			
			b_l  =  subbranches[i][4]    * teee_l[((dist_from_ground * 100)) as integer]  * posscale/2
			b_b  = -subbranches[i][6]    * teee_b[((dist_from_ground * 100)) as integer]
			b_d  = -subbranches[i][12]   * teee_d[((dist_from_ground * 100)) as integer] + dir_from_branch
			---- Gets correct values from the curves ----

 			
			noise_variation =	random (1 as float) ((1-(subbranches[i][15]/50)) as float)

	for k = 1 to (subbranches[i][2] + 1) do

	(	

		y = b_l / subbranches[i][2] * (k-1)

		noise =  subbranches[i][5] * noise_variation * sin ((y - y / subbranches[i][4]) * subbranches[i][14])
		noise_x = cos angle * noise
		noise_y = sin angle * noise

			taper = (((k-1-(subbranches[i][2]/2 as float))*-1)+subbranches[i][2]/2 as float)/(subbranches[i][2]-1) as float

		for L = 1 to subbranches[i][1] do

		(	

				------ calculates circle shape start ------

				add_x = sin (angle + subbranches[i][9] * switch) * -cos (angb*L) * subbranches[i][3] * taper * posscale / heigthscaler 
				add_y = cos (angle + subbranches[i][9] * switch) *  cos (angb*L) * subbranches[i][3] * taper * posscale / heigthscaler	

				------ calculates circle shape ends  ------

				------ bend / direction calcs start      ------

				if b_b < 0 or b_b > 0 then r = b_l / (noise + b_b) else r = b_l / (noise + b_b + 0.1)  				

				x = -sin (angb*L) * subbranches[i][3] * taper * posscale / heigthscaler + b_l * r 
--				y = b_l / subbranches[i][2] * (k-1)

				if r != 0 then yr = y / r else yr = 0

				c  = cos (yr + 90 + b_d)
				s  = sin (yr + 90 + b_d)

				x_var = placearr[jb_con][1] + cos (angle + subbranches[i][9] * switch) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				y_var = placearr[jb_con][2] + sin (angle + subbranches[i][9] * switch) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				z_var = placearr[jb_con][3] + ((x * s) - 2 * r * cos b_d * 0.5 * b_l)

				------ bend / direction calcs ends       ------

				append treeverts ([x_var - add_x + noise_y,y_var - add_y + noise_x,z_var])


			if l == 1 do
			(
					if k == 1 do forsta = [x_var,y_var,z_var]
					if k == subbranches[i][2] do sista = [x_var,y_var,z_var]

					if k > 1 do 
					(
							lutning_x = amax #(abs forra_x,abs x_var) - amin #(abs forra_x,abs x_var)
							lutning_y = amax #(abs forra_y,abs y_var) - amin #(abs forra_y,abs y_var)
							lutning_z = amax #(abs forra_z,abs z_var) - amin #(abs forra_z,abs z_var)

							lut = atan (sqrt (lutning_x^2 + lutning_y^2) / lutning_z)

							append lutningsarr ([forra_z,z_var,(90 - lut)])
							for LU = 1 to lutningsarr.count do append lutningsarrbranch lutningsarr[LU]
					)

					forra_x = x_var
					forra_y = y_var
					forra_z = z_var
			)

										if k != (subbranches[i][2] + 1) do
										(
												if l != subbranches[i][1] then
												(	
														arradd1 = [(L + subbranches[i][1] * (k-1)) + arrcount,L + 1 + subbranches[i][1] * (k-1) + arrcount,(subbranches[i][1] * k + L) + arrcount]
														arradd2 = [(L + 1 + subbranches[i][1] * (k-1)) + arrcount,(subbranches[i][1] * k + L + 1) + arrcount,(subbranches[i][1] * k + L) + arrcount]

														append facearr arradd1
														append facearr arradd2

														append matarr (i+1)
														append matarr (i+1)
												)
												else
												(
														local arradd1 = [L + subbranches[i][1] * (k-1) + arrcount,L + subbranches[i][1] * (k-1) - (subbranches[i][1]-1) + arrcount,((1 + k) * subbranches[i][1]) + arrcount]
														local arradd2 = [L + subbranches[i][1] * (k-1) - subbranches[i][1] - 1 + arrcount+2,L + 1 + subbranches[i][1] * (k-1) + arrcount,((1 + k) * subbranches[i][1]) + arrcount]

														append facearr arradd1
														append facearr arradd2
														append matarr (i+1)
														append matarr (i+1)
												)

										)
											
			)


	)

--- startpositions for next generation branches 

if subbranches[i+1] != undefined do

(
		--- starting point for nextgen scaling ---
			
			b_ls = subbranches[i+1][10] * teee_d[((dist_from_ground * 100)) as integer]
			b_lst = subbranches[i+1][11] * teee_d[((dist_from_ground * 100)) as integer]

		--- starting point for nextgen scaling ---

		for n = 1 to (subbranches[i+1][8]) do 

		(
--print subbranches[i][9]

				seed (n*subbranches[i+1][7])
				y =  random b_ls b_lst

				noise =  subbranches[i][5] * noise_variation * sin ((y - y / subbranches[i][4]) * subbranches[i][14])
				noise_x = cos angle * noise
				noise_y = sin angle * noise
 

				if b_b < 0 or b_b > 0 then r = b_l / (noise + b_b) else r = b_l / (noise + b_b + 0.1)

				x = b_l * r 

				if r != 0 then yr = y / r else yr = 0

				c  = cos (yr + 90 + b_d)
				s  = sin (yr + 90 + b_d)

--if i==2 then third = switch else third = 1

				x_var = placearr[jb_con][1] + cos (angle + subbranches[i][9] * switch) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				y_var = placearr[jb_con][2] + sin (angle + subbranches[i][9] * switch) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				z_var = placearr[jb_con][3] + ((x * s) - 2 * r * cos b_d * 0.5 * b_l)

				nexttaper = ((distance [placearr[jb_con][1],placearr[jb_con][2],placearr[jb_con][3]] [x_var,y_var,z_var] / subbranches[i][4])) 
				
--				if (n/2) as integer != (n/2) as float then switch = 1 else switch = -1

				append barr[i+1] #(x_var + noise_y,y_var + noise_x,z_var,nexttaper,switch)
									
				append lastdir (angle + subbranches[i][9])

									
		)
									
)
							
--- startpositions for next generation branches ends

					
---- leaf generation

antalperkvist = (SQRT ((abs sista[1] - abs forsta[1])^2 + (abs sista[2] - abs forsta[2])^2 + (abs sista[3] - abs forsta[3])^2)) / (subbranches[i][4] * 10)
--print subbleaf[i+1][2]
if subbleaf[i+1] != undefined and subbleaf[i+1][1] != 0 do

(

		--- starting point for thisgen leafs scaling ---
			
			b_ls = subbleaf[i+1][2] * teee_d[((placearr[jb_con][3]/length_trunk)*100) as integer]

		--- starting point for thisgen leafs scaling ---

		leafremember = leafplacearr.count
		for n = 1 to (subbleaf[i+1][1] * antalperkvist) as integer  do 

		(
				y = random b_ls  subbleaf[i+1][6]
				level = ((y / length_trunk) * segs_trunk)

				noise =  subbranches[i][5] * noise_variation * sin ((y - y / subbranches[i][4]) * subbranches[i][14])
				noise_x = cos angle * noise
				noise_y = sin angle * noise
			
				if b_b < 0 or b_b > 0 then r = b_l / (noise + b_b) else r = b_l / (noise + b_b + 0.1)  				

				x = b_l * r 

				if r != 0 then yr = y / r else yr = 0

				c  = cos (yr + 90 + b_d)
				s  = sin (yr + 90 + b_d)

				x_var = placearr[jb_con][1] + cos (angle + subbranches[i][9]) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				y_var = placearr[jb_con][2] + sin (angle + subbranches[i][9]) * ((r - x * c) - r - 2 * r * sin b_d * 0.5 * b_l)
				z_var = placearr[jb_con][3] + ((x * s) - 2 * r * cos b_d * 0.5 * b_l)
			
			
				append leafplacearr [x_var + noise_y,y_var + noise_x,z_var]

		)
	
--- end of leaf startpoints


antalperkvist = (SQRT ((abs sista[1] - abs forsta[1])^2 + (abs sista[2] - abs forsta[2])^2 + (abs sista[3] - abs forsta[3])^2)) / (subbranches[i][4] * 10)

for le = 1 to (subbleaf[i+1][1] * antalperkvist) as integer do

(
			randir = random subbleaf[i+1][7] subbleaf[i+1][8]

			hscale = 1 - (le / (subbleaf[i+1][1] * antalperkvist)) / subbleaf[i+1][9]
			if hscale < 0 or hscale > 1 do hscale = 1

			h_l = hscale * (random (subbleaf[i+1][4] + (subbleaf[i+1][6]/100 * subbleaf[i+1][4])) (subbleaf[i+1][4] - (subbleaf[i+1][6]/100 * subbleaf[i+1][4])))
			w_l = hscale * (random (subbleaf[i+1][5] + (subbleaf[i+1][6]/100 * subbleaf[i+1][5])) (subbleaf[i+1][5] - (subbleaf[i+1][6]/100 * subbleaf[i+1][5])))

			if ((le / 2)as integer * 2) != le then sidepl = 1 else sidepl = -1

	local current_numverts = treeverts.count
	next = #()

local lutning

for r = 1 to lutningsarr.count do 
(


if leafplacearr[le + leafremember][3] >= amin #(lutningsarr[r][1],lutningsarr[r][2]) \
and leafplacearr[le + leafremember][3] <= amax #(lutningsarr[r][1],lutningsarr[r][2]) do 

(
if  lutningsarr[r][1] > lutningsarr[r][2] then lutning = lutningsarr[r][3] * -1 else lutning = lutningsarr[r][3]

r = lutningsarr.count

)
)

if lutning == undefined do lutning = 0

	local direction = subbleaf[i+1][3] * cos lutning
	local randir = randir + lutning * sin subbleaf[i+1][3]
	
	for c = 1 to 4 do
	(	
			if c == 1 then affection_xy = 0 else affection_xy = 0.5
			if c == 3 then affection_xy = 1
			if c == 1 or c == 3 then affection24 = 0 else affection24 = 1
			if c == 2 then affection2 = -1 else affection2 = 1


			x_var_part_1 = leafplacearr[le + leafremember][1] + sidepl * w_l * hscale * affection_xy * -sin angle
			x_var_part_2 =           cos angle * cos (direction + 90) * w_l * affection_xy
			x_var_part_3 = -sidepl * sin angle * cos (direction + 90) * w_l * affection_xy
			x_var_part_4 = -sidepl * affection24 * affection2 * sin angle * cos (direction + 90) * h_l		
			x_var_part_5 =  sidepl * affection24 * affection2 * cos angle * sin (direction + 90) * h_l
			
			y_var_part_1 = leafplacearr[le + leafremember][2] + sidepl * w_l * hscale * affection_xy * cos angle
			y_var_part_2 =          sin angle * cos (direction + 90) * w_l * affection_xy
			y_var_part_3 = sidepl * cos angle * cos (direction + 90) * w_l * affection_xy
			y_var_part_4 = sidepl * affection24 * affection2 * cos angle * cos (direction + 90) * h_l
			y_var_part_5 = sidepl * affection24 * affection2 * sin angle * sin (direction + 90) * h_l

			z_var_part_1 = leafplacearr[le + leafremember][3]

			x_var_comp = x_var_part_1 - x_var_part_2 + x_var_part_3 + sidepl * x_var_part_4 + x_var_part_5
			y_var_comp = y_var_part_1 - y_var_part_2 + y_var_part_3 + sidepl * y_var_part_4 + y_var_part_5
			z_var_comp = z_var_part_1 

			z_var_part_2 = sin randir * w_l * affection_xy
			z_var_part_3 = abs (cos randir) * w_l * affection_xy
			
			x_var = x_var_comp + z_var_part_3 * sin angle * -sidepl
			y_var = y_var_comp + z_var_part_3 * -cos angle * -sidepl
			z_var = z_var_comp + z_var_part_2
			
			append treeverts ([x_var,y_var,z_var])

if leaf_type_l != 1 do 
(
	
	if c == 1 or c == 3 then 
	(
			append next treeverts[treeverts.count]
	)
	else 	
	(
			x_var =  x_var_part_1 - x_var_part_2 + x_var_part_3 - z_var_part_3 * sin angle * sidepl
			y_var =  y_var_part_1 - y_var_part_2 + y_var_part_3 - z_var_part_3 * -cos angle * sidepl
			z_var = z_var_part_1 - sqrt (x_var_part_4^2 + y_var_part_4^2) * affection2 - sqrt (x_var_part_5^2 + y_var_part_5^2) * affection2 + z_var_part_2

			append next ([x_var,y_var,z_var])

	)
)		
)

			append facearr [current_numverts+4,current_numverts+3,current_numverts+2]
			append facearr [current_numverts+2,current_numverts+1,current_numverts+4]
		
					append matarr 10
					append matarr 10

					


--- for duoplanes

if leaf_type_l != 1 do
(
		for q = 1 to 4 do append treeverts next[q]

			append facearr [current_numverts+8,current_numverts+7,current_numverts+6]
			append facearr [current_numverts+6,current_numverts+5,current_numverts+8]
				
					append matarr 10
					append matarr 10
)

--- duoplanes end

)		

--- end of leaf creation
							
)

--- end of leaf generation

colection += 1
					

				)
		)
branches = colection
)

setmesh mesh vertices:treeverts faces:facearr materialids:matarr

)

tool create
(
		on mousePoint click do
		case click of 
		(
				1: 
				(
					local posit = gridpoint
					nodeTM.translation = gridpoint
					local subbranches = #()
				)
				2: #stop
		)		
)

)-- EOS