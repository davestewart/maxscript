global FileName
global ExistingCamera

---- CAMERA IMPORT FUNCTON ----
-------------------------------------------------------------------------------------------------------------------------
fn CameraAnimationImport FileName =
(
	
ad=dummy() --name:"AimD"
ud=dummy() --name:"UpD"
	
	
ofl = openFile FileName
local fileid = readDelimitedString ofl " "					----------------------reading cio
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
local Softw =readDelimitedString ofl " "						----------------------SOFTWARE
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

c.rotation.controller = LookAt_Constraint upnode_world:off pickUpNode:ud upnode_ctrl:0 target_axis:2 upnode_axis:1 StoUP_axis:1 target_axisFlip:on
c.rotation.controller.appendTarget ad 100

with animate on do
(
	f=readvalue ofl as time					----------------------Frame Number
	px=(readvalue ofl *mul) as float----------------------Position X
	py=(readvalue ofl *mul) as float----------------------Position Y
	pz=(readvalue ofl *mul) as float----------------------Position Z
	
	dax=(readvalue ofl *mul) as float----------------------Position X
	day=(readvalue ofl *mul) as float----------------------Position Y
	daz=(readvalue ofl *mul) as float----------------------Position Z
	
	dux=(readvalue ofl *mul) as float----------------------Position X
	duy=(readvalue ofl *mul) as float----------------------Position Y
	duz=(readvalue ofl *mul) as float----------------------Position Z

	lens=readvalue ofl as float	----------------------Lens  MILIMETERS
	hfov=readvalue ofl as float	----------------------Horizontal FOV DEG
	vfov=readvalue ofl as float	----------------------Vertical FOV DEG

---at time f c.fov = hfov		--match FilmGate
	
	at time f c.fov = (2.0*atan(HorApert/(2.0*lens)))	--match ResGate
	
	if FinUpAxis =="y" then 
(
-----Y UP to Z UP		
	at time f ad.position = [dax,daz,day]
	at time f ud.position = [dux,duz,duy]
	at time f pd.position = [px,pz,py]
)
	else
(
	-----NO CHANGE
	at time f ad.position = [dax,day,daz]
	at time f ud.position = [dux,duy,duz]
	at time f c.position = [px,py,pz]
)
)
while not eof ofl
close ofl

)

-------------------------------------------------------------------------------------------------------------------------
---- CAMERA EXPORT FUNCTON ----
-------------------------------------------------------------------------------------------------------------------------
fn CameraAnimationExporter FileName ExistingCamera sf ef =
( 
local mul= units.decodeValue "1m" as float
mul=1/mul
local renderAperture=GetRendApertureWidth()						---ApertureWidth
local r_aspect=((renderWidth as float)/(renderHeight as float))*renderPixelAspect	---RenderAspectRatio
local ofl = createfile (FileName)
local td="ExistingCamera.baseObject.targetDistance"
local d
local named=""
d=FilterString (ExistingCamera.name) " "
---------------------------CREATE HELPERS, LINK AND OFFSET
ad = dummy() --name:"AimD"
ud = dummy() --name:"UpD"

ud.transform=ad.transform=ExistingCamera.transform
ad.parent = ExistingCamera
ud.parent = ExistingCamera
in coordsys local move ud [0,100,0]
in coordsys local move ad [0,0,-100]

for i = 1 to d.count do named = named+d[i]
----------------------------------------------
format "% " ("cio") to:ofl							----fileid
format "% " (named) to:ofl							----CameraName
format "% " (4800/ticksPerFrame) to:ofl						----FramesPerSecond
format "% " (renderWidth) to:ofl						----RendImg width PIX
format "% " (renderHeight) to:ofl 						----RendgImgHeigth PIX
format "% " (r_aspect) to:ofl							----RendImgeAspectRatio
format "% " (RenderPixelAspect) to:ofl						----PixAspectRatio 
format "% " (renderAperture/25.4) to:ofl					----ApertWidth IN
format "% " ((renderAperture/r_aspect)/25.4) to:ofl 				----ApertHeight IN 
format "% " (mul) to:ofl							----Position Units STRING 
format "% " ("y") to:ofl							----UP Axis STRING
format "% " ("MX ") to:ofl							----SOFTWARE
format "\n" to:ofl

---------------------------------------------
for f= sf to ef do
(
	local p = at time f ExistingCamera.transform.position
	local adp = at time f ad.transform.position
	local udp = at time f ud.transform.position
	
	local Hfov=at time f ExistingCamera.fov	
	local Lens=renderAperture/(2*tan( Hfov /2))
	local targDist=at time f execute td
	format "% " (int(f)) to:ofl								---CURENT FRAME
	format "% " (p.x) to:ofl									---POS X
	format "% " (p.z) to:ofl									---POS Y
	format "% " (p.y) to:ofl									---POS Z

	format "% " (adp.x) to:ofl									---POS X
	format "% " (adp.z) to:ofl									---POS Y
	format "% " (adp.y) to:ofl									---POS Z
	
	format "% " (udp.x) to:ofl									---POS X
	format "% " (udp.z) to:ofl									---POS Y
	format "% " (udp.y) to:ofl									---POS Z
	
	format "% " Lens to:ofl										---LENS
	format "% " Hfov to:ofl										---HFOV
	format "% " (2.0*atan(tan(Hfov/2.0)/r_aspect)) to:ofl		---VFOV
	format "\n" to:ofl
)

close ofl
select  ad
max delete
select ud
max delete

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
	CameraAnimationExporter FileName ExistingCamera CameraExport.stf.value CameraExport.enf.value
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
	Label LabelVersion "Version: 1.0 Constrain" align:#center
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
AddRollout AboutIt Cameraio rolledUp:off
-------------------------------------------------------------------------------------------------------------------------
