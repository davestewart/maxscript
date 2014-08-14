-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Name			Render Pickup Frames
-- Description	Allows you to scub through the timeline and click a button to add the current frame to the pickup frames
--				field in the Render Scene dialog
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		1.0
-- max version:	5+
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
/*
-- history:		9 Aug 2006	- created

				22 May 2008	= updated
*/
-------------------------------------------------------------------------------------------------------------------------------

rollout roRenderPickupFramesLists "Frames" width:160 height:360
	(
	listBox lbxFrames "Frames" pos:[8,8] width:144 height:11
	listBox lbxRanges "Ranges" pos:[8,184] width:144 height:11
	)

rollout roRenderPickupFrames "Grab" width:160 height:192
	(

	-------------------------------------------------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------------------------------------------------
	
		button btnGrab "Grab frame now" pos:[8,8] width:144 height:144
		button btnRender "Render" pos:[8,160] width:120 height:24 fieldwidth:144
		button btnClear "X" pos:[128,160] width:24 height:24 fieldwidth:144
		
	-------------------------------------------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------------------------------------------
	
		local frames	= #()
		local ranges	= #()
		local lastFrame = undefined
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- functions - utility
	-------------------------------------------------------------------------------------------------------------------------------
	
		function shrinkArray arr = 
			(
			for i = frames.count - 1 to 1 by -1 do
				(
				if arr[i] == arr[i + 1] do deleteItem arr i
				)
			arr
			)
	
		function arrayImpode arr delimiter =
			(
			local str = ""
			for i = 1 to arr.count do
				(
				str += arr[i] as string
				if i < arr.count do str += delimiter
				)
			str
			)

	
		function intervalsArrayToStrings arr =
			(
			local start, end
			for i = 1 to arr.count do
				(
				start = (arr[i].start / ticksperframe) as string
				end	= (arr[i].end / ticksperframe) as string

				arr[i] = start + "-" + end
				)
			print arr
			arr
			)
	
		fn compareInterval v1 v2 = 
			(
			case of
				(
				(v1.start < v2.start) : -1
				(v1.start > v2.start) : 1
				default: 0
				)
			)
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- functions - methods
	-------------------------------------------------------------------------------------------------------------------------------
	
		-- arrays
		
			function addToRanges start end =
				(
				local range = interval start end
				append ranges range
				qsort ranges compareInterval
				)
		
			function addToframes frame =
				(
				append frames frame
				sort frames
				)
	
			function removeFromFrames frame =
				(
				local index = findItem frames frame
				if index != undefined do deleteItem frames index
				)
		
			function removeFramesInRanges =
				(
				)
				
		-- render dialog
		
			function getFramesString =
				(
				local arr = #()
				join arr frames
				join arr (intervalsArrayToStrings ranges)
				arrayImpode arr ", "
				)
			
			function updateFrames =
				(
				rendTimeType = 4
				--rendPickupFrames = getFramesString()
				print (getFramesString())
				)
			
			function clearFrames =
				(
				rendPickupFrames = ""
				renderSceneDialog.update()
				)
			
	-------------------------------------------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------------------------------------------

		on btnClear pressed do clearFrames()
	
		on btnGrab pressed do
			(
			local frame = (slidertime as integer / ticksperframe)
			if keyboard.controlPressed then
				(
				removeFromFrames lastFrame
				removeFromFrames frame
				addToRanges lastFrame frame
				updateFrames()
				)
			else if findItem frames frame == 0 do
				(
				addToFrames frame
				updateFrames()
				)
			lastFrame = frame
			)
)

createDialog roRenderPickupFrames 
createDialog roRenderPickupFramesLists 

/*


arr = #()
for i = 1 to 10 do append arr (interval (random 1 100) (random 1 100))

print arr

fn compareInterval v1 v2 = 
	(
	case of
		(
		(v1.start < v2.start) : -1
		(v1.start > v2.start) : 1
		default: 0
		)
	)

 

qsort arr compareInterval 
print arr


for p in positions do print p

 


--apropos "render" to:(newscript())

--max render scene
*/


-------------------------------------------------------------------------------------------------------------------------------
-- Code examples
-------------------------------------------------------------------------------------------------------------------------------
/*

*/

