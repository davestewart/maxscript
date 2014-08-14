/*
CreateDialog <Rollout> 
<height> <width> <position_x> <position_y>

pos:<Point2>
width:<integer>
height:<integer>

lockHeight:<boolean>
lockWidth: <boolean> 

bgcolor:<color>
fgcolor:<color>

bitmap:<bitmap>
bmpstyle:<bmpstyle>

menu:<RCMenu>

style:<array>

modal:<boolean>
escapeEnable:<boolean>
Array of style flags, can be one or more of the following: 

#style_border: Creates a window with a double border but no title. 
#style_titlebar: Creates a dialog with a title bar. 
#style_toolwindow: Creates a tool window, which has a title bar and is intended to be used as a floating toolbar. A tool window has a title bar that is shorter than a normal title bar, and the window title is drawn using a smaller font. 
#style_resizing: Creates a window with a thick frame that can be used to size the window. 
#style_minimizebox: Creates a window that has a minimize button. 
#style_maximizebox: Creates a window that has a maximize button. 
#style_sysmenu: Creates a window that has a window menu in its title bar. 
#style_sunkenedge: Specifies that a window has a 3D look, in the form of a border with a sunken edge. 
Note: If the style keyword parameter is not specifed, the default styles of #style_titlebar, #style_border, #style_sysmenu are used. 

*/

rollout roContainer "3ds2ae" width:450 height:400
(
	subrollout container "Rollouts" height:400
	on roContainer resized size do roContainer.container.height =size[2]-10
) 


createdialog roContainer 450 410 10 10 style:#(#style_titlebar,#style_resizing,#style_minimizebox,#style_sysmenu) lockWidth:true
AddSubRollout roContainer.container roFlashUI--test1a 

AddSubRollout roContainer.container roFlash
AddSubRollout roContainer.container roSettings rolledUp:false
AddSubRollout roContainer.container roAnim rolledUp:true
AddSubRollout roContainer.container roRend rolledUp:true
AddSubRollout roContainer.container roEffects rolledUp:true
AddSubRollout roContainer.container roTools rolledUp:true



--destroydialog roTools

roTools.subrollouts

addSubRollout max2aeFloater roAnimation
