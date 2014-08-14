function recurseSubNodes parentNode =
(
	theNode=parentNode.child
	for i = 1 to parentNode.children do
	(
		format "%\n" theNode.text
		theNode=theNode.Next
--		recurseSubNodes theNode
	)
)
	
theNode = test.tv1.nodes[1].child
recurseSubNodes theNode


theNode.text

fn recurseSubAnims obj tv tvNode d=
(
	d+=1
	n = obj.numSubs
	for i = 1 to n do
	(
		local nodeText = ((getSubAnimName obj i) as string)
		newNode = tv.nodes.add tvNode.index 4 "" (replaceAll nodeText "_" " ")
		if d!=2 then newNode.expanded=true
		newNode.tag=i as string
		recurseSubAnims obj[i] tv newNode d
	)
)
i

theNode.child.text