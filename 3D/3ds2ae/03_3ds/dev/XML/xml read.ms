rollout r1 "xml rollout" width:200 height:200
(
	activeXControl ax  "MSXML.DOMDocument" -- setupEvents:false releaseOnClose:false
	on r1 open do
	(
		ax.load "http://www.davestewart.co.uk/3dsmax/test.xml" 
	)
		
	on ax onreadystatechange do
	(
		print "xml loaded!"
		nodes=ax.firstChild.nextSibling
		str=nodes.childNodes[1].text
		print str
	)

)
	
createdialog r1





		nodes=r1.ax.firstChild.nextSibling
		str=nodes.childNodes[0].text
		print str
		
showevents r1.ax


nodeTree=nodes.childNodes[0].childNodes
len=nodeTree.length

for i = 0 to nodeTree.length-1 do
(
	local name=nodeTree[i].nodeName
	local value=nodeTree[i].firstChild.nodeValue
	print (name +" : " + value)
)

nodes.childNodes[0].childNodes.length

nodeTree[2].firstChild.nodeValue

show r1.ax


xmlRoot=nodes=r1.ax.firstChild.nextSibling
xmlRoot.childNodes[1].childNodes[0].childNodes.length




xmlRoot.childNodes[1].childNodes[0].nodeType
xmlRoot.childNodes[1].childNodes[0].childNodes[0].tex


fn printNode node=
(
	if node.nodeType==#NODE_ELEMENT then
	(
		if node.childNodes.length==1 then print 
		else 
	)
	else if node.nodeType==#NODE_Text then print node.text
)
	
print nodes.text