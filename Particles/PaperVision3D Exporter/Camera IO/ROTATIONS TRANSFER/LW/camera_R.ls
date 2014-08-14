//IMPORT FROM LW
//EXPORT TO   LW MAX MAYA

generic
{
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

				c6=ctltext("","Version: 1.0 R","Author: Evil Kornholio","gasmasocet@abv.bg");

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
upvector = a[11];
soft = a[12];    

/////////////////////////////////////////////////////////////////
//CREATING NULS
    AddNull("Rot_H");
    h=scene.firstSelect();
    AddNull("Rot_P");
   	p=scene.firstSelect();
    AddNull("Rot_B");
    b=scene.firstSelect();
    
//END CREATING NULS

//SORTING NULS
for(i = 1; i < 4; i++){
		s=strsub(soft,i,1);
		if (s == "x" ){obj[i] =  p.name;}
		if (s == "y" ){obj[i] =  h.name;}
		if (s == "z" ){obj[i] =  b.name;}
}
//END SORTING NULS

//MAKE HERARCHY
SelectItem(Newcamera.name);
ParentItem(obj[1]);

SelectItem(obj[1]);
ParentItem(obj[2]);

SelectItem(obj[2]);
ParentItem(obj[3]);

//END MAKE HERARCHY
/////////////////////////////////////////////////////////////////////


for (line = 2;line <= file.linecount();line++)
{
a=file.parse(" ");
GoToFrame(number(a[1]));

px=number(a[2])*mul;
py=number(a[3])*mul;
pz=number(a[4])*mul;

ax=number(a[5]);
ay=number(a[6]);
az=number(a[7]);


////CAMERA POS AND LENS PART

SelectItem(Newcamera.name);
lns=number(a[8]);
hfov=number(a[9]);
vfov=number(a[10]);



//////////////////////////////////////////////////////////////////////

pz=pz * -1;
ay=ay * -1;
ax=ax * -1;
///ay ax az

SelectItem(obj[3]);
Position(px,py,pz);
CreateKey(Scene().currenttime);

SelectItem(h.name);
Rotation(ay,0,0);
CreateKey(Scene().currenttime);

SelectItem(p.name);
Rotation(0,ax,0);
CreateKey(Scene().currenttime);

SelectItem(b.name);
Rotation(0,0,az);
CreateKey(Scene().currenttime);

zm=(2*lns)/(25.4*ah);
c = Newcamera.firstChannel();
    while(c)
    {
         last if c.name == "ZoomFactor";
         c = Newcamera.nextChannel();
    }
c.createKey(Scene().currenttime,zm);
}
file.close();

if (upvector=="z") {

AddNull("Zup->Yup");
Zup=scene.firstSelect();

SelectItem(obj[3]);
ParentItem(Zup.name);

SelectItem(Zup.name);
Rotation(0,90,0);
CreateKey(0);

}


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
//rot order
file.writeln("cRio"," ",cn," ",fp," ",fw," ",fh," ",iaspr," ",pa," ",apertw," ",apert," ","1"," ","y"," ","zxy ");


for (frame = startanim;frame <= endanim;frame=frame+stepanim)
{
GoToFrame(frame);
cp=camera.getWorldPosition(scene.currenttime);
cr=camera.getWorldRotation(Scene().currenttime);

cl=camera.focalLength(scene.currenttime);
fov=camera.fovAngles(scene.currenttime);
fov[1]=deg(fov[1]);
fov[2]=deg(fov[2]);
cz=camera.zoomFactor(scene.currenttime);

file.writeln(frame," ",cp.x," ",cp.y," ",cp.z*-1," ",cr.p*-1," ",cr.h*-1," ",cr.b," ",cl," ",fov[1]," ",fov[2]);
}
file.close();
GoToFrame(ctm);

/////RESTORE PARENT IN PLACE STATE
if (OldPpstate == 1 )
{
ParentInPlace();
}

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
isValidFile: filename
{
file = File(filename,"r") || error("Couldn't open input file!");
a=file.parse(" "); file.close();
if (a[1]=="cRio") 
	return(1);
	else
	{
	info ("Wrong file format");
	ciowindow();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////