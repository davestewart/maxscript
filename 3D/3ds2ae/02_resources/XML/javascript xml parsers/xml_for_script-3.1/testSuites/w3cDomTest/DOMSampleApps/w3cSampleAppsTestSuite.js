// =========================================================================
//
// w3cSampleAppsTestSuite.js - a test suite for testing xmlw3cdom.js
//
// =========================================================================
//
// Copyright (C) 2001, 2003 - David Joham (djoham@yahoo.com)
// Copyright (C) 2003 - Jon van Noort (jon@webarcana.com.au)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

/*****************************************************************************
                            MODULE VARIABLES
*****************************************************************************/


/*****************************************************************************
                                    FUNCTIONS
*****************************************************************************/
function runTests() {
  /*****************************************************************************
  function: runTests

  author: djoham@yahoo.com

  description: Begins the test run.

  *****************************************************************************/

  clearTestResults();

  createTestResultsHeader("Starting Test Run");

  createTestResultsHeader("Starting Main Documentation Page Tests");
  testGettingStarted();
  testEntityCharacters();
  testNamespaces();

  //do DOMAttr tests after a break to refresh the page
  window.setTimeout("doDOMAttrTests()", 1000);

}


function doDOMAttrTests() {
  /*****************************************************************************
  function: doDOMAttrTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMAttr

  *****************************************************************************/

  createTestResultsHeader("Starting DOMAttr Tests");
  domAttr_getName();
  domAttr_getSpecified();
  domAttr_getOwnerElement();
  domAttr_getValue();
  domAttr_setValue();

  //do DOMCharacterData tests after a break to refresh the page
  //NOTE: skipping DOMCDATASection because there are no sample apps
  //for that object (no native methods to test)
  window.setTimeout("doDOMCharacterDataTests()", 1000);

} // end function doDOMAttrTests


function doDOMCharacterDataTests() {
  /*****************************************************************************
  function: doDOMCharacterDataTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMCharacterData

  *****************************************************************************/

  createTestResultsHeader("Starting DOMCharacterData Tests");
  domCharacterData_getData();
  domCharacterData_setData();
  domCharacterData_getLength();
  domCharacterData_substringData();
  domCharacterData_appendData();
  domCharacterData_insertData();
  domCharacterData_deleteData();
  domCharacterData_replaceData();

  //do DOMDocument tests after a break to refresh the page
  //NOTE: Skipping DOMComment section because there are no sample apps
  //for that object (no native methods to test)
  window.setTimeout("doDOMDocumentTests()", 1000)

} // end function doDOMCharacterDataTests


function doDOMDocumentTests() {
  /*****************************************************************************
  function: doDOMDocumentTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMDocument

  *****************************************************************************/

  createTestResultsHeader("Starting DOMDocument Tests");
  domDocument_getImplementation();
  domDocument_getDocumentElement();
  domDocument_createElement();
  domDocument_createDocumentFragment();
  domDocument_createTextNode();
  domDocument_createComment();
  domDocument_createCDATASection();
  domDocument_createProcessingInstruction();
  domDocument_createAttribute();
  domDocument_createAttributeNS();
  domDocument_createElementNS();
  domDocument_getElementById();
  domDocument_importNode();

  //do DOMElement tests after a break to refresh the page
  //NOTE: Skipping DOMDocumentFragment section because there are no sample apps
  //for that object (no native methods to test)
  window.setTimeout("doDOMElementTests()", 1000)

} // end function doDOMDocumentTests


function doDOMElementTests() {
  /*****************************************************************************
  function: doDOMElementTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMElement

  *****************************************************************************/

  createTestResultsHeader("Starting DOMElement Tests");
  domElement_getTagName();
  domElement_getAttribute();
  domElement_setAttribute();
  domElement_removeAttribute();
  domElement_getAttributeNode();
  domElement_setAttributeNode();
  domElement_removeAttributeNode();
  domElement_hasAttribute();
  domElement_getAttributeNS();
  domElement_setAttributeNS();
  domElement_removeAttributeNS();
  domElement_getAttributeNodeNS();
  domElement_setAttributeNodeNS();
  domElement_hasAttributeNS();

  //do DOMException tests after a break to refresh the page
  window.setTimeout("doDOMExceptionTests()", 1000);

} // end function doDOMElementTests



function doDOMExceptionTests() {
  /*****************************************************************************
  function: doDOMExceptionTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMException

  *****************************************************************************/

  createTestResultsHeader("Starting DOMException Tests");
  domException_indexSizeErr();
  domException_hierarchyRequestErr();
  domException_wrongDocumentErr();
  domException_invalidCharacterErr();
  domException_noModificationAllowedErr();
  domException_notFoundErr();
  domException_inuseAttributeErr();
  domException_syntaxErr();
  domException_namespaceErr();

  //do DOMImplementation tests after a break to refresh the page
  window.setTimeout("doDOMImplementationTests()", 1000);

} //end function doDOMExceptionTests


function doDOMImplementationTests() {
  /*****************************************************************************
  function: doDOMImplementationTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMImplementation

  *****************************************************************************/

  createTestResultsHeader("Starting DOMImplementation Tests");
  domImplementation_preserveWhiteSpace();
  domImplementation_namespaceAware();
  domImplementation_loadXML();
  domImplementation_translateErrCode();
  domImplementation_escapeString();
  domImplementation_unescapeString();

  //do DOMNamedNodeMap tests after a break to refresh the page
  window.setTimeout("doDOMNamedNodeMapTests()", 1000);

} // end function doDOMImplementationTests


function doDOMNamedNodeMapTests() {
  /*****************************************************************************
  function: doDOMNamedNodeMapTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMNamedNodeMap

  *****************************************************************************/

  createTestResultsHeader("Starting DOMNamedNodeMap Tests");
  domNamedNodeMap_getNamedItem();
  domNamedNodeMap_setNamedItem();
  domNamedNodeMap_removeNamedItem();
  domNamedNodeMap_getNamedItemNS();
  domNamedNodeMap_setNamedItemNS();
  domNamedNodeMap_removeNamedItemNS();

  //do DOMNode tests after a break to refresh the page
  window.setTimeout("doDOMNodeTests()", 1000);

} // end function doDOMNamedNodeMapTests


function doDOMNodeTests() {
  /*****************************************************************************
  function: doDOMNodeTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMNode

  *****************************************************************************/

  createTestResultsHeader("Starting DOMNode Tests");
  domNode_getNodeName1();
  domNode_getNodeName2();
  domNode_getNodeValue();
  domNode_setNodeValue();
  domNode_getNodeType();
  domNode_getParentNode();
  domNode_getChildNodes();
  domNode_getFirstChild();
  domNode_getLastChild();
  domNode_getPreviousSibling();
  domNode_getAttributes();
  domNode_getNamespaceURI();
  domNode_getPrefix();
  domNode_getLocalName();
  domNode_getOwnerDocument();
  domNode_insertBefore();
  domNode_replaceChild();
  domNode_removeChild();
  domNode_appendChild();
  domNode_hasChildNodes();
  domNode_cloneNode1();
  domNode_cloneNode2();
  domNode_getElementsByTagName();
  domNode_getElementsByTagNameNS();
  domNode_setPrefix();
  domNode_normalize();
  domNode_isSupported();
  domNode_getXML();
  domNode_hasAttributes();

  //do DOMNodeList tests after a break to refresh the page
  window.setTimeout("doDOMNodeListTests()", 1000);


} // end function doDOMNodeTests



function doDOMNodeListTests() {
  /*****************************************************************************
  function: doDOMNodeListTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMNodeList

  *****************************************************************************/

  createTestResultsHeader("Starting DOMNodeList Tests");
  domNodeList_getLength();
  domNodeList_item();

  //do DOMProcessingInstruction tests after a break to refresh the page
  window.setTimeout("doDOMProcessingInstructionTests()", 1000);


} // end function doDOMNodeListTests


function doDOMProcessingInstructionTests() {
  /*****************************************************************************
  function: doDOMProcessingInstructionTests

  author: djoham@yahoo.com

  description: Begins the tests for DOMProcessingInstruction

  *****************************************************************************/

  createTestResultsHeader("Starting DOMProcessingInstruction Tests ");
  domProcessingInstruction_getTarget();
  domProcessingInstruction_getData();
  domProcessingInstruction_setData();

  //do DOMText tests after a break to refresh the page
  window.setTimeout("doDOMTextTests()", 1000);

} // end function doDOMProcessingInstructionTests


function doDOMTextTests() {
  /*****************************************************************************
  function: doDOMTextTests

  author: djoham@yahoo.com

  description: Begins the tests for doDOMTextTests

  *****************************************************************************/

  createTestResultsHeader("Starting DOMText Tests ");
  domText_splitText();

  //DOMDocumentType, DOMEntity, DOMEntityReference and DOMNotation
  //are not supported. This test suite is finished
  createTestResultsHeader("TESTS CONCLUDED");

} // end function doDOMTextTests


/********************************************************************************************

                                    MAIN PAGE

*********************************************************************************************/

function testGettingStarted() {
  /*****************************************************************************
  function: runTests

  author: djoham@yahoo.com

  tests: documentation-w3cdom.html#gettingstarted

  *****************************************************************************/
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();

 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node (in this case, it is ROOTNODE)
 var docRoot = domDoc.getDocumentElement();

 //get the first "TAG1" element
 var firstTag1 = docRoot.getElementsByTagName("TAG1").item(0);

 //display the data
 //it should be "Hello World"
 var newOpt;
 if (firstTag1.getFirstChild().getNodeValue() == "Hello World") {
    newOpt = getTestSuccessOption("testGettingStarted -- Success");
 }
 else {
    newOpt = getTestFailureOption("testGettingStarted -- Failure");
 }

 insertOptionElement(newOpt);

} // end function testGettingStarted



function testEntityCharacters() {
  /*****************************************************************************
  function: testEntityCharacters

  author: djoham@yahoo.com

  tests: documentation-w3cdom.html#entities

  *****************************************************************************/

var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"&lt;&apos;goo&apos;&gt;\">"
 + "&amp;Hello&quot;World"
 + "<!--com\">&lt;ment-->"
 + "<![CDATA[nodeType <<<&amp;> CDATA]]>"
 + "<?foo h<el&gt;lo ?>"
 + "</TAG1>" + "</ROOTNODE>";

 var pass = true;
 var newOpt;

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();

 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node
 var docRoot = domDoc.getDocumentElement();

 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);

 //the following should be "<'goo'>"
 if (tag1.getAttributes().item(0).getNodeValue() != "<'goo'>") {
    pass = false;
 }

 //the following should be 'foo="&lt;&apos;goo&apos;&gt;"'
 if (tag1.getAttributes().item(0).getXML() != "foo=\"&lt;&apos;goo&apos;&gt;\"") {
    pass = false;
 }


 //the following should be '&Hello"World'
 if (tag1.childNodes.item(0).getNodeValue() != "&Hello\"World") {
    pass = false;
 }

 //the following should be "&amp;Hello&quot;World"
 if (tag1.childNodes.item(0).getXML() != "&amp;Hello&quot;World") {
    pass = false;
 }


 //the following should be 'com">&lt;ment'
 if (tag1.childNodes.item(1).getNodeValue() != "com\">&lt;ment") {
    pass = false;
 }

 //the following should be '<!--com">&lt;ment-->
 if (tag1.childNodes.item(1).getXML() != "<!--com\">&lt;ment-->" ) {
    pass = false;
 }


 //the following should be "nodeType <<<&amp;> CDATA"
 if (tag1.childNodes.item(2).getNodeValue() != "nodeType <<<&amp;> CDATA") {
    pass = false;
 }

 //the following should be "<![CDATA[nodeType <<<&amp;> CDATA]]>"
 if (tag1.childNodes.item(2).getXML() != "<![CDATA[nodeType <<<&amp;> CDATA]]>") {
    pass = false;
 }


 //the following should be "h<el&gt;lo"
 if (tag1.childNodes.item(3).getNodeValue() != "h<el&gt;lo") {
    pass = false;
 }

 //the following should be "<?foo h<el&gt;lo ?>"
 if (tag1.childNodes.item(3).getXML() != "<?foo h<el&gt;lo ?>") {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("testEntityCharacters -- Success");
 }
 else {
    newOpt = getTestFailureOption ("testEntityCharacters -- Failure");
 }

 insertOptionElement(newOpt);

} // end function testEntityCharacters


function testNamespaces() {
  /*****************************************************************************
  function: testNamespaces

  author: djoham@yahoo.com

  tests: documentation-w3cdom.html#namespaces

  *****************************************************************************/

var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns=\"http://xmljs.sf.net/nsdefault\" xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<TAG1>"
 + "<ns1:TAG2 att1=\"foo\" ns1:att2=\"nsfoo\" xmlns=\"newDefault\">"
 + "<TAG3>"
 + "Hello World"
 + "</TAG3>"
 + "</ns1:TAG2>"
 + "<TAG4>"
 + "Hello World"
 + "</TAG4>"
 + "</TAG1>"
 + "</ns1:ROOTNODE>";

 var pass = true;
 var newOpt;

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var ns1="http://xmljs.sf.net/nsdefault"
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //the TAG1 element has a namespace URI of
 //http://xmljs.sf.net/nsdefault because it exists in the
 //default namespace of the XML (as defined in the ROOTNODE's
 //xmlns="http://xmljs.sf.net/nsdefault" attribtue) and it
 //does not have a namespace declaration of its own.
 
 //The following should be "http://xmljs.sf.net/nsdefault"
 if (tag1.getNamespaceURI() != "http://xmljs.sf.net/nsdefault" ) {
    pass = false;
 }

 //The following should be "TAG1"
 if (tag1.getLocalName() != "TAG1" ) {
    pass = false;
 }

 //The following should be "" (blank) because TAG1 is in
 //the default namespace (which does not have a prefix)
 if (tag1.getPrefix() != "" ) {
    pass = false;
 }

 //The following should be "TAG1" since there is no prefix
 //to append to the localName
 if (tag1.getNodeName() != "TAG1") {
    pass = false;
 }


 //get the TAG2 element
 var tag2 = tag1.getFirstChild();

 //the TAG2 element has a namespace URI of
 //http://xmljs.sf.net/ns1 because it uses the "ns1" prefix which
 //was defined to exist in the http://xmljs.sf.net/ns1 namespace
 //in the xmlns:ns1="http://xmlns="http://xmljs.sf.net/ns1" attribtue
 //of the ROOTNODE.

 //The following should be "http://xmljs.sf.net/ns1"
 if (tag2.getNamespaceURI() != "http://xmljs.sf.net/ns1") {
    pass = false;
 }

 //the following should be "TAG2"
 if (tag2.getLocalName() != "TAG2") {
    pass = false;
 }

 //the following should be "ns1"
 if (tag2.getPrefix() != "ns1" ) {
    pass = false;
 }

 //the following should be "ns1:TAG2"
 if (tag2.getNodeName() != "ns1:TAG2" ) {
    pass = false;
 }


 //get the "att1" attribute
 var att1 = tag2.getAttributes().item(0);

 //The att1 attribute does not reside in any namespace
 //because attribute nodes do not inherit any namespace
 //information

 //the following should be "" (blank)
 if (att1.getNamespaceURI() != "" ) {
    pass = false;
 }

 //the following should be "att1"
 if (att1.getLocalName() != "att1" ) {
    pass = false;
 }

 //the following should be "" (blank)
 if (att1.getPrefix() != "" ) {
    pass = false;
 }

 //the following should be "att1"
 if (att1.getNodeName() != "att1") {
    pass = false;
 }


 //get the "att2" attribute
 var att2 = tag2.getAttributes().item(1);

 //The att2 attribute resides in the ns1 namespace
 //because it's prefix was specified

 //the following should be "http://xmljs.sf.net/ns1"
 if (att2.getNamespaceURI() != "http://xmljs.sf.net/ns1") {
    pass = false;
 }

 //the following should be "att2"
 if (att2.getLocalName() != "att2") {
    pass = false;
 }

 //the following should be "ns1"
 if (att2.getPrefix() != "ns1") {
    pass = false;
 }

 //the following should be "ns1:att2"
 if (att2.getNodeName() != "ns1:att2") {
    pass = false;
 }


 //get TAG3
 var tag3 = tag2.getFirstChild();

 //tag 3 had its default namespace specified by the
 //"xmlns" attribute of tag2.

 //the following should be "newDefault"
 if (tag3.getNamespaceURI() != "newDefault" ) {
    pass = false;
 }

 //the following should be "TAG3"
 if (tag3.getLocalName() != "TAG3" ) {
    pass = false;
 }

 //the following should be "" (blank) because the
 //node is part of a default namespace that does
 //not have a prefix
 if (tag3.getPrefix() != "" ) {
    pass = false;
 }

 //the following should be "TAG3"
 if (tag3.getNodeName() != "TAG3" ) {
    pass = false;
 }


 //get TAG4
 //tag 4 is not a child of TAG2 and thus did not inherit
 //its new default namespace URI. TAG4 uses the default
 //namespace URI specified in ROOTNODE
 var tag4 = docRoot.getElementsByTagNameNS(ns1, "TAG4").item(0);

 //The following should be "http://xmljs.sf.net/nsdefault"
 if (tag4.getNamespaceURI() != "http://xmljs.sf.net/nsdefault" ) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("testNamespaces -- Success");
 }
 else {
    newOpt = getTestFailureOption ("testNamespaces -- Failure");
 }

 insertOptionElement(newOpt);

} // end function testNamespaces



/********************************************************************************************

                                    DOMAttr Tests

*********************************************************************************************/


function domAttr_getName() {
  /*****************************************************************************
  function: domAttr_getName

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMAttr.html#getName

  *****************************************************************************/

var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\" />"
 + "</ROOTNODE>";
 
 var pass = true;
 var newOpt;

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();

 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node
 var docRoot = domDoc.getDocumentElement();

 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");

 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();

 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");

 //the following should be "foo"
 if (fooNode.getName() != "foo" ) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domAttr_getName -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domAttr_getName -- Failure");
 }

 insertOptionElement(newOpt);


} // end function domAttr_getName



function domAttr_getSpecified() {
  /*****************************************************************************
  function: domAttr_getSpecified

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMAttr.html#getSpecified

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");
 
 //the following should be "true"
 if (fooNode.getSpecified() != true) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domAttr_getSpecified -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domAttr_getSpecified -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domAttr_getSpecified


function domAttr_getOwnerElement() {
  /*****************************************************************************
  function: domAttr_getOwnerElement

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMAttr.html#getOwnerElement

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");
 
 //the following should be "TAG1"
 if (fooNode.getOwnerElement().getNodeName() != "TAG1") {
    pass = false;
 }

 //the following should be "true"
 if (tag1 != fooNode.getOwnerElement() ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domAttr_getOwnerElement -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domAttr_getOwnerElement -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domAttr_getOwnerElement


function domAttr_getValue() {
  /*****************************************************************************
  function: domAttr_getValue

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMAttr.html#getValue

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();

 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node
 var docRoot = domDoc.getDocumentElement();

 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");

 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();

 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");

 //the following should be "goo"
 if (fooNode.getValue() != "goo") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domAttr_getValue -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domAttr_getValue -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domAttr_getValue


function domAttr_setValue() {
  /*****************************************************************************
  function: domAttr_setValue

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMAttr.html#setValue

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");
 
 //set the foo attribute's value to "newFoo"
 fooNode.setValue("newFoo");
 
 //the following should be "newFoo"
 if (fooNode.getValue() != "newFoo") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domAttr_setValue -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domAttr_setValue -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domAttr_setValue


/********************************************************************************************

                                    DOMCharacterData Tests

*********************************************************************************************/


function domCharacterData_getData() {
  /*****************************************************************************
  function: domCharacterData_getData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataGetData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //both of the following should be "Hello World"
 if (textNode.getData() != "Hello World") {
    pass = false;
 }

 if (textNode.getNodeValue() != "Hello World") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_getData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_getData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_getData



function domCharacterData_setData() {
  /*****************************************************************************
  function: domAttr_setValue

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataSetData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "<!--Hello World-->"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" comment
 var commentNode = tag1.getFirstChild();
 
 //The following should be "Hello World"
 if (commentNode.getData() != "Hello World" ) {
    pass = false;
 }

 //now set the data
 commentNode.setData("New Comment Data");

 //the following should be
 //"New Comment Data"
 if (commentNode.getData() != "New Comment Data") {
    pass = false;
 }

 //The following should be
 //<TAG1>
 //<!--New Comment Data-->
 //</TAG1>
 if (tag1.getXML() != "<TAG1><!--New Comment Data--></TAG1>") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_setData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_setData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_setData



function domCharacterData_getLength() {
  /*****************************************************************************
  function: domCharacterData_getLength

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataGetLength

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "0123456789"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //The following should be "10"
 if (textNode.getLength() != 10) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_getLength -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_getLength -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_getLength



function domCharacterData_substringData() {
  /*****************************************************************************
  function: domCharacterData_substringData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataSubStringData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //The following should be "Hello"
 if (textNode.substringData(0, 5) != "Hello" ) {
    pass = false;
 }
 
 //The following should be "World"
 if (textNode.substringData(6, 5) != "World") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_substringData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_substringData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_substringData



function domCharacterData_appendData() {
  /*****************************************************************************
  function: domCharacterData_appendData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataAppendData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //append "!" to the node's data
 textNode.appendData("!");
 
 //the following should be
 //"Hello World!"
 if (textNode.getData() != "Hello World!") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_appendData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_appendData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_appendData



function domCharacterData_insertData() {
  /*****************************************************************************
  function: domCharacterData_insertData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataInsertData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //insert "There " into the node's data
 //between "Hello" and "World". Keep
 //the space after "Hello" and include
 //a space in the inserted data to
 //keep the sentance structure correct
 textNode.insertData(6, "There ");
 
 //the following should be
 //"Hello There World"
 if (textNode.getData() != "Hello There World") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_insertData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_insertData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_insertData



function domCharacterData_deleteData() {
  /*****************************************************************************
  function: domCharacterData_deleteData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataDeleteData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //remove "There " from the node's data
 //(note the space being removed as well)
 textNode.deleteData(5,6);
 
 //the following should be "Hello"
 if (textNode.getData() != "Hello") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_deleteData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_deleteData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_deleteData



function domCharacterData_replaceData() {
  /*****************************************************************************
  function: domCharacterData_replaceData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMCharacterData.html#DOMCharDataReplaceData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello Their"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello Their" text
 var textNode = tag1.getFirstChild();
 
 //replace "Their" from the node's data
 //with "There" for proper grammar
 textNode.replaceData(6, 5, "There");
 
 //the following should be "Hello There"
 if (textNode.getData() != "Hello There") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domCharacterData_replaceData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domCharacterData_replaceData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domCharacterData_replaceData





/********************************************************************************************

                                    DOMDocument Tests

*********************************************************************************************/





function domDocument_getImplementation() {
  /*****************************************************************************
  function: domDocument_getImplementation

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentImplementation

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //the following should be "true"
 //(remember, parser is a DOMImplementation object)
 if (domDoc.getImplementation() != parser) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_getImplementation -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_getImplementation -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_getImplementation


function domDocument_getDocumentElement() {
  /*****************************************************************************
  function: domDocument_getDocumentElement

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentDocumentElement

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //the following should be "ROOT"
 if (docRoot.getNodeName() != "ROOT" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_getDocumentElement -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_getDocumentElement -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_getDocumentElement


function domDocument_createElement() {
  /*****************************************************************************
  function: domDocument_createElement

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateElement

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new (TAG2) element
 var tag2 = domDoc.createElement("TAG2");
 
 //create a new TextNode
 var text = domDoc.createTextNode("New");
 
 //append the TextNode to the new TAG2 element
 tag2.appendChild(text);
 
 //add TAG2 to the DOMDocument
 docRoot.insertBefore(tag2, tag1);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<TAG2>
 //New
 //</TAG2>
 //<TAG1>
 //Hello
 //</TAG1>
 //</ROOT>"

 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG2>New</TAG2><TAG1>Hello</TAG1></ROOT>") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createElement -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createElement -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createElement


function domDocument_createDocumentFragment() {
  /*****************************************************************************
  function: domDocument_createDocumentFragment

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateDocumentFragment

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.documentElement;
 
 //create the DOMDocumentFragment
 var newDocFrag;
 newDocFrag = domDoc.createDocumentFragment();
 
 //create a new DOMElement and DOMText
 //that will be added to the DOMDocumentFragment
 //NOTE: These elements are *NOT* actually in the
 //DOMDocument yet.
 var newElem = domDoc.createElement("NEWELEMENT");
 var newText = domDoc.createTextNode("new text");
 
 //append the new objects to each other
 newElem.appendChild(newText);
 newDocFrag.appendChild(newElem);
 
 //append the DOMDocumentFragment
 //to the ROOT node. At this point
 //the new nodes become visible in the
 //DOMDocument.
 docRoot.appendChild(newDocFrag);
 
 //the following should be
 //"<?xml version="1.0"?>
 //<ROOT>
 // <TAG1>
 // Hello
 // </TAG1>
 // <NEWELEMENT>
 // new text
 // </NEWELEMENT>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>Hello</TAG1><NEWELEMENT>new text</NEWELEMENT></ROOT>") {
    pass = false;
 }

 //get the NEWELEMENT Node from the document
 //I can do this now that I've appended the
 //DOMDocumentFragment to the tree
 var newElem = docRoot.getElementsByTagName("NEWELEMENT").item(0);

 //the following should be "new text"
 if (newElem.getFirstChild().getNodeValue() != "new text") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createDocumentFragment -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createDocumentFragment -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createDocumentFragment


function domDocument_createTextNode() {
  /*****************************************************************************
  function: domDocument_createTextNode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateTextNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new (TAG2) element
 var tag2 = domDoc.createElement("TAG2");
 
 //create a new DOMText node
 var newText = domDoc.createTextNode("New Text Data");
 
 //append the TextNode to the new TAG2 element
 tag2.appendChild(newText);
 
 //add TAG2 to the DOMDocument
 docRoot.insertBefore(tag2, tag1);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<TAG2>
 //New Text Data
 //</TAG2>
 //<TAG1>
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG2>New Text Data</TAG2><TAG1>Hello</TAG1></ROOT>") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createTextNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createTextNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createTextNode


function domDocument_createComment() {
  /*****************************************************************************
  function: domDocument_createComment

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateComment

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new DOMComment node
 var newComment = domDoc.createComment("I'm a comment");
 
 //append the DOMComment to the TAG1 element
 tag1.appendChild(newComment);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<TAG1>
 //Hello<!--I'm a comment-->
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>Hello<!--I'm a comment--></TAG1></ROOT>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createComment -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createComment -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createComment


function domDocument_createCDATASection() {
  /*****************************************************************************
  function: domDocument_createCDATASection

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateCDATASection

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new DOMCDATADection node
 var newCDATA = domDoc.createCDATASection("<any text>");
 
 //append the DOMCDATASection to the TAG1 element
 tag1.appendChild(newCDATA);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<TAG1>
 //Hello<![CDATA[<any text>]]>
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>Hello<![CDATA[<any text>]]></TAG1></ROOT>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createCDATASection -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createCDATASection -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createCDATASection


function domDocument_createProcessingInstruction() {
  /*****************************************************************************
  function: domDocument_createProcessingInstruction

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateProcessingInstruction

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new DOMProcessingInstruction node
 var newPI = domDoc.createProcessingInstruction("target", "data");
 
 //Add the new DOMProcessingInstruction right
 //before TAG1
 docRoot.insertBefore(newPI, tag1);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<?target data ?>
 //<TAG1>
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><?target data ?><TAG1>Hello</TAG1></ROOT>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createProcessingInstruction -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createProcessingInstruction -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createProcessingInstruction


function domDocument_createAttribute() {
  /*****************************************************************************
  function: domDocument_createAttribute

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateAttribute

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new DOMAttr node
 var newAttribute = domDoc.createAttribute("attribute");
 
 newAttribute.setNodeValue("value");
 
 //Add the new attribute to TAG1
 tag1.setAttributeNode(newAttribute);
 
 //the following should be
 //<?xml version="1.0"?>
 //<ROOT>
 //<TAG1 attribute="value">
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1 attribute=\"value\">Hello</TAG1></ROOT>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createAttribute -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createAttribute -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createAttribute


function domDocument_createAttributeNS() {
  /*****************************************************************************
  function: domDocument_createAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateAttributeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1>"
 + "Hello"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var ns1="http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //create a new DOMAttr node with
 //the ns1 namespace
 var ns1="http://xmljs.sf.net/ns1";
 var newAttribute = domDoc.createAttributeNS(ns1, "ns1:attribute");
 
 newAttribute.setNodeValue("value");
 
 //Add the new attribute to TAG1
 tag1.setAttributeNode(newAttribute);
 
 //the following should be
 //<?xml version=\"1.0\"?>
 //<ns1:ROOT xmlns:ns1="http://xmljs.sf.net/ns1" >
 //<ns1:TAG1 ns1:attribute="value">
 //Hello
 //</ns1:TAG1>
 //</ns1:ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" ><ns1:TAG1 ns1:attribute=\"value\">Hello</ns1:TAG1></ns1:ROOT>" ) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createAttributeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createAttributeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createAttributeNS


function domDocument_createElementNS() {
  /*****************************************************************************
  function: domDocument_createElementNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentCreateElementNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1>"
 + "Hello"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var ns1="http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //create a new DOMElement node with
 //the ns1 namespace
 var ns1="http://xmljs.sf.net/ns1";
 var newElement = domDoc.createElementNS(ns1, "ns1:NewElement");
 
 //create and append a DOMText to the new node
 var newText = domDoc.createTextNode("new text");
 newElement.appendChild(newText);
 
 //Add the new DOMElement to the document
 docRoot.appendChild(newElement);
 
 //the following should be
 //<?xml version=\"1.0\"?>
 //<ns1:ROOT xmlns:ns1="http://xmljs.sf.net/ns1" >
 //<ns1:TAG1>
 //Hello
 //</ns1:TAG1>
 //<ns1:NewElement>
 //new text
 //</ns1:NewElement>
 //</ns1:ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" ><ns1:TAG1>Hello</ns1:TAG1><ns1:NewElement>new text</ns1:NewElement></ns1:ROOT>") {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_createElementNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_createElementNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_createElementNS


function domDocument_getElementById() {
  /*****************************************************************************
  function: domDocument_getElementById

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentGetElementById

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1 id=\"foo\">"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("foo");
 
 //the following should be
 //<TAG1 id="foo">
 //Hello
 //</TAG1>
 if (tag1.getXML() != "<TAG1 id=\"foo\">Hello</TAG1>") {
    pass = false;
 }

 //now add a new DOMElement to the document
 var newElem = domDoc.createElement("NEWELEM");
 docRoot.appendChild(newElem);

 //add an id element to the new element so it
 //can be found later using getElementById
 var newAttr = domDoc.createAttribute("id");
 newAttr.setNodeValue("newid");
 newElem.setAttributeNode(newAttr);

 //add a text node to the new element
 var newText = domDoc.createTextNode("new text");
 newElem.appendChild(newText);

 //get the element I just added by searching
 //on its ID
 var newElem = domDoc.getElementById("newid");

 //the following should be
 //<NEWELEM id="newid">
 //new text
 //</NEWELEM>
 if (newElem.getXML() != "<NEWELEM id=\"newid\">new text</NEWELEM>") {
    pass = false;
 }

 //now remove tag1
 docRoot.removeChild(tag1);

 //try to search for tag1
 //it should not be found
 var noTag1Found = domDoc.getElementById("foo");
 
 //the following should show the alert
 if (noTag1Found != null) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_getElementById -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_getElementById -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_getElementById



function domDocument_importNode() {
  /*****************************************************************************
  function: domDocument_importNode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMDocument.html#DOMDocumentImportNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
 var xml
xml1 = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "<DEEPNODE>"
 + "Hello 1"
 + "</DEEPNODE>"
 + "</TAG1>"
 + "</ROOT>";
 
 
 var xml2;
 xml2 = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT2>"
 + "<TAG2>"
 + "Hello 2"
 + "</TAG2>"
 + "</ROOT2>";
 
 //instantiate the W3C DOM Parsers
 var parser1 = new DOMImplementation();
 var parser2 = new DOMImplementation();
 
 //load the XML into the parsers and get the DOMDocuments
 var domDoc1 = parser1.loadXML(xml1);
 var domDoc2 = parser2.loadXML(xml2);
 
 //get the root nodes
 var docRoot1 = domDoc1.getDocumentElement();
 var docRoot2 = domDoc2.getDocumentElement();
 
 //get tag1 of the first XML
 var tag1 = docRoot1.getElementsByTagName("TAG1").item(0);
 
 //try to append tag1 to the second xml
 //this should fail because the tag1 is
 //not part of the second XML document
 try {
    docRoot2.appendChild(tag1);
 }
 catch(e) {

  //I should have failed with a
  //failure code of
  //DOMException.WRONG_DOCUMENT_ERROR
  //check to make sure
  if (e.code != DOMException.WRONG_DOCUMENT_ERR) {
     pass = false;
  }
 }

 //to add nodes that originate from different
 //documents, use the importNode method
 //Also, send true to the deep argument

 //so that all the child nodes are imported
 //as well.
 
 var nodeToImport = domDoc2.importNode(tag1, true);
 
 //nodeToImport can now be added to the second document
 
 docRoot2.appendChild(nodeToImport);
 
 //the following should be
 //<?xml version="1.0"?>
 //<ROOT2>
 //<TAG2>
 //Hello 2
 //</TAG2>
 //<TAG1>
 //<DEEPNODE>
 //Hello 1
 //</DEEPNODE>
 //</TAG1>
 //</ROOT2>
 if (domDoc2.getXML() != "<?xml version=\"1.0\" ?><ROOT2><TAG2>Hello 2</TAG2><TAG1><DEEPNODE>Hello 1</DEEPNODE></TAG1></ROOT2>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domDocument_importNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domDocument_importNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domDocument_importNode






/********************************************************************************************

                                    DOMElement Tests

*********************************************************************************************/








function domElement_getTagName() {
  /*****************************************************************************
  function: domElement_getTagName

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementGetTagName

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<ns1:TAG1 xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //the following should be "ROOT"
 if (docRoot.getTagName() != "ROOT") {
    pass = false;
 }

 //get the TAG1 node (with its namespace information)
 var tag1 = docRoot.getFirstChild();

 //the following should be "ns1:TAG1"
 if (tag1.getTagName() != "ns1:TAG1" ) {
    pass = false;
 }



 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_getTagName -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_getTagName -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_getTagName


function domElement_getAttribute() {
  /*****************************************************************************
  function: domElement_getAttribute

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementGetAttribute

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //the following should be "fooValue"
 if (tag1.getAttribute("foo") != "fooValue" ) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_getAttribute -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_getAttribute -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_getAttribute


function domElement_setAttribute() {
  /*****************************************************************************
  function: domElement_setAttribute

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementSetAttribute

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get TAG1
 var tag1 = rootNode.getFirstChild();
 
 //the following should be "fooValue"
 if (tag1.getAttribute("foo") != "fooValue" ) {
    pass = false;
 }

 //set the "foo" attribute's value to "newFooValue"
 tag1.setAttribute("foo", "newFooValue");

 //create a new attribute called "newAttrib"
 //with a value of "newAttribValue"
 tag1.setAttribute("newAttrib", "newAttribValue");

 //the following should be
 //"<TAG1 foo="newFooValue" newAttrib="newAttribValue">
 //Hello World
 //</TAG1>"
 if (tag1.getXML() != "<TAG1 foo=\"newFooValue\" newAttrib=\"newAttribValue\">Hello World</TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_setAttribute -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_setAttribute -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_setAttribute


function domElement_removeAttribute() {
  /*****************************************************************************
  function: domElement_removeAttribute

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementRemoveAttribute

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get TAG1
 var tag1 = rootNode.getFirstChild();
 
 //the following should be "fooValue"
 if (tag1.getAttribute("foo") != "fooValue") {
    pass = false;
 }

 //remove the "foo" attribute
 var retVal = tag1.removeAttribute("foo");

 //the following should be "fooValue"
 if (retVal.getValue() != "fooValue" ) {
    pass = false;
 }

 //the following should be
 //<TAG1>
 //Hello World
 //</TAG1>
 if (tag1.getXML() != "<TAG1>Hello World</TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_removeAttribute -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_removeAttribute -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_removeAttribute


function domElement_getAttributeNode() {
  /*****************************************************************************
  function: domElement_getAttributeNode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementGetAttributeNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //get the DOMAttr that represents the "foo" attribute
 var domAttr = tag1.getAttributeNode("foo");
 
 //the following should be "fooValue"
 if (domAttr.getValue() != "fooValue" ) {
    pass = false;
 }

 //search for an attribute that does not exist
 var notThere = tag1.getAttributeNode("notThere");

 //notThere should be null
 if (notThere != null) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_getAttributeNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_getAttributeNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_getAttributeNode


function domElement_setAttributeNode() {
  /*****************************************************************************
  function: domElement_setAttributeNode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementSetAttributeNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new DOMAttr node
 var newAttribute = domDoc.createAttribute("attribute");
 
 //set the attribute's value
 newAttribute.setNodeValue("value1");
 
 //add the attribute to the DOMElement
 var retVal = tag1.setAttributeNode(newAttribute);
 
 //retVal should be null since the
 //attribute did not replace another in the
 //DOMElement
 if (retVal != null) {
    pass = false;
 }
 
 //create another attribute, with the same name
 var newAttribute2 = domDoc.createAttribute("attribute");
 
 //set it's value
 newAttribute2.setNodeValue("value2");
 
 //now add this new attribute to the DOMElement
 //it should replace the first DOMAttr and return it
 retVal = tag1.setAttributeNode(newAttribute2);
 
 //make sure we got the correct DOMAttr back and that
 //the document has been correctly modified
 //the DOMAttr we get back should be newAttribute
 
 if (retVal != newAttribute) {
    pass = false;
 }
 
 //the following should be
 //<?xml version="1.0"?>
 //<ROOT>
 //<TAG1 attribute="value2">
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1 attribute=\"value2\">Hello</TAG1></ROOT>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_setAttributeNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_setAttributeNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_setAttributeNode


function domElement_removeAttributeNode() {
  /*****************************************************************************
  function: domElement_removeAttributeNode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementRemoveAttributeNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //get the DOMAttr that represents the "foo" attribute
 var domAttr = tag1.getAttributeNode("foo");
 
 //now remove it from the DOMElement
 var retVal = tag1.removeAttributeNode(domAttr);
 
 //retVal is the removed attribute, in this
 //case it should be equal to domAttr. Check and
 //make sure this is true
 
 if (retVal != domAttr) {
    pass = false;
 }
 
 //with the attribute removed,
 //the following should be
 //<TAG1>
 //Hello World
 //</TAG1>
 if (tag1.getXML() != "<TAG1>Hello World</TAG1>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_removeAttributeNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_removeAttributeNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_removeAttributeNode


function domElement_hasAttribute() {
  /*****************************************************************************
  function: domElement_hasAttribute

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementHasAttribute

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ROOT id=\"root\">"
 + "<TAG1 foo=\"fooValue\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE by its id
 var rootNode = domDoc.getElementById("root");
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //the following should be "true"
 if (tag1.hasAttribute("foo") != true) {
    pass = false;
 }

 //the following should be "false"
 if (tag1.hasAttribute("notThere") != false ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_hasAttribute -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_hasAttribute -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_hasAttribute


function domElement_getAttributeNS() {
  /*****************************************************************************
  function: domElement_getAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementGetAttributeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1 ns1:foo=\"fooValue\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE 
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //get the attribute value in the
 //http://xmljs.sf.net/ns1 namespace with the
 //local name of "foo"
 var ns1 = "http://xmljs.sf.net/ns1";
 var retVal = tag1.getAttributeNS(ns1, "foo");
 
 //the following should be "fooValue"
 if (retVal != "fooValue" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_getAttributeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_getAttributeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_getAttributeNS


function domElement_setAttributeNS() {
  /*****************************************************************************
  function: domElement_setAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementSetAttributeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1 ns1:foo=\"origValue\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE 
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //the following should be "origValue"
 var ns1="http://xmljs.sf.net/ns1";
 if (tag1.getAttributeNS(ns1, "foo") != "origValue" ) {
    pass = false;
 }
 
 //now update that attribute with a new value
 tag1.setAttributeNS(ns1, "ns1:foo", "newFooValue");
 
 //the following should be "newFooValue"
 if (tag1.getAttributeNS(ns1, "foo") != "newFooValue") {
    pass = false;
 }
 
 //add a new attribute in the ns1 namespace
 tag1.setAttributeNS(ns1, "ns1:newAttribute", "newAttributeValue");
 
 //confirm everything went OK.
 
 //the following should be "newAttributeValue"
 if (tag1.getAttributeNS(ns1, "newAttribute") != "newAttributeValue" ) {
    pass = false;
 }

 //with the attribute added,
 //the following should be
 //<ns1:TAG1 ns1:foo="newFooValue" ns1:newAttribute="newAttributeValue">
 //Hello World
 //</ns1:TAG1>
 if (tag1.getXML() != "<ns1:TAG1 ns1:foo=\"newFooValue\" ns1:newAttribute=\"newAttributeValue\">Hello World</ns1:TAG1>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_setAttributeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_setAttributeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_setAttributeNS


function domElement_removeAttributeNS() {
  /*****************************************************************************
  function: domElement_removeAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementRemoveAttributeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1 ns1:foo=\"origValue\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE 
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //remove the "ns1:foo" attribute
 var ns1 = "http://xmljs.sf.net/ns1";
 tag1.removeAttributeNS(ns1, "foo");
 
 //with the attribute removed,
 //the following should be
 //<ns1:TAG1>
 //Hello World
 //</ns1:TAG1>
 if (tag1.getXML() != "<ns1:TAG1>Hello World</ns1:TAG1>" ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_removeAttributeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_removeAttributeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_removeAttributeNS


function domElement_getAttributeNodeNS() {
  /*****************************************************************************
  function: domElement_getAttributeNodeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementGetAttributeNodeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1 ns1:foo=\"fooValue\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //get the attribute value in the
 //http://xmljs.sf.net/ns1 namespace with the
 //local name of "foo"
 var ns1 = "http://xmljs.sf.net/ns1";
 var domAttrNS = tag1.getAttributeNodeNS(ns1, "foo");
 
 //the following should be "fooValue"
 if (domAttrNS.getValue() != "fooValue" ) {
    pass = false;
 }

 //search for an attribute that does not exist
 var notThere = tag1.getAttributeNodeNS(ns1, "notThere");

 //notThere should be null
 if (notThere != null) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_getAttributeNodeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_getAttributeNodeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_getAttributeNodeNS


function domElement_setAttributeNodeNS() {
  /*****************************************************************************
  function: domElement_setAttributeNodeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementSetAttributeNodeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1>"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 //create a new attribute in the ns1 namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var newAttr1 = domDoc.createAttributeNS(ns1, "ns1:newAttr");
 
 //set the attribute's value
 newAttr1.setNodeValue("newAttrValue1");
 
 //add it to the DOMElement
 var retVal = tag1.setAttributeNodeNS(newAttr1);
 
 //since the new attribute didn't replace an
 //existing attribute, the retVal should be null
 if (retVal != null) {
    pass = false;
 }
 
 //now create another new attribute
 var newAttr2 = domDoc.createAttributeNS(ns1, "ns1:newAttr");
 
 //set the attribute's value
 newAttr2.setNodeValue("newAttrValue2");
 
 //now replace the existing attribute "ns1:newAttr"
 //with the new attribute we just created
 
 retVal = tag1.setAttributeNodeNS(newAttr2);
 
 //since we replaced a node, the retVal should be equal to newAttr1
 //(the replaced node was the first attribute
 //we created)
 if (retVal != newAttr1) {
    pass = false;
 }

 //the following should be
 //"<ns1:TAG1 ns1:newAttr="newAttrValue2">
 //Hello World
 //</ns1:TAG1>
 if (tag1.getXML() != "<ns1:TAG1 ns1:newAttr=\"newAttrValue2\">Hello World</ns1:TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_setAttributeNodeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_setAttributeNodeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_setAttributeNodeNS



function domElement_hasAttributeNS() {
  /*****************************************************************************
  function: domElement_hasAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMElement.html#DOMElementHasAttributeNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\" ?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1 ns1:foo=\"fooValue\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get ROOTNODE
 var rootNode = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = rootNode.getFirstChild();
 
 var ns1 = "http://xmljs.sf.net/ns1";
 
 //the following should be "true"
 if (tag1.hasAttributeNS(ns1, "foo") != true ) {
    pass = false;
 }

 //the following should be "false"
 if (tag1.hasAttributeNS(ns1, "notThere") != false ) {
    pass = false;
 }

 //the following should be "false"
 if (tag1.hasAttributeNS("badNamespaceURI", "foo") != false ) {
    pass = false;
 }
 
 //the following should be "false"
 //(the attribute name should be a localName, not a QName
 if (tag1.hasAttributeNS(ns1, "ns1:foo") != false ) {
    pass = false;
 }
 

 if (pass == true) {
    newOpt = getTestSuccessOption ("domElement_hasAttributeNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domElement_hasAttributeNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domElement_hasAttributeNS




/********************************************************************************************

                                    DOMException Tests

*********************************************************************************************/



function domException_indexSizeErr() {
  /*****************************************************************************
  function: domElement_hasAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#index_size_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //The following should raise a DOMException.INDEX_SIZE_ERR
 try {
  alert(textNode.substringData(15, 5))
  //if I got here, we failed
  pass = false;
 }
 catch (e) {
  if (e.code != DOMException.INDEX_SIZE_ERR) {
    pass = false;
  }

 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_indexSizeErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_indexSizeErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_indexSizeErr


function domException_hierarchyRequestErr() {
  /*****************************************************************************
  function: domException_hierarchyRequestErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#hierarchy_request_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //The following should raise a DOMException.HIERARCHY_REQUEST_ERR
 try {
    tag1.insertBefore(tag1, docRoot );
    //if I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.HIERARCHY_REQUEST_ERR) {
        pass = false;
    }
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_hierarchyRequestErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_hierarchyRequestErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_hierarchyRequestErr


function domException_wrongDocumentErr() {
  /*****************************************************************************
  function: domException_wrongDocumentErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#wrong_document_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml1;
 xml1 = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "<DEEPNODE>"
 + "Hello 1"
 + "</DEEPNODE>"
 + "</TAG1>"
 + "</ROOT>";
 
 
 var xml2;
 xml2 = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT2>"
 + "<TAG2>"
 + "Hello 2"
 + "</TAG2>"
 + "</ROOT2>";
 
 //instantiate the W3C DOM Parsers
 var parser1 = new DOMImplementation();
 var parser2 = new DOMImplementation();
 
 //load the XML into the parsers and get the DOMDocuments
 var domDoc1 = parser1.loadXML(xml1);
 var domDoc2 = parser2.loadXML(xml2);
 
 //get the root nodes
 var docRoot1 = domDoc1.getDocumentElement();
 var docRoot2 = domDoc2.getDocumentElement();
 
 //get tag1 of the first XML
 var tag1 = docRoot1.getElementsByTagName("TAG1").item(0);
 
 //try to append tag1 to the second xml
 //this should fail because the tag1 is
 //not part of the second XML document
 //The following should raise a DOMException.WRONG_DOCUMENT_ERR
 try {
    docRoot2.appendChild(tag1);
    //if I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.WRONG_DOCUMENT_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_wrongDocumentErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_wrongDocumentErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_wrongDocumentErr


function domException_invalidCharacterErr() {
  /*****************************************************************************
  function: domException_invalidCharacterErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#invalid_character_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //The following should raise a DOMException.INVALID_CHARACTER_ERR
 //because element names cannot contain the "*" character
 try {
    domDoc.createElement("***");
    //if I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.INVALID_CHARACTER_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_invalidCharacterErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_invalidCharacterErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_invalidCharacterErr


function domException_noModificationAllowedErr() {
  /*****************************************************************************
  function: domElement_hasAttributeNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#no_modification_allowed_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello" text node
 var textNode = tag1.getFirstChild();
 
 //set the textNode's internal read-only property
 textNode._readonly = true;
 
 //The following should raise a DOMException.NO_MODIFICATION_ALLOWED_ERR
 try {
    textNode.setNodeValue("foo");
    //If I've got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.NO_MODIFICATION_ALLOWED_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_noModificationAllowedErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_noModificationAllowedErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_noModificationAllowedErr


function domException_notFoundErr() {
  /*****************************************************************************
  function: domException_notFoundErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#not_found_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //The following should raise a DOMException.NOT_FOUND_ERR
 //because there is no DOMAttr with the name of "typo"
 try {
    namedNodeMap.removeNamedItem("typo");
    //If I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.NOT_FOUND_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_notFoundErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_notFoundErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_notFoundErr


function domException_inuseAttributeErr() {
  /*****************************************************************************
  function: domException_inUseAttributeErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#in_use_attribute_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");
 
 //The following should raise a DOMException.INUSE_ATTRIBUTE_ERR
 //because fooNode cannot be added to the docRoot's 
 //DOMNamedNodeMap without first being cloned
 try {
    docRoot.getAttributes().setNamedItem(fooNode);
    //if I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.INUSE_ATTRIBUTE_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_inUseAttributeErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_inUseAttributeErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_inUseAttributeErr




function domException_syntaxErr() {
  /*****************************************************************************
  function: domException_syntaxErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#syntax_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "<ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //The following should raise a DOMException.SYNTAX_ERR
 //because ROOTNODE is not closed properly
 try {
    var domDoc = parser.loadXML(xml);
    //If I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.SYNTAX_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_syntaxErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_syntaxErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_syntaxErr


function domException_namespaceErr() {
  /*****************************************************************************
  function: domException_namespaceErr

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMException.html#namespace_error

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "<ns1:TAG1>"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //The following should raise a DOMException.NAMESPACE_ERR
 //because the prefix is null (nothing before the ":")
 try {
    var nsFoo = "http://xmljs.sf.net/foo";
    var newNode = domDoc.createElementNS(nsFoo, ":ElementName");
    //If I got here, we've failed
 }
 catch (e) {
    if (e.code != DOMException.NAMESPACE_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domException_namespaceErr -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domException_namespaceErr -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domException_namespaceErr




/********************************************************************************************

                                    DOMImplementation Tests

*********************************************************************************************/





function domImplementation_preserveWhiteSpace() {
  /*****************************************************************************
  function: domImplementation_preserveWhiteSpace

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationpreserveWhiteSpace

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + " Hello World "
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 parser.preserveWhiteSpace = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the first "TAG1" element
 var firstTag1 = docRoot.getElementsByTagName("TAG1").item(0);


 if (firstTag1.getFirstChild().getNodeValue() != " Hello World ") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domImplementation_preserveWhiteSpace -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_preserveWhiteSpace -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domImplementation_preserveWhiteSpace



function domImplementation_namespaceAware() {
  /*****************************************************************************
  function: domImplementation_namespaceAware

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationnamespaceAware

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE "
 + "xmlns:ns1=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\">"
 + "<ns1:TAG1>"
 + "ns1 Hello world"
 + "</ns1:TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ns1:ROOTNODE>";
 

 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the ns1 "TAG1" element
 var ns1 = "http://xmljs.sf.net/ns1";
 var ns1Tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);

 //the following should be "ns1 Hello world"
 if (ns1Tag1.getFirstChild().getNodeValue() != "ns1 Hello world") {
    pass = false;
 }

 //get the ns2 "TAG1" element
 var ns2 = "http://xmljs.sf.net/ns2";
 var ns2Tag1 = docRoot.getElementsByTagNameNS(ns2, "TAG1").item(0);

 //the following should be "ns2 Hello world"
 if (ns2Tag1.getFirstChild().getNodeValue() != "ns2 Hello world") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domImplementation_namespaceAware -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_namespaceAware -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domImplementation_namespaceAware




function domImplementation_loadXML() {
  /*****************************************************************************
  function: domImplementation_loadXML

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationloadXML

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 parser.preserveWhiteSpace = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the first "TAG1" element
 var firstTag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //display the data
 //it should be "Hello World"
 if (firstTag1.getFirstChild().getNodeValue() != "Hello World") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domImplementation_loadXML -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_loadXML -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domImplementation_loadXML



function domImplementation_translateErrCode() {
  /*****************************************************************************
  function: domImplementation_translateErrCode

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationTranslateError

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //The following should raise a DOMException.INDEX_SIZE_ERR
 try {
    var x = textNode.substringData(15, 5);
    //If I got here, we've failed
    pass = false;
 }
 catch (e) {
    if (e.code != DOMException.INDEX_SIZE_ERR) {
        pass = false;
    }
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domImplementation_translateErrCode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_translateErrCode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domImplementation_translateErrCode


function domImplementation_escapeString() {
  /*****************************************************************************
  function: domImplementation_escapeString

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationEscapeString

  *****************************************************************************/
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 var newOpt;

 //The following should be &-<->-"-'
 var result = parser.escapeString("&-<->-\"-'");

 if (result == "&amp;-&lt;-&gt;-&quot;-&apos;") {
    newOpt = getTestSuccessOption ("domImplementation_escapeString -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_escapeString -- Failure");
 }

 insertOptionElement(newOpt);

} // end function domImplementation_escapeString


function domImplementation_unescapeString() {
  /*****************************************************************************
  function: domImplementation_unescapeString

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMImplementation.html#DOMImplementationEscapeString

  *****************************************************************************/
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 var newOpt;

 //The following should be &-<->-"-'
 var result = parser.unescapeString("&amp;-&lt;-&gt;-&quot;-&apos;");


 if (result == "&-<->-\"-'") {
    newOpt = getTestSuccessOption ("domImplementation_unescapeString -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domImplementation_unescapeString -- Failure");
 }

 insertOptionElement(newOpt);



} // end function domImplementation_unescapeString


/********************************************************************************************

                                    DOMNamedNodeMap Tests

*********************************************************************************************/



function domNamedNodeMap_getNamedItem() {
  /*****************************************************************************
  function: domNamedNodeMap_getNamedItem

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#getNamedItem

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo"
 var fooNode = namedNodeMap.getNamedItem("foo");
 
 //the following should be "goo"
 if (fooNode.getValue() != "goo" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_getNamedItem -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_getNamedItem -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_getNamedItem


function domNamedNodeMap_setNamedItem() {
  /*****************************************************************************
  function: domNamedNodeMap_setNamedItem

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#setNamedItem

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 //create a new DOMAttr object
 var newAttribute = domDoc.createAttribute("attribute");
 newAttribute.setNodeValue("value");
 
 //add the new attribute to the DOMNamedNodeMap
 var retVal = namedNodeMap.setNamedItem(newAttribute);
 
 //retVal should be null
 if (retVal != null) {
    pass = false;
 }

 //create another new DOMAttr object,
 //this time with a name of an attribute already
 //in the DOMNamedNodeMap
 var fooAttribute = domDoc.createAttribute("foo");
 fooAttribute.setNodeValue("newFoo");

 //add the new attribute to the DOMNamedNodeMap
 //This will actually replace the original foo
 //attribute with the new attribute
 var retVal = namedNodeMap.setNamedItem(fooAttribute);

 //retVal.getValue() should be "goo"
 if (retVal.getValue() != "goo") {
    pass = false;
 }

 //the following should be
 //<TAG1 foo="newFoo" id="tag1_id" attribute="value">
 //Hello World
 //</TAG1>

 if (tag1.getXML() != "<TAG1 foo=\"newFoo\" id=\"tag1_id\" attribute=\"value\">Hello World</TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_setNamedItem -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_setNamedItem -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_setNamedItem


function domNamedNodeMap_removeNamedItem() {
  /*****************************************************************************
  function: domNamedNodeMap_removeNamedItem

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#removeNamedItem

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //remove the "foo" attribute
 var retVal = namedNodeMap.removeNamedItem("foo");
 
 //the following should be "goo"
 if (retVal.getValue() != "goo") {
    pass = false;
 }

 //the following should be
 //<TAG1 id="tag1_id">Hello World</TAG1>
 if (tag1.getXML() != "<TAG1 id=\"tag1_id\">Hello World</TAG1>") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_removeNamedItem -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_removeNamedItem -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_removeNamedItem


function domNamedNodeMap_getNamedItemNS() {
  /*****************************************************************************
  function: domNamedNodeMap_getNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#getNamedItemNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "<ns1:TAG1 ns1:foo=\"goo\" id=\"tag1_id\">"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the DOMAttr node with the name of "foo" in the ns1 namespace
 var ns1="http://xmljs.sf.net/ns1";
 var fooAttr = namedNodeMap.getNamedItemNS(ns1, "foo");
 
 //the following should be "goo"
 if (fooAttr.getValue() != "goo" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_getNamedItemNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_getNamedItemNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_getNamedItemNS


function domNamedNodeMap_setNamedItemNS() {
  /*****************************************************************************
  function: domNamedNodeMap_setNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#setNamedItemNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "<ns1:TAG1 ns1:foo=\"goo\" >"
 + "Hello"
 + "</ns1:TAG1>"
 + "</ns1:ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node
 var docRoot = domDoc.getDocumentElement();

 //find tag1 by searching by name and namespace
 var ns1="http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);

 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();

 //create a new DOMAttr node with
 //the ns1 namespace
 var newAttribute = domDoc.createAttributeNS(ns1, "ns1:att");
 newAttribute.setNodeValue("val");

 //append the new attribute
 var retVal = namedNodeMap.setNamedItemNS(newAttribute);

 //retVal should be null
 if (retVal != null) {
    pass = false;
 }

 //now create a new DOMAttr node with
 //the ns1 namespace that will replace ns1:foo
 var ns1="http://xmljs.sf.net/ns1";
 var newFooAttr = domDoc.createAttributeNS(ns1, "ns1:foo");
 newFooAttr.setNodeValue("newFoo");

 //in this case newFooAttr will replace the original ns1:foo
 //the original ns1:foo will be returned
 var retVal = namedNodeMap.setNamedItemNS(newFooAttr);

 //the following should be "goo" since the replaced node
 //will be returned to us
 if (retVal.getValue() != "goo" ) {
    pass = false;
 }

 //the following should be
 //<ns1:TAG1 ns1:foo="newFoo" ns1:att="val">Hello</ns1:TAG1>
 if (tag1.getXML() != "<ns1:TAG1 ns1:foo=\"newFoo\" ns1:att=\"val\">Hello</ns1:TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_setNamedItemNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_setNamedItemNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_setNamedItemNS


function domNamedNodeMap_removeNamedItemNS() {
  /*****************************************************************************
  function: domNamedNodeMap_removeNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNamedNodeMap.html#removeNamedItemNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "<ns1:TAG1 ns1:foo=\"goo\" id=\"tag1_id\" >"
 + "Hello World"
 + "</ns1:TAG1>"
 + "</ns1:ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();

 //remove the foo node
 var ns1 = "http://xmljs.sf.net/ns1";
 var retVal = namedNodeMap.removeNamedItemNS(ns1, "foo");

 //the following should be "goo" since the removed
 //node will be returned to us
 if (retVal.getValue() != "goo" ) {
    pass = false;
 }

 //the following should be
 //<ns1:TAG1 id="tag1_id">Hello World</ns1:TAG1>
 if (tag1.getXML() != "<ns1:TAG1 id=\"tag1_id\">Hello World</ns1:TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNamedNodeMap_removeNamedItemNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNamedNodeMap_removeNamedItemNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNamedNodeMap_removeNamedItemNS





/********************************************************************************************

                                    DOMNode Tests

*********************************************************************************************/





function domNode_getNodeName1() {
  /*****************************************************************************
  function: domNode_getNodeName1

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenodeName

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //the following should be "ROOTNODE"
 if (docRoot.getNodeName() != "ROOTNODE") {
    pass = false;
 }

 //the following should be "attribute"
 if (docRoot.getAttributeNode("attribute").getNodeName() != "attribute" ) {
    pass = false;
 }

 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);

 //the following should be "#cdata-section"
 if (tag1.childNodes.item(2).getNodeName() != "#cdata-section") {
    pass = false;
 }

 //the following should be "#comment"
 if (tag1.childNodes.item(1).getNodeName() != "#comment") {
    pass = false;
 }

 //the following should be "#document"
 if (domDoc.nodeName != "#document") {
    pass = false;
 }

 //the following should be "#document-fragment"
 if (domDoc.createDocumentFragment().getNodeName() != "#document-fragment") {
    pass = false;
 }

 //the following should be "TAG1"
 if (tag1.getNodeName() != "TAG1") {
    pass = false;
 }

 //the following should be "xml"
 if (domDoc.firstChild.getNodeName() != "xml") {
    pass = false;
 }

 //the following should be "#text"
 if (tag1.firstChild.getNodeName() != "#text" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNodeName1 -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNodeName1 -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNodeName1


function domNode_getNodeName2() {
  /*****************************************************************************
  function: domNode_getNodeName

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenodeName

  *****************************************************************************/
 var pass = true;
 var newOpt;

var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ROOTNODE "
 + "xmlns=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\" >"
 + "<TAG1>"
 + "ns1 Hello world"
 + "</TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ROOTNODE>";
 
 
//instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);

 //get the root node
 var docRoot = domDoc.getDocumentElement();

 //get the DOMNodeList for TAG1 with the ns1 (default) namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);

 //the following should be "TAG1"
 //because that DOMElement's name is not a QName
 //(because it is in the default namespace)
 if (tag1.getNodeName() != "TAG1" ) {
    pass = false;
 }

 //get the DOMNodeList for TAG1 with the ns2 namespace
 var ns2 = "http://xmljs.sf.net/ns2";
 var tag1 = docRoot.getElementsByTagNameNS(ns2, "TAG1").item(0);

 //the following should be "ns2:TAG1"
 //because that DOMElement is not in the default namespace
 if (tag1.getNodeName() != "ns2:TAG1") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNodeName2 -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNodeName2 -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNodeName2



function domNode_getNodeValue() {
  /*****************************************************************************
  function: domNode_getNodeValue

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenodeValue

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //the following should be "attributeValue"
 if (docRoot.getAttributeNode("attribute").getNodeValue() != "attributeValue" ) {
    pass = false;
 }

 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);

 //the following should be "this child is of <<<>nodeType CDATA"
 if (tag1.getChildNodes().item(2).getNodeValue() != "this child is of <<<>nodeType CDATA" ) {
    pass = false;
 }

 //the following should be "comment"
 if (tag1.getChildNodes().item(1).getNodeValue() != "comment" ) {
    pass = false;
 }

 //the following should be 'version="1.0"'
 if (domDoc.getFirstChild().getNodeValue() != "version=\"1.0\"") {
    pass = false;
 }

 //the following should be "Hello World"
 if (tag1.getFirstChild().getNodeValue() != "Hello World" ) {
    pass = false;
 }



 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNodeValue -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNodeValue -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNodeValue



function domNode_setNodeValue() {
  /*****************************************************************************
  function: domNode_setNodeValue

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodesetNodeValue

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //the following should be "attributeValue"
 if (docRoot.getAttributes().getNamedItem("attribute").getNodeValue() != "attributeValue") {
    pass = false;
 }
 
 //set the attribute's value to "First New Value"
 docRoot.getAttributes().getNamedItem("attribute").setNodeValue("First New Value");
 
 //the following should be "First New Value"
 if (docRoot.getAttributes().getNamedItem("attribute").getNodeValue() != "First New Value") {
    pass = false;
 }

 //set the attribute's value to "Second New Value"
 //via the container node's setAttribute method
 docRoot.setAttribute("attribute", "Second New Value");

 //the following should be "Second New Value"
 if (docRoot.getAttributes().getNamedItem("attribute").getNodeValue() != "Second New Value") {
    pass = false;
 }

 //now get the CharacterData under the TAG1 Element

 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);

 //the following should be "Hello World"
 if (tag1.getFirstChild().getNodeValue() != "Hello World") {
    pass = false;
 }

 //set the node value and data properties using the setNodeValue helper function
 //DO NOT set nodeValue or data directly
 tag1.getFirstChild().setNodeValue("New Hello World");

 //the following should be "New Hello World"
 if (tag1.getFirstChild().getNodeValue() != "New Hello World" ) {
    pass = false;
 }

 if (tag1.getFirstChild().getData() != "New Hello World" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_setNodeValue -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_setNodeValue -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_setNodeValue



function domNode_getNodeType() {
  /*****************************************************************************
  function: domNamedNodeMap_removeNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenodeType

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be 1
 if (tag1.getNodeType() != 1) {
    pass = false;
 }

 //the following should be 2
 if (tag1.attributes.getNamedItem("foo").getNodeType() != 2 ) {
    pass = false;
 }

 //the following should be 3
 if (tag1.childNodes.item(0).getNodeType() != 3 ) {
    pass = false;
 }

 //the following should be 4
 if (tag1.childNodes.item(2).getNodeType() != 4 ) {
    pass = false;
 }

 //the following should be 7
 if (tag1.childNodes.item(3).getNodeType() != 7 ) {
    pass = false;
 }

 //the following should be 8
 if (tag1.childNodes.item(1).getNodeType() != 8 ) {
    pass = false;
 }

 //the following should be 9
 if (domDoc.getNodeType() != 9 ) {
    pass = false;
 }

 //the following should be 11
 if (domDoc.createDocumentFragment().getNodeType() != 11 ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNodeType -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNodeType -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNodeType



function domNode_getParentNode() {
  /*****************************************************************************
  function: domNamedNodeMap_removeNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeparentNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 var retNode = tag1.getParentNode();
 
 //the following should be "ROOTNODE"
 if (retNode.nodeName != "ROOTNODE") {
    pass = false;
 }

 retNode = tag1.childNodes.item(1).getParentNode();
 //the following should be "TAG1"
 if (retNode.getNodeName() != "TAG1" ) {
    pass = false;
 }

 //the following should be null (attributes cannot have parents)
 if (tag1.attributes.getNamedItem("foo").getParentNode() != null ) {
    pass = false;
 }

 //attributes can, however, have owner Elements
 //the following should be "TAG1"
 if (tag1.attributes.getNamedItem("foo").getOwnerElement().getNodeName() != "TAG1" ) {
    pass = false;
 }

 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getParentNode -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getParentNode -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getParentNode



function domNode_getChildNodes() {
  /*****************************************************************************
  function: domNode_getChildNodes

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodechildNodes

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<?hello world ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get a DOMNodeList consisting of "TAG1" elements
 domNodeListTag1s = docRoot.getElementsByTagName("TAG1");
 
 //get the number of nodes in the
 //domNodeListTag1s DOMNodeList
 //the following should be 1
 if (domNodeListTag1s.getLength() != 1) {
    pass = false;
 }

 //get the TAG1 element from the domNodeListsTag1s DOMNodeList
 //using the DOMNodeList item method. The item method
 //is zero-based, so the node we're interested in would be
 //node 0 since the length of the DOMNodeList object was 1
 var tag1 = domNodeListTag1s.item(0);

 //call getChildNodes to get another DOMNodeList object
 //NOTE: getChildNodes does *not* return an array.
 //It returns a DOMNodeList object
 var domNodeList = tag1.getChildNodes();

 //call the getLength method of the DOMNodeList object
 //the following should be 4
 if (domNodeList.getLength() != 4 ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getChildNodes -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getChildNodes -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getChildNodes



function domNode_getFirstChild() {
  /*****************************************************************************
  function: domNode_getFirstChild

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodefirstChild

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be "Hello World"
 if (tag1.getFirstChild().getNodeValue() != "Hello World" ) {
    pass = false;
 }

 //the following should also be "Hello World"
 if (tag1.getChildNodes().item(0).getNodeValue() != "Hello World" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getFirstChild -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getFirstChild -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getFirstChild



function domNode_getLastChild() {
  /*****************************************************************************
  function: domNode_getLastChild

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodelastChild

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "Hi!"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be "Hi!"
 if (tag1.getLastChild().getNodeValue() != "Hi!" ) {
    pass = false;
 }

 //the following should also be "Hi!"
 var lastChildIndex = tag1.getChildNodes().getLength() -1;
 if (tag1.getChildNodes().item(lastChildIndex).getNodeValue() != "Hi!" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getLastChild -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getLastChild -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getLastChild



function domNode_getPreviousSibling() {
  /*****************************************************************************
  function: domNode_getPreviousSibling

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodepreviousSibling

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //item(1) is the comment. The previousSibling of the
 //comment is "Hello World" so
 //the following should be "Hello world"
 if (tag1.getChildNodes().item(1).getPreviousSibling().getNodeValue() != "Hello World" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getPreviousSibling -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getPreviousSibling -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getPreviousSibling



function domNode_getNextSibling() {
  /*****************************************************************************
  function: domNode_getNextSibling

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenextSibling

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //item(0) is the "Hello World". The next sibling of the
 //"Hello World" is the comment so
 //the following should be "comment"
 if (tag1.getChildNodes().item(0).getNextSibling().getNodeValue() != "comment" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNextSibling -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNextSibling -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNextSibling



function domNode_getAttributes() {
  /*****************************************************************************
  function: domNode_getAttributes

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeattributes

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be "goo"
 if (tag1.getAttributes().getNamedItem("foo").getNodeValue() != "goo" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getAttributes -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getAttributes -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getAttributes



function domNode_getNamespaceURI() {
  /*****************************************************************************
  function: domNode_getNamespaceURI

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenamespaceURI

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE "
 + "xmlns:ns1=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\">"
 + "<ns1:TAG1>"
 + "ns1 Hello world"
 + "</ns1:TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ns1:ROOTNODE>";
 
//instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the DOMNodeList for TAG1 with the ns1 namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //the following should be "http://xmljs.sf.net/ns1"
 if (tag1.getNamespaceURI() != "http://xmljs.sf.net/ns1" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getNamespaceURI -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getNamespaceURI -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getNamespaceURI



function domNode_getPrefix() {
  /*****************************************************************************
  function: domNode_getPrefix

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeprefix

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE "
 + "xmlns:ns1=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\">"
 + "<ns1:TAG1>"
 + "ns1 Hello world"
 + "</ns1:TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ns1:ROOTNODE>";
 
//instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the DOMNodeList for TAG1 with the ns1 namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //the following should be "ns1"
 if (tag1.getPrefix() != "ns1" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getPrefix -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getPrefix -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getPrefix



function domNode_getLocalName() {
  /*****************************************************************************
  function: domNode_getLocalName

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodelocalName

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE "
 + "xmlns:ns1=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\">"
 + "<ns1:TAG1>"
 + "ns1 Hello world"
 + "</ns1:TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ns1:ROOTNODE>";
 
//instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the DOMNodeList for TAG1 with the ns1 namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //the following should be "ns1:TAG1"
 if (tag1.getNodeName() != "ns1:TAG1" ) {
    pass = false;
 }

 //the following should be "TAG1"
 if (tag1.getLocalName() != "TAG1" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getLocalName -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getLocalName -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getLocalName



function domNode_getOwnerDocument() {
  /*****************************************************************************
  function: domNode_getOwnerDocument

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeownerDocument

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE attribute=\"attributeValue\">"
 + "<TAG1 foo=\"goo\">"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<? hello ?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //tag1.getOwnerDocument should be domDoc
 if (tag1.getOwnerDocument() != domDoc) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getOwnerDocument -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getOwnerDocument -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getOwnerDocument



function domNode_insertBefore() {
  /*****************************************************************************
  function: domNamedNodeMap_removeNamedItemNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeinsertBefore

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new (TAG2) element
 var tag2 = domDoc.createElement("TAG2");
 
 //create a new DOMText node
 var text = domDoc.createTextNode("New");
 
 //append the TextNode to the new TAG2 element
 tag2.appendChild(text);
 
 //add TAG2 to the DOMDocument
 docRoot.insertBefore(tag2, tag1);
 
 //the following should be
 //"<?xml version=\"1.0\" ?>
 //<ROOT>
 //<TAG2>
 //New
 //</TAG2>
 //<TAG1>
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG2>New</TAG2><TAG1>Hello</TAG1></ROOT>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_insertBefore -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_insertBefore -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_insertBefore



function domNode_replaceChild() {
  /*****************************************************************************
  function: domNode_replaceChild

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodereplaceChild

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //get TAG1's "Hello" child
 var tag1HelloChild = tag1.getFirstChild();
 
 //create a new TextNode
 var newTextNode = domDoc.createTextNode("New Text Node");
 
 //replace TAG1's "Hello" child with the new child
 tag1.replaceChild(newTextNode, tag1HelloChild);
 
 //the following should be
 //"<?xml version=\"1.0\" ?>
 //<ROOT>
 //<TAG1>
 //New Text Node
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>New Text Node</TAG1></ROOT>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_replaceChild -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_replaceChild -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_replaceChild



function domNode_removeChild() {
  /*****************************************************************************
  function: domNode_removeChild

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNoderemoveChild

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "<!--remove me -->"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //get TAG1's comment child
 var tag1CommentChild = tag1.getChildNodes().item(1);
 
 //remove TAG1's comment child
 tag1.removeChild(tag1CommentChild);
 
 //the following should be
 //"<?xml version=\"1.0\" ?>
 //<ROOT>
 //<TAG1>
 //Hello
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>Hello</TAG1></ROOT>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_removeChild -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_removeChild -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_removeChild



function domNode_appendChild() {
  /*****************************************************************************
  function: domNode_appendChild

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeappendChild

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //create a new comment Node
 var newDOMComment = domDoc.createComment("new child comment");
 
 //append the new child to TAG1
 tag1.appendChild(newDOMComment);
 
 //the following should be
 //"<?xml version=\"1.0\"?>"
 //<ROOT>
 //<TAG1>
 //Hello
 //<!--new child comment-->
 //</TAG1>
 //</ROOT>"
 if (domDoc.getXML() != "<?xml version=\"1.0\" ?><ROOT><TAG1>Hello<!--new child comment--></TAG1></ROOT>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_appendChild -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_appendChild -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_appendChild



function domNode_hasChildNodes() {
  /*****************************************************************************
  function: domNode_hasChildNodes

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodehasChildNodes

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be "true"
 if (tag1.hasChildNodes() != true ) {
    pass = false;
 }

 //get the first child of tag1
 var firstChild = tag1.getFirstChild();

 //the following should be "false"
 if (firstChild.hasChildNodes() != false ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_hasChildNodes -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_hasChildNodes -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_hasChildNodes



function domNode_cloneNode1() {
  /*****************************************************************************
  function: domNode_cloneNode1

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodecloneNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1 name=\"value\">"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 var totalClone = tag1.cloneNode(true);
 var partialClone = tag1.cloneNode(false);
 
 //the following should be
 //"<TAG1 name="value">
 //Hello
 //</TAG1>"
 if (totalClone.getXML() != "<TAG1 name=\"value\">Hello</TAG1>" ) {
    pass = false;
 }

 //the following should be
 //"<TAG1 name="value">
 //</TAG1>"
 if (partialClone.getXML() != "<TAG1 name=\"value\"></TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_cloneNode1 -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_cloneNode1 -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_cloneNode1



function domNode_cloneNode2() {
  /*****************************************************************************
  function: domNode_cloneNode2

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodecloneNode

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOT xmlns:ns1=\"http://xmljs.sf.net/ns1\" >"
 + "<ns1:TAG1>"
 + "Hello"
 + "</ns1:TAG1>"
 + "</ns1:ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 var clone = tag1.cloneNode(true);
 
 //the following should be "ns1"
 if (clone.getPrefix() != "ns1" ) {
    pass = false;
 }

 //the following should be "http://xmljs.sf.net/ns1"
 if (clone.getNamespaceURI() != "http://xmljs.sf.net/ns1" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_cloneNode2 -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_cloneNode2 -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_cloneNode2



function domNode_getElementsByTagName() {
  /*****************************************************************************
  function: domNode_getElementsByTagName

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodegetElementsByTagName

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "<TAG2>"
 + "There"
 + "</TAG2>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the DOMNodeList for any element matching "TAG1"
 var tag1NodeList = docRoot.getElementsByTagName("TAG1");
 
 //get the DOMNodeList for any element matching "TAG2"
 var tag2NodeList = docRoot.getElementsByTagName("TAG2");
 
 //get the DOMNodeList for any element
 //NOTE: docRoot matches "*" as well and will be returned
 var allTagsNodeList = docRoot.getElementsByTagName("*");
 
 //the following should be 1
 if (tag1NodeList.getLength() != 1) {
    pass = false;
 }

 //the following should be 1
 if (tag2NodeList.getLength() != 1 ) {
    pass = false;
 }

 //the following should be 3
 if (allTagsNodeList.getLength() != 3 ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getElementsByTagName -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getElementsByTagName -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getElementsByTagName



function domNode_getElementsByTagNameNS() {
  /*****************************************************************************
  function: domNode_getElementsByTagNameNS

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodegetElementsByTagNameNS

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml =""
 
+ "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE "
 + "xmlns:ns1=\"http://xmljs.sf.net/ns1\" "
 + "xmlns:ns2=\"http://xmljs.sf.net/ns2\">"
 + "<ns1:TAG1>"
 + "ns1 Hello world"
 + "</ns1:TAG1>"
 + "<ns2:TAG1>"
 + "ns2 Hello world"
 + "</ns2:TAG1>"
 + "</ns1:ROOTNODE>";
 
//instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //namespaceAware is true by default
 //this line is here only for demonstration purposes
 parser.namespaceAware = true;
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the DOMNodeList for TAG1 with the ns1 namespace
 var ns1 = "http://xmljs.sf.net/ns1";
 var tag1 = docRoot.getElementsByTagNameNS(ns1, "TAG1").item(0);
 
 //the following should be "ns1 Hello world"
 if (tag1.getFirstChild().getNodeValue() != "ns1 Hello world" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getElementsByTagNameNS -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getElementsByTagNameNS -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getElementsByTagNameNS



function domNode_setPrefix() {
  /*****************************************************************************
  function: domNode_setPrefix

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodesetPrefix

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ns1:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\">"
 + "<ns1:TAG1>"
 + "Hello"
 + "</ns1:TAG1>"
 + "</ns1:ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //give the docRoot a new prefix - note that the namespaceURI
 //remains the same
 docRoot.setPrefix("foo");
 
 //the following should be
 //<foo:ROOTNODE xmlns:ns1="http://xmljs.sf.net/ns1" >
 //<ns1:TAG1>
 //Hello
 //</ns1:TAG1>
 //</foo:ROOTNODE>
 if (docRoot.getXML() != "<foo:ROOTNODE xmlns:ns1=\"http://xmljs.sf.net/ns1\" ><ns1:TAG1>Hello</ns1:TAG1></foo:ROOTNODE>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_setPrefix -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_setPrefix -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_setPrefix



function domNode_normalize() {
  /*****************************************************************************
  function: domNode_normalize

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodenormalize

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 var newTextNode = domDoc.createTextNode("There");
 tag1.appendChild(newTextNode);
 
 //the following should be 2
 if (tag1.getChildNodes().getLength() != 2 ) {
    pass = false;
 }

 tag1.normalize();

 //the following should be 1
 if (tag1.getChildNodes().getLength() != 1 ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_normalize -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_normalize -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_normalize



function domNode_isSupported() {
  /*****************************************************************************
  function: domNode_isSupported

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodeisSupported

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be "true"
 if (tag1.isSupported("core", "2.0") != true ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_isSupported -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_isSupported -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_isSupported



function domNode_getXML() {
  /*****************************************************************************
  function: domNode_getXML

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodegetXML

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //the following should be
 //"<TAG1>
 //Hello
 //</TAG1>"
 if (tag1.getXML() != "<TAG1>Hello</TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_getXML -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_getXML -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_getXML




function domNode_hasAttributes() {
  /*****************************************************************************
  function: domNode_hasAttributes

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNode.html#DOMNodehasAttributes

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + "Hello World"
 + "</TAG1>"
 + "<TAG1 foo=\"goo\" >"
 + "Hello World"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find the tag1 elements
 var tag1s = domDoc.getElementsByTagName("TAG1");
 
 //get the first tag1
 var firstTag1 = tag1s.item(0);
 
 //the following should be "false"
 if (firstTag1.hasAttributes() != false ) {
    pass = false;
 }

 //get the second tag1
 var secondTag1 = tag1s.item(1);

 //the following should be "true"
 if (secondTag1.hasAttributes() != true ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNode_hasAttributes -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNode_hasAttributes -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNode_hasAttributes






/********************************************************************************************

                                    DOMNodeList Tests

*********************************************************************************************/









function domNodeList_getLength() {
  /*****************************************************************************
  function: domNodeList_getLength

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNodeList.html#DOMNodeListGetLength

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + "Hello World"
 + "<!--comment-->"
 + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
 + "<?hello world?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the "TAG1" element
 var tag1 = docRoot.getElementsByTagName("TAG1").item(0);
 
 //call getChildNodes to get a DOMNodeList object
 //NOTE: getChildNodes does *not* return an array.
 //It returns a DOMNodeList object
 var domNodeList = tag1.getChildNodes();
 
 //call the getLength method of the DOMNodeList object
 //the following should be 4
 if (domNodeList.getLength() != 4) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNodeList_getLength -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNodeList_getLength -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNodeList_getLength





function domNodeList_item() {
  /*****************************************************************************
  function: domNodeList_item

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMNodeList.html#DOMNodeListItem

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1>"
 + "Hello World"
 + "<!--this is a comment node-->"
 + "<![CDATA[this is a CDATA node]]>"
 + "<?hello this is a processing instruction node?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 element
 var tag1 = docRoot.getFirstChild();
 
 //call getChildNodes on tag1 to get a DOMNodeList object
 //NOTE: getChildNodes does *not* return an array.
 //It returns a DOMNodeList object
 var domNodeList = tag1.getChildNodes();

 //call the getLength method of the DOMNodeList object
 //the following should be 4
 if (domNodeList.getLength() != 4) {
    pass = false;
 }

 //get each DOMNode in the DOMNodeList
 //and display its value. Remember, the item method
 //of the DOMNodeList is zero-based.

 var node;

 //get the "Hello World" node from the DOMNodeList
 node = domNodeList.item(0);

 //the following should be "Hello World"
 if (node.getNodeValue() != "Hello World" ) {
    pass = false;
 }


 //get the comment node from the DOMNodeList
 node = domNodeList.item(1);

 //the following should be "this is a comment node"
 if (node.getNodeValue() != "this is a comment node" ) {
    pass = false;
 }


 //get the CDATA node from the DOMNodeList
 node = domNodeList.item(2);

 //the following should be "this is a CDATA node"
 if (node.getNodeValue() != "this is a CDATA node" ) {
    pass = false;
 }


 //get the processing instruction node from the DOMNodeList
 node = domNodeList.item(3);

 //the following should be "this is a processing instruction node"
 if (node.getNodeValue() != "this is a processing instruction node" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domNodeList_item -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domNodeList_item -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domNodeList_item






/********************************************************************************************

                                    DOMProcessingInstruction Tests

*********************************************************************************************/








function domProcessingInstruction_getTarget() {
  /*****************************************************************************
  function: domProcessingInstruction_getTarget

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMProcessingInstruction.html#getTarget

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "<?piTarget piData?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the processing instruction in tag1
 var pi = tag1.getFirstChild();
 
 //the following should be "piTarget"
 if (pi.getTarget() != "piTarget" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domProcessingInstruction_getTarget -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domProcessingInstruction_getTarget -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domProcessingInstruction_getTarget





function domProcessingInstruction_getData() {
  /*****************************************************************************
  function: domProcessingInstruction_getData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMProcessingInstruction.html#getData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "<?piTarget piData more piData?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the processing instruction in tag1
 var pi = tag1.getFirstChild();
 
 //the following should be "piData more piData"
 if (pi.getData() != "piData more piData") {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domProcessingInstruction_getData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domProcessingInstruction_getData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domProcessingInstruction_getData





function domProcessingInstruction_setData() {
  /*****************************************************************************
  function: domProcessingInstruction_setData

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMProcessingInstruction.html#setData

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOTNODE>"
 + "<TAG1 foo=\"goo\" id=\"tag1_id\">"
 + "<?piTarget piData more piData?>"
 + "</TAG1>"
 + "</ROOTNODE>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the root node
 var docRoot = domDoc.getDocumentElement();
 
 //find tag1 by searching by its id
 var tag1 = domDoc.getElementById("tag1_id");
 
 //get a DOMNamedNodeMap of the attributes for tag1
 var namedNodeMap = tag1.getAttributes();
 
 //get the processing instruction in tag1
 var pi = tag1.getFirstChild();
 
 //set the processing instruction's data to "newPiData"
 pi.setData("newPiData")
 
 //the following should be "newPiData"
 if (pi.getData() != "newPiData" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domProcessingInstruction_setData -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domProcessingInstruction_setData -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domProcessingInstruction_setData




/********************************************************************************************

                                    DOMText Tests

*********************************************************************************************/





function domText_splitText() {
  /*****************************************************************************
  function: domText_splitText

  author: djoham@yahoo.com

  tests: documentation-w3cdom-DOMText.html#DOMTextSplitText

  *****************************************************************************/
 var pass = true;
 var newOpt;
var xml;
 xml = ""
 + "<?xml version=\"1.0\"?>"
 + "<ROOT>"
 + "<TAG1>"
 + "Hello World"
 + "<![CDATA[Foo Foobar]]>"
 + "</TAG1>"
 + "</ROOT>";
 
 //instantiate the W3C DOM Parser
 var parser = new DOMImplementation();
 
 //load the XML into the parser and get the DOMDocument
 var domDoc = parser.loadXML(xml);
 
 //get the document root
 var docRoot = domDoc.getDocumentElement();
 
 //get the TAG1 node
 var tag1 = docRoot.getFirstChild();
 
 //get the "Hello World" text
 var textNode = tag1.getFirstChild();
 
 //the following should be 2
 if (tag1.getChildNodes().getLength() != 2 ) {
    pass = false;
 }

 //split "Hello World" into two DOMText nodes
 //(both of which will be in the tree)
 textNode.splitText(6);

 //the following should be 3
 if (tag1.getChildNodes().getLength() != 3 ) {
    pass = false;
 }

 //the following should be "Hello "
 if (tag1.getFirstChild().getData() != "Hello " ) {
    pass = false;
 }

 //the following should be "World"
 if (tag1.getChildNodes().item(1).getData() != "World" ) {
    pass = false;
 }

 //get the CDATA section
 var cdataNode = tag1.getChildNodes().item(2);

 //split "Foo Foobar" into two DOMCDATASection nodes
 cdataNode.splitText(3);

 //NOTE: getXML() serializes text nodes. This means
 //that in serialized form, the "Hello " and "World"
 //text nodes are not visible as individual nodes
 //the following should be
 //<TAG1>
 //Hello World
 //<![CDATA[Foo]]>
 //<![CDATA[ Foobar]]>
 //</TAG1>
 if (tag1.getXML() != "<TAG1>Hello World<![CDATA[Foo]]><![CDATA[ Foobar]]></TAG1>" ) {
    pass = false;
 }


 if (pass == true) {
    newOpt = getTestSuccessOption ("domText_splitText -- Success");
 }
 else {
    newOpt = getTestFailureOption ("domText_splitText -- Failure");
 }

 insertOptionElement(newOpt);

} //end function domText_splitText



