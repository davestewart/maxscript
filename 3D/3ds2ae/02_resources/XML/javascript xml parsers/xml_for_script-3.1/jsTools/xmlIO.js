// =========================================================================
//
// xmlIO.js - api for the xmlIO functions
//
// version 3.1 
//
// =========================================================================
//
// Copyright (C) 2002 - 2003 David Joham (djoham@yahoo.com)
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

//NOTE: parts of this code were inspired by the book JavaScript Unleashed by R. Allen Wyke, Richard Wagner

//NOTE: parts of this code were inspired by http://developer.apple.com/internet/javascript/iframe.html


//NOTE: Part of this code was written on Feb 1, 2003 after I had learned of the destruction of the space shuttle Columbia.
//      My heart goes out to the families of the seven brave astronauts: 
//      Colonel Rick Husband, Lieutenant Colonel Michael Anderson, Commander Laurel Clark, Captain David Brown, 
//      Commander William McCool, Dr. Kalpana Chawla, and Colonel Ilan Ramon of the Israeli air force. 
//		May they rest in peace.

//		Hail Mary, full of grace. The Lord is with thee. 
//		Blessed art thou amongst women, and blessed is the fruit of thy womb, Jesus.
// 		Holy Mary, Mother of God, pray for us sinners,
//		now and at the hour of our death.
//		Amen
//
//		In memory of STS-107


var _xmlIOProxyGetLastLoadStatus = "";
var _xmlIOLoadLocalDataCallbackFunction = "";
var _xmlIOLoadlocalDataIFrameID = "";
var _xmlIOLoadLocalDataLastLoadStatus = "";
var _xmlIOLoadLocalDataRetryCount = 0;

/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
                        SAVING DATA TO THE CLIENTS HARD DRIVE VIA COOKES
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/                        


function xmlIODeleteData(dataName) {
    /********************************************************************************
    Function: xmlIODeleteData

    Author: djoham@yahoo.com

    Description:
        Deletes the data from the cookie stream
    ********************************************************************************/
    //in order to ensure that the xmlIOGetData doesn't confuse this name with another,
    //(ie having two names like "xml1" and "xml10", 
    //the save routine wraped the name with colons. We must do the same
    dataName = ":::" + dataName + ":::";

    //expire by setting to date in past
    var expDate = new Date("January 01, 1980").toGMTString();
    document.cookie = dataName + "=;expires=" + expDate;


} // end function xmlIODeleteData


function xmlIOGetData(dataName){
    /********************************************************************************
    Function: xmlIOGetData

    Author: djoham@yahoo.com

    Description:
        retrieves the data from the cookie (if the data is there)
    ********************************************************************************/

    //in order to ensure that the xmlIOGetData doesn't confuse this name with another,
    //(ie having two names like "xml1" and "xml10", 
    //the save routine wraped the name with colons. We must do the same
    var origDataName = dataName;
    dataName = ":::" + dataName + ":::";

    var myCookie = " " + document.cookie + ";";
    var cookieName = " " + dataName;
    var cookieStart = myCookie.indexOf(cookieName);
    var cookieEnd;
	var retVal = "";
        
    if (cookieStart != -1){
        cookieStart += cookieName.length;
        cookieEnd = myCookie.indexOf(";", cookieStart);
        retVal = unescape(myCookie.substring((cookieStart+1), cookieEnd));
    }
    
    //if the return value is "", it's possible that the user has upgraded from XML for <SCRIPT> 2.0 to 2.1.
    //we need to check to see if that's the case and handle the request correctly
    //xml for <SCRIPT> used String.fromCharCode(171) and String.fromCharCode(187) as delimiters
    //rather than ":::". I'll just check for String.fromCharCode(171). If it's there, it's worth doing the lookup again.
    if (retVal == "" && document.cookie.indexOf(String.fromCharCode(171)) > -1) {
    	//do the lookup again, this time with the old 2.0 delimiters
        dataName = String.fromCharCode(171) + origDataName + String.fromCharCode(187);

        var myCookie = " " + document.cookie + ";";
        var cookieName = " " + dataName;
        var cookieStart = myCookie.indexOf(cookieName);
        var cookieEnd;
        if (cookieStart != -1){
            cookieStart += cookieName.length;
            cookieEnd = myCookie.indexOf(";", cookieStart);
        }

        var retVal = unescape(myCookie.substring((cookieStart+1), cookieEnd));
	}
            
    return retVal;

}  // end function xmlIOGetData

function xmlIOListSavedDataNames(){
    /********************************************************************************
    Function: xmlIOListSavedDataNames

    Author: djoham@yahoo.com

    Description:
        Returns an array of all the stored names in the XMLIO cookie database
    ********************************************************************************/
    var aryRet = new Array();
    
    var arySplit = document.cookie.split(":::");
    var intCount = arySplit.length;
    for (intLoop = 0; intLoop < intCount; intLoop ++) {
    	//if the split array element is empty or has an equal sign in it, we want to discard it
        if (arySplit[intLoop].indexOf("=") > -1 || arySplit[intLoop] == "") {
        	//do nothing
        }
        else {
        	//add it to the return array
            aryRet[aryRet.length] = arySplit[intLoop];
        }
    }
          
    return aryRet;
    
} // end xmlIOListSavedDataNames


function xmlIOSaveData(dataName, dataValue, expireDate){
    /********************************************************************************
    Function: xmlIOSaveData

    Author: djoham@yahoo.com

    Description:
        Saves the data to the cookie.

    expireDate is optional. If passed in, it must be a valid JavaScript
    Date object. If not passed in, the cookie will expire on Jan 1st
    10 years from when the function was called.
    ********************************************************************************/

    var expireDateGMT; // cookies need GMT values for their expiration date

    //check if expireDate has been passed in
    if (expireDate == null) {
        var x = new Date();  //today
        var z = x.getFullYear() + 10;  //plus 10 years
        var y = new Date("January 01, " + z);  // on Jan1
        expireDateGMT = y.toGMTString();
    }
    else {
        expireDateGMT = expireDate.toGMTString();
    }

    //in order to ensure that the xmlIOGetData doesn't confuse this name with another, 
    //(ie having two names like "xml1" and "xml10", wrap the name with colons
    dataName = ":::" + dataName + ":::";

    //set the cookie
    //document.cookie = dataName + "=" + escape(dataValue) + " ;expires=" + expireDateGMT;
    document.cookie = dataName + "=" + escape(dataValue) + " ;expires=" + expireDateGMT;

}  // end function xmlIOSaveData



/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
                        LOADING XML VIA THE PROXY SERVERS
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/


function xmlIOProxyGetLastLoadStatus() {
    /********************************************************************************
    Function: xmlIOProxyGetLastLoadStatus

    Author: djoham@yahoo.com

    Description:
    		Returns xmlIOProxyGetLastLoadStatus, the last status report as reported
            in the getXMLfromIframe function
    ********************************************************************************/

	return _xmlIOProxyGetLastLoadStatus;


} // end xmlIOLoadXMLGetLastStatus


function xmlIOProxyLoadData(proxyURL, resourceID, callbackFunction, authenticationCode) {
    /********************************************************************************
    Function: xmlIOProxyLoadData

    Author: djoham@yahoo.com

    Description:
        makes the call to the proxy server (proxyURL) to get the XML requested (resourceID)
        and calls  the xmlIO function that reads the XML and returns it to the
        callback function (callBackFunc)
    ********************************************************************************/

    var dataSource = document.createElement("iframe");
    var guid = "guid" + new Date().getTime();
    dataSource.id = guid;
    dataSource.src = __trim(proxyURL, true, true) + "?resourceID=" + resourceID + "&guid=" + guid + "&callbackFunction=" + callbackFunction + "&authenticationCode=" + authenticationCode;
    dataSource.style.position = "absolute";
    dataSource.style.left = "-2000px";

    document.body.appendChild(dataSource);
    return guid;
    
} //end function xmlIOProxyLoadData


function __getXMLFromIFrame(callbackGUID, callbackFunction, proxyReturnCode, xml) {
    /********************************************************************************
    Function: __getXMLFromIFrame

    Author: djoham@yahoo.com

    Description:
		Gets called when the Iframe is finished loading. Unescapes the XML
        and calls the callback function 
    ********************************************************************************/

    var retXML = "";
    //clean up our mess from adding the IFRAMES
    try {
        document.body.removeChild(document.getElementById(callbackGUID));
    }
    catch (e) {
        //noop
    }
    
    try {
    	//The retXML is escaped. use the XML for <SCRIPT>'s unescape function.
        //Put the catch in here to make sure the programmer has included it
        retXML = xmlUnescapeHTMLToXML(xml)
    }
    catch (e) {
    	retXML = "The function xmlUnescapeHTMLToXML was not found. Did you include xmlEscape.js (from the jsTools directory) in your HTML file?";
        proxyReturnCode = "error";

    }

    //if the callback function is an empty string, the try-catch doesn't seem to work
    //the javascript just goes off into the weeds and never comes back
    if (callbackFunction == "") { 
        //in this case, the retXML gives a decent error string, so use it
        alert("xmlIO error in __getXMLFromIFrame:\nErrorString: " + retXML + "\nguid: " + callbackGUID + "\ncallbackFunction: " + callbackFunction + "\nproxyReturnCode: " + proxyReturnCode);
	}
    else {    
        // try to call the callback function. If it fails, punt and just set the status
        try {
            _xmlIOProxyGetLastLoadStatus = "xmlIOProxyLoadData-Called callbackFunction"; // must be before the following line
            eval(callbackFunction + "(retXML, callbackGUID, proxyReturnCode)");
        }
        catch (e) {
            _xmlIOProxyGetLastLoadStatus = "xmlIOProxyLoadData-Error: xmlIO error in __getXMLFromIFrame:\nErrorString: " + e.toString() + "\nguid: " + callbackGUID + "\ncallbackFunction: " + callbackFunction + "\nproxyReturnCode: " + proxyReturnCode;
        }
	}
} // end function __getXMLFromIFrame




/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
                        LOADING XML VIA LOCAL FILE ACCESS
         (files on the same web server or files on the local hard drive)
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/

function xmlIOLoadLocalData(dataURL, callbackFunction) {
    /********************************************************************************
    Function: xmlIOLoadLocalData

    Author: djoham@yahoo.com

    Description:
            Loads up an IFRAME in the background with its src being dataURL
            then goes through an enourmous amount of stupid gymnastics to make
            sure it gets that data back to the calling javascript
    ********************************************************************************/

    _xmlIOLoadLocalDataCallbackFunction = callbackFunction;
    _xmlIOLoadLocalDataLastLoadStatus = "Starting xmlIOLoadLocalData";
    var _xmlIOLoadLocalDataRetryCount = 0;

    //create the IFrame and start the loading process
    var dataFrame;
    try {
        try {
            dataFrame = document.createElement("iframe");
            //dataFrame.src has to be here for konq 3.0x to work properly
            dataFrame.src = dataURL;
            dataFrame.id = new Date().valueOf();
            dataFrame.style.position = "absolute";
            dataFrame.style.left = "-2000px";
            _xmlIOLoadlocalDataIFrameID = dataFrame.id;
            document.body.appendChild(dataFrame);
        }
        catch (e) {
            _xmlIOLoadLocalDataLastLoadStatus = "ERROR: xmlIOLoadLocalData cannot be used in this browser";
        }
        if (!document.readyState) {
            //try to do the onload (mozilla goes here)
            dataFrame.onload = __loadLocalIFrameXML;
        }
        else {
            //else send it to the readystatechecker (everybody elses goes here)
            window.setTimeout("__readyStateChecker()", 250);
        }
    }
    catch (badFailure) {
        _xmlIOLoadLocalDataLastLoadStatus = badFailure;
    }

    _xmlIOLoadLocalDataLastLoadStatus = "Ending xmlIOLoadLocalData";


} // end function xmlIOLoadLocalData


function __readyStateChecker() {
    /********************************************************************************
    Function: __readyStateChecker

    Author: djoham@yahoo.com

    Description:
            checks the readState of the IFrame document. Tries again and again
            for 10 seconds before it gives up and sends control to the function
            that returns the XML back to the callback function

    *********************************************************************************/

    var dataFrame;

    _xmlIOLoadLocalDataLastLoadStatus = "Starting __readyStateChecker";

    try {
        //(konq, Opera and Moz go here)
        dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID).contentDocument.readyState;
    }
    catch (imIE) {
        try {
            //(IE win or mac)
            dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID).contentWindow.document.readyState;
        }
        catch (imIEMac) {
            try {
                //mac IE goes here - mac ie readystate doesn't seem to work,
                //so I just check for an empty innerHTML.
                //try for 10 seconds
                if (_xmlIOLoadLocalDataRetryCount < 41) {
                    if (__trim(window.frames[_xmlIOLoadlocalDataIFrameID].document.body.innerHTML, true, true) == "") {
                        _xmlIOLoadLocalDataRetryCount++;
                        _xmlIOLoadLocalDataLastLoadStatus = "Calling __readyStateChecker again";
                        window.setTimeout("__readyStateChecker()", 250);
                        return;
                    }
                    else {
                        //we have data - assume we have it all and call the IFrame XML getter
                        _xmlIOLoadLocalDataLastLoadStatus = "Calling __loadLocalIFrameXML";
                        __loadLocalIFrameXML();
                        return;
                    }
                }
                else {
                    //maybe the document is supposed to be empty?
                    _xmlIOLoadLocalDataLastLoadStatus = "__readyStateChecker TimeOut - calling __loadLocalIFrameXML anyway";
                    __loadLocalIFrameXML();
                }
                return;
            }
            catch (badFailure) {
                //punt
                _xmlIOLoadLocalDataLastLoadStatus = "__readStateChecker unrecoverable error: " + badFailure;
                return;
            }
        }
    }
    if (dataFrame.toLowerCase() != "complete" ) {
        //try for 10 seconds
        if (_xmlIOLoadLocalDataRetryCount > 40 ) {
            //giving up and calling the local IFrame XML getter
            _xmlIOLoadLocalDataLastLoadStatus = "__readyStateChecker TimeOut - calling __loadLocalIFrameXML anyway";
            __loadLocalIFrameXML();
        }
        else {
            //try again
            _xmlIOLoadLocalDataRetryCount++;
            _xmlIOLoadLocalDataLastLoadStatus = "Calling __readyStateChecker again";
            window.setTimeout("__readyStateChecker()", 250);
        }
    }
    else {
        _xmlIOLoadLocalDataLastLoadStatus = "Calling __loadLocalIFrameXML";
        __loadLocalIFrameXML();
    }

} // end function __readyStateChecker


function __loadLocalIFrameXML() {
    /********************************************************************************
    Function: __loadLocalIFrameXML

    Author: djoham@yahoo.com

    Description:
            Gets the XML from the IFrame created in xmlIOLoadLocalData,
            unescapes it and then sends it to the callback function

    *********************************************************************************/

    _xmlIOLoadLocalDataLastLoadStatus = "Starting __loadLocalIFrameXML";

    var xmlString = "";

    try {
        var dataFrame = document.getElementById(_xmlIOLoadlocalDataIFrameID);
        try {
            //(Konqueror, Opera and Mozilla get this)
            xmlString = dataFrame.contentDocument.body.innerHTML;
        }
        catch (imIE) {
            try {
                xmlString = dataFrame.contentWindow.document.body.innerHTML;
            }
            catch (imIEMac) {
                xmlString = window.frames[_xmlIOLoadlocalDataIFrameID].document.body.innerHTML;
            }
        }
        try {
            document.body.removeChild(dataFrame);
        }
        catch (badFailure) {
            _xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error(1): " + badFailure;
        }
    }
    catch (badFailure2) {
        _xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error(2): " + badFailure2;
    }

    try {
        //The xmlString is escaped. use the XML for <SCRIPT>'s unescape function.
        //Put the catch in here to make sure the programmer has included it
        xmlString = xmlUnescapeHTMLToXML(xmlString)
    }
    catch (e) {
        alert(e);
        _xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error: The function xmlUnescapeHTMLToXML was not found. Did you include xmlEscape.js (from the jsTools directory) in your HTML file?";
    }

    try {

        eval(_xmlIOLoadLocalDataCallbackFunction + "(xmlString)");
        _xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML successfully called callback function";
    }
    catch (e) {
    	_xmlIOLoadLocalDataLastLoadStatus = "__loadLocalIFrameXML unrecoverable error: Is your callback function correct?";
    }


}

function xmlIOLoadLocalGetLastLoadStatus() {

    return _xmlIOLoadLocalDataLastLoadStatus;

} //end function xmlIOLoadLocalGetLastLoadStatus

/************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
                                        Helper Functions
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************/

function __trim(trimString, leftTrim, rightTrim) {
    /*******************************************************************************************************************
    function: _isEmpty

    Author: may106@psu.edu

    Description:
        helper function to trip a string (trimString) of leading (leftTrim)
        and trailing (rightTrim) whitespace

		Copied from xmldom.js

    *********************************************************************************************************************/
	var whitespace = "\n\r\t ";

	if (__isEmpty(trimString)) {
        return "";
    }

    // the general focus here is on minimal method calls - hence only one
    // substring is done to complete the trim.

    if (leftTrim == null) {
        leftTrim = true;
    }

    if (rightTrim == null) {
        rightTrim = true;
    }

    var left=0;
    var right=0;
    var i=0;
    var k=0;

    // modified to properly handle strings that are all whitespace
    if (leftTrim == true) {
        while ((i<trimString.length) && (whitespace.indexOf(trimString.charAt(i++))!=-1)) {
            left++;
        }
    }
    if (rightTrim == true) {
        k=trimString.length-1;
        while((k>=left) && (whitespace.indexOf(trimString.charAt(k--))!=-1)) {
            right++;
        }
    }
    return trimString.substring(left, trimString.length - right);
} // end function _trim



function __isEmpty(str) {
    /*******************************************************************************************************************
    function: __isEmpty

    Author: mike@idle.org

    Description:
        convenience function to identify an empty string
		copied from xmldom.js
    *********************************************************************************************************************/
    return (str==null) || (str.length==0);

} // end function __isEmpty
