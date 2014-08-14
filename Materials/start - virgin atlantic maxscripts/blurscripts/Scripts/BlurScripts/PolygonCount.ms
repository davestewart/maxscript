-------------------------------------------------------------------------------
-- PolygonCount.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.14
-- Created On: 10/19/00
-- Modified On: 04/06/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Count the number of polys in your scene and in your selection, placing
-- the results in your interface.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Instructions:
-- Just run the script. Edit the PolygonCount.ini file that is in the
-- scripts\blurscripts directory to change the way the script displays. 
-- 1 means it'll display to the command prompt
-- 2 means it'll display in the viewport
-- 3 means it'll display to a messagebox
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs:
-- If you have the move tool selected when you activate this script, it will
-- not display the information in the status bar properly, so make sure
-- before running the script you're in select, rotate or scale mode.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 counts the number of polys in your scene and in your selection, placing
-- the results in your status bar. Thanks to Chugg for some code.
--
-- v 1.10 Added two more ways to display the count, including as text in your
-- viewport and as a messagebox. To change the way is displays, edit the
-- PolygonCount_Default.txt file. Defaults to status bar.
--
-- v 1.11 Changed the name of the defaults file to BSDefaults.ms, placed it in
-- startup. The default polycolor is now the viewport text color.
--
-- v 1.12 BSLib and BSDefaults are now accessed using an include instead of 
-- getting loaded at max startup.
--
-- v 1.13 Now the script uses a seperate ini file. Polygon count include
-- commas in the numbers to allow you to more quickly tell what your count is.
--
-- v 1.14 Cleaned up the ini file code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global pc_io
global pc_count
global display_polys

global slf = 0
global scf = 0
global polycolor = (getuicolor 8)*255
global polytext1
global polytext2

-- Variables

pc_display_type = 1

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn pc_io = 
	(
	pc_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "PolygonCount.ini")
	if openFile pc_ini_name != undefined then
		(
		pc_ini = openFile pc_ini_name
		inputdata = readLine pc_ini
		if inputdata == "1" or inputdata == "2" or inputdata == "3" then pc_display_type = (inputdata as integer) else pc_display_type = 1
		close pc_ini
		)
	else
		(
		pc_ini = createFile pc_ini_name
		format (pc_display_type as string) to:pc_ini
		close pc_ini
		)
	)
	
fn pc_count = 
	(
	for i in $* do
		(
		tempfaces = howmanypolys i
		if i.isselected == true then slf += tempfaces
		scf += tempfaces
		)
	polytext1 = (commafy (slf as string)) + " faces in selected"
	polytext2 = (commafy (scf as string)) + " faces in scene"
	)
	
fn display_polys = 
	(
	if pc_display_type == 1 then
		(
		pushPrompt (polytext1 + ", " + polytext2)
		)
	else if pc_display_type == 2 then
		(
		gw.wtext [5,35,50] polytext1 color:polycolor
		gw.wtext [5,50,50] polytext2 color:polycolor
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
		)
	else
		(
		MessageBox (polytext1 + ", " + polytext2) title:"PolygonCount"
		)
	)

-- Script

pc_io()
pc_count()
display_polys()

pc_ini_name = ((getdir #scripts) + "\\BlurScripts\\" + "PolygonCount.ini")
if openFile pc_ini_name != undefined then deletefile pc_ini_name
pc_ini = createFile pc_ini_name
format (pc_display_type as string) to:pc_ini
close pc_ini
)
-------------------------------------------------------------------------------