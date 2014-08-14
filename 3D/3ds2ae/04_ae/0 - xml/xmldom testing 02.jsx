path='E:/03_Scripting/3ds2ae/04_ae/0 - xml/scene1.xml'

var f = File(path);
f.open("r");
xml=f.read();
f.close();


function xmljsDOMExample() {

//instantiate the W3C DOM Parser
var parser = new DOMImplementation();

//load the XML into the parser and get the DOMDocument
var domDoc = parser.loadXML(xml);

//get the root node
var docRoot = domDoc.getDocumentElement();

//get the "TAG1" element
var tag1 = docRoot.getElementsByTagName("file").item(0);

var retNode = tag1.getParentNode();

//the following should be "ROOTNODE"
alert(retNode.nodeName);

retNode = tag1.childNodes.item(1).getParentNode();
//the following should be "TAG1"
alert(retNode.getNodeName());

//the following should be null (attributes cannot have parents)
alert(tag1.attributes.getNamedItem("url").getParentNode());

//attributes can, however, have owner Elements
//the following should be "TAG1"
alert(tag1.attributes.getNamedItem("url").getOwnerElement().getNodeName());


}// end function xmljsDOMExample


xmljsDOMExample() 