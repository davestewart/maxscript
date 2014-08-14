generic
{
info("Hide everything in the scene before export to avoid inaccuracy !");
ciowindow();
}

ciowindow
{
scene = Scene();
frame = 0;
startanim= scene.previewstart;
endanim= scene.previewend;
stepanim=scene.previewstep;
EditObjects();
reqbegin("Camera i/o");
reqsize(275,200);
c0 = ctltab("Camera Export","Camera Import","About");
        
        c1 = ctlnumber("Start Frame",startanim);
        c2 = ctlnumber("End Frame",endanim);
        c3 = ctlnumber("Step ",1.0);
        c4 = ctlcameraitems("Select Camera:");
       	c5 = ctlfilename("Select Camera file", "D:/CameraOut.txt",33,0);
				
       	c7=ctltext("","");
				c8 = ctlfilename("Select Camera file", "D:/CameraOut.txt",33,1);

				c6=ctltext("","Version: 1.0 Constrain","Author: Evil Kornholio","gasmasocet@abv.bg");

				ctlposition(c1, 3, 30, 235, 20,100);
				ctlposition(c2, 3, 55, 235, 20,100);
				ctlposition(c3, 3, 80, 235, 20,100);
				ctlposition(c4, 3,105, 235, 20,100);
				ctlposition(c5, 3,130, 235, 20,100);
				ctlposition(c6,80, 30, 235, 20,100);
				ctlposition(c7,80, 55, 235, 20,100);
				ctlposition(c8, 3, 30, 235, 20,100);
       	
       	ctlpage(1,c1,c2,c3,c4,c5);
       	ctlpage(2,c7,c8);
       	ctlpage(3,c6);
		
		if(reqpost())
		{
          chc=getvalue(c0);
     			if (chc==1) CamExport(getvalue(c1),getvalue(c2),getvalue(c3),getvalue(c4),getvalue(c5));
     			if (chc==2) CamImport(getvalue(c8));
    }
        else
             reqend();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
CamImport: filename
{
isValidFile(filename);
scene = Scene();
ctm=Scene().currenttime;
file = File(filename,"r") || error("Fucking Read Only Attribute!");
a=file.parse(" ");

CameraName=a[2];
AddCamera(CameraName);
Newcamera=scene.firstSelect();
AddEnvelope("ZoomFactor"); 
UpAxis=a[11];
Units=a[10];
softw=a[12];
FramesPerSecond(number(a[3]));
FrameSize(number(a[4]),number(a[5]));
PixelAspect(number(a[7]));
aper=(number(a[9]));
ApertureHeight((number(a[9]))*0.0254);
ah=number(a[9]);
mul=number(a[10]);

///CREATE HELPERS NULLS
		AddNull("Aim_Null_Cam");
    aimN=scene.firstSelect();
		AddNull("Up_Null_Cam");
    upN=scene.firstSelect();
///////////////////////



for (line = 2;line <= file.linecount();line++)
{
a=file.parse(" ");
GoToFrame(number(a[1]));

px=number(a[2])*mul;
py=number(a[3])*mul;
pz=number(a[4])*mul;

ax=number(a[5])*mul;
ay=number(a[6])*mul;
az=number(a[7])*mul;

ux=number(a[8])*mul;
uy=number(a[9])*mul;
uz=number(a[10])*mul;

////CAMERA POS AND LENS PART

SelectByName(Newcamera.name);

lns=number(a[11]);
hfov=number(a[12]);
vfov=number(a[13]);
Position(px,py,pz);
CreateKey(Scene().currenttime);


zm=(2*lns)/(25.4*ah);
c = Newcamera.firstChannel();
    while(c)
    {
         last if c.name == "ZoomFactor";
         c = Newcamera.nextChannel();
    }
c.createKey(Scene().currenttime,zm);
////////////////////////////////////
//HELPER NULLS PART
SelectByName(aimN.name);
Position(ax,ay,az);
CreateKey(Scene().currenttime);

SelectByName(upN.name);
Position(ux,uy,uz);
CreateKey(Scene().currenttime);
////////////////////////////////////

}
file.close();
SelectByName(Newcamera.name);
ApplyServer("ItemMotionHandler","RV_Orient");
GoToFrame(ctm);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
CamExport: startanim, endanim, stepanim, camera, filename
{
if (stepanim<=0.0) {
	info("Illegal Step value. Must be greater than 0");
	ciowindow();
}
if (camera==nil) {
	info("No Camera for export!"); 
		ciowindow();
}

scene = Scene();
frame = 0;


///PARENT IN PLACE CHECK
if (scene.generalopts[3] == 0 )
{
OldPpstate=0;
ParentInPlace();
}

//-----------------------------------

    AddNull("Aim_Null_Cam");
    aimN=scene.firstSelect();
    ParentItem(camera.name);
    AddPosition(0,0,1000000);
    CreateKey(0);
    
    AddNull("Up_Null_Cam");
    upN=scene.firstSelect();
    ParentItem(camera.name);
		AddPosition(0,1000000,0);
		CreateKey(0);
		
//-----------------------------------
str= camera.name;
cn="";
t=size(str)+1;
for(i = 1; i < t; i++)
{
 p=strsub(str,i,1);    
 if (p == " ")
 {
	p = "_";
 }
    cn = cn +p; 
}

ctm=scene.currenttime;
pa=scene.pixelaspect;
fh=scene.frameheight;
fw=scene.framewidth;
fp=scene.fps;
iaspr=(fw/fh)*pa;
apert=((2*camera.focalLength(0))/camera.zoomFactor(0))/25.4;
apertw=apert*iaspr;
file = File(filename,"w") || error("Couldn't open output file!");
file.writeln("cio"," ",cn," ",fp," ",fw," ",fh," ",iaspr," ",pa," ",apertw," ",apert," ","1"," ","y"," ","LW ");


for (frame = startanim;frame <= endanim;frame=frame+stepanim)
{
GoToFrame(frame);
cp=camera.getWorldPosition(scene.currenttime);

/////////////////////////////////////////////////    GET NULLS POSITIONS
apos=aimN.getWorldPosition(scene.currenttime);
upos=upN.getWorldPosition(scene.currenttime);
// cr=camera.getWorldRotation(Scene().currenttime);

cl=camera.focalLength(scene.currenttime);
fov=camera.fovAngles(scene.currenttime);
fov[1]=deg(fov[1]);
fov[2]=deg(fov[2]);
cz=camera.zoomFactor(scene.currenttime);
//file.writeln(frame," ",cp," ",cr," ",cl," ",fov[1]," ",fov[2]);

file.writeln(frame," ",cp," ",apos," ",upos," ",cl," ",fov[1]," ",fov[2]);
}
file.close();
GoToFrame(ctm);

/////RESTORE PARENT IN PLACE STATE
if (OldPpstate == 1 )
{
ParentInPlace();
}

////DELETE TEMP OBJECTS
SelectByName(aimN.name);
AutoConfirm(1);
ClearSelected();
SelectByName(upN.name);
ClearSelected();
AutoConfirm(0);
/////

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
isValidFile: filename
{
file = File(filename,"r") || error("Couldn't open input file!");
a=file.parse(" "); file.close();
if (a[1]=="cio") 
	return(1);
	else
	{
	info ("Wrong file format");
	ciowindow();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////