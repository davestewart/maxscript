rla.colorDepth = 16 --set color depth to 16 bpp 
rla.description = "First Revision" --set the file description string 
rla.author = "Bobo" --set the author name string 
rla.iRLAio.zChannel = true --enable Z-Buffer saving 
rla.nodeIDChannel=true
showinterface rla.iRLAio
/*
<Interface:iRLAio>
  Interface: iRLAio
   Properties:
    .colorDepth : integer : Read|Write
    .alpha : boolean : Read|Write
    .premultAlpha : boolean : Read|Write
    .description : TSTR by value : Read|Write
    .author : TSTR by value : Read|Write
    .zChannel : boolean : Read|Write
    .mtlIDChannel : boolean : Read|Write
    .nodeIDChannel : boolean : Read|Write
    .uvChannel : boolean : Read|Write
    .normalChannel : boolean : Read|Write
    .realpixChannel : boolean : Read|Write
    .coverageChannel : boolean : Read|Write
   Methods:
   Actions:
*/