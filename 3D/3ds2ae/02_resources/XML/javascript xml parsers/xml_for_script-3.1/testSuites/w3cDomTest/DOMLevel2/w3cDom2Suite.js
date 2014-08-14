// =========================================================================
//
// w3cDom2Suite.js - a test suite for testing xmlw3cdom.js
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

function makeDOM(xmlStr) {
  var parser = new DOMImplementation();
//  parser.namespaceAware = false;

  var dom = parser.loadXML(xmlStr);

  return dom;
}

var testErrorCalling = "";

var testXMLns =""
+ "<?xml version=\"1.0\"?>"
+ "<?xml-stylesheet type=\"text/xsl\" href=\"../style/module.stylesheet.xsl\" ?>"
+ "<exslt:module xmlns:exslt=\"http://exslt.org/documentation\""
+ "              xmlns=\"http://default-ns-outter\""
+ "              version=\"1\" prefix=\"str\" exslt:foo=\"bah\" >"
+ "<name exslt:ni=\"flim\">Strings</name>"
+ ""
+ "<rdf:Description xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\""
+ "                 xmlns:dc=\"http://purl.org/dc/elements/1.1/\""
+ "                 ID=\"str\""
+ "                 rdf:foo=\"bah\">"
+ "   <dc:subject dc:bok=\"koo\">EXSLT</dc:subject>"
+ "   <dc:subject>str</dc:subject>"
+ "   <dc:subject>module</dc:subject>"
+ "   <dc:subject>string</dc:subject>"
+ "   <exslt:revision>"
+ "      <rdf:Description xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\""
+ "                       xmlns:dc=\"http://purl.org/dc/elements/1.1/\""
+ "                       ID=\"str.1\">"
+ "         <exslt:version>1</exslt:version>"
+ "         <dc:creator>Jeni Tennison</dc:creator>"
+ "         <dc:date>2001-06-03</dc:date>"
+ "         <dc:description>A module of string manipulation functions.</dc:description>"
+ "      </rdf:Description>"
+ "   </exslt:revision>"
+ "</rdf:Description>"
+ "<exslt:doc xmlns=\"http://default-ns-inner\">"
+ "   <section>"
+ "      <para align=\"right\">"
+ "         EXSLT - Strings covers extension elements and functions that provide facilities to do with string manipulation."
+ "      </para>"
+ "   </section>"
+ "</exslt:doc>"
+ "<exslt:functions>"
+ "   <exslt:function name=\"tokenize\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"replace\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"padding\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"align\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"encode-uri\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"decode-uri\" version=\"1\" core=\"no\" />"
+ "   <exslt:function name=\"concat\" version=\"1\" core=\"no\" />"
+ "</exslt:functions>"
+ "</exslt:module>";


var methodRegister = new method_registry();

/*****************************************************************************
                                    FUNCTIONS
*****************************************************************************/
function runTests() {
  /*****************************************************************************
  function: runTests

  author: jon@webarcana.com.au

  description: Begins the test run. An alert box informs the user
                  when the test has been completed

  *****************************************************************************/

  clearTestResults();
  createTestResultsHeader("Starting Test Run");

  createTestResultsHeader("Document Methods");
  test_Document_getDocumentElement();

  test_Document_getElementById();

  createTestResultsHeader("Node Attributes");
  test_Node_getNodeName();
  test_Node_getNamespaceURI();
  test_Node_getPrefix();
  test_Node_getLocalName();

  createTestResultsHeader("Attribute Attributes");
  test_Attr_getName();
  test_Attr_getNamespaceURI();
  test_Attr_getPrefix();
  test_Attr_getLocalName();

  createTestResultsHeader("Node Methods");
  test_Node_getElementsByTagNameNS();
  test_Node_normalize();

  createTestResultsHeader("Document Methods");
  test_Document_createAttributeNS();
  test_Document_createElementNS();

  createTestResultsHeader("NamedNodeMap Methods");
  test_NamedNodeMap_getNamedItemNS();
  test_NamedNodeMap_setNamedItemNS();
  test_NamedNodeMap_removeNamedItemNS();

  createTestResultsHeader("Element Methods");
  test_Element_getAttributeNS();
  test_Element_setAttributeNS();
  test_Element_removeAttributeNS();
  test_Element_hasAttribute();
  test_Element_hasAttributeNS();
  test_Element_getAttributeNodeNS();
  test_Element_setAttributeNodeNS();
  createTestResultsHeader("TEST COMPLETED");

} //end function runTests


function xmlError(e) {
  /*****************************************************************************
  function: xmlError

  author: djoham@yahoo.com

  description:
      this will be the function that is called by the XML
      parser if an error is generated

  *****************************************************************************/
  testErrorCalling = e;

} // end function xmlError


function test_Document_getDocumentElement() {
  /*****************************************************************************
  function: test_Document_getDocumentElement

  author: jon@webarcana.com.au

  description:
	Tests Document.getDocumentElement()
  *****************************************************************************/
  dom = makeDOM(testXMLns);
  doc = dom.getDocumentElement();

  var success = true;
  var detailStr = "";

 if (doc.getNodeType() == DOMNode.ELEMENT_NODE ) {
    detailStr += "Passed test: doc is an element ("+ doc.getNodeType()+ ") \n";
  }
  else {
    detailStr += "Failed test: doc is not an element, got "+ doc.getNodeType() + " \n";
    success = false;
  }

  methodRegister.setMethodStatus('Document', 'getDocumentElement', success);

  if (success) {
    newOption = getTestSuccessOption("Document.getDocumentElement() --- Success", detailStr);
    insertOptionElement(newOption);
  }
  else {
    newOption = getTestFailureOption("Document.getDocumentElement() --- Failure", detailStr);
    insertOptionElement(newOption);
  }

} // end function test_Document_getDocumentElement

function test_Document_getElementById() {
  /*****************************************************************************
  function: test_Document_getElementById

  author: jon@webarcana.com.au

  description:
	Tests Document.getElementById()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.getElementById() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var foundNode = dom.getElementById('str');

    if (foundNode) {
      detailStr += "Passed test: got a matching el () \n";
    }
    else {
      detailStr += "Failed test: failed to get a matching el () \n";
      success = false;
    }

    if (success) {
      var foundNode;
      if (foundNode.getLocalName() == 'Description') {
        detailStr += "Passed test: got expected node name ("+ foundNode.getLocalName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected node name ("+ foundNode.getLocalName() + ") \n";
        success = false;
      }
    }

    var oldParent;

    if (success) {
      // remove found node
      oldParent = foundNode.getParentNode();
      oldParent.removeChild(foundNode);

      // attempt to find removed node
      var foundNode2 = dom.getElementById('str');

      if (foundNode2) {
        detailStr += "Failed test: incorrectly got removed el () \n";
        success = false;
      }
      else {
        detailStr += "Passed test: failed to get removed el () \n";
      }
    }

    if (success) {
      // put removed node back
      oldParent.appendChild(foundNode);

      // attempt to find removed node
      var foundNode3 = dom.getElementById('str');

      if (foundNode3) {
        if (foundNode3.getLocalName() == 'Description') {
          detailStr += "Passed test: got expected node name of re-incorporated node ("+ foundNode3.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected node name of re-incorporated node ("+ foundNode3.getLocalName() + ") \n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('Document', 'getElementById', success);

    if (success) {
      newOption = getTestSuccessOption("Document.getElementById() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Document.getElementById() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Document_getElementById

function test_Node_getNodeName() {
  /*****************************************************************************
  function: test_Node_getNodeName

  author: jon@webarcana.com.au

  description:
	Tests Node.getNodeName()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNodeName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getNodeName() == "exslt:module") {
      detailStr += "Passed test: got expected node name for root with ns getPrefix() & ns dec ("+ doc.getNodeName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name for root with ns getPrefix() & ns dec ("+ doc.getNodeName() + ") \n";
      success = false;
    }

    var rdfDescNode = doc.getFirstChild().getNextSibling();
    if (rdfDescNode.getNodeName() == "rdf:Description") {
      detailStr += "Passed test: got expected getNodeName() for el with ns getPrefix() & ns dec("+ rdfDescNode.getNodeName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNodeName() for el with ns getPrefix() & ns dec ("+ rdfDescNode.getNodeName() + ") \n";
      success = false;
    }

    var nameNode = doc.getFirstChild();
    if (nameNode.getNodeName() == "name") {
      detailStr += "Passed test: got expected getNodeName() for el with no getPrefix() ("+ nameNode.getNodeName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNodeName() for el with no getPrefix() ("+ nameNode.getNodeName() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getNodeName()', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNodeName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNodeName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getNodeName

function test_Node_getNamespaceURI() {
  /*****************************************************************************
  function: test_Node.getNamespaceURI()

  author: jon@webarcana.com.au

  description:
	Tests Node.getNamespaceURI()
  *****************************************************************************/

  var dom = makeDOM(testXMLns);
  
  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNamespaceURI() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getNamespaceURI() == "http://exslt.org/documentation") {
      detailStr += "Passed test: got expected getNamespaceURI() for root with ns dec ("+ doc.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for root with ns dec ("+ doc.getNamespaceURI() + ") \n";
      success = false;
    }

    var rdfDescNode = doc.getFirstChild().getNextSibling();
    if (rdfDescNode.getNamespaceURI() == "http://www.w3.org/1999/02/22-rdf-syntax-ns#") {
      detailStr += "Passed test: got expected getNamespaceURI() for ns dec on self ("+ rdfDescNode.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for ns dec on self ("+ rdfDescNode.getNamespaceURI() + ") \n";
      success = false;
    }

    var dcSubjectNode = doc.getFirstChild().getNextSibling().getFirstChild();
    if (dcSubjectNode.getNamespaceURI() == "http://purl.org/dc/elements/1.1/") {
      detailStr += "Passed test: got expected getNamespaceURI() for node with inherited ns dec ("+ dcSubjectNode.getNamespaceURI() + ") \n";
    }
    else {
	alert(dcSubjectNode.getNamespaceURI());
      detailStr += "Failed test: got unexpected getNamespaceURI() for node with inherited ns dec ("+ dcSubjectNode.getNamespaceURI() + ") \n";
      success = false;
    }

    var nameNode = doc.getFirstChild();
    if (nameNode.getNamespaceURI() == "http://default-ns-outter") {
      detailStr += "Passed test: got expected getNamespaceURI() for node with inherited default ns ("+ nameNode.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for node with inherited default ns ("+ nameNode.getNamespaceURI() + ") \n";
      success = false;
    }


    var sectionNode = doc.getFirstChild().getNextSibling().getNextSibling().getFirstChild();
    if (sectionNode.getNamespaceURI() == "http://default-ns-inner") {
      detailStr += "Passed test: got expected getNamespaceURI() for node with inherited redefined default ns ("+ sectionNode.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for node with inherited redefined default ns ("+ sectionNode.getNamespaceURI() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getNamespaceURI', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNamespaceURI() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNamespaceURI() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getNodeNamespaceURI

function test_Node_getPrefix() {
  /*****************************************************************************
  function: test_Node_getPrefix()

  author: jon@webarcana.com.au

  description:
	Tests Node.getPrefix()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getPrefix() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getPrefix() == "exslt") {
      detailStr += "Passed test: got expected node getPrefix() ("+ doc.getPrefix() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node getPrefix() ("+ doc.getPrefix() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getPrefix()', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getPrefix() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getPrefix() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getPrefix

function test_Node_getLocalName() {
  /*****************************************************************************
  function: test_Node_getLocalName()

  author: jon@webarcana.com.au

  description:
	Tests Node.getLocalName()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getLocalName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getLocalName() == "module") {
      detailStr += "Passed test: got expected node local name ("+ doc.getLocalName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node local name ("+ doc.getLocalName() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getLocalName()', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getLocalName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getLocalName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getLocalName

// ---------------------------

function test_Attr_getName() {
  /*****************************************************************************
  function: test_Attr_getName()

  author: jon@webarcana.com.au

  description:
	Tests Attr.getNodeName()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getNodeName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var docNSAttr = doc.getAttributes().item(2);

    if (docNSAttr.getName() == "exslt:foo") {
      detailStr += "Passed test: got expected attr name on root with ns getPrefix() & ns dec ("+ docNSAttr.getName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected attr name on root with ns getPrefix() & ns dec ("+ docNSAttr.getName() + ") \n";
      success = false;
    }

    var nameAttr = doc.getFirstChild().getAttributes().item(0);
    if (nameAttr.getName() == "exslt:ni") {
      detailStr += "Passed test: got expected getNodeName() for attr with inherited ns ("+ nameAttr.getName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNodeName() for attr with inherited ns ("+ nameAttr.getName() + ") \n";
      success = false;
    }

    var versionAttr = doc.getAttributes().item(0);
    if (versionAttr.getName() == "version") {
      detailStr += "Passed test: got expected getNodeName() for attr with no getPrefix() ("+ versionAttr.getName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNodeName() for attr with no getPrefix() ("+ versionAttr.getName() + ") \n";
      success = false;
    }

    var rdfDescAttr = doc.getFirstChild().getNextSibling().getAttributes().item(1);
    if (rdfDescAttr.getName() == "rdf:foo") {
      detailStr += "Passed test: got expected getNodeName() on el with ns getPrefix() & ns dec("+ rdfDescAttr.getName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNodeName() on el with ns getPrefix() & ns dec ("+ rdfDescAttr.getName() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getName', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getName

function test_Attr_getNamespaceURI() {
  /*****************************************************************************
  function: test_Attr_getNamespaceURI()

  author: jon@webarcana.com.au

  description:
	Tests Attr.getNamespaceURI()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getNamespaceURI() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var docNSAttr = doc.getAttributes().item(2);

    if (docNSAttr.getNamespaceURI() == "http://exslt.org/documentation") {
      detailStr += "Passed test: got expected getNamespaceURI() for attr on root with ns dec ("+ docNSAttr.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for attr on root with ns dec ("+ docNSAttr.getNamespaceURI() + ") \n";
      success = false;
    }

    var rdfDescAttr = doc.getFirstChild().getNextSibling().getAttributes().item(1);

    if (rdfDescAttr.getNamespaceURI() == "http://www.w3.org/1999/02/22-rdf-syntax-ns#") {
      detailStr += "Passed test: got expected getNamespaceURI() for attr with ns dec on parent el ("+ rdfDescAttr.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for attr with ns dec on parent el ("+ rdfDescAttr.getNamespaceURI() + ") \n";
      success = false;
    }

    var dcSubjectAttr = doc.getFirstChild().getNextSibling().getFirstChild().getAttributes().item(0);
    if (dcSubjectAttr.getNamespaceURI() == "http://purl.org/dc/elements/1.1/") {
      detailStr += "Passed test: got expected getNamespaceURI() for attr with inherired ns dec ("+ dcSubjectAttr.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for attr with inherired ns dec ("+ dcSubjectAttr.getNamespaceURI() + ") \n";
      success = false;
    }

    var paraAttr = doc.getFirstChild().getNextSibling().getNextSibling().getFirstChild().getFirstChild().getAttributes().item(0);
    if (paraAttr.getNamespaceURI() == "") {
      detailStr += "Passed test: got expected getNamespaceURI() for attr with inherited redefined default ns ("+ paraAttr.getNamespaceURI() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getNamespaceURI() for attr with inherited redefined default ns ("+ paraAttr.getNamespaceURI() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getNamespaceURI()', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getNamespaceURI() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getNamespaceURI() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getNamespaceURI

function test_Attr_getPrefix() {
  /*****************************************************************************
  function: test_Attr_getPrefix()

  author: jon@webarcana.com.au

  description:
	Tests Attr.getPrefix()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getPrefix() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var docNSAttr = doc.getAttributes().item(2);

    if (doc.getPrefix() == "exslt") {
      detailStr += "Passed test: got expected attr getPrefix() ("+ docNSAttr.getPrefix() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected attr getPrefix() ("+ docNSAttr.getPrefix() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getPrefix', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getPrefix() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getPrefix() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getPrefix

function test_Attr_getLocalName() {
  /*****************************************************************************
  function: test_Attr_getLocalName()

  author: jon@webarcana.com.au

  description:
	Tests Attr.getLocalName()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getLocalName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var docNSAttr = doc.getAttributes().item(2);

    if (docNSAttr.getLocalName() == "foo") {
      detailStr += "Passed test: got expected attr local name ("+ docNSAttr.getLocalName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected attr local name ("+ docNSAttr.getLocalName() + ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getLocalName', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getLocalName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getLocalName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getLocalName

function test_Document_createAttributeNS() {
  /*****************************************************************************
  function: test_Document_createAttributeNS

  author: jon@webarcana.com.au

  description:
	Tests Document.createAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var newAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

    if (newAttr){
      detailStr += "Passed test: created expected attr ("+ newAttr.getLocalName() +") \n";
    }
    else {
      detailStr += "Failed test: failed to create attrib () \n";
      success = false;
    }

    if (success) {
      try {
        if (newAttr.getLocalName() == "ni") {
          detailStr += "Passed test: got expected attr local name ("+ newAttr.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr local name ("+ newAttr.getLocalName() + ") \n";
          success = false;
        }

        if (newAttr.getPrefix() == "exslt") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ newAttr.getPrefix() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ newAttr.getPrefix() + ") \n";
          success = false;
        }

        if (newAttr.getNamespaceURI() == "http://exslt.org/documentation") {
          detailStr += "Passed test: got expected attr getNamespaceURI() ("+ newAttr.getNamespaceURI() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getNamespaceURI() ("+ newAttr.getNamespaceURI() + ") \n";
          success = false;
        }
      }
      catch (e) {
        detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
        success = false;
      }
    }

    // test for INVALID_CHARACTER_ERR: Exception
    if (success) {
      try {
        // attempt to create an Attribute with a dodgy Name
        var newAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni no');

        // should have thrown a INVALID_CHARACTER_ERR Exception by now
        detailStr += "Failed test: INVALID_CHARACTER_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INVALID_CHARACTER_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NAMESPACE_ERR: Exception
    if (success) {
      try {
        // attempt to create an Element with a dodgy Namemspace
        var newAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni:no');

        // should have thrown a NAMESPACE_ERR Exception by now
        detailStr += "Failed test: NAMESPACE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NAMESPACE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('Document', 'createAttributeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Document.createAttributeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Document.createAttributeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Document_createAttributeNS

function test_Document_createElementNS() {
  /*****************************************************************************
  function: test_Document_createElementNS

  author: jon@webarcana.com.au

  description:
	Tests Document.createElementNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createElementNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var docAttrs = doc.getAttributes();

      var newEl = dom.createElementNS('http://exslt.org/documentation', 'exslt:unit');

      if (newEl){
        detailStr += "Passed test: created expected attr ("+ newEl.getLocalName() +") \n";
      }
      else {
        detailStr += "Failed test: failed to create attrib () \n";
        success = false;
      }

      if (success) {
        if (newEl.getLocalName() == "unit") {
          detailStr += "Passed test: got expected attr local name ("+ newEl.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr local name ("+ newEl.getLocalName() + ") \n";
          success = false;
        }
        if (newEl.getPrefix() == "exslt") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ newEl.getPrefix() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ newEl.getPrefix() + ") \n";
          success = false;
        }
        if (newEl.getNamespaceURI() == "http://exslt.org/documentation") {
          detailStr += "Passed test: got expected attr getNamespaceURI() ("+ newEl.getNamespaceURI() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getNamespaceURI() ("+ newEl.getNamespaceURI() + ") \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INVALID_CHARACTER_ERR: Exception
    if (success) {
      try {
        // attempt to create an Element with a dodgy Name
        var newEl = dom.createElementNS('http://exslt.org/documentation', 'exslt:un it');

        // should have thrown a INVALID_CHARACTER_ERR Exception by now
        detailStr += "Failed test: INVALID_CHARACTER_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INVALID_CHARACTER_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NAMESPACE_ERR: Exception
    if (success) {
      try {
        // attempt to create an Element with a dodgy Namemspace
        var newEl = dom.createElementNS('http://exslt.org/documentation', 'exslt:un:it');

        // should have thrown a NAMESPACE_ERR Exception by now
        detailStr += "Failed test: NAMESPACE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NAMESPACE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('Document', 'createElementNS', success);

    if (success) {
      newOption = getTestSuccessOption("Document.createElementNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Document.createElementNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Document_createElementNS


function test_NamedNodeMap_getNamedItemNS() {
  /*****************************************************************************
  function: test_NamedNodeMap_getNamedItemNS

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.getNamedItemNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.getNamedItemNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var docAttrs = doc.getAttributes();

    var foundAttr = docAttrs.getNamedItemNS('http://exslt.org/documentation', 'foo');

    if (foundAttr) {
      detailStr += "Passed test: got expected attr () \n";
    }
    else {
      detailStr += "Failed test: got unexpected attr () \n";
      success = false;
    }

    if (success) {
      if (foundAttr.getLocalName() == "foo") {
        detailStr += "Passed test: got expected attr local name ("+ foundAttr.getLocalName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected attr local name ("+ foundAttr.getLocalName() + ") \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'getNamedItemNS', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.getNamedItemNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.getNamedItemNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_getNamedItemNS

function test_NamedNodeMap_setNamedItemNS() {
  /*****************************************************************************
  function: test_NamedNodeMap_setNamedItemNS

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.setNamedItemNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createAttributeNS')) {
    detailStr += "Failed dependancy: Document.createAttributeNS \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItemNS')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItemNS \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.setNamedItemNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var docAttrs = doc.getAttributes();

      var newAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

      var verifyNewAttr = docAttrs.setNamedItemNS(newAttr);
      var foundAttr = docAttrs.getNamedItemNS('http://exslt.org/documentation', 'ni');

      if (!verifyNewAttr){
        detailStr += "Passed test: successfully got null from setNamedItemNS () \n";
      }
      else {
        detailStr += "Failed test: unexpectedly got attr from setNamedItemNS () \n";
        success = false;
      }

      if (success) {
        if (foundAttr) {
          detailStr += "Passed test: successfully found newly set original attribute () \n";
        }
        else {
          detailStr += "Failed test: failed to find newly set original attribute ()\n";
          success = false;
        }
      }

      if (success) {
        if (foundAttr.getLocalName() == "ni") {
          detailStr += "Passed test: got expected attr local name ("+ foundAttr.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr local name ("+ foundAttr.getLocalName() + ") \n";
          success = false;
        }

        if (foundAttr.getPrefix() == "exslt") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ foundAttr.getPrefix() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ foundAttr.getPrefix() + ") \n";
          success = false;
        }

        if (foundAttr.getNamespaceURI() == "http://exslt.org/documentation") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ foundAttr.getNamespaceURI() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ foundAttr.getNamespaceURI() + ") \n";
          success = false;
        }
      }

      var updatedAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:foo');
      var verifyUpdatedAttr = docAttrs.setNamedItemNS(updatedAttr);
      var foundUpdatedAttr = docAttrs.getNamedItemNS('http://exslt.org/documentation', 'foo');

      if (verifyUpdatedAttr){
        detailStr += "Passed test: attr successfully returned from setNamedItemNS () \n";
      }
      else {
        detailStr += "Failed test: attr was not successfully returned from setNamedItemNS () \n";
        success = false;
      }

      if (success) {
        if (foundUpdatedAttr) {
          detailStr += "Passed test: successfully found newly set updated attribute () \n";
        }
        else {
          detailStr += "Failed test: failed to find newly set updated attribute ()\n";
          success = false;
        }
      }

      if (success) {
        if (foundUpdatedAttr.getLocalName() == "foo") {
          detailStr += "Passed test: got expected attr local name ("+ foundUpdatedAttr.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr local name ("+ foundUpdatedAttr.getLocalName() + ") \n";
          success = false;
        }

        if (foundUpdatedAttr.getPrefix() == "exslt") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ foundUpdatedAttr.getPrefix() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ foundUpdatedAttr.getPrefix() + ") \n";
          success = false;
        }

        if (foundUpdatedAttr.getNamespaceURI() == "http://exslt.org/documentation") {
          detailStr += "Passed test: got expected attr getPrefix() ("+ foundUpdatedAttr.getNamespaceURI() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr getPrefix() ("+ foundUpdatedAttr.getNamespaceURI() + ") \n";
          success = false;
        }

        if (foundUpdatedAttr.value == "") {
          detailStr += "Passed test: got expected attr value ("+ foundUpdatedAttr.value + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr value ("+ foundUpdatedAttr.value + ") \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for WRONG_DOCUMENT_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        // create 2nd dom document
        var dom2 = makeDOM(testXMLns);
        var newAttrib2 = dom2.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        // attempt to add foreign attribute node to NamedNodeMap
        var verifyNewAttr = docAttrs.setNamedItemNS(newAttrib2);

        // should have thrown a WRONG_DOCUMENT_ERR Exception by now
        detailStr += "Failed test: WRONG_DOCUMENT_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.WRONG_DOCUMENT_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NO_MODIFICATION_ALLOWED_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        var newAttrib = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        // make it readonly
        docAttrs._readonly = true;

        // attempt to add attribute node to readonly NamedNodeMap
        var verifyNewAttr = docAttrs.setNamedItemNS(newAttrib2);

        // should have thrown a NO_MODIFICATION_ALLOWED_ERR Exception by now
        success = false;
        detailStr += "Failed test: NO_MODIFICATION_ALLOWED_ERR Exception not generated\n";
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NO_MODIFICATION_ALLOWED_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for INUSE_ATTRIBUTE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // get 1st Node's attributes
        var tag1 = doc.getFirstChild();
        var attribs = tag1.getAttributes();

        // get Attribute from 2nd Node (without removing it)
        var tag2 = tag1.getNextSibling();
        var tag2Attrib = tag2.getAttributes().getNamedItemNS('http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'foo');

        // attempt to assign used Attribute to NamedNodeMap (ie, still belongs to tag3)
        attribs.setNamedItemNS(tag2Attrib);

        // should have thrown a INUSE_ATTRIBUTE_ERR Exception by now
        detailStr += "Failed test: INUSE_ATTRIBUTE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INUSE_ATTRIBUTE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'setNamedItemNS', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.setNamedItemNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.setNamedItemNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_setNamedItemNS

function test_NamedNodeMap_removeNamedItemNS() {
  /*****************************************************************************
  function: test_NamedNodeMap_removeNamedItemNS

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.removeNamedItemNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.removeNamedItemNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var docAttrs = doc.getAttributes();

      var removedAttr = docAttrs.removeNamedItemNS('http://exslt.org/documentation', 'foo');
      var foundAttr = docAttrs.getNamedItemNS('http://exslt.org/documentation', 'foo');

      if (!foundAttr){
        detailStr += "Passed test: did not fail to get attr () \n";
      }
      else {
        detailStr += "Failed test: unexpectedly got attr ("+ foundAttr.getLocalName() + ") \n";
        success = false;
      }

      if (success) {
        if (removedAttr) {
          detailStr += "Passed test: got expected removed attr ("+ removedAttr.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: failed to get expected removed attr ()\n";
          success = false;
        }
      }

      if (success) {
        if (removedAttr.getLocalName() == "foo") {
          detailStr += "Passed test: got expected attr local name ("+ removedAttr.getLocalName() + ") \n";
        }
        else {
          detailStr += "Failed test: got unexpected attr local name ("+ removedAttr.getLocalName() + ") \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for NO_MODIFICATION_ALLOWED_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var nameTag = doc.getFirstChild();
        var nameAttribs = nameTag.getAttributes();
        var niAttrib = nameAttribs.getNamedItemNS('http://exslt.org/documentation', 'ni');

        // make it readonly
        niAttrib._readonly = true;

        // attempt to remove readonly Attribute
        var removedAttr = nameAttribs.removeNamedItemNS('http://exslt.org/documentation', 'ni');

        // should have thrown a NO_MODIFICATION_ALLOWED_ERR Exception by now
        success = false;
        detailStr += "Failed test: NO_MODIFICATION_ALLOWED_ERR Exception not generated\n";
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NO_MODIFICATION_ALLOWED_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NOT_FOUND_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var nameTag = doc.getFirstChild();
        var nameAttribs = nameTag.getAttributes();

        // attempt to missing Attribute (removed in previous test)
        var removedAttr = nameAttribs.removeNamedItemNS('http://exslt.org/documentation', 'foo');

        // should have thrown a NOT_FOUND_ERR Exception by now
        detailStr += "Failed test: NOT_FOUND_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NOT_FOUND_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'removeNamedItemNS', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.removeNamedItemNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.removeNamedItemNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_removeNamedItemNS

function test_Element_getAttributeNS() {
  /*****************************************************************************
  function: test_Element_getAttributeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.getAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var foundAttrVal = doc.getAttributeNS('http://exslt.org/documentation', 'foo');

    if (foundAttrVal) {
      detailStr += "Passed test: got an attr value ("+ foundAttrVal + ") \n";
    }
    else {
      detailStr += "Failed test: failed to get an attr value ("+ foundAttrVal+ ") \n";
      success = false;
    }

    if (foundAttrVal == "bah") {
      detailStr += "Passed test: got expected attr value ("+ foundAttrVal + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected attr value ("+ foundAttrVal+ ") \n";
      success = false;
    }

    methodRegister.setMethodStatus('Element', 'getAttributeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.getAttributeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.getAttributeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_getAttributeNS

function test_Element_setAttributeNS() {
  /*****************************************************************************
  function: test_Element_setAttributeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.setAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.setAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();

      doc.setAttributeNS('http://exslt.org/documentation', 'exslt:foo', 'bing');
      var foundAttrVal = doc.getAttributeNS('http://exslt.org/documentation', 'foo');

      if (foundAttrVal) {
        detailStr += "Passed test: got an attr value ("+ foundAttrVal + ") \n";
      }
      else {
        detailStr += "Failed test: failed to get an attr value ("+ foundAttrVal+ ") \n";
        success = false;
      }

      if (foundAttrVal == "bing") {
        detailStr += "Passed test: got expected attr value ("+ foundAttrVal + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected attr value ("+ foundAttrVal+ ") \n";
        success = false;
      }
    }
    catch (e) {
      if (e.code && (e.code == DOMException.INVALID_CHARACTER_ERR)) {
        detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
      }
      else {
        detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        success = false;
      }
    }

    // test for INVALID_CHARACTER_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // attempt to create an Attribute with a dodgy Name
        doc.setAttributeNS('http://exslt.org/documentation', 'exslt:fo o', 'bing');

        // should have thrown a INVALID_CHARACTER_ERR Exception by now
        detailStr += "Failed test: INVALID_CHARACTER_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INVALID_CHARACTER_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NO_MODIFICATION_ALLOWED_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        docAttrs = doc.getAttributes();

        // make it readonly
        docAttrs._readonly = true;

        // attempt to add attribute node to readonly NamedNodeMap
        var verifyNewAttr = doc.setAttributeNS('http://exslt.org/documentation', 'exslt:foo', 'bing');

        // should have thrown a NO_MODIFICATION_ALLOWED_ERR Exception by now
        success = false;
        detailStr += "Failed test: NO_MODIFICATION_ALLOWED_ERR Exception not generated\n";
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NO_MODIFICATION_ALLOWED_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NAMESPACE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // attempt to create an Attribute with a dodgy Namespace
        doc.setAttributeNS('http://exslt.org/documentation', 'exslt:fo:o', 'bing');

        // should have thrown a NAMESPACE_ERR Exception by now
        detailStr += "Failed test: NAMESPACE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NAMESPACE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }


    methodRegister.setMethodStatus('Element', 'setAttributeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.setAttributeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.setAttributeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_setAttributeNS

function test_Element_removeAttributeNS() {
  /*****************************************************************************
  function: test_Element_removeAttributeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.removeAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.removeAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();

      doc.removeAttributeNS('http://exslt.org/documentation', 'foo');

      var foundAttrVal = doc.getAttributeNS('http://exslt.org/documentation', 'foo');

      if (!foundAttrVal){
        detailStr += "Passed test: did not fail to get attr value() \n";
      }
      else {
        detailStr += "Failed test: unexpectedly got attr ("+ foundAttr.getLocalName() + ") \n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }


    // test for NO_MODIFICATION_ALLOWED_ERR: Exception
    if (success) {
      try {
        var nameTag = dom.getDocumentElement().getFirstChild();
        niAttrib = nameTag.getAttributeNodeNS('http://exslt.org/documentation', 'ni');

        // make it readonly
        niAttrib._readonly = true;

        // attempt to add remove readonly Attribute from  NamedNodeMap
        nameTag.removeAttributeNS('http://exslt.org/documentation', 'ni');

        // should have thrown a NO_MODIFICATION_ALLOWED_ERR Exception by now
        success = false;
        detailStr += "Failed test: NO_MODIFICATION_ALLOWED_ERR Exception not generated\n";
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NO_MODIFICATION_ALLOWED_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('Element', 'removeAttributeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.removeAttributeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.removeAttributeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_removeAttributeNS

function test_Element_hasAttribute() {
  /*****************************************************************************
  function: test_Element_hasAttribute

  author: jon@webarcana.com.au

  description:
	Tests Element.hasAttribute()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.hasAttribute() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var found = doc.hasAttribute('version');

    if (found){
      detailStr += "Passed test: got attr value () \n";
    }
    else {
      detailStr += "Failed test: failed to get attr () \n";
      success = false;
    }

    methodRegister.setMethodStatus('Element', 'hasAttribute', success);

    if (success) {
      newOption = getTestSuccessOption("Element.hasAttribute() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.hasAttribute() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_hasAttribute

function test_Element_hasAttributeNS() {
  /*****************************************************************************
  function: test_Element_hasAttributeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.hasAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.hasAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var found = doc.hasAttributeNS('http://exslt.org/documentation', 'foo');

    if (found){
      detailStr += "Passed test: got attr value () \n";
    }
    else {
      detailStr += "Failed test: failed to get attr () \n";
      success = false;
    }

    methodRegister.setMethodStatus('Element', 'hasAttributeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.hasAttributeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.hasAttributeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_hasAttributeNS

function test_Element_getAttributeNodeNS() {
  /*****************************************************************************
  function: test_Element_getAttributeNodeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.getAttributeNodeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getAttributeNodeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var foundAttr = doc.getAttributeNodeNS('http://exslt.org/documentation', 'foo');

    if (foundAttr) {
      detailStr += "Passed test: got an attr () \n";
    }
    else {
      detailStr += "Failed test: failed to get an attr () \n";
      success = false;
    }

    if (success) {
      if (foundAttr.getLocalName() == 'foo') {
        detailStr += "Passed test: got expected attr name ("+ foundAttr.getLocalName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected attr name ("+ foundAttr.getLocalName() + ") \n";
        success = false;
      }

      if (foundAttr.value == "bah") {
        detailStr += "Passed test: got expected attr value ("+ foundAttr.value + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected attr value ("+ foundAttr.value + ") \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Element', 'getAttributeNodeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.getAttributeNodeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.getAttributeNodeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_getAttributeNodeNS

function test_Element_setAttributeNodeNS() {
  /*****************************************************************************
  function: test_Element_setAttributeNodeNS

  author: jon@webarcana.com.au

  description:
	Tests Element.setAttributeNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.setAttributeNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var newAttr = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:fub');
      newAttr.setValue('buff');

      doc.setAttributeNodeNS(newAttr);
      var foundAttr = doc.getAttributeNodeNS('http://exslt.org/documentation', 'fub');

      if (foundAttr) {
        detailStr += "Passed test: got an attr () \n";
      }
      else {
        detailStr += "Failed test: failed to get an attr () \n";
        success = false;
      }

      if (foundAttr.value == "buff") {
        detailStr += "Passed test: got expected attr value ("+ foundAttr.value + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected attr value ("+ foundAttr.value + ") \n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for WRONG_DOCUMENT_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        // create 2nd dom document
        var dom2 = makeDOM(testXMLns);
        var newAttrib2 = dom2.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

        // attempt to add foreign attribute node to Document
        doc.setAttributeNodeNS(newAttrib2);

        // should have thrown a WRONG_DOCUMENT_ERR Exception by now
        detailStr += "Failed test: WRONG_DOCUMENT_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.WRONG_DOCUMENT_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for INUSE_ATTRIBUTE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // get 1st Node's attributes
        var tag1 = doc.getFirstChild();
        var attribs = tag1.getAttributes();

        // get Attribute from 2nd Node (without removing it)
        var tag2 = tag1.getNextSibling();
        var tag2Attrib = tag2.getAttributes().getNamedItemNS('http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'foo');

        // attempt to assign used Attribute to NamedNodeMap (ie, still belongs to tag3)
        doc.setAttributeNodeNS(tag2Attrib);

        // should have thrown a INUSE_ATTRIBUTE_ERR Exception by now
        detailStr += "Failed test: INUSE_ATTRIBUTE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INUSE_ATTRIBUTE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for NO_MODIFICATION_ALLOWED_ERR: Exception
    if (success) {
      try {
        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var docAttrs = doc.getAttributes();

        // make it readonly
        docAttrs._readonly = true;

        // create dummy attribute
        var newAttrib = dom.createAttributeNS('http://exslt.org/documentation', 'exslt:ni');

        // attempt to add attribute to readonly NamedNodeMap
        var verifyNewAttr = doc.setAttributeNodeNS(newAttr);

        // should have thrown a NO_MODIFICATION_ALLOWED_ERR Exception by now
        success = false;
        detailStr += "Failed test: NO_MODIFICATION_ALLOWED_ERR Exception not generated\n";
      }
      catch (e) {
        if (e.code && (e.code == DOMException.NO_MODIFICATION_ALLOWED_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('Element', 'setAttributeNodeNS', success);

    if (success) {
      newOption = getTestSuccessOption("Element.setAttributeNodeNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.setAttributeNodeNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_setAttributeNodeNS

function test_Node_getElementsByTagNameNS() {
  /*****************************************************************************
  function: test_Node_getElementsByTagNameNS

  author: jon@webarcana.com.au

  description:
	Tests Node.getElementsByTagNameNS()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getElementsByTagNameNS() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var foundNodeList = doc.getElementsByTagNameNS('http://exslt.org/documentation', 'module');

    if (foundNodeList.length > 0) {
      detailStr += "Passed test: got at least one matching el () \n";
    }
    else {
      detailStr += "Failed test: failed to get at least one matching el () \n";
      success = false;
    }

    if (success) {
      var foundNode = foundNodeList.item(0);
      if (foundNode.getLocalName() == 'module') {
        detailStr += "Passed test: got expected node name ("+ foundNode.getLocalName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected node name ("+ foundNode.getLocalName() + ") \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'getElementsByTagNameNS', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getElementsByTagNameNS() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getElementsByTagNameNS() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getElementsByTagNameNS

function test_Node_normalize() {
  /*****************************************************************************
  function: test_Node_normalize

  author: jon@webarcana.com.au

  description:
	Tests Node.normalize()
  *****************************************************************************/
  var dom = makeDOM(testXMLns);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.getDocumentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getElementsByTagNameNS')) {
    detailStr += "Failed dependancy: Document.getElementsByTagNameNS \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.normalize() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    // get a Text Node (dc:description)
    var descriptionTag = doc.getElementsByTagNameNS('http://purl.org/dc/elements/1.1/', 'description').item(0);
    var textNode = descriptionTag.getFirstChild();

    // split the Text Node to create adjacent text nodes
    textNode.splitText(10);

    // do normalize
    descriptionTag.normalize();

    // test that adjacent Text Nodes have been merged
    if (success) {
      if (descriptionTag.getFirstChild().getNodeValue() == "A module of string manipulation functions.") {
        detailStr += "Passed test: got expected merged TextNode value ("+ descriptionTag.getFirstChild().getNodeValue() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected merged TextNode value ("+ descriptionTag.getFirstChild().getNodeValue() + ") \n";
        success = false;
      }
    }

    // clear one the text nodes
    if (success) {
      textNode = descriptionTag.getFirstChild();
      textNode.setNodeValue("");

      // do normalize
      descriptionTag.normalize();

      // test that empty text node has been removed
      if (descriptionTag.childNodes.getLength() == 0) {
        detailStr += "Passed test: empty text node was removed \n";
      }
      else {
        detailStr += "Failed test: empty text node was not removed \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'normalize', success);

    if (success) {
      newOption = getTestSuccessOption("Node.normalize() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.normalize() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_normalize
