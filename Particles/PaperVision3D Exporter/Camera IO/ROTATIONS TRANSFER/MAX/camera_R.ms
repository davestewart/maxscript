----IMPORT FROM MAYA MAX LW
----EXPORT TO   MAYA MAX
----ROT ORDER FIXED


global FileName
global ExistingCamera

---- CAMERA IMPORT FUNCTON ----
-------------------------------------------------------------------------------------------------------------------------

fn CameraAnimationImport FileName =
(
local rord =#("xyz","xzy","yzx","yxz","zxy","zyx")
	
ofl = openFile FileName
local fileid = readDelimitedString ofl " "					----------------------reading cRio
local CameraName = readDelimitedString ofl " "			----------------------CameraName
local ticspf = (4800/readvalue ofl) as float				----------------------FramesPerSecond
local Rwidth = readvalue ofl as integer							----------------------RendImg width PIX
local Rheigth = readvalue ofl as integer						----------------------RendgImgHeigth PIX
local Rasp = readvalue ofl as float									----------------------RendImgeAspectRatio
local Rpa =  readvalue ofl as float									----------------------PixAspectRatio
local HorApert = readvalue ofl *25.4 as float				----------------------ApertWidth IN
local VerApert = readvalue ofl *25.4 as float				----------------------ApertHeight IN
local FinUnits =readvalue ofl												----------------------Position Units STRING
local FinUpAxis =readDelimitedString ofl " "				----------------------UP Axis STRING
local Softw =readDelimitedString ofl " "						----------------------SOFTWARE   rot order
local mul= units.decodeValue "1m" as float
mul=mul*FinUnits




-------------------Set Values----------------------------
CameraName = uniquename CameraName
renderPixelAspect = Rpa
renderWidth = Rwidth
renderHeight = Rheigth
setRendApertureWidth HorApert
ticksPerFrame = ticspf

------------------CAMERA CREATION
local c=freecamera name:CameraName wirecolor:(color 112 255 0) selected:on   ----CREATE CAMERA
------------------HELPER CREATION

do
(
	f=readvalue ofl as time					----------------------Frame Number
	px=(readvalue ofl *mul) as float----------------------Position X
	py=(readvalue ofl *mul) as float----------------------Position Y
	pz=(readvalue ofl *mul) as float----------------------Position Z
	
	rx=(readvalue ofl) as float----------------------Rotation X
	ry=(readvalue ofl) as float----------------------Rotation Y
	rz=(readvalue ofl) as float----------------------Rotation Z
	
	lens=readvalue ofl as float	----------------------Lens  MILIMETERS
	hfov=readvalue ofl as float	----------------------Horizontal FOV DEG
	vfov=readvalue ofl as float	----------------------Vertical FOV DEG

---at time f c.fov = hfov		--match FilmGate

c.rotation.controller = Euler_XYZ()
c.rotation.controller.axisorder=(findItem rord Softw)

with animate on
(
	----CAMERA
	at time f c.pos.controller.x_position = px
	at time f c.pos.controller.y_position = py
	at time f c.pos.controller.z_position = pz

	at time f c.rotation.controller.x_rotation = rx
	at time f c.rotation.controller.y_rotation = ry
	at time f c.rotation.controller.z_rotation = rz
	
	
	
	at time f c.fov = (2.0*atan(HorApert/(2.0*lens)))
)
)
while not eof ofl
close ofl

----- Y to Z
if FinUpAxis =="y" then 
	(
			-----Y UP to Z UP	
			pp=Point pos:[0,0,0] name: (CameraName+"_Yup->Zup")
			c.parent = pp
			pp.rotation=(quat 0.707107 0 0 0.707107)
	)
)

-------------------------------------------------------------------------------------------------------------------------
---- CAMERA EXPORT FUNCTON ----
-------------------------------------------------------------------------------------------------------------------------
fn CameraAnimationExporter FileName ExistingCamera sf ef stepf =
( 
rord =#("xyz","xzy","yzx","yxz","zxy","zyx")
local mul= units.decodeValue "1m" as float
mul=1/mul
local renderAperture=GetRendApertureWidth()						---ApertureWidth
local r_aspect=((renderWidth as float)/(renderHeight as float))*renderPixelAspect	---RenderAspectRatio
local ofl = createfile (FileName)
local td="ExistingCamera.baseObject.targetDistance"
local d
local named=""
d=FilterString (ExistingCamera.name) " "
-----ROT ORDER EXTRACT

try 
(
rotorder = ExistingCamera.rotation.controller.axisorder
)
catch
(
rotorder=1
)


for i = 1 to d.count do named = named+d[i]
----------------------------------------------
format "% " ("cRio") to:ofl							----fileid
format "% " (named) to:ofl							----CameraName
format "% " (4800/ticksPerFrame) to:ofl						----FramesPerSecond
format "% " (renderWidth) to:ofl						----RendImg width PIX
format "% " (renderHeight) to:ofl 						----RendgImgHeigth PIX
format "% " (r_aspect) to:ofl							----RendImgeAspectRatio
format "% " (RenderPixelAspect) to:ofl						----PixAspectRatio 
format "% " (renderAperture/25.4) to:ofl					----ApertWidth IN
format "% " ((renderAperture/r_aspect)/25.4) to:ofl 				----ApertHeight IN 
format "% " (mul) to:ofl							----Position Units STRING 
format "% " ("z") to:ofl							----UP Axis STRING
format "% " (rord[rotorder]) to:ofl							----SOFTWARE    rot order
format "\n" to:ofl

---------------------------------------------

------BAKE ANIM
local tmpobj=point()
tmpobj.rotation.controller.axisorder = rotorder

local f = 0.0f as time
with animate on
(
for f= sf to ef by stepf do 
(
	at time f tmpobj.transform = at time f ExistingCamera.transform
)
)
----END BAKE
for f= sf to ef by stepf do
(
	local p = at time f tmpobj.transform.position
			
	local rx = at time f in coordsys #gimbal tmpobj.rotation.x_rotation
	local ry = at time f in coordsys #gimbal tmpobj.rotation.y_rotation
	local rz = at time f in coordsys #gimbal tmpobj.rotation.z_rotation
	
	local Hfov=at time f ExistingCamera.fov	
	local Lens=renderAperture/(2*tan( Hfov /2))
	local targDist=at time f execute td
	format "% " (f) to:ofl								---CURENT FRAME
	format "% " (p.x) to:ofl									---POS X
	format "% " (p.y) to:ofl									---POS Y
	format "% " (p.z) to:ofl									---POS Z
	
	format "% " (rx) to:ofl									---ROT X
	format "% " (ry) to:ofl									---ROT Y
	format "% " (rz) to:ofl									---ROT Z

	format "% " Lens to:ofl										---LENS
	format "% " Hfov to:ofl										---HFOV
	format "% " (2.0*atan(tan(Hfov/2.0)/r_aspect)) to:ofl		---VFOV
	format "\n" to:ofl
)
delete tmpobj
close ofl
)

-------------------------------------------------------------------------------------------------------------------------
---FiilterFunctionForCamerasOnly
-------------------------------------------------------------------------------------------------------------------------
fn camera_filter obj= 
(
local type =classOf obj
if type == freecamera or type ==targetCamera then true
)
-------------------------------------------------------------------------------------------------------------------------
---EXPORT INTERFACE--
-------------------------------------------------------------------------------------------------------------------------
Rollout CameraExport "Camera Exporter" 
(	
	spinner stf "Start Frame" width:105 height:16 enabled:true range:[animationrange.start,animationrange.end,animationrange.start]type:#integer scale:1
	spinner enf "End Frame " width:105 height:16 enabled:true range:[animationrange.start,animationrange.end,animationrange.end] type:#integer scale:1
	spinner stp "Step Frame " width:105 height:16 enabled:true range:[0.0000001,1000,1] type:#float scale:1
	pickButton pickCamera "Pick Camera"  width:135 height:21 filter:camera_filter
	button FilePick "Select File" width:135 height:21 enabled:false
	button Export "EXPORT" width:135 height:21 enabled:false
		
	on FilePick pressed  do
	(
		FileName = getSaveFileName caption:"Select Camera Motion File" filename:"CameraOut.txt"
		if FileName != undefined do
		(
		FilePick.text = FileName
		Export.enabled=true
		)
	)
	
	on pickCamera picked obj do
	(
		if obj !="" do
		(
		pickCamera.text = obj.name
		ExistingCamera=obj
		FilePick.enabled=true
		)
	)
	
	on Export pressed  do
	(
	CameraAnimationExporter FileName ExistingCamera CameraExport.stf.value CameraExport.enf.value CameraExport.stp.value
	)

)
-------------------------------------------------------------------------------------------------------------------------
---IMPORT INTERFACE---
-------------------------------------------------------------------------------------------------------------------------
Rollout CameraImport "Camera Importer"
(
	button FilePick "Pick File" width:135 height:21
	button Import "IMPORT" width:135 height:21 enabled:false
	on FilePick pressed  do
	(
		FileName = getOpenFileName caption:"Select Camera Motion File" filename:"CameraOut.txt"
		if FileName != undefined do
		(
			FilePick.text = FileName
			Import.enabled=true;
		)
	)

	on Import pressed  do
	(
		CameraAnimationImport FileName
	)
)

-------------------------------------------------------------------------------------------------------------------------
---Info----
-------------------------------------------------------------------------------------------------------------------------
Rollout AboutIt "About" 
(
	Label LabelVersion "Version: 1.0 R" align:#center
	Label LabelAuthor "Author: Evil Kornholio" align:#center
	Label Labelmail "gasmasocet@abv.bg" align:#center
)	
-------------------------------------------------------------------------------------------------------------------------
---CraetingInterface---
-------------------------------------------------------------------------------------------------------------------------
if Cameraio != undefined do closeRolloutFloater Cameraio

Cameraio = NewRolloutFloater "Camera i/o" 160 250
AddRollout CameraExport Cameraio rolledUp:on
AddRollout CameraImport Cameraio rolledUp:on
AddRollout AboutIt Cameraio rolledUp:on
-------------------------------------------------------------------------------------------------------------------------
