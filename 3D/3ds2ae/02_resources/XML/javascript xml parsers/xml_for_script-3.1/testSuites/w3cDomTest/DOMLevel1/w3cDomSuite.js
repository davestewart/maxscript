// =========================================================================
//
// w3cdomTestSuite.js - a test suite for testing xmlw3cdom.js
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
  parser.namespaceAware = false;
  var dom = parser.loadXML(xmlStr);

  return dom;
}

var testErrorCalling = "";

var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
                + "<TAG1 name=\"foo\" class=\"bar\" empty=\"\">"
                    + "tag1content"
                + "</TAG1>"
                + "<TAG2>"
                    + "1 is &lt;&amp;&gt; 2"
                + "</TAG2>"
                + "<TAG3 name=\"goo\">"
                    + "<TAG4>"
                        + "tag4content"
                    + "</TAG4>"
                + "</TAG3>"
                + "<TAG5>tag5content</TAG5>"
                + "<TAG6 nodeType=\"ELEMENT\" id=\"4\">"
                    + "This child is of nodeType TEXT"
                    + "<!--This child is of nodeType COMMENT-->"
                    + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
                    + "this child has a special &amp;lt; character that should come out escaped"
                + "</TAG6>"
            + "</ROOTNODE>";

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

  createTestResultsHeader("Node Identification Methods");
  test_Node_getNodeName();

  createTestResultsHeader("Node Tree Traversal Methods");
  test_Node_getFirstChild();
  test_Node_getLastChild();
  test_Node_getNextSibling();
  test_Node_getPreviousSibling();
  test_Node_getParentNode();

  createTestResultsHeader("NamedNodeMap Methods");
  test_NamedNodeMap_getLength();
  test_NamedNodeMap_item();
  test_NamedNodeMap_getNamedItem();
  test_NamedNodeMap_setNamedItem();
  test_NamedNodeMap_removeNamedItem();

  createTestResultsHeader("NodeList Methods");
  test_NodeList_getLength();
  test_NodeList_item();

  createTestResultsHeader("Node Inspection Methods");
  test_Node_getNodeValue();
  test_Node_getNodeType();
  test_Node_getChildNodes();
  test_Node_hasChildNodes();
  test_Node_getAttributes();
  test_Node_getOwnerDocument();

  createTestResultsHeader("Document Create Methods");
  test_Document_createElement();
  test_Document_createDocumentFragment();
  test_Document_createTextNode();
  test_Document_createComment();
  test_Document_createCDATASection();
  test_Document_createProcessingInstruction();
  test_Document_createAttribute();

  createTestResultsHeader("Node Tree Manipulation Methods");
  test_Node_insertBefore();
  test_Node_replaceChild();
  test_Node_removeChild();
  test_Node_appendChild();
  test_Node_cloneNode();

  createTestResultsHeader("Attr Methods");
  test_Attr_getName();
  test_Attr_getSpecified();
  test_Attr_getValue();
  test_Attr_setValue();

  createTestResultsHeader("Element Methods");
  test_Element_getTagName();
  test_Element_getAttribute();
  test_Element_setAttribute();
  test_Element_removeAttribute();
  test_Element_getAttributeNode();
  test_Element_setAttributeNode();
  test_Element_removeAttributeNode();
  test_Element_getElementsByTagName();

  createTestResultsHeader("CharacterData Methods");
  test_CharacterData_getData();
  test_CharacterData_setData();
  test_CharacterData_getLength();
  test_CharacterData_substringData();
  test_CharacterData_appendData();
  test_CharacterData_insertData();
  test_CharacterData_deleteData();
  test_CharacterData_replaceData();

  createTestResultsHeader("Text Methods");
  test_Text_splitText();

  createTestResultsHeader("CDATASection Methods");
  test_CDATASection_splitText();

  createTestResultsHeader("ProcessingInstruction Methods");
  test_ProcessingInstruction_getTarget();
  test_ProcessingInstruction_getData();
  test_ProcessingInstruction_setData();
  createTestResultsHeader("TEST COMPLETED");

} //end function runTests




function test_Document_getDocumentElement() {
  /*****************************************************************************
  function: test_Document_getDocumentElement

  author: jon@webarcana.com.au

  description:
	Tests Document.getDocumentElement()
  *****************************************************************************/
  dom = makeDOM(testXML);
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


function test_Node_getNodeName() {
  /*****************************************************************************
  function: test_Node.getNodeName()

  author: jon@webarcana.com.au

  description:
	Tests Node.getNodeName()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNodeName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getNodeName() == "ROOTNODE") {
      detailStr += "Passed test: got expected node name ("+ doc.getNodeName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ doc.getNodeName() + ") \n";
      success = false;
    }

    var nodeName = doc.getFirstChild().getAttributeNode("name").getNodeName();
    if ( nodeName == "name") {
        detailStr += "Passed test: got expected node name (" + nodeName + ") \n";
    }
    else {
        detailStr += "Failed test: got unexpected node name (" + nodeName + ") \n";
        success = false;
    }
    nodeName = "";


    tagTest = doc.getElementsByTagName("TAG6").item(0);
    nodeName = tagTest.getChildNodes().item(2).getNodeName();
    if (nodeName == "#cdata-section") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";


    nodeName = tagTest.getChildNodes().item(1).getNodeName();
    if (nodeName == "#comment") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    nodeName = dom.getNodeName();
    if (nodeName == "#document") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    nodeName = dom.createDocumentFragment().getNodeName();
    if (nodeName == "#document-fragment") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    nodeName = tagTest.getNodeName();
    if (nodeName == "TAG6") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    nodeName = dom.getFirstChild().getNodeName();
    if (nodeName == "xml") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    nodeName = tagTest.getChildNodes().item(0).getNodeName();
    if (nodeName == "#text") {
      detailStr += "Passed test: got expected node name ("+ nodeName + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node name ("+ nodeName + ") \n";
      success = false;
    }
    nodeName = "";

    methodRegister.setMethodStatus('Node', 'getNodeName', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNodeName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNodeName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node.getNodeName()

function test_Node_getFirstChild() {
  /*****************************************************************************
  function: test_Node_getFirstChild()

  author: jon@webarcana.com.au

  description:
	Tests Node.getFirstChild()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getFirstChild() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getFirstChild()) {
      detailStr += "Passed test: getFirstChild() is defined\n";
    }
    else {
      detailStr += "Failed test: getFirstChild() is not defined\n";
      success = false;
    }

    var tag1 = doc.getFirstChild();

    if (success) {
      if (tag1.getNodeName() == "TAG1") {
        detailStr += "Passed test: got expected getFirstChild() ("+ tag1.getNodeName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected getFirstChild(), got "+ tag1.getNodeName() + " \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'getFirstChild', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getFirstChild() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getFirstChild() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getFirstChild


function test_Node_getLastChild() {
  /*****************************************************************************
  function: test_Node_getLastChild()

  author: jon@webarcana.com.au

  description:
	Tests Node.getLastChild()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getFirstChild() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getLastChild()) {
      detailStr += "Passed test: getLastChild() is defined\n";
    }
    else {
      detailStr += "Failed test: getLastChild() is not defined\n";
      success = false;
    }

    var tag6 = doc.getLastChild();

    if (success) {
      if (tag6.getNodeName() == "TAG6") {
        detailStr += "Passed test: got expected getLastChild() ("+ tag6.getNodeName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected getLastChild(), got "+ tag6.getNodeName() + " \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'getLastChild', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getLastChild() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getLastChild() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getLastChild()

function test_Node_getNextSibling() {
  /*****************************************************************************
  function: test_Node_getNextSibling()

  author: jon@webarcana.com.au

  description:
	Tests Node.getNextSibling()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNextSibling() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.getLastChild()) {
      detailStr += "Passed test: getLastChild() is defined\n";
    }
    else {
      detailStr += "Failed test: getLastChild() is not defined\n";
      success = false;
    }

    var tag1 = doc.getFirstChild();


    if (success) {
      if (tag1.getNextSibling()) {
        detailStr += "Passed test: getNextSibling() is defined\n";
      }
      else {
        detailStr += "Failed test: getNextSibling() is not defined\n";
        success = false;
      }
    }

    var tag2 = tag1.getNextSibling();

    if (success) {
      if (tag2.getNodeName() == "TAG2") {
        detailStr += "Passed test: got expected getNextSibling() ("+ tag2.getNodeName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected getNextSibling() , got "+ tag2.getNodeName() + " \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'getNextSibling', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNextSibling() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNextSibling() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getNextSibling()

function test_Node_getPreviousSibling() {
  /*****************************************************************************
  function: test_Node_getPreviousSibling()

  author: jon@webarcana.com.au

  description:
	Tests Node.getPreviousSibling()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getPreviousSibling() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (success) {
      if (doc.getLastChild()) {
        detailStr += "Passed test: getLastChild() is defined\n";
      }
      else {
        detailStr += "Failed test: getLastChild() is not defined\n";
        success = false;
      }
    }

    var tag6 = doc.getLastChild();

    if (success) {
      if (tag6.getNodeName() == "TAG6") {
        detailStr += "Passed test: got expected getLastChild() ("+ tag6.getNodeName() + ") \n";
      }
      else {
        detailStr += "Failed test: got unexpected getLastChild(), got "+ tag6.getNodeName() + " \n";
        success = false;
      }
    }

    var tag5 = tag6.getPreviousSibling();

    if (tag5.getNodeName() == "TAG5") {
      detailStr += "Passed test: got expected getPreviousSibling() ("+ tag5.getNodeName() + ") \n";
    }
    else {
      detailStr += "Failed test: got unexpected getPreviousSibling() , got "+ tag5.getNodeName() + " \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getPreviousSibling', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getPreviousSibling() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getPreviousSibling() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getPreviousSibling()

function test_Node_getParentNode() {
  /*****************************************************************************
  function: test_Node_getParentNode()

  author: jon@webarcana.com.au

  description:
	Tests Node.getParentNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getParentNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (success) {
      if (doc.getFirstChild()) {
        detailStr += "Passed test: getFirstChild() is defined\n";
      }
      else {
        detailStr += "Failed test: getFirstChild() is not defined\n";
        success = false;
      }
    }

    if (success) {
      if (doc.getFirstChild().getFirstChild()) {
        detailStr += "Passed test: getFirstChild() is defined\n";
      }
      else {
        detailStr += "Failed test: getFirstChild() is not defined\n";
        success = false;
      }
    }

    if (success) {
      var innerTag = doc.getFirstChild().getFirstChild();

      if (innerTag.getNodeValue() == "tag1content") {
        detailStr += "Passed test: got expected child ("+ innerTag.getNodeValue() +") \n";
      }
      else {
        detailStr += "Failed test: got unexpected child, got "+ innerTag.getNodeValue() +" \n";
        success = false;
      }
    }

    if (success) {
      var tag1 = innerTag.getParentNode();

      if (tag1.getNodeName() == "TAG1") {
        detailStr += "Passed test: got expected parent node ("+ tag1.getNodeName() +") \n";
      }
      else {
        detailStr += "Failed test: got unexpected parent node, got "+ tag1.getNodeName() +" \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'getParentNode', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getParentNode() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getParentNode() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getParentNode()


function test_NamedNodeMap_getLength() {
  /*****************************************************************************
  function: test_NamedNodeMap_getLength

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.length
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<TAG1 name=\"foo\" class=\"bar\">"
                + "<TAG2 name=\"bet\" class=\"bof\">"
                    + "tag2content"
                + "</TAG2>"
                + "<TAG3>"
                    + "tag3content"
                + "</TAG3>"
              + "</TAG1>"
              + "<TAG8 name=\"foo\" class=\"bar\">"
                + "<TAG9 name=\"bet\" class=\"bof\">"
                    + "tag1content"
                + "</TAG9>"
              + "</TAG8>"
            + "</ROOTNODE>";


  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.getLength() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    var tag1 = doc.getFirstChild().getFirstChild();
    var attribs = tag1.getAttributes();

    if (attribs.length > 0) {
      detailStr += "Passed test: got expected length ("+ attribs.length +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected length, got "+ attribs.length +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'getLength', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.getLength() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.getLength() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_getLength

function test_NamedNodeMap_item() {
  /*****************************************************************************
  function: test_NamedNodeMap_item

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.item()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.item() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    var tag1 = doc.getFirstChild();
    var attribs = tag1.getAttributes();

    if (attribs.item(0)) {
      detailStr += "Passed test: named item 0 exists ("+ attribs.item(0) +") \n";
    }
    else {
      detailStr += "Failed test: named item 0 does not exist \n";
      success = false;
    }

    if (attribs.item(1)) {
      detailStr += "Passed test: named item 1 exists ("+ attribs.item(1) +") \n";
    }
    else {
      detailStr += "Failed test: named item 1 does not exist \n";
      success = false;
    }

    if (attribs.item(0).getNodeType() == DOMNode.ATTRIBUTE_NODE) {
      detailStr += "Passed test: got expected node type Attribute ("+ attribs.item(0).getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got expected node type, got "+ attribs.item(0).getNodeType() +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'item', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.item() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.item() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_item

function test_NamedNodeMap_getNamedItem() {
  /*****************************************************************************
  function: test_NamedNodeMap_getNamedItem

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.getNamedItem()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.getNamedItem() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    var tag1 = doc.getFirstChild();
    var attribs = tag1.getAttributes();

    if (attribs.getNamedItem('class')) {
      detailStr += "Passed test: named item 'class' exists ("+ attribs.getNamedItem('class') +") \n";
    }
    else {
      detailStr += "Failed test: named item 'class' does not exist \n";
      success = false;
    }


    if (attribs.getNamedItem('class').getNodeType() == DOMNode.ATTRIBUTE_NODE) {
      detailStr += "Passed test: got expected node type Attribute ("+ attribs.getNamedItem('class').getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type Attribute, got "+ attribs.getNamedItem('class').getNodeType() +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('NamedNodeMap', 'getNamedItem', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.getNamedItem() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.getNamedItem() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_getNamedItem

function test_NamedNodeMap_setNamedItem() {
  /*****************************************************************************
  function: test_NamedNodeMap_setNamedItem

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.setNamedItem()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment

  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.setNamedItem() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();

      var tag1 = doc.getFirstChild();
      var attribs = tag1.getAttributes();

      var newAttrib = dom.createAttribute('NEWATTRIB');

      attribs.setNamedItem(newAttrib);

      var verifyAttrib = attribs.getNamedItem('NEWATTRIB');

      if (verifyAttrib.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
        detailStr += "Passed test: got & set Attribute  \n";
      }
      else {
        detailStr += "Failed test: got & set Attribute failed \n";
        success = false;
      }

      var verifyAttribs = tag1.getAttributes();
      var verifyAttribInElement = verifyAttribs.getNamedItem('NEWATTRIB');

      if (verifyAttribInElement.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
        detailStr += "Passed test: changes to NamedNodeMap are global \n";
      }
      else {
        detailStr += "Failed test: changes to NamedNodeMap are not global \n";
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
        // create 2nd dom document
        var dom2 = makeDOM(testXML);
        var newAttrib2 = dom2.createAttribute('NEWATTRIB');

        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var tag1 = doc.getFirstChild();
        var attribs = tag1.getAttributes();

        // attempt to add foreign attribute node to NamedNodeMap
        attribs.setNamedItem(newAttrib2);

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
        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var tag1 = doc.getFirstChild();
        var attribs = tag1.getAttributes();

        // get attribute to be replaced
        var nameAttrib = verifyAttribs.getNamedItem('name');

        // make it readonly
        nameAttrib._readonly = true;

        // create dummy Attribute
        var newAttrib = dom.createAttribute('name');

        // attempt to add dummy attribute node to overwrite readonly node
        attribs.setNamedItem(newAttrib);

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

        // get Attribute from 3rd Node (without removing it)
        var tag3 = tag1.getNextSibling().getNextSibling();
        var tag3Attrib = tag3.getAttributes().getNamedItem('name');

        // attempt to assign used Attribute to NamedNodeMap (ie, still belongs to tag3)
        attribs.setNamedItem(tag3Attrib);

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

    methodRegister.setMethodStatus('NamedNodeMap', 'setNamedItem', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.setNamedItem() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.setNamedItem() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_setNamedItem

function test_NamedNodeMap_removeNamedItem() {
  /*****************************************************************************
  function: test_NamedNodeMap_removeNamedItem

  author: jon@webarcana.com.au

  description:
	Tests NamedNodeMap.removeNamedItem()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NamedNodeMap.removeNamedItem() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();

      var tag1 = doc.getFirstChild();
      var attribs = tag1.getAttributes();

      var nameAttrib = attribs.getNamedItem('name');

      if ((nameAttrib) && (nameAttrib.getNodeType() == DOMNode.ATTRIBUTE_NODE)) {
        detailStr += "Passed test: attrib to be removed exists \n";
      }
      else {
        detailStr += "Failed test: attrib to be removed does not exist \n";
        success = false;
      }

      attribs.removeNamedItem('name');

      var verifyNameAttrib = attribs.getNamedItem('name');

      if (success) {
        if (!verifyNameAttrib) {
          detailStr += "Passed test: attrib has been removed \n";
        }
        else {
          detailStr += "Failed test: attrib has not been removed \n";
          success = false;
        }
      }

      if (success) {
        var verifyAttribs = tag1.getAttributes();
        var verifyAttribInElement = verifyAttribs.getNamedItem('name');

        if (!verifyAttribInElement) {
          detailStr += "Passed test: removes from NamedNodeMap are global \n";
        }
        else {
          detailStr += "Failed test: removes fromNamedNodeMap are not global \n";
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
        // get NamedNodeMap from Node's Attributes
        var doc = dom.getDocumentElement();
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();
        var attribs = tag3.getAttributes();

        // get attribute to be replaced
        var nameAttrib = attribs.getNamedItem('name');

        // make it readonly
        nameAttrib._readonly = true;

        // attempt to remove readonly attribute node
        attribs.removeNamedItem('name');

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


    methodRegister.setMethodStatus('NamedNodeMap', 'removeNamedItem', success);

    if (success) {
      newOption = getTestSuccessOption("NamedNodeMap.removeNamedItem() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NamedNodeMap.removeNamedItem() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NamedNodeMap_removeNamedItem

function test_NodeList_getLength() {
  /*****************************************************************************
  function: test_NodeList_getLength

  author: jon@webarcana.com.au

  description:
	Tests NodeList.length
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<TAG1 name=\"foo\" class=\"bar\">"
                + "<TAG2 name=\"bet\" class=\"bof\">"
                    + "tag2content"
                + "</TAG2>"
                + "<TAG3>"
                    + "tag3content"
                + "</TAG3>"
              + "</TAG1>"
              + "<TAG8 name=\"foo\" class=\"bar\">"
                + "<TAG9 name=\"bet\" class=\"bof\">"
                    + "tag1content"
                + "</TAG9>"
              + "</TAG8>"
            + "</ROOTNODE>";


  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  // assuming that Node.getChildNodes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NodeList.getLength --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var childNodes = doc.getChildNodes();

    if (childNodes.length > 0) {
      detailStr += "Passed test: got expected length ("+ childNodes.length +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected length, got "+ childNodes.length +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('NodeList', 'getLength', success);

    if (success) {
      newOption = getTestSuccessOption("NodeList.getLength() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NodeList.getLength() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NodeList_getLength

function test_NodeList_item() {
  /*****************************************************************************
  function: test_NodeList_item

  author: jon@webarcana.com.au

  description:
	Tests NodeList.item()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NodeList', 'getLength')) {
    detailStr += "Failed dependancy: Document.length \n";
    success = false;
  }

  // assuming that Node.getAttributes() works for the moment


  if (!success) {
    newOption = getTestWarningOption("NodeList.item() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    var childNodes = doc.getChildNodes();

    if (childNodes.item(0)) {
      detailStr += "Passed test: item 0 exists ("+ childNodes.item(0).getNodeName() +") \n";
    }
    else {
      detailStr += "Failed test: item 0 does not exist \n";
      success = false;
    }

    if (childNodes.item(1)) {
      detailStr += "Passed test: item 1 exists ("+ childNodes.item(1).getNodeName() +") \n";
    }
    else {
      detailStr += "Failed test: item 1 does not exist \n";
      success = false;
    }

    if (success) {
      if (childNodes.item(0).getNodeType() == DOMNode.ELEMENT_NODE) {
        detailStr += "Passed test: got expected node type Element ("+ childNodes.item(0).getNodeType() +") \n";
      }
      else {
        detailStr += "Failed test: got unexpected node type, got "+ childNodes.item(0).getNodeType() +" \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('NodeList', 'item', success);

    if (success) {
      newOption = getTestSuccessOption("NodeList.item() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("NodeList.item() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_NodeList_item

function test_Node_getNodeValue() {
  /*****************************************************************************
  function: test_Node_getNodeValue()

  author: jon@webarcana.com.au

  description:
	Tests Node.getNodeValue()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNodeValue() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    var tag1_nameAttrib = tag1.getAttributes().getNamedItem('name');

    //this tests the ability to set a nodeValue
    tag1_nameAttrib.setNodeValue("bah");

    var tag1_nameAttribValue = tag1_nameAttrib.getNodeValue();

    if (tag1_nameAttribValue == "bah") {
      detailStr += "Passed test: got expected Node value ("+ tag1_nameAttribValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ tag1_nameAttribValue +"\n";
      success = false;
    }

    var nodeValue = tag1.getAttributes().getNamedItem("class").getNodeValue();
    if ( nodeValue == "bar") {
      detailStr += "Passed test: got expected Node value ("+ nodeValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ nodeValue +"\n";
      success = false;
    }
    nodeValue = "";

    //get tag6
    var tag6 = doc.getElementsByTagName("TAG6").item(0);
    nodeValue = tag6.getChildNodes().item(2).getNodeValue();
    if ( nodeValue == "this child is of <<<>nodeType CDATA") {
      detailStr += "Passed test: got expected Node value ("+ nodeValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ nodeValue +"\n";
      success = false;
    }
    nodeValue = "";

    nodeValue = tag6.getChildNodes().item(1).getNodeValue();
    if ( nodeValue == "This child is of nodeType COMMENT") {
      detailStr += "Passed test: got expected Node value ("+ nodeValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ nodeValue +"\n";
      success = false;
    }
    nodeValue = "";

    nodeValue = dom.getFirstChild().getNodeValue();
    if ( nodeValue == "version=\"1.0\"") {
      detailStr += "Passed test: got expected Node value ("+ nodeValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ nodeValue +"\n";
      success = false;
    }
    nodeValue = "";


    nodeValue = tag6.getFirstChild().getNodeValue();
    if ( nodeValue == "This child is of nodeType TEXT") {
      detailStr += "Passed test: got expected Node value ("+ nodeValue +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected Node value, got "+ nodeValue +"\n";
      success = false;
    }
    nodeValue = "";


    methodRegister.setMethodStatus('Node', 'getNodeValue', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNodeValue() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNodeValue() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getNodeValue

function test_Node_getNodeType() {
  /*****************************************************************************
  function: test_Node_getNodeType()

  author: jon@webarcana.com.au

  description:
	Tests Node.getNodeType()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getNodeType() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var elementNode = doc.getFirstChild();

    if (elementNode.getNodeType() == DOMNode.ELEMENT_NODE) {
      detailStr += "Passed test: got expected node type for ELEMENT_NODE ("+ elementNode.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for ELEMENT_NODE, got "+ elementNode.getNodeType() +" \n";
      success = false;
    }

    var textNode = elementNode.getFirstChild();

    if (textNode.getNodeType() == DOMNode.TEXT_NODE) {
      detailStr += "Passed test: got expected node type for TEXT_NODE ("+ textNode.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for TEXT_NODE, got "+ textNode.getNodeType() +" \n";
      success = false;
    }

    if (dom.getNodeType() == DOMNode.DOCUMENT_NODE) {
      detailStr += "Passed test: got expected node type for DOCUMENT_NODE ("+ dom.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for DOCUMENT_NODE, got "+ dom.getNodeType() +" \n";
      success = false;
    }

    var cdataXML =""
    + "<?xml version=\"1.0\"?>"
    + "<ROOTNODE>"
      + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
    + "</ROOTNODE>";

    var cdataDom = makeDOM(cdataXML);
    var cdataDoc = cdataDom.getDocumentElement();
    var cdataNode = cdataDoc.getFirstChild();

    if (cdataNode.getNodeType() == DOMNode.CDATA_SECTION_NODE) {
      detailStr += "Passed test: got expected node type for CDATA_SECTION_NODE ("+ cdataNode.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for CDATA_SECTION_NODE, got "+ cdataNode.getNodeType() +" \n";
      success = false;
    }

    var piXML =""
    + "<?xml version=\"1.0\"?>"
    + "<ROOTNODE>"
      + "<?xml version=\"1.0\"?>"
    + "</ROOTNODE>";

    var piDom = makeDOM(piXML);
    var piDoc = piDom.getDocumentElement();
    var piNode = piDoc.getFirstChild();

    if (piNode.getNodeType() == DOMNode.PROCESSING_INSTRUCTION_NODE) {
      detailStr += "Passed test: got expected node type for PROCESSING_INSTRUCTION_NODE ("+ piNode.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for PROCESSING_INSTRUCTION_NODE, got "+ piNode.getNodeType() +" \n";
      success = false;
    }

    var commentXML =""
    + "<?xml version=\"1.0\"?>"
    + "<ROOTNODE>"
      + "<!--This child is of nodeType COMMENT-->"
    + "</ROOTNODE>";

    var commentDom = makeDOM(commentXML);
    var commentDoc = commentDom.getDocumentElement();
    var commentNode = commentDoc.getFirstChild();

    if (commentNode.getNodeType() == DOMNode.COMMENT_NODE) {
      detailStr += "Passed test: got expected node type for COMMENT_NODE ("+ commentNode.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected node type for COMMENT_NODE, got "+ commentNode.getNodeType() +" \n";
      success = false;
    }

    // supports ELEMENT_NODE, TEXT_NODE, DOCUMENT_NODE, CDATA_SECTION_NODE, PROCESSING_INSTRUCTION_NODE, COMMENT_NODE
    methodRegister.setMethodStatus('Node', 'getNodeType', success);

    if (success) {
      newOption = getTestSuccessOption("Node.getNodeType() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Node.getNodeType() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Node_getNodeType


function test_Node_getChildNodes() {
  /*****************************************************************************
  function: test_Node_getChildNodes

  author: jon@webarcana.com.au

  description:
	Tests Node.getChildNodes()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NodeList', 'getLength')) {
    detailStr += "Failed dependancy: NodeList.getlength \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NodeList', 'item')) {
    detailStr += "Failed dependancy: NodeList.item \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getChildNodes() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var nodeList = doc.getChildNodes();

    if (nodeList.length > 0) {
      detailStr += "Passed test: NodeList is not empty \n";

      var childNode = nodeList.item(0);
      if (childNode.getNodeName() == "TAG1") {
        detailStr += "Passed test: got expected first child in NodeList ("+ childNode.getNodeName() +") \n";
      }
      else {
        detailStr += "Failed test: got unexpected first child in NodeList, got "+ childNode.getNodeName() +" \n";
        success = false;
      }
    }
    else {
      detailStr += "Failed test: NodeList is empty  \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getChildNodes', success);

    if (success) {
        newOption = getTestSuccessOption("Node.getChildNodes() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.getChildNodes() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_getChildNodes

function test_Node_hasChildNodes() {
  /*****************************************************************************
  function: test_Node_hasChildNodes

  author: jon@webarcana.com.au

  description:
	Tests Node.hasChildNodes()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.hasChildNodes() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();

    if (doc.hasChildNodes()) {
      detailStr += "Passed test: got expected status ("+ doc.hasChildNodes() +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected status, got "+ doc.hasChildNodes() +" \n";
      success = false;
    }

    var tag1content = doc.getFirstChild().getFirstChild();

    if (!tag1content.hasChildNodes()) {
      detailStr += "Passed test: got expected status ("+ tag1content.hasChildNodes() +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected status, got "+ tag1content.hasChildNodes() +")\n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'hasChildNodes', success);

    if (success) {
        newOption = getTestSuccessOption("Node.hasChildNodes() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.hasChildNodes() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_hasChildNodes

function test_Node_getAttributes() {
  /*****************************************************************************
  function: test_Node_getAttributes

  author: jon@webarcana.com.au

  description:
	Tests Node.getAttributes()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getLength')) {
    detailStr += "Failed dependancy: NamedNodeMap.length \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.getAttributes() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();
    var attributeNamedNodeMap = tag1.getAttributes();

    if (attributeNamedNodeMap.length > 0) {
      detailStr += "Passed test: attributeNamedNodeMap is not empty \n";

      var attribute = attributeNamedNodeMap.getNamedItem('name');

      if ((attribute) && (attribute.getNodeType() == DOMNode.ATTRIBUTE_NODE)) {
        detailStr += "Passed test: got expected node type attribute ("+ attribute.getNodeType() +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected node type, got "+ attribute.getNodeType() +" \n";
        success = false;
      }
    }
    else {
      detailStr += "Failed test: NodeList is empty  \n";
      success = false;
    }

    methodRegister.setMethodStatus('Node', 'getAttributes', success);

    if (success) {
        newOption = getTestSuccessOption("Node.getAttributes() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.getAttributes() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_getAttributes()

function test_Node_getOwnerDocument() {
  /*****************************************************************************
  function: test_Node_getOwnerDocument

  author: djoham@yahoo.com

  description:
	Tests Node.getOwnerDocument
  *****************************************************************************/
  var dom = makeDOM(testXML);
  var doc = dom.getDocumentElement();


  if (doc.getOwnerDocument() == dom) {
      newOption = getTestSuccessOption("Node.getOwnerDocument() --- Success", "Owner Document was correct");
      insertOptionElement(newOption);
      methodRegister.setMethodStatus('Node', 'getOwnerDocument', true);
  }
  else {
      newOption = getTestFailureOption("Node.getOwnerDocument() --- Failure", "Owner Document was incorrect");
      insertOptionElement(newOption);
      methodRegister.setMethodStatus('Node', 'getOwnerDocument', false);
  }


} // end function test_Node_getOwnerDocument

function test_Document_createElement() {
  /*****************************************************************************
  function: test_Document_createElement

  author: jon@webarcana.com.au

  description:
	Tests Document.createElement()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createElement() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cElement = dom.createElement('MyElement');

      if (cElement.getNodeType() == DOMNode.ELEMENT_NODE ) {
        detailStr += "Passed test: created node is an element \n";
      }
      else {
        detailStr += "Failed test: created node is not an element, got "+ cElement.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (cElement.getNodeName() == 'MyElement') {
          detailStr += "Passed test: created node has expected name \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected name, got "+ cElement.getNodeName() +" \n";
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
        var doc = dom.getDocumentElement();

        // attempt to create an Element with a dodgy Name
        var cElement = dom.createElement('My Element');

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

    methodRegister.setMethodStatus('Document', 'createElement', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createElement() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createElement() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createElement

function test_Document_createDocumentFragment() {
  /*****************************************************************************
  function: test_Document_createDocumentFragment

  author: jon@webarcana.com.au

  description:
	Tests Document.createDocumentFragment()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createDocumentFragment() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cDocumentFragment = dom.createDocumentFragment();

      if (cDocumentFragment.getNodeType() == DOMNode.DOCUMENT_FRAGMENT_NODE ) {
        detailStr += "Passed test: created node is a DocumentFragment \n";
      }
      else {
        detailStr += "Failed test: created node is not a DocumentFragment, got "+ cElement.getNodeType() +" \n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    methodRegister.setMethodStatus('Document', 'createDocumentFragment', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createDocumentFragment() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createDocumentFragment() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createElement

function test_Document_createTextNode() {
  /*****************************************************************************
  function: test_Document_createTextNode

  author: jon@webarcana.com.au

  description:
	Tests Document.createTextNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeValue')) {
    detailStr += "Failed dependancy: Node.getNodeValue() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createTextNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cTextNode = dom.createTextNode('My Text');

      if (cTextNode.getNodeType() == DOMNode.TEXT_NODE) {
        detailStr += "Passed test: created node is a TextNode \n";
      }
      else {
        detailStr += "Failed test: created node is not a TextNode, got "+ cTextNode.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (cTextNode.getNodeValue() == 'My Text') {
          detailStr += "Passed test: created node has expected value ("+ cTextNode.getNodeValue() +") \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected value, got "+ cTextNode.getNodeValue() +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    methodRegister.setMethodStatus('Document', 'createTextNode', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createTextNode() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createTextNode() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createTextNode

function test_Document_createComment() {
  /*****************************************************************************
  function: test_Document_createComment

  author: jon@webarcana.com.au

  description:
	Tests Document.createComment()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeValue')) {
    detailStr += "Failed dependancy: Node.getNodeValue() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createComment() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cComment = dom.createComment('My Comment');

      if (cComment.getNodeType() == DOMNode.COMMENT_NODE) {
        detailStr += "Passed test: created node is a Comment \n";
      }
      else {
        detailStr += "Failed test: created node is not a Comment, got "+ cComment.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (cComment.getNodeValue() == 'My Comment') {
          detailStr += "Passed test: created node has expected value ("+ cComment.getNodeValue() +")\n";
        }
        else {
          detailStr += "Failed test: created node has unexpected value, got "+ cComment.getNodeValue() +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    methodRegister.setMethodStatus('Document', 'createComment', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createComment() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createComment() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createComment

function test_Document_createCDATASection() {
  /*****************************************************************************
  function: test_Document_createCDATASection

  author: jon@webarcana.com.au

  description:
	Tests Document.createCDATASection()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeValue')) {
    detailStr += "Failed dependancy: Node.getNodeValue() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createCDATASection() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var cCDATASection = dom.createCDATASection('My CDATASection');

    if (cCDATASection.getNodeType() == DOMNode.CDATA_SECTION_NODE) {
      detailStr += "Passed test: created node is a CDATASection \n";
    }
    else {
      detailStr += "Failed test: created node is not a CDATASection, got "+ cCDATASection.getNodeType() +" \n";
      success = false;
    }

    if (success) {
      try {
        if (cCDATASection.getNodeValue() == 'My CDATASection') {
          detailStr += "Passed test: created node has expected value ("+ cCDATASection.getNodeValue() +") \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected value, got "+ cCDATASection.getNodeValue() +" \n";
          success = false;
        }
      }
      catch (e) {
        detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
        success = false;
      }
    }

    methodRegister.setMethodStatus('Document', 'createCDATASection', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createCDATASection() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createCDATASection() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createCDATASection

function test_Document_createProcessingInstruction() {
  /*****************************************************************************
  function: test_Document_createProcessingInstruction

  author: jon@webarcana.com.au

  description:
	Tests Document.createProcessingInstruction()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeValue')) {
    detailStr += "Failed dependancy: Node.getNodeValue() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createProcessingInstruction() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cProcessingInstruction = dom.createProcessingInstruction('PIName', 'My PI');

      if (cProcessingInstruction.getNodeType() == DOMNode.PROCESSING_INSTRUCTION_NODE) {
        detailStr += "Passed test: created node is a PI \n";
      }
      else {
        detailStr += "Failed test: created node is not a PI, got "+ cProcessingInstruction.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (cProcessingInstruction.getNodeName() == 'PIName') {
          detailStr += "Passed test: created node has expected name ("+ cProcessingInstruction.getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected name, got "+ cProcessingInstruction.getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if (cProcessingInstruction.getNodeValue() == 'My PI') {
          detailStr += "Passed test: created node has expected value ("+ cProcessingInstruction.getNodeValue() +") \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected value, got "+ cProcessingInstruction.getNodeValue() +" \n";
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
        var doc = dom.getDocumentElement();

        // attempt to create an Element with a dodgy Name
        var cElement = dom.createProcessingInstruction('PI Name', 'My PI');

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


    methodRegister.setMethodStatus('Document', 'createProcessingInstruction', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createProcessingInstruction() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createProcessingInstruction() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createProcessingInstruction

function test_Document_createAttribute() {
  /*****************************************************************************
  function: test_Document_createAttribute

  author: jon@webarcana.com.au

  description:
	Tests Document.createAttribute()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeValue')) {
    detailStr += "Failed dependancy: Node.getNodeValue() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Document.createAttribute() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();

      var cAttribute = dom.createAttribute('AttribName');

      if (cAttribute.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
        detailStr += "Passed test: created node is an Attribute \n";
      }
      else {
        detailStr += "Failed test: created node is not a Attribute, got "+ cAttribute.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (cAttribute.getNodeName() == 'AttribName') {
          detailStr += "Passed test: created node has expected name ("+ cAttribute.getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: created node has unexpected name, got "+ cAttribute.getNodeName() +" \n";
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
        var doc = dom.getDocumentElement();

        // attempt to create an Element with a dodgy Name
        var cElement = dom.createAttribute('Attrib Name');

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

    methodRegister.setMethodStatus('Document', 'createAttribute', success);

    if (success) {
        newOption = getTestSuccessOption("Document.createAttribute() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Document.createAttribute() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Document_createAttribute

function test_Node_insertBefore() {
  /*****************************************************************************
  function: test_Node_insertBefore

  author: jon@webarcana.com.au

  description:
	Tests Node.insertBefore()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getPreviousSibling')) {
    detailStr += "Failed dependancy: Node.getPreviousSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createElement')) {
    detailStr += "Failed dependancy: Document.createElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.insertBefore() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag6 = doc.getLastChild();
      var tag5 = tag6.getPreviousSibling();
      var insertTag = dom.createElement('INSERTED');

      doc.insertBefore(insertTag, tag6);

      if (success) {
        if ((insertTag.getParentNode()) && (insertTag.getParentNode().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: inserted node has spotted getParentNode() \n";
        }
        else {
          detailStr += "Failed test: inserted node has spotted getParentNode(), got "+ insertTag.getParentNode() +" \n";
          success = false;
        }
      }

      if (success) {
        if (insertTag.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE) {
          detailStr += "Passed test: inserted node has spotted getNextSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node has spotted not extSibling, got "+ insertTag.getNextSibling() +" \n";
          success = false;
        }
      }

      if (success) {
        if (insertTag.getNextSibling().getNodeName() == tag6.getNodeName()) {
          detailStr += "Passed test: inserted node's getNextSibling() has expected name ("+ insertTag.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has getNextSibling() has unexpected name, got "+ insertTag.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if (insertTag.getPreviousSibling().getNodeType() == DOMNode.ELEMENT_NODE) {
          detailStr += "Passed test: inserted node has spotted getPreviousSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node has spotted getPreviousSibling(), got "+ insertTag.getPreviousSibling() +" \n";
          success = false;
        }
      }

      if (success) {
        if (insertTag.getPreviousSibling().getNodeName() == tag5.getNodeName()) {
          detailStr += "Passed test: inserted node's getPreviousSibling() has expected name ("+ insertTag.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has getPreviousSibling() has unexpected name, got "+ insertTag.getPreviousSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((tag5.getNextSibling()) && (tag5.getNextSibling().getNodeType()) && (tag5.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: inserted node is spotted via getNextSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node is not spotted via getNextSibling(), got "+ tag5.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if (tag5.getNextSibling().getNodeName() == insertTag.getNodeName()) {
          detailStr += "Passed test: inserted node has expected name ("+ tag5.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has unexpected, got "+ tag5.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((tag6.getPreviousSibling()) && (tag6.getNodeType()) && (tag6.getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: inserted node is spotted via getPreviousSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node is not spotted via getPreviousSibling() \n";
          success = false;
        }
      }

      if (success) {
        if (tag6.getPreviousSibling().getNodeName() == insertTag.getNodeName()) {
          detailStr += "Passed test: inserted node has expected name ("+ tag6.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has unexpected name, got "+ tag6.getPreviousSibling().getNodeName() +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for HIERARCHY_REQUEST_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // get lower level node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // attempt to add high level node to lower level node
        tag3.insertBefore(doc, tag4);

        // should have thrown a HIERARCHY_REQUEST_ERR Exception by now
        detailStr += "Failed test: HIERARCHY_REQUEST_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.HIERARCHY_REQUEST_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for WRONG_DOCUMENT_ERR: Exception
    if (success) {
      try {
        // create 2nd dom document
        var dom2 = makeDOM(testXML);
        var insertTag = dom2.createElement('INSERTED');

        var doc = dom.getDocumentElement();
        var tag6 = doc.getLastChild();
        var tag5 = tag6.getPreviousSibling();

        // attempt to add foreign Node to Node
        doc.insertBefore(insertTag, tag6);

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
        var insertTag = dom.createElement('INSERTED');

        var doc = dom.getDocumentElement();
        var tag6 = doc.getLastChild();
        var tag5 = tag6.getPreviousSibling();

        // make Node readonly
        doc._readonly = true;

        // attempt to add Node to readonly Node
        doc.insertBefore(insertTag, tag6);

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
        // get a tag that is not a child of tag3
        var tag1 = doc.getFirstChild();

        // get test node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // create dummy Attribute
        var newNode = dom.createAttribute('INSERTED');

        // attempt to add dummy node before inappropriate Node
        tag3.insertBefore(newNode, tag1);

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

    methodRegister.setMethodStatus('Node', 'insertBefore', success);

    if (success) {
        newOption = getTestSuccessOption("Node.insertBefore() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.insertBefore() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_insertBefore

function test_Node_replaceChild() {
  /*****************************************************************************
  function: test_Node_replaceChild

  author: jon@webarcana.com.au

  description:
	Tests Node.replaceChild()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getPreviousSibling')) {
    detailStr += "Failed dependancy: Node.getPreviousSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createElement')) {
    detailStr += "Failed dependancy: Node.createElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.replaceChild() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag6 = doc.getLastChild();
      var tag5 = tag6.getPreviousSibling();
      var tag3 = tag5.getPreviousSibling();

      var replaceTag = dom.createElement('REPLACEMENT');

      doc.replaceChild(replaceTag, tag5);

      if (success) {
        if ((replaceTag.getParentNode()) && (replaceTag.getParentNode().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: inserted node has spotted getParentNode() \n";
        }
        else {
          detailStr += "Failed test: inserted node has not spotted getParentNode(), got "+ replaceTag.getParentNode() +" \n";
          success = false;
        }
      }

      if (success) {
        if (replaceTag.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE) {
          detailStr += "Passed test: inserted node has spotted getNextSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node has spotted not extSibling, got "+ replaceTag.getNextSibling() +" \n";
          success = false;
        }
      }

      if (success) {
        if (replaceTag.getNextSibling().getNodeName() == tag6.getNodeName()) {
          detailStr += "Passed test: inserted node's getNextSibling() has expected name ("+ replaceTag.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has getNextSibling() has unexpected name, got "+ replaceTag.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if (replaceTag.getPreviousSibling().getNodeType() == DOMNode.ELEMENT_NODE) {
          detailStr += "Passed test: inserted node has spotted getPreviousSibling() \n";
        }
        else {
          detailStr += "Failed test: inserted node has spotted getPreviousSibling(), got "+ replaceTag.getPreviousSibling() +" \n";
          success = false;
        }
      }

      if (success) {
        if (replaceTag.getPreviousSibling().getNodeName() == tag3.getNodeName()) {
          detailStr += "Passed test: inserted node's getPreviousSibling() has expected name ("+ replaceTag.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: inserted node has getPreviousSibling() has unexpected name, got "+ replaceTag.getPreviousSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if ((tag3.getNextSibling()) && (tag3.getNextSibling().getNodeType()) && (tag3.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE)) {
        detailStr += "Passed test: replacement node is spotted via getNextSibling() \n";
      }
      else {
        detailStr += "Failed test: replacement node is not spotted via getNextSibling() \n";
        success = false;
      }

      if (success) {
        if (tag3.getNextSibling().getNodeName() == replaceTag.getNodeName()) {
          detailStr += "Passed test: replacement node has expected name ("+ tag3.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: replacement node has unexpected name, got "+ tag3.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((tag6.getPreviousSibling()) && (tag6.getNodeType()) && (tag6.getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: replacement node is spotted via getPreviousSibling() \n";
        }
        else {
          detailStr += "Failed test: replacement node is not spotted via getPreviousSibling() \n";
          success = false;
        }
      }

      if (success) {
        if (tag6.getPreviousSibling().getNodeName() == replaceTag.getNodeName()) {
          detailStr += "Passed test: replacement node has expected name ("+ tag6.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: replacement node has unexpected name, got "+ tag6.getPreviousSibling().getNodeName() +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for HIERARCHY_REQUEST_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // get lower level node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // attempt replace lower level node with ancestor node
        tag3.replaceChild(doc, tag4);

        // should have thrown a HIERARCHY_REQUEST_ERR Exception by now
        detailStr += "Failed test: HIERARCHY_REQUEST_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.HIERARCHY_REQUEST_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for WRONG_DOCUMENT_ERR: Exception
    if (success) {
      try {
        // create 2nd dom document
        var dom2 = makeDOM(testXML);
        var insertTag = dom2.createElement('INSERTED');

        var doc = dom.getDocumentElement();
        var tag6 = doc.getLastChild();
        var tag5 = tag6.getPreviousSibling();

        // attempt to replace Node with foreign Node
        doc.replaceChild(insertTag, tag6);

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
        var insertTag = dom.createElement('INSERTED');

        var doc = dom.getDocumentElement();
        var tag6 = doc.getLastChild();
        var tag5 = tag6.getPreviousSibling();

        // make Node readonly
        doc._readonly = true;

        // attempt to replace readonly Node
        doc.replaceChild(insertTag, tag6);

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
        // get a tag that is not a child of tag3
        var tag1 = doc.getFirstChild();

        // get test node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // create dummy Attribute
        var newNode = dom.createAttribute('INSERTED');

        // attempt to add dummy node replacing inappropriate Node
        tag3.insertBefore(newNode, tag1);
        doc.replaceChild(newNode, tag1);

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

    methodRegister.setMethodStatus('Node', 'replaceChild', success);

    if (success) {
        newOption = getTestSuccessOption("Node.replaceChild() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.replaceChild() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_replaceChild

function test_Node_removeChild() {
  /*****************************************************************************
  function: test_Node_removeChild

  author: jon@webarcana.com.au

  description:
	Tests Node.removeChild()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getPreviousSibling')) {
    detailStr += "Failed dependancy: Node.getPreviousSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.removeChild() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag6 = doc.getLastChild();
      var tag5 = tag6.getPreviousSibling();
      var tag3 = tag5.getPreviousSibling();

      var removeTag = doc.removeChild(tag5);

      if (success) {
        if ((tag3.getNextSibling()) && (tag3.getNextSibling().getNodeType()) && (tag3.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: getPreviousSibling() has getNextSibling() \n";
        }
        else {
          detailStr += "Failed test: getPreviousSibling() has no getNextSibling()  \n";
          success = false;
        }
      }

      if (success) {
        if (tag3.getNextSibling().getNodeName() == tag6.getNodeName()) {
          detailStr += "Passed test: getPreviousSibling()'s getNextSibling() has expected name ("+ tag3.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: getPreviousSibling()'s getNextSibling() has unexpected name, got "+ tag3.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((tag6.getPreviousSibling()) && (tag6.getNodeType()) && (tag6.getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: getNextSibling() has getPreviousSibling()  \n";
        }
        else {
          detailStr += "Failed test: getNextSibling() has no getPreviousSibling() \n";
          success = false;
        }
      }

      if (success) {
        if (tag6.getPreviousSibling().getNodeName() == tag3.getNodeName()) {
          detailStr += "Passed test: getNextSibling()'s getPreviousSibling() has expected name ("+ tag6.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: getNextSibling()'s getPreviousSibling() has unexpected name, got "+ tag6.getPreviousSibling().getNodeName() +" \n";
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
        var insertTag = dom.createElement('INSERTED');

        var doc = dom.getDocumentElement();
        var tag6 = doc.getLastChild();

        // make Node readonly
        tag6._readonly = true;

        // attempt to remove readonly Node
        var removeTag = doc.removeChild(tag6);

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
        // get a tag that is not a child of tag3
        var tag1 = doc.getFirstChild();

        // get test node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // create dummy Attribute
        var newNode = dom.createAttribute('INSERTED');

        // attempt to remove inappropriate Node
        var removeTag = tag3.removeChild(tag1);

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

    methodRegister.setMethodStatus('Node', 'removeChild', success);

    if (success) {
        newOption = getTestSuccessOption("Node.removeChild() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.removeChild() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_removeChild

function test_Node_appendChild() {
  /*****************************************************************************
  function: test_Node_appendChild

  author: jon@webarcana.com.au

  description:
	Tests Node.appendChild()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getPreviousSibling')) {
    detailStr += "Failed dependancy: Node.getPreviousSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createElement')) {
    detailStr += "Failed dependancy: Node.createElement \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.appendChild() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag6 = doc.getLastChild();

      var appendTag = dom.createElement('APPENDED');

      doc.appendChild(appendTag);

      if (success) {
        if (appendTag.getParentNode()) {
          detailStr += "Passed test: appended node has spotted getParentNode() \n";
        }
        else {
          detailStr += "Failed test: appended node has no getParentNode() \n";
          success = false;
        }
      }

      if (success) {
        if ((tag6.getNextSibling()) && (tag6.getNextSibling().getNodeType()) && (tag6.getNextSibling().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: original LastNode has getNextSibling() \n";
        }
        else {
          detailStr += "Failed test: original LastNode has no getNextSibling()  \n";
          success = false;
        }
      }

      if (success) {
        if (tag6.getNextSibling().getNodeName() == appendTag.getNodeName()) {
          detailStr += "Passed test: original LastNode's getNextSibling() has expected name ("+ tag6.getNextSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: original LastNode's getNextSibling() has unexpected name, got "+ tag6.getNextSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((appendTag.getPreviousSibling()) && (appendTag.getPreviousSibling().getNodeType()) && (appendTag.getPreviousSibling().getNodeType() == DOMNode.ELEMENT_NODE)) {
          detailStr += "Passed test: appended Node has getPreviousSibling()  \n";
        }
        else {
          detailStr += "Failed test: appended Node has no getPreviousSibling() \n";
          success = false;
        }
      }

      if (success) {
        if (appendTag.getPreviousSibling().getNodeName() == tag6.getNodeName()) {
          detailStr += "Passed test: appended Node's getPreviousSibling() has expected name ("+ appendTag.getPreviousSibling().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: appended Node's getPreviousSibling() has unexpected name, got "+ appendTag.getPreviousSibling().getNodeName() +" \n";
          success = false;
        }
      }

      if (success) {
        if ((doc.getLastChild()) && (doc.getLastChild().getNodeName() == appendTag.getNodeName())) {
          detailStr += "Passed test: parent.getLastChild() has expected name ("+ doc.getLastChild().getNodeName() +") \n";
        }
        else {
          detailStr += "Failed test: parent.getLastChild() has unexpected name, got "+ doc.getLastChild().getNodeName() +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for HIERARCHY_REQUEST_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();

        // get lower level node
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // get child of lower level node
        var tag4 = doc.getLastChild();

        // attempt to add high level node to lower level node
        tag3.appendChild(doc);

        // should have thrown a HIERARCHY_REQUEST_ERR Exception by now
        detailStr += "Failed test: HIERARCHY_REQUEST_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.HIERARCHY_REQUEST_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for WRONG_DOCUMENT_ERR: Exception
    if (success) {
      try {
        // create 2nd dom document
        var dom2 = makeDOM(testXML);
        var foreignTag = dom2.createElement('INSERTED');

        var doc = dom.getDocumentElement();

        // attempt to add foreign Node to Node
        doc.appendChild(foreignTag);

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
        var insertTag = dom.createElement('INSERTED');

        var doc = dom.getDocumentElement();

        // make Node readonly
        doc._readonly = true;

        // attempt to add Node to readonly Node
        doc.appendChild(insertTag);

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

    methodRegister.setMethodStatus('Node', 'appendChild', success);

    if (success) {
        newOption = getTestSuccessOption("Node.appendChild() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.appendChild() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_appendChild

function test_Node_cloneNode() {
  /*****************************************************************************
  function: test_Node_cloneNode

  author: jon@webarcana.com.au

  description:
	Tests Node.cloneNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getLastChild')) {
    detailStr += "Failed dependancy: Node.getLastChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getPreviousSibling')) {
    detailStr += "Failed dependancy: Node.getPreviousSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getParentNode')) {
    detailStr += "Failed dependancy: Node.getParentNode() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'hasChildNodes')) {
    detailStr += "Failed dependancy: Node.hasChildNodes \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getAttributes')) {
    detailStr += "Failed dependancy: Node.getAttributes() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getLength')) {
    detailStr += "Failed dependancy: NamedNodeMap.length \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Node.cloneNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag3 = doc.getChildNodes().item(2);

    var shallowClone = tag3.cloneNode(false);

    if (success) {
      if (!shallowClone.hasChildNodes()) {
        detailStr += "Passed test: shallowClone node has no ChildNodes \n";
      }
      else {
        detailStr += "Failed test: shallowClone node has ChildNodes \n";
        success = false;
      }
    }

    if (success) {
      if (shallowClone.getAttributes().length > 0) {
        detailStr += "Passed test: shallowClone node has getAttributes() \n";
      }
      else {
        detailStr += "Failed test: shallowClone node has no getAttributes() \n";
        success = false;
      }
    }

    if (success) {
      if (!shallowClone.getParentNode()) {
        detailStr += "Passed test: shallowClone node has no getParentNode() \n";
      }
      else {
        detailStr += "Failed test: shallowClone node has getParentNode(), got "+ shallowClone.getParentNode().getNodeName() +" \n";
        success = false;
      }
    }

    if (success) {
      if (!shallowClone.getPreviousSibling()) {
        detailStr += "Passed test: shallowClone node has no getPreviousSibling() \n";
      }
      else {
        detailStr += "Failed test: shallowClone node has getPreviousSibling(), got "+ shallowClone.getPreviousSibling().getNodeName() +" \n";
        success = false;
      }
    }

    if (success) {
      if (!shallowClone.getNextSibling()) {
        detailStr += "Passed test: shallowClone node has no getNextSibling() \n";
      }
      else {
        detailStr += "Failed test: shallowClone node has getNextSibling(), got "+ shallowClone.getNextSibling().getNodeName() +" \n";
        success = false;
      }
    }

    var deepClone = tag3.cloneNode(true);

    if (success) {
      if (deepClone.hasChildNodes()) {
        detailStr += "Passed test: deepClone node has ChildNodes \n";
      }
      else {
        detailStr += "Failed test: deepClone node has no ChildNodes \n";
        success = false;
      }
    }

    if (success) {
      if (deepClone.getAttributes().length > 0) {
        detailStr += "Passed test: deepClone node has getAttributes() \n";
      }
      else {
        detailStr += "Failed test: deepClone node has no getAttributes() \n";
        success = false;
      }
    }

    if (success) {
      if (!deepClone.getParentNode()) {
        detailStr += "Passed test: deepClone node has no getParentNode() \n";
      }
      else {
        detailStr += "Failed test: deepClone node has getParentNode(), got "+ deepClone.getParentNode().getNodeName() +" \n";
        success = false;
      }
    }

    if (success) {
      if (!deepClone.getPreviousSibling()) {
        detailStr += "Passed test: deepClone node has no getPreviousSibling() \n";
      }
      else {
        detailStr += "Failed test: deepClone node has getPreviousSibling(), got "+ deepClone.getPreviousSibling().getNodeName() +" \n";
        success = false;
      }
    }

    if (success) {
      if (!deepClone.getNextSibling()) {
        detailStr += "Passed test: deepClone node has no getNextSibling() \n";
      }
      else {
        detailStr += "Failed test: deepClone node has getNextSibling(), got "+ deepClone.getNextSibling().getNodeName() +" \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Node', 'cloneNode', success);

    if (success) {
        newOption = getTestSuccessOption("Node.cloneNode() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Node.cloneNode() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_Node_cloneNode

function test_Attr_getName() {
  /*****************************************************************************
  function: test_Attr_getName

  author: jon@webarcana.com.au

  description:
	Tests Attr.name
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getAttributes')) {
    detailStr += "Failed dependancy: Node.getAttributes() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    var attrib = tag1.getAttributes().getNamedItem('name');

    var attribName = attrib.getName();

    if (attribName == "name") {
      detailStr += "Passed test: got expected name ("+ attribName +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected name, got "+ attribName +"\n";
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

function test_Attr_getSpecified() {
  /*****************************************************************************
  function: test_Attr_getSpecified

  author: jon@webarcana.com.au

  description:
	Tests Attr.specified
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getAttributes')) {
    detailStr += "Failed dependancy: Node.getAttributes() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getSpecified() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    var attrib = tag1.getAttributes().getNamedItem('name');

    var attribSpecified = attrib.getSpecified();

    if (attribSpecified) {
      detailStr += "Passed test: got expected status for specified attribute ("+ attribSpecified +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected status for specified attribute, got "+ attribSpecified +"\n";
      success = false;
    }

    var emptyAttrib = tag1.getAttributes().getNamedItem('empty');

    var emptyAttribSpecified = emptyAttrib.specified;

    if (!emptyAttribSpecified) {
      detailStr += "Passed test: got expected status for unspecified attribute ("+ emptyAttribSpecified +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected status for unspecified attribute, got "+ emptyAttribSpecified +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getSpecified', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getSpecified() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getSpecified() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getSpecified

function test_Attr_getValue() {
  /*****************************************************************************
  function: test_Attr_getValue

  author: jon@webarcana.com.au

  description:
	Tests Attr.getValue
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getAttributes')) {
    detailStr += "Failed dependancy: Node.getAttributes() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.getValue() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    var attrib = tag1.getAttributes().getNamedItem('name');
    var attribValue = attrib.getValue();

    if (attribValue == 'foo') {
      detailStr += "Passed test: got expected value attribute ("+ attribValue +") \n";
    }
    else {
      detailStr += "Failed test: got unexpected value attribute, got "+ attribValue +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('Attr', 'getValue', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.getValue() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.getValue() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getValue

function test_Attr_setValue() {
  /*****************************************************************************
  function: test_Attr_setValue

  author: jon@webarcana.com.au

  description:
	Tests Attr.setValue
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getAttributes')) {
    detailStr += "Failed dependancy: Node.getAttributes() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NamedNodeMap', 'getNamedItem')) {
    detailStr += "Failed dependancy: NamedNodeMap.getNamedItem \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getValue')) {
    detailStr += "Failed dependancy: Attr.getValue \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Attr.setValue() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag1 = doc.getFirstChild();

      var attrib = tag1.getAttributes().getNamedItem('name');

      attrib.setValue('new value');
      var attribValue = attrib.getValue();

      if (attribValue == 'new value') {
        detailStr += "Passed test: got expected value attribute ("+ attribValue +") \n";
      }
      else {
        detailStr += "Failed test: got unexpected value attribute, got "+ attribValue +" \n";
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
        var doc = dom.getDocumentElement();
        var tag1 = doc.getFirstChild();

        var attrib = tag1.getAttributes().getNamedItem('name');

        // make Node readonly
        attrib._readonly = true;

        // attempt to set value of readonly Attribute
        attrib.setValue('new value');

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


    methodRegister.setMethodStatus('Attr', 'setValue', success);

    if (success) {
      newOption = getTestSuccessOption("Attr.setValue() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Attr.setValue() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Attr_getValue


function test_Element_getTagName() {
  /*****************************************************************************
  function: test_Element_getTagName

  author: jon@webarcana.com.au

  description:
	Tests Element.tagName
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getTagName --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    if (tag1.getNodeType() == DOMNode.ELEMENT_NODE ) {
      detailStr += "Passed test: node has expected type ("+ tag1.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: node has unexpected type, got "+ tag1.getNodeType() +" \n";
      success = false;
    }

    if (tag1.getTagName() == 'TAG1') {
      detailStr += "Passed test: node has expected tag name ("+ tag1.getTagName() +") \n";
    }
    else {
      detailStr += "Failed test: node has unexpected tag name, got "+ tag1.getTagName() +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('Element', 'getTagName', success);

    if (success) {
      newOption = getTestSuccessOption("Element.getTagName() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.getTagName() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_getTagName

function test_Element_getAttribute() {
  /*****************************************************************************
  function: test_Element_getAttribute

  author: jon@webarcana.com.au

  description:
	Tests Element.getAttribute()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getAttribute() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    if (tag1.getNodeType() == DOMNode.ELEMENT_NODE ) {
      detailStr += "Passed test: node has expected type ("+ tag1.getNodeType() +") \n";
    }
    else {
      detailStr += "Failed test: node has unexpected type, got "+ tag1.getNodeType() +" \n";
      success = false;
    }

    if (tag1.getAttribute('name') == 'foo') {
      detailStr += "Passed test: attribute has expected name ("+ tag1.getAttribute('name') +") \n";
    }
    else {
      detailStr += "Failed test: attribute has unexpected name, got "+ tag1.getAttribute('name') +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('Element', 'getAttribute', success);

    if (success) {
      newOption = getTestSuccessOption("Element.getAttribute() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.getAttribute() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_getAttribute

function test_Element_setAttribute() {
  /*****************************************************************************
  function: test_Element_setAttribute

  author: jon@webarcana.com.au

  description:
	Tests Element.setAttribute()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Element', 'getAttribute')) {
    detailStr += "Failed dependancy: Element.getAttribute \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.setAttribute() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag1 = doc.getFirstChild();

      if (tag1.getNodeType() == DOMNode.ELEMENT_NODE ) {
        detailStr += "Passed test: node has expected type ("+ tag1.getNodeType() +") \n";
      }
      else {
        detailStr += "Failed test: node has unexpected type, got "+ tag1.getNodeType() +" \n";
        success = false;
      }

      tag1.setAttribute('name', 'gak');

      if (tag1.getAttribute('name') == 'gak') {
        detailStr += "Passed test: attribute has expected name ("+ tag1.setAttribute('name') +") \n";
      }
      else {
        detailStr += "Failed test: attribute has unexpected name, got "+ tag1.setAttribute('name') +" \n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INVALID_CHARACTER_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var tag1 = doc.getFirstChild();

        // attempt to create an Element with a dodgy Name
        tag1.setAttribute('n ame', 'gak')

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

    methodRegister.setMethodStatus('Element', 'setAttribute', success);

    if (success) {
      newOption = getTestSuccessOption("Element.setAttribute() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.setAttribute() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_setAttribute

function test_Element_removeAttribute() {
  /*****************************************************************************
  function: test_Element_removeAttribute

  author: jon@webarcana.com.au

  description:
	Tests Element.removeAttribute()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Element', 'getAttribute')) {
    detailStr += "Failed dependancy: Element.getAttribute \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.removeAttribute() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag1 = doc.getFirstChild();

      if (tag1.getNodeType() == DOMNode.ELEMENT_NODE ) {
        detailStr += "Passed test: node has expected type ("+ tag1.getNodeType() +") \n";
      }
      else {
        detailStr += "Failed test: node has unexpected type, got "+ tag1.getNodeType() +" \n";
        success = false;
      }

      tag1.removeAttribute('name')
      if (tag1.getAttribute('name') == "") {
        detailStr += "Passed test: attribute has been removed \n";
      }
      else {
        detailStr += "Failed test: attribute has not been removed, got "+ tag1.getAttribute('name') +" \n";
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
        // get an Element Node
        var doc = dom.getDocumentElement();
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        // make Node readonly
        tag3._readonly = true;

        // attempt to add Node to readonly Node
        tag3.removeAttribute('name');

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


    methodRegister.setMethodStatus('Element', 'removeAttribute', success);

    if (success) {
      newOption = getTestSuccessOption("Element.removeAttribute() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.removeAttribute() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_removeAttribute

function test_Element_getAttributeNode() {
  /*****************************************************************************
  function: test_Element_getAttributeNode

  author: jon@webarcana.com.au

  description:
	Tests Element.getAttributeNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createAttribute')) {
    detailStr += "Failed dependancy: Document.createAttribute \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getName')) {
    detailStr += "Failed dependancy: Attr.name \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getValue')) {
    detailStr += "Failed dependancy: Attr.value \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getAttributeNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var tag1 = doc.getFirstChild();

    var nameAttrib = tag1.getAttributeNode('name');

    if (nameAttrib.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
      detailStr += "Passed test: node is an attribute \n";
    }
    else {
      detailStr += "Failed test: node is not an attribute "+ nameAttrib.getNodeType() +" \n";
      success = false;
    }

    if (success) {
      if (nameAttrib.name == 'name') {
        detailStr += "Passed test: attribute has expected name ("+ nameAttrib.name +") \n";
      }
      else {
        detailStr += "Failed test: attribute has unexpected name, got "+ nameAttrib.name +" \n";
        success = false;
      }
    }

    if (success) {
      if (nameAttrib.value == 'foo') {
        detailStr += "Passed test: attribute has expected value ("+ nameAttrib.value +") \n";
      }
      else {
        detailStr += "Failed test: attribute has unexpected value, got "+ nameAttrib.value +" \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Element', 'getAttributeNode', success);

    if (success) {
      newOption = getTestSuccessOption("Element.getAttributeNode() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.getAttributeNode() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_getAttributeNode

function test_Element_setAttributeNode() {
  /*****************************************************************************
  function: test_Element_setAttributeNode

  author: jon@webarcana.com.au

  description:
	Tests Element.setAttributeNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Document', 'createAttribute')) {
    detailStr += "Failed dependancy: Document.createAttribute \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getName')) {
    detailStr += "Failed dependancy: Attr.name \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getValue')) {
    detailStr += "Failed dependancy: Attr.value \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Attr', 'getValue')) {
    detailStr += "Failed dependancy: Attr.value \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Element', 'getAttributeNode')) {
    detailStr += "Failed dependancy: Element.getAttributeNode \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.setAttributeNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag1 = doc.getFirstChild();

      var newAttrib = dom.createAttribute('new');
      newAttrib.value = 'foo';

      tag1.setAttributeNode(newAttrib);

      verifyAttrib = tag1.getAttributeNode('new');

      if (verifyAttrib.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
        detailStr += "Passed test: node is an attribute \n";
      }
      else {
        detailStr += "Failed test: node is not an attribute "+ verifyAttrib.getNodeType() +" \n";
        success = false;
      }

      if (success) {
        if (verifyAttrib.name == 'new') {
          detailStr += "Passed test: attribute has expected name ("+ verifyAttrib.name +") \n";
        }
        else {
          detailStr += "Failed test: attribute has unexpected name, got "+ verifyAttrib.name +" \n";
          success = false;
        }
      }

      if (success) {
        if (verifyAttrib.value == 'foo') {
          detailStr += "Passed test: attribute has expected value ("+ verifyAttrib.value +") \n";
        }
        else {
          detailStr += "Failed test: attribute has unexpected value, got "+ verifyAttrib.value +" \n";
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
        // create 2nd dom document
        var dom2 = makeDOM(testXML);
        var newAttrib2 = dom2.createAttribute('new');

        var doc = dom.getDocumentElement();
        var tag1 = doc.getFirstChild();

        // attempt to add foreign Attribute to Node
        tag1.setAttributeNode(newAttrib2);

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
        var tag1 = doc.getFirstChild();
        var newAttrib = dom.createAttribute('new');

        // make Node readonly
        tag1._readonly = true;

        // attempt to add foreign Attribute to Node
        tag1.setAttributeNode(newAttrib);

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

        // get 1st Node
        var tag1 = doc.getFirstChild();

        // get Attribute from 3rd Node (without removing it)
        var tag3 = tag1.getNextSibling().getNextSibling();
        var tag3Attrib = tag3.getAttributes().getNamedItem('name');

        tag1._readonly = false;

        // attempt to used Attribute to Node
        tag1.setAttributeNode(tag3Attrib);

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

    methodRegister.setMethodStatus('Element', 'setAttributeNode', success);

    if (success) {
      newOption = getTestSuccessOption("Element.setAttributeNode() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.setAttributeNode() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_setAttributeNode

function test_Element_removeAttributeNode() {
  /*****************************************************************************
  function: test_Element_removeAttributeNode

  author: jon@webarcana.com.au

  description:
	Tests Element.removeAttributeNode()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Element', 'getAttributeNode')) {
    detailStr += "Failed dependancy: Element.getAttributeNode \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.removeAttributeNode() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var tag1 = doc.getFirstChild();

      var nameAttrib = tag1.getAttributeNode('name');
      tag1.removeAttributeNode(nameAttrib);

      verifyAttrib = tag1.getAttributeNode('name');

      if (!verifyAttrib) {
        detailStr += "Passed test: attributeNode has been removed \n";
      }
      else {
        detailStr += "Failed test: attributeNode has not been removed \n";
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
        var doc = dom.getDocumentElement();
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        var nameAttrib = tag3.getAttributeNode('name');

        // make Node readonly
        nameAttrib._readonly = true;

        // attempt to remove readonly Attribute
        tag3.removeAttributeNode(nameAttrib);

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
        var tag3 = doc.getFirstChild().getNextSibling().getNextSibling();

        var nameAttrib = tag3.getAttributeNode('name');
        nameAttrib._readonly = false;

        // remove Attribute
        tag3.removeAttributeNode(nameAttrib);

        // attempt to remove Attribute again
        tag3.removeAttributeNode(nameAttrib);

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

    methodRegister.setMethodStatus('Element', 'removeAttributeNode', success);

    if (success) {
      newOption = getTestSuccessOption("Element.removeAttributeNode() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Element.removeAttributeNode() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Element_removeAttributeNode


function test_Element_getElementsByTagName() {
  /*****************************************************************************
  function: test_Element_getElementsByTagName

  author: jon@webarcana.com.au

  description:
	Tests Element.getElementsByTagName()
  *****************************************************************************/
  var testXML = "<?xml version=\"1.0\"?><ROOTNODE><TAG1>original</TAG1><TAG1>and</TAG1><TAG1>the best</TAG1></ROOTNODE>";
  var dom = makeDOM(testXML);

  var detailStr = "";
  var success = true;

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('NodeList', 'getLength')) {
    detailStr += "Failed dependancy: nodeList.length \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Element.getElementsByTagName() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var nodeList = doc.getElementsByTagName("TAG1");

    if (success) {
      if (nodeList.length > 0) {
        detailStr += "Passed test: NodeList is not empty (contains "+ nodeList.length +" Nodes) \n";
      }
      else {
        detailStr += "Failed test: NodeList is empty \n";
        success = false;
      }
    }

    methodRegister.setMethodStatus('Element', 'getElementsByTagName', success);

    if (success) {
        newOption = getTestSuccessOption("Element.getElementsByTagName() --- Success", detailStr);
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("Element.getElementsByTagName() --- Failure", detailStr);
        insertOptionElement(newOption);
    }
  }
} // end function test_getElementsByTagName

function test_CharacterData_getData() {
  /*****************************************************************************
  function: test_CharacterData_getData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.getData
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.getData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      if (success) {
        if (cdataNode.getData() == "this child is of <<<>nodeType CDATA") {
          detailStr += "Passed test: got expected string ("+ cdataNode.getData() +")\n";
        }
        else {
          detailStr += "Failed test: got unexpected string, got "+ cdataNode.getData() +"\n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    methodRegister.setMethodStatus('CharacterData', 'getData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.getData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.getData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_getData

function test_CharacterData_setData() {
  /*****************************************************************************
  function: test_CharacterData_setData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.setData
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[this child is of <<<>nodeType CDATA]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.getData() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.setData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      cdataNode.setData("updated cdata text");

      if (success) {
        if (cdataNode.getData() == "updated cdata text") {
          detailStr += "Passed test: got expected string ("+ cdataNode.getData() +")\n";
        }
        else {
          detailStr += "Failed test: got unexpected string, got "+ cdataNode.getData() +"\n";
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
        var cdataNode = doc.getFirstChild();

        // make it readonly
        cdataNode._readonly = true;

        // attempt to setData on readonly NamedNodeMap
        cdataNode.setData("updated cdata text");

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

    methodRegister.setMethodStatus('CharacterData', 'setData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.setData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.setData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_setData

function test_CharacterData_getLength() {
  /*****************************************************************************
  function: test_CharacterData_getLength

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.getLength
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.getLength() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var cdataNode = doc.getFirstChild();

    var cdataLength = cdataNode.getLength();

    if (cdataLength == "my text string".length) {
      detailStr += "Passed test: got expected length ("+ cdataLength +")\n";
    }
    else {
      detailStr += "Failed test: got unexpected length, got "+ cdataLength +"\n";
      success = false;
    }

    methodRegister.setMethodStatus('CharacterData', 'getLength', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.getLength() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.getLength() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_getLength

function test_CharacterData_substringData() {
  /*****************************************************************************
  function: test_CharacterData_substringData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.substringData()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.substringData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      var subStr = cdataNode.substringData(3, 4);

      if (subStr == "text") {
        detailStr += "Passed test: got expected substring ("+ subStr +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected substring, got "+ subStr +"\n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call substringData with a dodgy index
        var subStr = cdataNode.substringData(23, 4);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

   // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call substringData with a dodgy index
        var subStr = cdataNode.substringData(3, -4);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    methodRegister.setMethodStatus('CharacterData', 'substringData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.substringData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.substringData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_substringData

function test_CharacterData_appendData() {
  /*****************************************************************************
  function: test_CharacterData_appendData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.appendData()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.appendData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      cdataNode.appendData(" appended");

      var verifyAppendedStr = cdataNode.data;

      if (verifyAppendedStr == "my text string appended") {
        detailStr += "Passed test: got expected string ("+ verifyAppendedStr +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected string, got "+ verifyAppendedStr +"\n";
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
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // make Node readonly
        cdataNode._readonly = true;

        // attempt to add data to readonly CharacterData Node
        cdataNode.appendData(" appended");

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

    methodRegister.setMethodStatus('CharacterData', 'appendData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.appendData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.appendData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_appendData

function test_CharacterData_insertData() {
  /*****************************************************************************
  function: test_CharacterData_insertData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.insertData()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.insertData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      cdataNode.insertData(3, "inserted ");

      var verifyInsertedStr = cdataNode.data;

      if (verifyInsertedStr == "my inserted text string") {
        detailStr += "Passed test: got expected string ("+ verifyInsertedStr +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected string, got "+ verifyInsertedStr +"\n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call insertData with a dodgy index
        cdataNode.insertData(33, "inserted ");

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
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
        var cdataNode = doc.getFirstChild();

        // make Node readonly
        cdataNode._readonly = true;

        // attempt to call insertData to readonly Node
        cdataNode.insertData(3, "inserted ");

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

    methodRegister.setMethodStatus('CharacterData', 'insertData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.insertData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.insertData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_insertData

function test_CharacterData_deleteData() {
  /*****************************************************************************
  function: test_CharacterData_deleteData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.deleteData()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.deleteData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      cdataNode.deleteData(3, 5);

      var verifyDeletedStr = cdataNode.data;

      if (verifyDeletedStr == "my string") {
        detailStr += "Passed test: got expected string ("+ verifyDeletedStr +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected string, got "+ verifyDeletedStr +"\n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call deleteData with a dodgy index
        cdataNode.deleteData(33, 5);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call deleteData with a negative count
        cdataNode.deleteData(3, -5);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
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
        var cdataNode = doc.getFirstChild();

        // make Node readonly
        cdataNode._readonly = true;

        // attempt to call deleteData on a readonly Node
        cdataNode.deleteData(3, 5);

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

    methodRegister.setMethodStatus('CharacterData', 'deleteData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.deleteData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.deleteData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_deleteData

function test_CharacterData_replaceData() {
  /*****************************************************************************
  function: test_CharacterData_replaceData

  author: jon@webarcana.com.au

  description:
	Tests CharacterData.replaceData()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[my text string]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CharacterData.replaceData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var cdataNode = doc.getFirstChild();

      cdataNode.replaceData(3, 5, "replaced ");

      var verifyReplacedStr = cdataNode.data;

      if (verifyReplacedStr == "my replaced string") {
        detailStr += "Passed test: got expected substring ("+ verifyReplacedStr +")\n";
      }
      else {
        detailStr += "Failed test: got unexpected substring, got "+ verifyReplacedStr +"\n";
        success = false;
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call deleteData with a dodgy index
        cdataNode.replaceData(33, 5, "replaced ");

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
          detailStr += "Passed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
        }
        else {
          detailStr += "Failed test: caught unexpected Exception ["+ e +" - "+ e.code + "] - "+ dom.getImplementation().translateErrCode(e.code) +"\n";
          success = false;
        }
      }
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var cdataNode = doc.getFirstChild();

        // attempt to call deleteData with a negative count
        cdataNode.replaceData(3, -5, "replaced ");

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
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
        var cdataNode = doc.getFirstChild();

        // make Node readonly
        cdataNode._readonly = true;

        // attempt to call deleteData on a readonly Node
        cdataNode.replaceData(3, 5, "replaced ");

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

    methodRegister.setMethodStatus('CharacterData', 'replaceData', success);

    if (success) {
      newOption = getTestSuccessOption("CharacterData.replaceData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CharacterData.replaceData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CharacterData_replaceData

function test_Text_splitText() {
  /*****************************************************************************
  function: test_Text_splitText

  author: jon@webarcana.com.au

  description:
	Tests Text.splitText()
  *****************************************************************************/
  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType()\n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getLength')) {
    detailStr += "Failed dependancy: CharacterData.length \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("Text.splitText() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var splitTag = doc.getFirstChild().getFirstChild();

      var returnedTag = splitTag.splitText(4);
      var newTag = splitTag.getNextSibling();

      if (splitTag.length == 4) {
        detailStr += "Passed test: text part 1 has expected length ("+ splitTag.length +") \n";
      }
      else {
        detailStr += "Failed test: text part 1 has unexpected length, got "+ splitTag.length +" \n";
        success = false;
      }

      if (success) {
        if (splitTag.data == 'tag1') {
          detailStr += "Passed test: text part 1 has expected value ("+ splitTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text part 1 has unexpected value, got "+ splitTag.data +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag) {
          detailStr += "Passed test: a node was returned  \n";
        }
        else {
          detailStr += "Failed test: a node was not returned \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.getNodeType() == DOMNode.TEXT_NODE) {
          detailStr += "Passed test: returned node is a text node\n";
        }
        else {
          detailStr += "Failed test: returned node is not a text node, got type "+ returnedTag.getNodeType() +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.length == 7) {
          detailStr += "Passed test: text of returned node has expected length ("+ returnedTag.length +") \n";
        }
        else {
          detailStr += "Failed test: text of returned node has unexpected length , got "+ returnedTag.length +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.data == 'content') {
          detailStr += "Passed test: text of returned node has expected value ("+ returnedTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text of returned node has unexpected value, got "+ returnedTag.data +" \n";
          success = false;
        }
      }

      if (success) {
        if (newTag) {
          detailStr += "Passed test: a node was appended to original node  \n";
        }
        else {
          detailStr += "Failed test: a node was not appended to original node \n";
          success = false;
        }
      }

      if (success) {
        if (newTag.getNodeType() == DOMNode.TEXT_NODE) {
          detailStr += "Passed test: appended node is a text node\n";
        }
        else {
          detailStr += "Failed test: appended node is not a text node, got type "+ newTag.getNodeType() +" \n";
          success = false;
        }
      }

      if (success) {
        if (newTag.length == 7) {
          detailStr += "Passed test: text of appended node has expected length ("+ newTag.length +") \n";
        }
        else {
          detailStr += "Failed test: text of appended node has unexpected length , got "+ newTag.length +" \n";
          success = false;
        }
      }

      if (success) {
        if (newTag.data == 'content') {
          detailStr += "Passed test: text of appended node has expected value ("+ newTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text of appended node has unexpected value, got "+ newTag.data +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var splitTag = doc.getFirstChild().getFirstChild();

        // attempt to call splitText with a dodgy index
        var returnedTag = splitTag.splitText(44);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
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
        var splitTag = doc.getFirstChild().getFirstChild();

        // make Node readonly
        splitTag._readonly = true;

        // attempt to call splitText on a readonly Node
        var returnedTag = splitTag.splitText(44);

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

    methodRegister.setMethodStatus('Text', 'splitText', success);

    if (success) {
      newOption = getTestSuccessOption("Text.splitText() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("Text.splitText() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_Text_splitText

function test_CDATASection_splitText() {
  /*****************************************************************************
  function: test_CDATASection_splitText

  author: jon@webarcana.com.au

  description:
	Tests CDATASection.splitText()
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<![CDATA[this is CDATA text]]>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeName')) {
    detailStr += "Failed dependancy: Node.getNodeName() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNodeType')) {
    detailStr += "Failed dependancy: Node.getNodeType()\n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getNextSibling')) {
    detailStr += "Failed dependancy: Node.getNextSibling() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getLength')) {
    detailStr += "Failed dependancy: CharacterData.length \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('CharacterData', 'getData')) {
    detailStr += "Failed dependancy: CharacterData.data \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("CDATASection.splitText() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var splitTag = doc.getFirstChild();

      var returnedTag = splitTag.splitText(5);
      var newTag = splitTag.getNextSibling();

      if (splitTag.length == 5) {
        detailStr += "Passed test: text split node has expected length ("+ splitTag.length +") \n";
      }
      else {
        detailStr += "Failed test: text split node has unexpected length, got "+ splitTag.length +" \n";
        success = false;
      }

      if (success) {
        if (splitTag.data == 'this ') {
          detailStr += "Passed test: text split node has expected value ("+ splitTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text split node has unexpected value, got "+ splitTag.data +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag) {
          detailStr += "Passed test: a node was returned  \n";
        }
        else {
          detailStr += "Failed test: a node was not returned \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.getNodeType() == DOMNode.CDATA_SECTION_NODE) {
          detailStr += "Passed test: returned node is a cdata node\n";
        }
        else {
          detailStr += "Failed test: returned node is not a cdata node, got type "+ returnedTag.getNodeType() +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.length == 13) {
          detailStr += "Passed test: text returned node has expected length ("+ returnedTag.length +") \n";
        }
        else {
          detailStr += "Failed test: text returned node has unexpected length , got "+ returnedTag.length +" \n";
          success = false;
        }
      }

      if (success) {
        if (returnedTag.data == 'is CDATA text') {
          detailStr += "Passed test: text returned node has expected value ("+ returnedTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text returned node has unexpected value, got "+ returnedTag.data +" \n";
          success = false;
        }
      }

      if (success) {
        if (newTag) {
          detailStr += "Passed test: a node was appended to original node  \n";
        }
        else {
          detailStr += "Failed test: a node was not appended to original node \n";
          success = false;
        }
      }

      if (success) {
        if (newTag.getNodeType() == DOMNode.CDATA_SECTION_NODE) {
          detailStr += "Passed test: appended node is a cdata node\n";
        }
        else {
          detailStr += "Failed test: appended node is not a cdata node, got type "+ newTag.getNodeType()
          success = false;
        }
      }

      if (success) {
        if (newTag.length == 13) {
          detailStr += "Passed test: text of appended node has expected length ("+ newTag.length +") \n";
        }
        else {
          detailStr += "Failed test: text of appended node has unexpected length, got "+ newTag.length +" \n";
          success = false;
        }
      }

      if (success) {
        if (newTag.data == 'is CDATA text') {
          detailStr += "Passed test: text of appended node has expected value ("+ newTag.data +") \n";
        }
        else {
          detailStr += "Failed test: text of appended node has unexpected value, got "+ newTag.data +" \n";
          success = false;
        }
      }
    }
    catch (e) {
      detailStr += "Failed test: caught Exception [" + e.code + "] - "+ dom.getImplementation().translateErrCode(e.code);
      success = false;
    }

    // test for INDEX_SIZE_ERR: Exception
    if (success) {
      try {
        var doc = dom.getDocumentElement();
        var splitTag = doc.getFirstChild();

        // attempt to call splitText with a dodgy index
        var returnedTag = splitTag.splitText(44);

        // should have thrown a INDEX_SIZE_ERR Exception by now
        detailStr += "Failed test: INDEX_SIZE_ERR Exception not generated\n";
        success = false;
      }
      catch (e) {
        if (e.code && (e.code == DOMException.INDEX_SIZE_ERR)) {
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
        var splitTag = doc.getFirstChild();

        // make Node readonly
        splitTag._readonly = true;

        // attempt to call splitText on a readonly Node
        var returnedTag = splitTag.splitText(4);

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

    methodRegister.setMethodStatus('CDATASection', 'splitText', success);

    if (success) {
      newOption = getTestSuccessOption("CDATASection.splitText() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("CDATASection.splitText() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_CDATASection_splitText

function test_ProcessingInstruction_getTarget() {
  /*****************************************************************************
  function: test_Node_getTarget

  author: jon@webarcana.com.au

  description:
	Tests ProcessingInstruction.getTarget
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<?xml version=\"1.0\"?>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("ProcessingInstruction.target --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var piNode = doc.getFirstChild();

    var piTarget = piNode.getTarget();

    if (piTarget == "xml") {
      detailStr += "Passed test: pi node has expected target ("+ piTarget +") \n";
    }
    else {
      detailStr += "Failed test: pi node has unexpected target, got "+ piTarget +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('ProcessingInstruction', 'getTarget', success);

    if (success) {
      newOption = getTestSuccessOption("ProcessingInstruction.getTarget() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("ProcessingInstruction.getTarget() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_ProcessingInstruction_getTarget

function test_ProcessingInstruction_getData() {
  /*****************************************************************************
  function: test_Node_getData

  author: jon@webarcana.com.au

  description:
	Tests ProcessingInstruction.getData
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<?xml version=\"1.0\"?>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("ProcessingInstruction.getData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    var doc = dom.getDocumentElement();
    var piNode = doc.getFirstChild();

    var piNodeData = piNode.getData();

    if (piNodeData == "version=\"1.0\"") {
      detailStr += "Passed test: pi node has expected data ("+ piNodeData +") \n";
    }
    else {
      detailStr += "Failed test: pi node has unexpected data, got "+ piNodeData +" \n";
      success = false;
    }

    methodRegister.setMethodStatus('ProcessingInstruction', 'getData', success);

    if (success) {
      newOption = getTestSuccessOption("ProcessingInstruction.getData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("ProcessingInstruction.getData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_ProcessingInstruction_getData

function test_ProcessingInstruction_setData() {
  /*****************************************************************************
  function: test_Node_setData

  author: jon@webarcana.com.au

  description:
	Tests ProcessingInstruction.setData
  *****************************************************************************/
  var testXML =""
            + "<?xml version=\"1.0\"?>"
            + "<ROOTNODE>"
              + "<?xml version=\"1.0\"?>"
            + "</ROOTNODE>";

  var dom = makeDOM(testXML);

  var success = true;
  var detailStr = "";

  if (!methodRegister.getMethodStatus('Document', 'getDocumentElement')) {
    detailStr += "Failed dependancy: Document.documentElement \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('Node', 'getFirstChild')) {
    detailStr += "Failed dependancy: Node.getFirstChild() \n";
    success = false;
  }

  if (!methodRegister.getMethodStatus('ProcessingInstruction', 'getData')) {
    detailStr += "Failed dependancy: ProcessingInstruction.getData() \n";
    success = false;
  }

  if (!success) {
    newOption = getTestWarningOption("ProcessingInstruction.setData() --- Failed Dependancies", detailStr);
    insertOptionElement(newOption);
  }
  else {
    try {
      var doc = dom.getDocumentElement();
      var piNode = doc.getFirstChild();

      piNode.setData('my new data');

      var piNodeData = piNode.getData();

      if (piNodeData == "my new data") {
        detailStr += "Passed test: pi node has expected data ("+ piNodeData +") \n";
      }
      else {
        detailStr += "Failed test: pi node has unexpected data, got "+ piNodeData +" \n";
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
        var doc = dom.getDocumentElement();
        var piNode = doc.getFirstChild();

        // make Node readonly
        piNode._readonly = true;

        // attempt to setData on readonly Node
        piNode.setData('my new data');

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

    methodRegister.setMethodStatus('ProcessingInstruction', 'setData', success);

    if (success) {
      newOption = getTestSuccessOption("ProcessingInstruction.setData() --- Success", detailStr);
      insertOptionElement(newOption);
    }
    else {
      newOption = getTestFailureOption("ProcessingInstruction.setData() --- Failure", detailStr);
      insertOptionElement(newOption);
    }
  }
} // end function test_ProcessingInstruction_setData


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


