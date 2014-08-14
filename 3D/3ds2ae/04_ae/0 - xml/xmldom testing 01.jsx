path='E:/03_Scripting/3ds2ae/04_ae/0 - xml/doc.xml'
path='E:/03_Scripting/3ds2ae/04_ae/0 - xml/objects3.xml'

var f = File(path);
f.open("r");
xml=f.read();
f.close();


// simple
/*
xmlObj=new XMLDoc(xml)
str=''
for(i=0;i<6;i++){
	node = xmlObj.selectNode('dir/file['+i+']');
	str+=node.getAttribute('url')+'\n'
	}
alert(str)
*/
//w3c
//instantiate the W3C DOM Parser
var parser = new DOMImplementation();

//load the XML into the parser and get the DOMDocument
var domDoc = parser.loadXML(xml);

//get the root node (in this case, it is ROOTNODE)
var docRoot = domDoc.getDocumentElement();
alert('OK')

