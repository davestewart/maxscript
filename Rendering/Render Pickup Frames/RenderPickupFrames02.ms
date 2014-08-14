rollout roRenderPickupFrames "Grab Frame" width:160 height:192
(
		button btnGrab "Grab frame now" pos:[8,8] width:144 height:144
		button btnRender "Render" pos:[8,160] width:120 height:24 fieldwidth:144
		button btnClear "X" pos:[128,160] width:24 height:24 fieldwidth:144
		
		local frames = #()
		local ranges = #()
		local lastFrame = undefined
	
		function shrinkArray arr = 
			(
			for i = frames.count - 1 to 1 by -1 do
				(
				if arr[i] == arr[i + 1] do deleteItem arr i
				)
			arr
			)
	
		function arrayToDelimtedString arr delimiter: ", " = 
			(
			local str = ""
			arr = shrinkArray arr
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
	
		function getFramesString =
			(
			local arr = #()
			join arr frames
			join arr (intervalsArrayToStrings ranges)
			arrayToDelimtedString arr
			)
		
		function clearFrames =
			(
			rendPickupFrames = ""
			renderSceneDialog.update()
			)
		
		on btnClear pressed do clearFrames()
	
		on btnGrab pressed do
			(
			local frame = (slidertime as integer / ticksperframe)
			if keyboard.controlPressed then
				(
				local range = interval lastFrame frame
				append ranges range
				qsort ranges compareInterval
				--rendPickupFrames = getFramesString()
				print (getFramesString())
				)
			else if findItem frames frame == 0 do
				(
				append frames frame
				sort frames
				rendPickupFrames = getFramesString()
				rendTimeType = 4
				renderSceneDialog.update()
				)
			lastFrame = frame
			)
)

createDialog roRenderPickupFrames 


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