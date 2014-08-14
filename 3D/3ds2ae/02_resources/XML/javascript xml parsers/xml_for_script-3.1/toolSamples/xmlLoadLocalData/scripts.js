// =========================================================================
//
// scripts.js - example code for the xmlIOLoadLocalData tool sample application
//
// =========================================================================
//
// Copyright (C) 2003 David Joham (djoham@yahoo.com)
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

var callbackFunctionCalled = false;

function loadLocalXML(loadData) {
    /********************************************************************************
    Function: loadLocalXML

    Author: djoham@yahoo.com

    Description:
        loads the XML file requested via the xmlIOLoadLocalData API. The code to put
        the returned XML data into the text area is in the callback function
    ********************************************************************************/

    //clear the text area
    document.getElementById("txtXML").value = "";

    //set up the global variable
    callbackFunctionCalled = false;

    //the XMLIO API handles all of the data retrieval.
    //all we need to do is tell it which file to load and what
    //function to call when it is finished
    if (loadData == true) {
        xmlIOLoadLocalData("xmlData.xml.htm", "callbackFunction");
    }
    else {

        //we're testing the lastLoadStatus. This takes a while so
        //put up some text explaining the situation
        document.getElementById("txtXML").value = "This demonstration uses an incorrect callback function for the API. After 5 seconds, an error message should appear. Please be patient...";

        //use a bad callback function for the API
        xmlIOLoadLocalData("xmlData.xml.htm", "badCallbackFunction");
    }
    //start a 5 second timer - if we haven't got the data by then, we'll go into
    //our error handling function
    window.setTimeout("errorFunction()", 5000);

} //end function loadLocalXML

function callbackFunction(xmlString) {
    /********************************************************************************
    Function: callbackFunction

    Author: djoham@yahoo.com

    Description:
        called when the xml data has been returned. We should now display the
        data in the text area
    ********************************************************************************/

    callbackFunctionCalled = true;
    document.getElementById("txtXML").value = xmlString;

} // end function callbackFunction


function errorFunction() {
    /********************************************************************************
    Function: errorFunction

    Author: djoham@yahoo.com

    Description:
        This is our timeout function. If we get here and have not yet called the callback
        function, assume things went wrong and tell the user
    ********************************************************************************/

    //only display the error message if we haven't gone through
    //the callback function.
    if (callbackFunctionCalled == false) {
        document.getElementById("txtXML").value = "There was a problem loading the XML.\nThe last reported step in the process was:\n" + xmlIOLoadLocalGetLastLoadStatus();
    }

} // end function errorFunction

