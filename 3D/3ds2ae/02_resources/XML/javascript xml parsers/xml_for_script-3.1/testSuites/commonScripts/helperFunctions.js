// =========================================================================
//
// helperFunctions.js - a set of helper functions to assist in the testing of XML for <SCRIPT>
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
//
// Contributor - Jon van Noort <jon@webarcana.com.au>
//
// 03 May 2003 [jon] - updated getTestFailureOption, getTestHeaderOption,
//    getTestWarningOption, getTestSuccessOption
//  added optionValue param, so that option.value can hold additional test details


/*****************************************************************************
                            MODULE VARIABLES
*****************************************************************************/

var docRef = document.getElementById("frmForm"); //global reference to the form object


/*****************************************************************************
                                    FUNCTIONS
*****************************************************************************/

function updateDetails(val) {
    document.getElementById("details").value = "";
    if (val.toLowerCase() != "undefined") {
        document.getElementById("details").value=val;
    }
}

function centerMe(myWindow) {
    /***********************************************************************************
    function: centerMe()

    author: djoham@yahoo.com

    Description:    takes the window passed in and centers it on the screen

    ************************************************************************************/

    //each test suite is 800px wide and 500px tall

    var xPos = screen.width/2 - 400;
    var yPos = screen.height/2 -255;

    myWindow.moveTo(xPos,yPos);

} // end function centerMe


function clearTestResults() {
    /***********************************************************************************
    function: clearTestResults()

    author: djoham@yahoo.com

    Description:    Loops through the test results select object and clears the contents

    ************************************************************************************/
    var intCount = docRef.lstResults.length;

    //again, Opera is really off base here, but I'll work around them

    for (intLoop = 0; intLoop < intCount; intLoop++) {
        if (navigator.appName == "Opera") {
            docRef.lstResults[0] = null;
        }
        else {
            docRef.lstResults.remove(0);
        }
    }

    //for the W3C test, we have an additional field to clear. Put the clear in a try catch
    //for the times we're not in that test
    try {
    	document.getElementById("details").value = "";
    }
    catch (e) {
    	//noop
    }

} // end function clearTestResults


function createTestResultsHeader(header) {
    /***********************************************************************************
    function: createTestResultsHeader

    author: djoham@yahoo.com

    Description:    puts a header block section into the test results section

    ************************************************************************************/

    var blankOption;

    try {
        blankOption = new Option("");
    }
    catch (e) {
        //working around a Mozilla bug the happens in the proxy test suite
        //where the new Option call would fail in Moz 1.3 and 1.6 (and maybe others)
        //this is a gross hack, but it does allow Moz to work with the proxy test suite
        //***HACK***HACK***HACK***HACK***HACK***HACK***HACK***HACK***
        blankOption = document.createElement("option");
    }

    var firstStarOption = getTestHeaderOption("**************************************************************************");
    var newOption = getTestHeaderOption(header.toUpperCase());
    var secondStarOption = getTestHeaderOption("**************************************************************************");

    insertOptionElement(blankOption);
    insertOptionElement(firstStarOption);
    insertOptionElement(newOption);
    insertOptionElement(secondStarOption);

} //end function createTestResultsHeader

function getTestFailureOption(optionText, optionValue) {
    /***********************************************************************************
    function: getTestFailureOption()

    author: djoham@yahoo.com

    Description:    Returns an option element with the "failure" style set

    ************************************************************************************/
    var newOption;

    try {
        newOption = new Option(optionText, optionValue);
    }
    catch (e) {
        //working around a Mozilla bug the happens in the proxy test suite
        //where the new Option call would fail in Moz 1.3 and 1.6 (and maybe others)
        //this is a gross hack, but it does allow Moz to work with the proxy test suite
        //***HACK***HACK***HACK***HACK***HACK***HACK***HACK***HACK***
        newOption = document.createElement("option");
        newOption.innerHTML= "<option value=\"" + optionValue + "\">" + optionText + "</option>";
    }

    newOption.style.color = "red";
    newOption.style.fontWeight = "bold";
    return newOption;
} // end function getTestFailureOption


function getTestHeaderOption(optionText, optionValue) {
    /***********************************************************************************
    function: getTestHeaderOption()

    author: djoham@yahoo.com

    Description:    Returns an option element with the "header" style set

    ************************************************************************************/
    var newOption;

    try {
        newOption = new Option(optionText, optionValue);
    }
    catch (e) {
        //working around a Mozilla bug the happens in the proxy test suite
        //where the new Option call would fail in Moz 1.3 and 1.6 (and maybe others)
        //this is a gross hack, but it does allow Moz to work with the proxy test suite
        //***HACK***HACK***HACK***HACK***HACK***HACK***HACK***HACK***
        newOption = document.createElement("option");
        newOption.innerHTML= "<option value=\"" + optionValue + "\">" + optionText + "</option>"
    }

    newOption.style.color = "green";
    newOption.style.fontSize = "larger"
    newOption.style.fontWeight = "bold";
    return newOption;
} // end function getTestHeaderOption

function getTestWarningOption(optionText, optionValue) {
    /***********************************************************************************
    function: getTestWarningOption()

    author: jon@webarcana.com.au

    Description:    Returns an option element with the "warning" style set

    ************************************************************************************/
    var newOption;

    try {
        newOption = new Option(optionText, optionValue);
    }
    catch (e) {
        //working around a Mozilla bug the happens in the proxy test suite
        //where the new Option call would fail in Moz 1.3 and 1.6 (and maybe others)
        //this is a gross hack, but it does allow Moz to work with the proxy test suite
        //***HACK***HACK***HACK***HACK***HACK***HACK***HACK***HACK***
        newOption = document.createElement("option");
        newOption.innerHTML= "<option value=\"" + optionValue + "\">" + optionText + "</option>";
    }

    newOption.style.color = "orange";
    newOption.style.fontWeight = "bold";
    return newOption;
} // end function getTestWarningOption


function getTestSuccessOption(optionText, optionValue) {
    /***********************************************************************************
    function: getTestSuccessOption()

    author: djoham@yahoo.com

    Description:    Returns an option element with the "success" style set

    ************************************************************************************/

    var newOption;

    try {
    	newOption = new Option(optionText, optionValue);
    }
    catch (e) {
        //working around a Mozilla bug the happens in the proxy test suite
        //where the new Option call would fail in Moz 1.3 and 1.6 (and maybe others)
        //this is a gross hack, but it does allow Moz to work with the proxy test suite
        //***HACK***HACK***HACK***HACK***HACK***HACK***HACK***HACK***

        newOption = document.createElement("option")
        newOption.innerHTML= "<option value=\"" + optionValue + "\">" + optionText + "</option>"

    }

    //IE doesn't support inherit - thanx redmond
    try {
        newOption.style.color = "inherit";
    }
    catch (e) {
        //do nothing
    }
    return newOption;


} // end function getTestSucccessOption


function insertOptionElement(optionObject) {
    /***********************************************************************************
    Function: insertOptionElement()
    Author: djoham@yahoo.com

    Description:    Handles the browser sniffing necessary to insert an
                         option element into the select box

    ************************************************************************************/

   //IE does this wrong according to the W3C. I have to browser sniff
    //http://www.w3.org/TR/2000/CR-DOM-Level-2-20000510/html.html#ID-94282980

   //opera 6 just flat does it wrong. At least IE is in the ballpark

    //with IE being the lowest common denominator, I'll have my API look like it. Nav will take what the
    //API gives it and translate that into what it's supposed to be


    var selectObject = document.getElementById("frmForm").lstResults;

    if (navigator.appName == "Microsoft Internet Explorer") {
        selectObject.add(optionObject);
    }
    else if (navigator.appName == "Opera") {
        selectObject[selectObject.length] = optionObject;
    }
    else {
        //Nav does it right
        selectObject.add(optionObject, null);
    }


} // end function insertOptionElement


function setActionLinkVisibility(visible) {
    /***********************************************************************************
    Function: setActionLinkVisibility
    Author: djoham@yahoo.com

    Description:
        sets the visibility of the action link on the test suite pages -
        this is done to ensure that the user doesn't clink on a link in IE
        before the browser if finished loading the page which results
        in a nasty JavaScript error
    ************************************************************************************/
    if (visible == true) {
        document.getElementById("testSuiteLinkBar").style.visibility = "visible";
    }
    else {
        document.getElementById("testSuiteLinkBar").style.visibility = "hidden";
    }
     
} // end function setActionLinkVisibility
