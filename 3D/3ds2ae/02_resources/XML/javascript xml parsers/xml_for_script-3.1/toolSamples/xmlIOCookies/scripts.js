// =========================================================================
//
// scripts.js - example code for the xmlIO interface
//
// =========================================================================
//
// Copyright (C) 2000 - 2003 Michael Houghton (mike@idle.org) and David Joham (djoham@yahoo.com)
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

function deleteXML() {
    /********************************************************************************
    Function: deleteXML

    Author: djoham@yahoo.com

    Description:
        gets the name of the XML and calls the function to delete it from the cookie
    ********************************************************************************/

    var dataName;
    dataName = prompt("Please enter the name of the XML stream to be retrieved.", "");

    if (dataName ==null || dataName == "") {
        //they either hit cancel or didn't enter a name
        alert("Operation canceled");
    }
    else {
        xmlIODeleteData(dataName);
        //for debugging in case of failure
        var origCookie = document.cookie;

        if (xmlIOGetData(dataName) == "") {
            alert("Operation Successful");
        }
        else {
            alert("Operation Failed.\nDEBUG:\n The cookie stream before the operation was:\n" + origCookie + "\n now it is:\n" + document.cookie)
        }
    }
}  // end function deleteXML


function getXML() {
    /********************************************************************************
    Function: getXML

    Author: djoham@yahoo.com

    Description:
        gets the name of the XML and calls the function to get it from the cookie
    ********************************************************************************/

    var dataName;
    dataName = prompt("Please enter the name of the XML stream to be retrieved.", "");

    if (dataName ==null || dataName == "") {
        //they either hit cancel or didn't enter a name
        alert("Operatcion canceled");
    }
    else {
        var dataStream = xmlIOGetData(dataName);
        if (dataStream == "") {
            alert("The name entered was not found or was stored with empty data.");
        }
        else {
            document.getElementById("txtXML").value = dataStream;
        }
    }



} // end function getXML

function listDataFiles() {
    /********************************************************************************
    Function: listDataFiles

    Author: djoham@yahoo.com

    Description:
        Lists all the stored names in the XMLIO cookie database
    ********************************************************************************/
	var dataNames = xmlIOListSavedDataNames();
    var strNames = "";
    
    var intCount = dataNames.length;
    for (intLoop = 0; intLoop < intCount; intLoop++) {
    	strNames += "\t" + dataNames[intLoop] + "\n";
    }
    
    if (strNames != "") {
    	strNames = "The stored XML data names are as follows:\n" + strNames;
    	document.getElementById("txtXML").value = strNames;
    }
    else {
        document.getElementById("txtXML").value = "";
    	alert("No XML data names found");
    }

}

function saveXML() {
    /********************************************************************************
    Function: saveXML

    Author: djoham@yahoo.com

    Description:
        gets the name of the XML and calls the function to save it to the cookie
    ********************************************************************************/

    var dataName;
    dataName = prompt("Please enter the name of the XML stream. This name will be used later for retrieval.", "");

    if (dataName ==null || dataName == "") {
        //they either hit cancel or didn't enter a name
        alert("Operatcion canceled");
    }
    else {
        //go ahead and save the data
        var dataStream = document.getElementById("txtXML").value;
        xmlIOSaveData(dataName, dataStream) //I'm not passing in an expire date (the third param). The default of 10 years is OK for this example

        //now confirm the data is there
        var savedData = xmlIOGetData(dataName);
        if (savedData == dataStream) {
            alert("Operation Successful");
            document.getElementById("txtXML").value = "";
        }
        else {
            alert("Operation Failed.\nPlease ensure you are using a browser\nthat support JavaScript manipulation of cookies\nand that your security settings allow this type of cookie manipulation.");
        }
    }

} // end function saveXML
