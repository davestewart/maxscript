rollout roCC "Curve Control"
	(

	CurveControl cc1 "" height:400 width:800 numCurves:1
	button btnPrint "Print selected points" width:200 height:20


	fn printPoints cc i =
		(
		print cc
		print (getSelectedPts cc.curves[i])
		)
	
	on btnPrint pressed do printPoints cc1 1
	
	on roCC open do
		(
		)
	
	)
	
createdialog roCC 820 440

print (getSelectedPts roCC.cc1.curves[1])


setSelectedPts roCC.cc1.curves[1] #{1..2} #select

getSelectedPts roCC.cc1.curves[1]