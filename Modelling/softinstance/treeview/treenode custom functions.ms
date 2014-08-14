for i = 1 to tnode.children do

 in tnode do format "%\n" t
 
 
for n in test.tv1.nodes do format "%\n" n

tNode = test.tv1.selectedItem


-- list all downstream...
	fn getDownstreamNodes tv tvNode =
		(
		local nodeArr=#()
		for i = tvNode.index+1 to tvNode.next.index-1 do append nodeArr tv.nodes[i]
		return nodeArr
		)
	

-- get all children

	fn getNodeChildren tvNode =
		(
		local nodeArr=#()
		local c = tvNode.child
		for i = 1 to tvNode.children do
			(
			append nodeArr c
			c=c.next
			)
		if debug==true then (for n in nodeArr do format "%, " n.text;format "\n")
		return nodeArr
		)
	
	