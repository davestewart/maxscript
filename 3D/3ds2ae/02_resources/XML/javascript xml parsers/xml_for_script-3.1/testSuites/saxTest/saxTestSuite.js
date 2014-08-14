
// =========================================================================
//
// saxtestsSuite.js - a tests suite for testsing xmlsax.js
//
// =========================================================================
//
// Copyright (C) 2002 - David Joham (djoham@yahoo.com)
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
var resultsArray = new Array();


/*****************************************************************************
                            FUNCTIONS
*****************************************************************************/

function compareArrays(array1, array2) {
    /*****************************************************************************
    function: compareArrays

    author: djoham@yahoo.com

    description:
        compares the two arrays passed in. If they are exactly equal
        in content, return true. Otherwise, return false.

    *****************************************************************************/
    //if they're not the same length, then obviously they're not the same
    if (array1.length != array2.length) {
        return false;
    }
    else {

        var intCount = array1.length;
        for(intLoop = 0; intLoop < array1.length; intLoop++) {
            if (array1[intLoop] != array2[intLoop]) {
                //DEBUG CODE
                //alert("path = " + array1[intLoop-2] + "-" + array1[intLoop-1] + "\ndied on \n--" + array1[intLoop] + "-- != \n--" + array2[intLoop] + "--\n" + array1[intLoop+1] + "--" + array2[intLoop+1] + "\n" + array1[intLoop+2] + "--" + array2[intLoop+2]);
                // END DEBUG CODE
                return false;
            }
        }
    }

    return true;
}  //end function compareArrays


function runTests() {
    /*****************************************************************************
    function: runtestss

    author: djoham@yahoo.com

    description:
        Starts the tests run.

    *****************************************************************************/

    // clear the results box
    clearTestResults();

    //initialize the tests object
    var saxtests = new SAXtests();

    //run the tests
    createTestResultsHeader("Starting Test Run");

    createTestResultsHeader("Attribute Tests");
    saxtests.testsAttribute1();  // tests the parser's capability to correctly parse attributes in a tag when the attributes are delimited with double quotes
    saxtests.testsAttribute2();  // tests the parser's capability to correctly parse attributes in a tag when the attributes are delimited with single quotes
    saxtests.testsAttribute3();  // tests the parsers capability to correctly parse attributes in a tag even when the tag ends with a "/"
    saxtests.testsAttribute4();  // tests the parsers capability to correctly parse attributes in a tag when there are formatting characters in the text (tabs, etc)
    saxtests.testsAttribute5();  // tests the parsers capability to correctly parse attributes in a tag when there are formatting characters in the text (tabs, etc) and values
	saxtests.testsAttribute6();  // tests the parsers capability to correctly parse attributes in a tag when there are escaped characters in the value
	saxtests.testsAttribute7();  // tests the parsers capability to correctly parse attributes in a tag when the attribute is blank (2.0 had a bug in this regard where a blank attribute would get the value of the previous attribute)

    createTestResultsHeader("Attribute Error Tests");
    saxtests.testsAttributeError1();  // tests the parsers capability to report errors when there are duplicate attribute names
    saxtests.testsAttributeError2();  // tests the parsers capability to report errors when there are no values for the attributes or if they are not enclosed in quotes
    saxtests.testsAttributeError3();  // tests the parsers capability to report errors when there are no values for the attributes or if they are not enclosed in quotes
    saxtests.testsAttributeError4();  // tests the parsers capability to report errors when there are no values for the attributes or if they are not enclosed in quotes
    saxtests.testsAttributeError5();  // tests the parsers capability to report errors when there are no values for the attributes or if they are not enclosed in quotes
    saxtests.testsAttributeError6();  // tests the parsers capability to report errors when there are no values for the attributes or if they are not enclosed in quotes
    saxtests.testsAttributeError7();  // tests the parsers capability to report errors when there are illegal (unescaped) characters in the attribute values
    saxtests.testsAttributeError8();  // tests the parsers capability to report errors when there are missing closing sequences
    saxtests.testsAttributeError9();  // tests the parsers capability to report the column and row locations of errors


    createTestResultsHeader("CDATA Tests");
    saxtests.testsCDATA1();  // tests the parser's capability to correctly parse out CDATA tags
    saxtests.testsCDATA2();  // tests the parser's capability to correctly parse out CDATA tags


    createTestResultsHeader("CDATA Error Tests");
    saxtests.testsCDATAError1();  // tests the parser's capability to report errors with incorrectly formed CDATA tags


    createTestResultsHeader("Comment Tests");
    saxtests.testsComment1();  // tests the parser's capability to correctly parse comment tags
    saxtests.testsComment2();  // tests the parser's capability to correctly parse comment tags with text formatting included
    saxtests.testsComment3();  // tests the parser's capability to correctly parse comment tags with escaped characters included


    createTestResultsHeader("Comment Error Tests");
    saxtests.testsCommentError1();  // tests the parser's capability to report errors when there are improperly formed comment tags


    createTestResultsHeader("Document Error Tests");
    saxtests.testsDocumentError1();  // tests the parser's capability to report errors when there is invalid text outside of the document element
    saxtests.testsDocumentError2();  // tests the parser's capability to report errors when there is invalid text outside of the document element
    saxtests.testsDocumentError3();  // tests the parser's capability to report errors when there is invalid text outside of the document element
    saxtests.testsDocumentError4();  // tests the parser's capability to report errors when there are illegal characters in element names


    createTestResultsHeader("DTD Tests");
    saxtests.testsDTD1();  // tests the parser's capability to correctly parse DTD's (which will be ignored)
    saxtests.testsDTD2();  // tests the parser's capability to correctly parse DTD's (which will be ignored)


    createTestResultsHeader("DTD Error Tests");
    saxtests.testsDTDError1();  // tests the parser's capability to report errors with malformed DTDs


    createTestResultsHeader("Element Tests");
    saxtests.testsElement1();  // tests the parser's capability to correctly parse elements
    saxtests.testsElement2();  // tests the parser's capability to correctly parse elements when they are nested
    saxtests.testsElement3();  // tests the parser's capability to correctly parse elements even when the element is empty
    saxtests.testsElement4();  // tests the parser's capability to correctly parse elements even when the element's name has formatting characters
    saxtests.testsElement5();  // tests the parser's capability to correctly parse elements when there are single character element names


    createTestResultsHeader("Element Error Tests");
    saxtests.testsElementError1();  // tests the parser's capability to report errors when there are missing closing sequences in tags
    saxtests.testsElementError2();  // tests the parser's capability to report errors when the element is both empty and closing
    saxtests.testsElementError3();  // tests the parser's capability to report errors when the element name does not immediatly follow the "<"
    saxtests.testsElementError4();  // tests the parser's capability to report errors when the element name does not immediatly follow the "<"


    createTestResultsHeader("Event Order Tests");
    saxtests.testsEventOrder();  // tests the parser's capability to fire all of its events in the correct sequence


    createTestResultsHeader("Processing Instruction Tests");
    saxtests.testsPI1();  // tests the parser's capability to correctly parse processing instructions
    saxtests.testsPI2();  // tests the parser's capability to correctly parse processing instructions
    saxtests.testsPI3();  // tests the parser's capability to correctly parse processing instructions


    createTestResultsHeader("Processing Instruction Error Tests");
    saxtests.testsPIError1();  // tests the parser's capability to report errors when there are missing closing sequences in the processing instruction


    createTestResultsHeader("Text Tests");
    saxtests.testsText1();  // tests the parser's capability to report errors when there are missing targets in the processing instruction
    saxtests.testsText2();  // tests the parser's capability to correctly parse the text out of tags


    createTestResultsHeader("Text Error Tests");
    saxtests.testsTextError1();  // tests the parser's capability to correctly parse the text out of tags even when the text contains escaped characters
    saxtests.testsTextError2();  // tests the parser's capability to correctly report errors when there are missing closing sequences in the text

    createTestResultsHeader("Tests Concluded");

} // end function runtestss



/*****************************************************************************
                            SAXtests OBJECT
*****************************************************************************/

SAXtests = function() {
    /*****************************************************************************
    function:   SAXtests

    author: djoham@yahoo.com

    description:
        This is the constructor for the object containing the tests cases
    *****************************************************************************/
} // end function SAXtests


SAXtests.prototype.testsAttribute1 = function() {
    /*****************************************************************************
    function:   testsAttribute1

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        when the attributes are delimited with double quotes
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1=\"value1\" attribute2=\"value2\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=2--attribute1--value1--value1--attribute2--value2--value2";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute1 --- Failure");
        insertOptionElement(newOption);
    }
}  // end function testsAttribute1



SAXtests.prototype.testsAttribute2 = function() {
    /*****************************************************************************
    function:  testsAttribute2

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        when the attributes are delimited with single quotes
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1='value1' attribute2='value2'>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=2--attribute1--value1--value1--attribute2--value2--value2";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute2 --- Failure");
        insertOptionElement(newOption);
    }

}  //end function testsAttribute2


SAXtests.prototype.testsAttribute3 = function() {
    /*****************************************************************************
    function:  testsAttribute3

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        even when the tag ends with a "/"
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tagempty attribute1=\"value1\" attribute2=\"value2\"/>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagempty--attributeCount=2--attribute1--value1--value1--attribute2--value2--value2";
    saxEvent[saxEvent.length] = "endElement--tagempty";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttribute3


SAXtests.prototype.testsAttribute4 = function() {
    /*****************************************************************************
    function:  testsAttribute4

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        when there are formatting characters in the text (tabs, etc)
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag \r\n   \t  attribute1  \t= \r \"value1\"   \n attribute2\r=\r\n\"value2\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=2--attribute1--value1--value1--attribute2--value2--value2";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute4 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute4 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttribute4


SAXtests.prototype.testsAttribute5 = function() {
    /*****************************************************************************
    function:  testsAttribute5

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        when there are formatting characters in the text (tabs, etc)
        and values
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1=\"value\n1\t\" attribute2=\"va l\tu\ne2\" >"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=2--attribute1--value 1 --value 1 --attribute2--va l u e2--va l u e2";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute5 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute5 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttribute5


SAXtests.prototype.testsAttribute6 = function() {
    /*****************************************************************************
    function:  testsAttribute6

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse attributes in a tag
        when there are escaped characters in the value
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1=\"value&amp;data\" attribute2=\"novalue&lt;value\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=2--attribute1--value&data--value&data--attribute2--novalue<value--novalue<value";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute6 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute6 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttribute6



SAXtests.prototype.testsAttribute7 = function() {
    /*****************************************************************************
    function:   testsAttribute1

    author: djoham@yahoo.com

    description:
		tests the parsers capability to correctly parse attributes in a tag when the 
		attribute is blank (2.0 had a bug in this regard where a blank attribute 
		would get the value of the previous attribute)
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1=\"value1\" attribute2=\"value2\" attribute3=\"\" attribute4=\" \" attribute5=\"value5\" >"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=5--attribute1--value1--value1--attribute2--value2--value2--attribute3------attribute4-- -- --attribute5--value5--value5";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttribute7 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttribute7 --- Failure");
        insertOptionElement(newOption);
    }
}  // end function testsAttribute7


SAXtests.prototype.testsAttributeError1 = function() {
    /*****************************************************************************
    function:  testsAttributeError1

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        duplicate attribute names

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute1=\"value\" attribute1=\"value\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: duplicate attributes not allowed";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError1 --- Failure");
        insertOptionElement(newOption);
    }

} //end function testsAttributeError1


SAXtests.prototype.testsAttributeError2 = function() {
    /*****************************************************************************
    function:  testsAttributeError2

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        no values for the attributes or if they are not enclosed in quotes

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: values are required and must be in quotes";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError2 --- Failure");
        insertOptionElement(newOption);
    }

} // end function testsAttributeError2


SAXtests.prototype.testsAttributeError3 = function() {
    /*****************************************************************************
    function:  testsAttributeError3

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        no values for the attributes or if they are not enclosed in quotes

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: values are required and must be in quotes";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError3 --- Failure");
        insertOptionElement(newOption);
    }

} // end function testsAttributeError3


SAXtests.prototype.testsAttributeError4 = function() {
    /*****************************************************************************
    function:  testsAttributeError4

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        no values for the attributes or if they are not enclosed in quotes

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=value>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: values are required and must be in quotes";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError4 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError4 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttributeError4


SAXtests.prototype.testsAttributeError5 = function() {
    /*****************************************************************************
    function:  testsAttributeError5

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        no values for the attributes or if they are not enclosed in quotes

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=\"value>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: values are required and must be in quotes";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError5 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError5 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttributeError5


SAXtests.prototype.testsAttributeError6 = function() {
    /*****************************************************************************
    function:  testsAttributeError6

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        no values for the attributes or if they are not enclosed in quotes

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=\"value'>"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: values are required and must be in quotes";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError6 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError6 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttributeError6


SAXtests.prototype.testsAttributeError7 = function() {
    /*****************************************************************************
    function:  testsAttributeError7

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        illegal (unescaped) characters in the attribute values
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=\"1 < 2\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Attribute: \"<\" not allowed in attribute values";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError7 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError7 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsAttributeError7


SAXtests.prototype.testsAttributeError8 = function() {
    /*****************************************************************************
    function:  testsAttributeError8

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors when there are
        missing closing sequences
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<tag attribute=\"This & that\">"
        + "</tag>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Entity: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError8 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError8 --- Failure");
        insertOptionElement(newOption);
    }

} // testsAttributeError8


SAXtests.prototype.testsAttributeError9 = function() {
    /*****************************************************************************
    function:  testsAttributeError9

    author: djoham@yahoo.com

    description:
        tests the parser's capability to locate the line numbers and
        column numbers of errors

    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>\n"
        + "<root>\n"
        + "<tag attribute1=\"value\" attribute1=\"value\">\n"
        + "</tag>"
        + "</root>";

    handler.reportErrorLocation = true;
    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "characters--\n";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--\n";
    saxEvent[saxEvent.length] = "fatalError--Attribute: duplicate attributes not allowed--column=25--line=3";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsAttributeError9 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsAttributeError9 --- Failure");
        insertOptionElement(newOption);
    }

} //end function testsAttributeError9


SAXtests.prototype.testsCDATA1 = function() {
    /*****************************************************************************
    function:  testsCDATA1

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse out CDATA tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<![CDATA[CDATA Text]]>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startCDATA";
    saxEvent[saxEvent.length] = "characters--CDATA Text";
    saxEvent[saxEvent.length] = "endCDATA";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsCDATA1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsCDATA1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsCDATA1


SAXtests.prototype.testsCDATA2 = function() {
    /*****************************************************************************
    function:  testsCDATA2

    author: djoham@yahoo.com

    description:
        testss the parser's capability to correctly parse out CDATA tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<![CDATA[This & that, 1 < 2 and 4 > 3. &amp;]]>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startCDATA";
    saxEvent[saxEvent.length] = "characters--This & that, 1 < 2 and 4 > 3. &amp;";
    saxEvent[saxEvent.length] = "endCDATA";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsCDATA2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsCDATA2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsCDATA2


SAXtests.prototype.testsCDATAError1 = function() {
    /*****************************************************************************
    function:  testsCDATAError1

    author: djoham@yahoo.com

    description:
        testss the parser's capability to report errors with incorrectly
        formed CDATA tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<![CDATA[CDATA Text]>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--CDATA: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsCDATAError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsCDATAError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsCDATAError1


SAXtests.prototype.testsComment1 = function() {
    /*****************************************************************************
    function:  testsComment1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse comment tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<!--Comment Text-->"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "comment--Comment Text";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsComment1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsComment1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsComment1


SAXtests.prototype.testsComment2 = function() {
    /*****************************************************************************
    function:  testsComment2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse comment tags
        with text formatting included
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<!--     Comment -- Text \r\n   -->"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "comment--     Comment -- Text \n   ";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsComment2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsComment2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsComment2


SAXtests.prototype.testsComment3 = function() {
    /*****************************************************************************
    function:  testsComment3

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse comment tags
        with escaped characters included
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<!--Comment &amp; Text-->"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "comment--Comment &amp; Text";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsComment3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsComment3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsComment3


SAXtests.prototype.testsCommentError1 = function() {
    /*****************************************************************************
    function:  testsCommentError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there are
        improperly formed comment tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<!--Comment Text->"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Comment: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsCommentError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsCommentError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsCommentError1


SAXtests.prototype.testsDocumentError1 = function() {
    /*****************************************************************************
    function:  testsDocumentError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there is invalid
        text outside of the document element
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "</root>"
        + "Text outside document node";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "fatalError--Document: only comments, processing instructions, or whitespace allowed outside of document element";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDocumentError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDocumentError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDocumentError1


SAXtests.prototype.testsDocumentError2 = function() {
    /*****************************************************************************
    function:  testsDocumentError2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there is invalid
        text outside of the document element
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "Text outside document node"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "fatalError--Document: only comments, processing instructions, or whitespace allowed outside of document element";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDocumentError2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDocumentError2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDocumentError2


SAXtests.prototype.testsDocumentError3 = function() {
    /*****************************************************************************
    function:  testsDocumentError3

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there is invalid
        text outside of the document element
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "&amp;";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "fatalError--Document: only comments, processing instructions, or whitespace allowed outside of document element";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDocumentError3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDocumentError3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDocumentError3


SAXtests.prototype.testsDocumentError4 = function() {
    /*****************************************************************************
    function:  testsDocumentError4

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there are
        illegal characters in element names
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<<<>>>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "fatalError--Element: \"<\" not allowed in element names";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDocumentError4 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDocumentError4 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDocumentError4


SAXtests.prototype.testsDTD1 = function() {
    /*****************************************************************************
    function:  testsDTD1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse DTD's
        (which will be ignored)
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<!DOCTYPE root SYSTEM \"root.dtd\">"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    //The DTD information will be ignored
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDTD1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDTD1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDTD1


SAXtests.prototype.testsDTD2 = function() {
    /*****************************************************************************
    function:  testsDTD2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse DTD's
        (which will be ignored)
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<!DOCTYPE root ["
            + "<!ELEMENT doesnt  (#PCDATA)>"
            + "<!ELEMENT matter  (#PCDATA)>"
            + "<!ELEMENT this    (#PCDATA)>"
            + "<!ELEMENT is      (#PCDATA)>"
            + "<!ELEMENT ignored (#PCDATA)>"
        + "]>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    //the DTD information will be ignored
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDTD2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDTD2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDTD2


SAXtests.prototype.testsDTDError1 = function() {
    /*****************************************************************************
    function:  testsDTDError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors with malformed DTDs
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<!DOCTYPE root ["
            + "<!ELEMENT doesnt  (#PCDATA)>"
            + "<!ELEMENT matter  (#PCDATA)>"
            + "<!ELEMENT this    (#PCDATA)>"
            + "<!ELEMENT is      (#PCDATA)>"
            + "<!ELEMENT ignored (#PCDATA)>"
        + ">"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "fatalError--DTD: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsDTDError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsDTDError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsDTDError1


SAXtests.prototype.testsElement1 = function() {
    /*****************************************************************************
    function:  testsElement1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse elements
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElement1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElement1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElement1


SAXtests.prototype.testsElement2 = function() {
    /*****************************************************************************
    function:  testsElement2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse elements
        when they are nested
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "<tagnested>"
                + "<tagnested1>"
                + "</tagnested1>"
                + "<tagnested2>"
                + "</tagnested2>"
            + "</tagnested>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagnested--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagnested1--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--tagnested1";
    saxEvent[saxEvent.length] = "startElement--tagnested2--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--tagnested2";
    saxEvent[saxEvent.length] = "endElement--tagnested";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElement2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElement2 --- Failure");
        insertOptionElement(newOption);
    }

}  //end function testsElement2


SAXtests.prototype.testsElement3 = function() {
    /*****************************************************************************
    function:  testsElement3

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse elements
        even when the element is empty
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "<tagempty/>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagempty--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--tagempty";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElement3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElement3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElement3


SAXtests.prototype.testsElement4 = function() {
    /*****************************************************************************
    function:  testsElement4

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse elements
        even when the element's name has formatting characters
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "<tagspace  \n\r\t   \r\n>"
            + "</tagspace>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagspace--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--tagspace";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElement4 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElement4 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElement4


SAXtests.prototype.testsElement5 = function() {
    /*****************************************************************************
    function:  testsElement5

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse elements
        when there are single character element names
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "<tag>"
                + "a tag value"
            + "</tag>"
            + "<a>"
                + "a tag value"
            + "</a>"
            + "<tag>"
                + "a tag value"
            + "</tag>"
            + "<a>"
                + "<tag>"
                    + "a tag value"
                + "</tag>"
            + "</a>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--a tag value";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "startElement--a--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--a tag value";
    saxEvent[saxEvent.length] = "endElement--a";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--a tag value";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "startElement--a--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--a tag value";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "endElement--a";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElement5 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElement5 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElement5


SAXtests.prototype.testsElementError1 = function() {
    /*****************************************************************************
    function:  testsElementError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors
        when there are missing closing sequences in tags
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "fatalError--Element: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElementError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElementError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElementError1


SAXtests.prototype.testsElementError2 = function() {
    /*****************************************************************************
    function:  testsElementError2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors
        when the element is both empty and closing
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "</root/>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "fatalError--Element: cannot be both empty and closing";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElementError2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElementError2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElementError2


SAXtests.prototype.testsElementError3 = function() {
    /*****************************************************************************
    function:  testsElementError3

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors
        when the element name does not immediatly follow the "<"
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<   root   />";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "fatalError--Element: name must immediatly follow \"<\"";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElementError3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElementError3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElementError3


SAXtests.prototype.testsElementError4 = function() {
    /*****************************************************************************
    function:  testsElementError4

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors
        when the element name does not immediatly follow the "<"
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "<>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Element: name must immediatly follow \"<\"";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsElementError4 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsElementError4 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsElementError4


SAXtests.prototype.testsEventOrder = function() {
    /*****************************************************************************
    function:  testsEventOrder

    author: djoham@yahoo.com

    description:
        tests the parser's capability to fire all of its events in the correct
        sequence
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    //clear the global results Array
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\"?>"
        + "<!DOCTYPE root ["
            + "<!ELEMENT doesnt  (#PCDATA)>"
            + "<!ELEMENT matter  (#PCDATA)>"
            + "<!ELEMENT this    (#PCDATA)>"
            + "<!ELEMENT is      (#PCDATA)>"
            + "<!ELEMENT ignored (#PCDATA)>"
        + "]>"
        + "<root>"
            + "<tag></tag>"
            + "<tagtext>content</tagtext>"
            + "<tagattr attribute=\"value\" attribute2=\"value2\">content</tagattr>"
            + "<singleton/>"
            + "<tagnested>"
            + "<tagnested2>content</tagnested2>"
            + "</tagnested>"
            + "<tagmultipletext>"
                + "some text"
                + "<!--comment-->"
                + "more text"
            + "</tagmultipletext>"
            + "<![CDATA[cdata section w/ unescaped chars: <&>'\"]]>"
            + "<?pi	processing=\"data\"?>"
            + "<tagentities>text &lt;&amp;&gt;&apos;&quot;&#169;</tagentities>"
            + "text"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tag--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--tag";
    saxEvent[saxEvent.length] = "startElement--tagtext--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--content";
    saxEvent[saxEvent.length] = "endElement--tagtext";
    saxEvent[saxEvent.length] = "startElement--tagattr--attributeCount=2--attribute--value--value--attribute2--value2--value2";
    saxEvent[saxEvent.length] = "characters--content";
    saxEvent[saxEvent.length] = "endElement--tagattr";
    saxEvent[saxEvent.length] = "startElement--singleton--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--singleton";
    saxEvent[saxEvent.length] = "startElement--tagnested--attributeCount=0";
    saxEvent[saxEvent.length] = "startElement--tagnested2--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--content";
    saxEvent[saxEvent.length] = "endElement--tagnested2";
    saxEvent[saxEvent.length] = "endElement--tagnested";
    saxEvent[saxEvent.length] = "startElement--tagmultipletext--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--some text";
    saxEvent[saxEvent.length] = "comment--comment";
    saxEvent[saxEvent.length] = "characters--more text";
    saxEvent[saxEvent.length] = "endElement--tagmultipletext";
    saxEvent[saxEvent.length] = "startCDATA";
    saxEvent[saxEvent.length] = "characters--cdata section w/ unescaped chars: <&>'\"";
    saxEvent[saxEvent.length] = "endCDATA";
    saxEvent[saxEvent.length] = "processingInstruction--pi--processing=\"data\"";
    saxEvent[saxEvent.length] = "startElement--tagentities--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--text <&>'\"" + String.fromCharCode(169);
    saxEvent[saxEvent.length] = "endElement--tagentities";
    saxEvent[saxEvent.length] = "characters--text";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsEventOrder --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsEventOrder --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsEventOrder


SAXtests.prototype.testsPI1 = function() {
    /*****************************************************************************
    function:  testsPI1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse processing instructions
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsPI1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsPI1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsPI1


SAXtests.prototype.testsPI2 = function() {
    /*****************************************************************************
    function:  testsPI2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse processing instructions
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml?>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsPI2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsPI2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsPI2


SAXtests.prototype.testsPI3 = function() {
    /*****************************************************************************
    function:  testsPI3

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse processing instructions
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?    xml    version=\"1.0\"     ?>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsPI3 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsPI3 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsPI3


SAXtests.prototype.testsPIError1 = function() {
    /*****************************************************************************
    function:  testsPIError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there
        are missing closing sequences in the processing instruction
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\">"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "fatalError--PI: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsPIError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsPIError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsPIError1


SAXtests.prototype.testsPIError2 = function() {
    /*****************************************************************************
    function:  testsPIError2

    author: djoham@yahoo.com

    description:
        tests the parser's capability to report errors when there
        are missing targets in the processing instruction
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?   ?>"
        + "<root>"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "fatalError--PI: target is required";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsPIError2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsPIError2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsPIError2


SAXtests.prototype.testsText1 = function() {
    /*****************************************************************************
    function:  testsText1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse
        the text out of tags
    *****************************************************************************/

    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    xml = "<?xml version=\"1.0\"?>"
    + "<root>"
        + "Text"
    + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--Text";
    saxEvent[saxEvent.length] = "endElement--root"
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsText1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsText1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsText1


SAXtests.prototype.testsText2 = function() {
    /*****************************************************************************
    function:  testsText1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly parse
        the text out of tags even when the text contains escaped characters
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "Text &amp; More Text"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--Text & More Text";
    saxEvent[saxEvent.length] = "endElement--root";
    saxEvent[saxEvent.length] = "endDocument";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsText2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsText2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsText2


SAXtests.prototype.testsTextError1 = function() {
    /*****************************************************************************
    function:  testsTextError1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly report errors when
        there are missing closing sequences in the text
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "Text & More Text"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "characters--Text ";
    saxEvent[saxEvent.length] = "fatalError--Entity: missing closing sequence";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsTextError1 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsTextError1 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsTextError1


SAXtests.prototype.testsTextError2 = function() {
    /*****************************************************************************
    function:  testsText1

    author: djoham@yahoo.com

    description:
        tests the parser's capability to correctly report errors when
        there are invalid escaped characters in the text
    *****************************************************************************/
    var xml;
    var saxEvent = new Array();
    var parser = new SAXDriver();
    var handler = new SAXEventHandler();

    // clear the global resultsArray
    resultsArray = new Array();

    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);


    xml = "<?xml version=\"1.0\"?>"
        + "<root>"
            + "&foo;"
        + "</root>";

    parser.parse(xml);

    saxEvent[saxEvent.length] = "setDocumentLocator";
    saxEvent[saxEvent.length] = "startDocument";
    saxEvent[saxEvent.length] = "processingInstruction--xml--version=\"1.0\"";
    saxEvent[saxEvent.length] = "startElement--root--attributeCount=0";
    saxEvent[saxEvent.length] = "fatalError--Entity: unknown entity";

    if (compareArrays(saxEvent, resultsArray) == true) {
        newOption = getTestSuccessOption("testsTextError2 --- Success");
        insertOptionElement(newOption);
    }
    else {
        newOption = getTestFailureOption("testsTextError2 --- Failure");
        insertOptionElement(newOption);
    }

}  // end function testsTextErro2


/*****************************************************************************
                    SAXEventHandler Object
*****************************************************************************/

SAXEventHandler = function() {
    /*****************************************************************************
    function:  SAXEventHandler

    author: djoham@yahoo.com

    description:
        this is the constructor for the object which will be the sink for
        the SAX events
    *****************************************************************************/

    this.characterData = "";   // there is no guarantee that the text event will only fire once
                                                 // for element texts. This variable keeps track of the text that has
                                                 // been returned in the text events. It is reset  when a non-text
                                                 //event is fired and should be read at that time

    this.reportErrorLocation = false;  //not normally a part of the sax handler,
                                                                  //but needed in the specific case of this
                                                                  //test suite -- see the error exception sinks
}  // end function SAXEventHandler



/*****************************************************************************
                    SAXEventHandler Object SAX INTERFACES
*****************************************************************************/


SAXEventHandler.prototype.characters = function(data, start, length) {
    /*****************************************************************************
    function:  characters

    author: djoham@yahoo.com

    description:
        Fires when character data is found

        ****** NOTE******
        there is no guarantee that this event will only fire once for
        text data. Particularly, in the cases of escaped characters,
        this event can be called multiple times. It is best to keep a
        variable around to collect all of the data returned in this event.
        You'll know all of the text is returned when you get a non-characters
        event.

        The variable that this object keeps for just this purpose is this.characterData

        To ensure that text values are handled properly, each event calls the function
        this._handleCharacterData. This event resets the characterData
        variable for non-characters events. It also calls the function
        this._fullCharacterDataReceived.

        since this event can be called many times, you should put your text handling
        code in the function this._fullCharacterDataReceived if you need to act only
        when you know you have all of the character data for the element.

        data is your full XML string
        start is the beginning of the XML character data being reported to you
        end is the end of the XML character data being reported to you

        the data can be retrieved using the following code:
        var data = data.substr(start, length);

        Generally, you won't have any code here. Place your code in
        this._fullCharacterDataReceived instead

    *****************************************************************************/

    this.characterData += data.substr(start, length);

}  // end function characters


SAXEventHandler.prototype.endDocument = function() {
    /*****************************************************************************
    function:  endDocument

    author: djoham@yahoo.com

    description:
        Fires at the end of the document
    *****************************************************************************/

    this._handleCharacterData();

    //place endDocument event handling code below this line


    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "endDocument";

}  // end function endDocument


SAXEventHandler.prototype.endElement = function(name) {
    /*****************************************************************************
    function:  endElement

    author: djoham@yahoo.com

    description:
        Fires at the end of an element

        name == the element name that is ending
    *****************************************************************************/

    this._handleCharacterData();

    //place endElement event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "endElement--" + name;

}  // end function endElement


SAXEventHandler.prototype.processingInstruction = function(target, data) {
    /*****************************************************************************
    function:  processingInstruction

    author: djoham@yahoo.com

    description:
        Fires when a processing Instruction is found

        In the following processing instruction:
        <?xml version=\"1.0\"?>

        target == xml
        data == version"1.0"
    *****************************************************************************/
    this._handleCharacterData();

    //place processingInstruction event handling code below this line

    var strTemp = "processingInstruction";
    if (target != "") {
        strTemp += "--" + target;
    }

    //There doesn't have to be a data element. If there is none, "" is passed in as the data variable
    if (data != "") {
        strTemp += "--" + data;
    }

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = strTemp;

}  // end function processingInstruction


SAXEventHandler.prototype.setDocumentLocator = function(locator) {
    /*****************************************************************************
    function:  setDocumentLocator

    author: djoham@yahoo.com

    description:
        This is the first event ever called by the parser.

        locator is a reference to the actual parser object that is parsing
        the XML text. Normally, you won't need to trap for this error
        or do anything with the locator object, but if you do need to,
        this is how you get a reference to the object
    *****************************************************************************/

    //setDocumentLocator returns a pointer to the underlying SAX Parser.
    this._handleCharacterData();

    //place setDocumentLocator event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "setDocumentLocator";

}  // end function setDocumentLocator


SAXEventHandler.prototype.startElement = function(name, atts) {
    /*****************************************************************************
    function:  startElement

    author: djoham@yahoo.com

    description:
        Fires at the start of an element

        name == the name of the element that is starting
        atts == an array of element attributes

        The attribute information can be retrieved by calling
        atts.getName([ordinal])  -- zero based
        atts.getValue([ordinal]) -- zero based
        atts.getAttributeCount()
        atts.getLength([attributeName])


    *****************************************************************************/

    this._handleCharacterData();

    //place startElement event handling code below this line

    var strTemp = "startElement--" + name + "--attributeCount=" + atts.getLength();

    var intCount = atts.getLength();
    for (intLoop =0; intLoop < intCount; intLoop++) {
        strTemp += "--" + atts.getName(intLoop);
        strTemp += "--" + atts.getValue(intLoop);
        strTemp += "--" + atts.getValueByName(atts.getName(intLoop));
    }

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = strTemp;

}  // end function startElement


SAXEventHandler.prototype.startDocument = function() {
    /*****************************************************************************
    function:  startDocument

    author: djoham@yahoo.com

    description:
        Fires at the start of the document
    *****************************************************************************/

    this._handleCharacterData();

    //place startDocument event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "startDocument";

}  // end function startDocument


/*****************************************************************************
                    SAXEventHandler Object Lexical Handlers
*****************************************************************************/


SAXEventHandler.prototype.comment = function(data, start, length) {
    /*****************************************************************************
    function:  comment

    author: djoham@yahoo.com

    description:
        Fires when a comment is found

        data is your full XML string
        start is the beginning of the XML character data being reported to you
        end is the end of the XML character data being reported to you

        the data can be retrieved using the following code:
        var data = data.substr(start, length);
    *****************************************************************************/
    this._handleCharacterData();

    //place comment event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "comment--" + data.substr(start,length);

}  // end function comment


SAXEventHandler.prototype.endCDATA = function() {
    /*****************************************************************************
    function:  endCDATA

    author: djoham@yahoo.com

    description:
        Fires at the end of a CDATA element
    *****************************************************************************/
    this._handleCharacterData();

    //place endCDATA event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "endCDATA";

}  // end function endCDATA


SAXEventHandler.prototype.startCDATA = function() {
    /*****************************************************************************
    function:  startCDATA

    author: djoham@yahoo.com

    description:
        Fires at the start of a CDATA element
    *****************************************************************************/
    this._handleCharacterData();

    //place startCDATA event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "startCDATA";

}  // end function startCDATA


/*****************************************************************************
                    SAXEventHandler Object Error Interface
*****************************************************************************/


SAXEventHandler.prototype.error = function(exception) {
    /*****************************************************************************
    function:  error

    author: djoham@yahoo.com

    description:
        Fires when an error is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place error event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "error--" + exception.getMessage();

    //The way we have architected the tests, everything is on line one, which
    //is a bummer. Only report the location information if it has been asked for
    //we have one test that has actually put the XML into separate lines
    if (this.reportErrorLocation == true) {
        resultsArray[resultsArray.length -1] = resultsArray[resultsArray.length -1] + "--column=" + exception.getColumnNumber() + "--line=" + exception.getLineNumber();
    }

}  // end function error


SAXEventHandler.prototype.fatalError = function(exception) {
    /*****************************************************************************
    function:  fatalError

    author: djoham@yahoo.com

    description:
        Fires when a  fatal error is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place fatalError event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "fatalError--" + exception.getMessage();

    //The way we have architected the tests, everything is on line one, which
    //is a bummer. Only report the location information if it has been asked for
    //we have one test that has actually put the XML into separate lines
    if (this.reportErrorLocation == true) {
        resultsArray[resultsArray.length -1] = resultsArray[resultsArray.length -1] + "--column=" + exception.getColumnNumber() + "--line=" + exception.getLineNumber();
    }


}  // end function fatalError


SAXEventHandler.prototype.warning = function(exception) {
    /*****************************************************************************
    function:  warning

    author: djoham@yahoo.com

    description:
        Fires when a warning is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place warning event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "warning--" + exception.getMessage();

    //The way we have architected the tests, everything is on line one, which
    //is a bummer. Only report the location information if it has been asked for
    //we have one test that has actually put the XML into separate lines
    if (this.reportErrorLocation == true) {
        resultsArray[resultsArray.length -1] = resultsArray[resultsArray.length -1] + "--column=" + exception.getColumnNumber() + "--line=" + exception.getLineNumber();
    }

}  // end function warning


/*****************************************************************************
                   SAXEventHandler Object Internal Functions
*****************************************************************************/


SAXEventHandler.prototype._fullCharacterDataReceived = function(fullCharacterData) {
    /*****************************************************************************
    function:  _fullCharacterDataReceived

    author: djoham@yahoo.com

    description:
        this function is called when we know we are finished getting
        all of the character data. If you need to be sure you handle
        your text processing when you have all of the character data,
        your code for that handling should go here

        fullCharacterData contains all of the character data for the element
    *****************************************************************************/

    //place character (text) event handling code below this line

    // append this event to the end of the array tracking the events
    resultsArray[resultsArray.length] = "characters--" + fullCharacterData

}  // end function _fullCharacterDataReceived


SAXEventHandler.prototype._handleCharacterData = function()  {
    /*****************************************************************************
    function:  _handleCharacterData

    author: djoham@yahoo.com

    description:
        This internal function is called at the beginning of every event, with the exception
        of the characters event.  It fires the internal event this._fullCharacterDataReceived
        if there is any data in the this.characterData internal variable.
        It then resets the this.characterData variable to blank

        Generally, you will not need to modify this function
    *****************************************************************************/

    // call the function that lets the user know that all of the text data has been received
    // but only if there is data.
    if (this.characterData != "") {
        this._fullCharacterDataReceived(this.characterData);
    }

    //reset the characterData variable
    this.characterData = "";

}  // end function _handleCharacterData










