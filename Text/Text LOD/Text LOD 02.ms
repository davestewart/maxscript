caLod = attributes "Level Of Detail"
	(
	
	local ckbLod
	local nodeHi
	local nodeLo
	local arrNodes
	
	function test =
		(
		print "test called"
		)
	
	parameters main rollout:params
		(
		lowres type:#boolean ui:ckbLod default:false animatable:false
		nodeHiName type:#string
		nodeLoName type:#string
		nodeGroupHead type:#node
		)
	
	rollout params "Level of Detail" width:168 height:136
	(
	
		checkbutton ckbLod "High Detail" pos:[8,8] width:152 height:16 -- pos:[8,72]
		GroupBox grpUtilities "Utilities" pos:[8,32] width:152 height:52
		button btnUnhide "Unhide" pos:[16,56] width:68 height:16 across:2
		button btnUngroup "Break apart" pos:[84,56] width:68 height:16 -- pos:[8,72]
		
		function getLodNodes =
			(
			nodeHi	= getNodeByName nodeHiName
			nodeLo	= getNodeByName nodeLoName
			arrNodes = #(nodeHi,nodeLo)
			)
		
		function unhideLodNodes =
			(
			getLodNodes ()
			if isvalidnode nodeHi then nodeHi.ishidden = false
			if isvalidnode nodeLo then nodeLo.ishidden = false
			)
			
		function setLod state =
			(
			getLodNodes ()
			if isvalidnode nodeHi then nodeHi.ishidden = state
			if isvalidnode nodeLo then nodeLo.ishidden = NOT state
			
			ckbLod.text = if state then "Low Detail" else "High Detail"
			)
	
		on ckbLod changed state do
			(
			setLod state
			)
			
		on btnUnhide pressed do unhideLodNodes ()
		
		on btnUngroup pressed do
			(
			unhideLodNodes()
			ungroup nodeGroupHead
			local mIndex
			if isvalidnode nodeHi then
				(
				for m in nodeHi.modifiers do if m.name == "Level of Detail" then deletemodifier nodeHi m
				)
			if isvalidnode nodeLo then
				(
				for m in nodeLo.modifiers do if m.name == "Level of Detail" then deletemodifier nodeLo m
				)
			)
		
		)
	)

/*
for obj in gp do (if (superclassof obj == GeometryClass) then setProperty obj.modifiers[1] #nodeLo $[3].name)
for obj in gp do (if (superclassof obj == GeometryClass) then setProperty obj.modifiers[1] #nodeHi $[1].name)


getproperty $[1].modifiers[1] #nodeHi
*/
function addLod =
	(
	local nodeHi, nodeLo, gp, mod, ca
	local arr = getCurrentSelection()
	
	if arr.count != 2 then
		(
		messagebox "The LOD utility requires 2 objects to be selected."
		return false
		)
	if (getnumverts (snapshotasmesh arr[1])) > (getnumverts (snapshotasmesh arr[2])) then
		(
		nodeHi = arr[1]
		nodeLo = arr[2]
		)
	else
		(
		nodeHi = arr[2]
		nodeLo = arr[1]
		)
		
	
	gp		= group arr prefix:"LOD Group "
	addmodifier arr (EmptyModifier name:"Level of Detail")
	mod		= arr[1].modifiers
	custAttributes.add mod caLod

	setProperty mod #nodeLoName nodeLo.name
	setProperty mod #nodeHiName nodeHi.name
	setProperty mod #nodeGroupHead gp
	
	select gp
	
	nodeLo.isHidden = true
	)
	
addLod ()

/*
showinterfaces LOD
getnumverts (snapshotasmesh $)

group $ prefix:"text group "

for obj in $ do print obj

classof $
setProperty $.modifiers[1] #nodeLo "dave"

ungroup $

addLod()
sel = $

sel = getcurrentselection()

classof sel

-- add to object
--	custAttributes.delete $ 1
	custAttributes.add $.modifiers[1] caLod
--	ca = custAttributes.get $ 1

ca	
-- set properties
	$.baseobject.order = 0
	
	
-- see if definition is applied to an existing object
	fn objectHasCaDef obj defName =
		(
		if classof defName == String then defName = defName as name
		caDefs = for ca in (custAttributes.getDefs obj) collect ca.name
		return (finditem caDefs defName) != 0
		)
	

	objectHasCaDef $ #cameraAnimationParameters

unhide objects


function addCaToCamera obj =
	(
	-- material
		if num == 0 then matName = "Black - " + obj.name
		else matName = "Black - " + num as string
		obj.material = standardmaterial diffusecolor:black name:matName selfIllumAmount:100
	-- modifier
		if classof obj.modifiers[1] != EmptyModifier then addmodifier obj (EmptyModifier())
		mod = obj.modifiers[#Attribute_Holder]
	-- custom attributes
		custAttributes.add mod caBrightness
	-- wiring
		paramWire.connect mod.brightness[#brightness] obj.material[#Shader_Basic_Parameters][#Diffuse_Color] "white * brightness / 255"
		paramWire.connect mod.brightness[#brightness] obj.material[#Extended_Parameters][#opacity] "(0.4 * brightness) + 0.60"
	)
	
delete objects
for obj in (getcurrentselection()) do
	(
	createAndConnectMaterial obj
	)

select $text*

custAttributes.add $.modifiers[1] caBrightness 

for obj in $text* do obj.material.name = "black - " + obj.name


-- delete material modifiers
for obj in geometry do if classof obj.modifiers[1] == MaterialModifier AND obj.modifiers[1].materialID == 2 then deletemodifier obj 1


for obj in $ do if classof obj.modifiers[1] == MaterialModifier then deletemodifier obj 1
*/