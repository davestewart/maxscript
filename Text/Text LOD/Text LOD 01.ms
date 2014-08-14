caLod = attributes "Level Of Detail"
(
	
	local ckbLod
	
	parameters main rollout:params
	(
		lowres type:#boolean ui:ckbLod default:false animatable:false
		nodeHi type:#node
		nodeLo type:#node
	)
	
	rollout params "Camera animation" width:168 height:136
(
	
		checkbutton ckbLod "High Detail" width:152 height:16 -- pos:[8,72]
		
		function setLod state =
		(
			if isvalidnode nodeHi then if state then hide nodeHi else unhide nodeLo
			if isvalidnode nodeLo then if state then unhide nodeLo else show nodeHi
			
			ckbLod.text = if state then "Low Detail" else "High Detail"
		)
	
		on ckbLod changed state do
		(
			setLod state
		)
	)
)


function addLod =
(
	local nodeHi
	local nodeLo
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
		
	group arr prefix:"LOD Group "
)


getnumverts (snapshotasmesh $)

group $ prefix:"text group "

for obj in $ do print obj

classof $

ungroup $

addLod()
sel = $

sel = getcurrentselection()

classof sel

-- add to object
--	custAttributes.delete $ 1
	ca = custAttributes.add $ caLod
--	ca = custAttributes.get $ 1

	
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

/*	
custAttributes.add $ caBrightness 
paramWire.connect $.baseObject.brightness[#brightness] $.material[#Shader_Basic_Parameters][#Diffuse_Color] "white * brightness / 255"

custAttributes.delete $ 1

$.brightness = 1
*/
custAttributes.add $.modifiers[1] caBrightness 

for obj in $text* do obj.material.name = "black - " + obj.name


-- delete material modifiers
for obj in geometry do if classof obj.modifiers[1] == MaterialModifier AND obj.modifiers[1].materialID == 2 then deletemodifier obj 1


for obj in $ do if classof obj.modifiers[1] == MaterialModifier then deletemodifier obj 1
