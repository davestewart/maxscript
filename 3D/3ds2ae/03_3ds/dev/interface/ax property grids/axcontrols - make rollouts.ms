f=openfile "axcontrols.ms"
arr=#()
seek f 1
while not eof f do
	(
	s=readline f
	if findstring s "grid" != undefined then
		(
		arr1=filterstring s "\""
		arr2=#()
		for a in arr1 do if a!= " " then append arr2 a
		append arr arr2
		format "%\n" s
		)
	)
arr

for i=1 to arr.count do
	(
	format "rollout rProp% \"%\" \n" i  arr[i][1]
	format "	(\n "
	format "	activeXControl ax \"%\" height:300 width:400 align:#left -- %\n" arr[i][3] arr[i][1]
	format "	)\n\n"
	)

"Microsoft Hierarchical FlexGrid Control 6.0 (SP4) (OLEDB)" "MSHierarchicalFlexGridLib.MSHFlexGrid.6" "{0ECD9B64-23AA-11D0-B351-00A0C9055D8E}" 
"10Tec iGrid Control 2.51" "iGrid251_75B4A91C.iGrid" "{46FFC6B5-D62D-4C11-A97B-F1205AF6ABCF}" 
"Microsoft FlexGrid Control, version 6.0" "MSFlexGridLib.MSFlexGrid.1" "{6262D3A0-531B-11CF-91F6-C2863C385E30}" 
"vbAccelerator Grid Control" "vbAcceleratorSGrid.vbalGrid" "{68BDE045-1E7B-4B42-9FE6-E92E487AB03E}" 
"ComponentOne FlexGrid 8.0 (UNICODE Light)" "VSFlexGrid8.VSFlexGridN.1" "{74233DB3-F72F-44EA-94DC-258A624037E6}" 
"vbAccelerator Grid Control" "vbAcceleratorSGrid6.vbalGrid" "{C5DA1F2B-B2BF-4DFC-BC9A-439133543A67}" 
close f