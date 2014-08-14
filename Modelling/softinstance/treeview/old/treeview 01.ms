fn showHier obj d=
(
-- if this is the root then print the name
	if d==1 then format "%\n" obj.name

-- get children and sort
	local arr = #()
	for c in obj.children do append arr c.name
	arr = sort arr

--print the hierarchy
	for c in arr do
	(
		local str=""
		if (getNodeByName c).isFrozen then str+=">"
		for i = 1 to d do str+=" "
		format "%\n" (str + c)
		showHier (getNodeByName c) (d+1)
	)
)

rollout test "test" (

	activeXControl tv "MSComctlLib.TreeCtrl" height:500 width:300 pos:[5,5]
	--activeXControl il "MSComctlLib.ImageListCtrl" height:100 width:100 -- imagelist control

	on test open do (
		tv.lineStyle = #tvwRootLines
		tv.Checkboxes= true
		
		-- enable 'Picture', otherwise you'll never see any pictures
		tv.style = #tvwTreelinesPlusMinusText
		tv.SingleSel =false
--		tv.Indentation=50

		
		-- create nodes

	for m = 1 to $.modifiers.count do
	(
		mNode = tv.nodes.add()
		mNode.text = m.name as string
		local propArr = getPropNames $.modifiers[2]
		for p in propArr do
		(
			pNode = tv.nodes.add mNode.index 4 "" (p as string)
--			pNode.text = p as string
			if (execute(" classof $.modifiers["+m as string+"]."+p as string)==SubAnim) then
				gNode = tv.nodes.add pNode.index 4 "" "Gizmo stuff"

			

		)
	)		
)


)

createdialog test 310 510
showMethods test.tv
showEvents test.tv