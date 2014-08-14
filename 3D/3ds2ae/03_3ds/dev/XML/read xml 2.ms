( 
	local init = true
	activeXControl ax  "MSXML.DOMDocument" setupEvents:false releaseOnClose:false
	activeXControl axXMLRead "MSXML.DOMDocument" setupEvents:false releaseOnClose:false
	on rxmlIO open do init = false
)

show rxmlIO.axXMLCreate 
showmethods rxmlIO.axXMLCreate 


rxmlIO.axXMLCreate.load "http://www.nocturnalgroove.co.uk/data/news.xml" 

show rxmlIO.axXMLCreate

nodes=rxmlIO.axXMLCreate.firstChild.nextSibling


n=nodes.childNodes.nextNode()

nodes.childNodes[1].text


for n in nodes.childNodes do print n.nodeValue



showmethods nodes.childNodes



n.firstChild.nodeValue

rollout r1 "xml rollout" width:200 height:200
(
	activeXControl ax  "MSXML.DOMDocument"--  setupEvents:false releaseOnClose:false
	on r1 open do
	(
		ax.load "http://www.davestewart.co.uk/3dsmax/test.xml" 
		nodes=ax.firstChild.nextSibling
		str=nodes.childNodes[1].text
		print str
	)
)
	
createdialog r1