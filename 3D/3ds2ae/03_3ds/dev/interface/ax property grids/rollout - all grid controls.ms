fileIn  "../utilityRollouts.ms"
rollout rProp1 "Microsoft Hierarchical FlexGrid Control 6.0 (SP4) (OLEDB)" 
	(
 	activeXControl ax "MSHierarchicalFlexGridLib.MSHFlexGrid.6" height:300 width:400 align:#left -- Microsoft Hierarchical FlexGrid Control 6.0 (SP4) (OLEDB)
	)

rollout rProp2 "10Tec iGrid Control 2.51" 
	(
 	activeXControl ax "iGrid251_75B4A91C.iGrid" height:300 width:400 align:#left -- 10Tec iGrid Control 2.51
	)

rollout rProp3 "Microsoft FlexGrid Control, version 6.0" 
	(
 	activeXControl ax "MSFlexGridLib.MSFlexGrid.1" height:300 width:400 align:#left -- Microsoft FlexGrid Control, version 6.0
	)

rollout rProp4 "vbAccelerator Grid Control" 
	(
 	activeXControl ax "vbAcceleratorSGrid.vbalGrid" height:300 width:400 align:#left -- vbAccelerator Grid Control
	)

rollout rProp5 "ComponentOne FlexGrid 8.0 (UNICODE Light)" 
	(
 	activeXControl ax "VSFlexGrid8.VSFlexGridN.1" height:300 width:400 align:#left -- ComponentOne FlexGrid 8.0 (UNICODE Light)
	)

rollout rProp6 "vbAccelerator Grid Control" 
	(
 	activeXControl ax "vbAcceleratorSGrid6.vbalGrid" height:300 width:400 align:#left -- vbAccelerator Grid Control
	)

/*
rollout rProp1 "Microsoft Hierarchical FlexGrid Control 6.0 (SP4) (OLEDB)" 
	(
 	activeXControl ax "{0ECD9B64-23AA-11D0-B351-00A0C9055D8E}" height:300 width:400 align:#left -- Microsoft Hierarchical FlexGrid Control 6.0 (SP4) (OLEDB)
	)

rollout rProp2 "10Tec iGrid Control 2.51" 
	(
 	activeXControl ax "{46FFC6B5-D62D-4C11-A97B-F1205AF6ABCF}" height:300 width:400 align:#left -- 10Tec iGrid Control 2.51
	)

rollout rProp3 "Microsoft FlexGrid Control, version 6.0" 
	(
 	activeXControl ax "{6262D3A0-531B-11CF-91F6-C2863C385E30}" height:300 width:400 align:#left -- Microsoft FlexGrid Control, version 6.0
	)

rollout rProp4 "vbAccelerator Grid Control" 
	(
 	activeXControl ax "{68BDE045-1E7B-4B42-9FE6-E92E487AB03E}" height:300 width:400 align:#left -- vbAccelerator Grid Control
	)

rollout rProp5 "ComponentOne FlexGrid 8.0 (UNICODE Light)" 
	(
 	activeXControl ax "{74233DB3-F72F-44EA-94DC-258A624037E6}" height:300 width:400 align:#left -- ComponentOne FlexGrid 8.0 (UNICODE Light)
	)

rollout rProp6 "vbAccelerator Grid Control" 
	(
 	activeXControl ax "{C5DA1F2B-B2BF-4DFC-BC9A-439133543A67}" height:300 width:400 align:#left -- vbAccelerator Grid Control
	)
*/

propFloater2 = newRolloutFloater "Grid" 450 450 10 10 
addRollout rAccelState propFloater2 

for i = 1 to 6 do
	(
	execute ("addRollout rProp"+i as string+" propFloater2")
	
	)
--addRollout rAccelState propFloater 
showmethods rProp4.ax

rProp4.ax.AddRow GroupColStartIndex:1
--"hello"-- lRowBefore:1--integer lItemData:integer bVisible:boolean lHeight:integer lGroupColStartIndex:integer

rProp4.ax.AddColumn vKey:"jljll" --:string sHeader:string eAlign:ECGHdrTextAlignFlags( #ecgHdrTextALignLeft | #ecgHdrTextALignCentre | #ecgHdrTextALignRight ) iIconIndex:integer lColumnWidth:integer bVisible:boolean bFixedWidth:boolean vKeyBefore:undefined bIncludeInSelect:boolean sFmtString:string bRowTextColumn:boolean eSortType:ECGSortTypeConstants( #CCLSortNumeric | #CCLSortString | #CCLSortStringNoCase | #CCLSortDate | #CCLSortDateYearAccuracy | #CCLSortDateMonthAccuracy | #CCLSortDateDayAccuracy | #CCLSortDateHourAccuracy | #CCLSortDateMinuteAccuracy | #CCLSortIcon | #CCLSortExtraIcon | #CCLSortForeColor | #CCLSortBackColor | #CCLSortFontIndex | #CCLSortSelected | #CCLSortIndentation | #CCLSortItemData ) bOwnerDraw:boolean

rProp4.ax.GridLines=true
rProp4.ax.EditRow
rProp4.ax.RowItemData[1]

rProp4.ax
rProp4.ax
rProp4.ax
rProp4.ax
