rollout roAE "Comp List" width:312 height:112
(
	-- interface
	GroupBox grp1 "After Effects" pos:[8,8] width:296 height:98
		dropdownList ddComps "" pos:[48,30] width:230 height:21 items:#("Click button to update comp list...")
		label lblDD "Comp:" pos:[16,32] width:32 height:16
		label lbl1 "" pos:[48,56] width:64 height:48
		label lbl2 "" pos:[112,56] width:48 height:48
		label lbl3 "" pos:[160,56] width:64 height:48
		label lbl4 "" pos:[224,56] width:48 height:48
		button btnRefresh "<" pos:[280,32] width:16 height:16



	-- declarations
		local compArr=#()
		local ddItems=#()

	-- functions

		include "..\\core\\jsx.ms"

		function updateCompInfo sel=
			(
			if sel <= compArr.count then
				(
				-- labels
					lbl1.text="Width:\nHeight:\nPixel Aspect:"
					lbl3.text="Duration:\nFramerate:"

				-- properties
					arr=compArr[sel]
					lbl2.text=lbl4.text=""
					for i = 2 to 4 do lbl2.text+=arr[i]+"\n"
					for i = 5 to 6 do lbl4.text+=arr[i]+"\n"
				)
			else
				(
				lbl2.text="--\n--\n--"
				lbl4.text="--\n--"
				)
			)

		function getCompList=
			(
			-- run the AE script
				runJSX "getCompList.jsx"
				sleep 0.1

			-- pick up the file
				f=openFile "C:\\temp\\comps.dat" mode:"r"
				if f != undefined then
					(
					compArr=#()
					while not eof f do
						(
						txt=readline f
						if txt.count>1 then append compArr (filterstring txt "\t")
						)
					close f
				)

			-- populate the list
				ddItems=#()
				for arr in compArr do append ddItems arr[1]
				append ddItems "--------------------------------------------------------------------------------"
				append ddItems "Active Comp"
				ddComps.items=ddItems
				
			-- update the UI
				updateCompInfo 1
				
			)


	on roAE open do
		(
		--getCompList()
		)
		
	on ddComps selected sel do
		(
		if ddComps.items[1]!="Click button to update comp list..." then
			(
			if sel == (ddComps.items.count-1) then
				(
				ddComps.selection = ddComps.items.count
				sel=ddComps.items.count
				)
			updateCompInfo sel
			)
		)

	on btnRefresh pressed do getCompList()

)

createDialog roAE