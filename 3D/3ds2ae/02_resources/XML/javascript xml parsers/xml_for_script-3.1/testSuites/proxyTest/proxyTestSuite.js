
// =========================================================================
//
// proxyTestSuite.js - a test suite for testing a server-side proxy 
//
// =========================================================================
//
// Copyright (C) 2003 - David Joham (djoham@yahoo.com)
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


var proxyServer;
var returnGuid;
var testCount = 0;
var threadGUID1;
var threadGUID2;
var threadGUID3;
var threadGUIDCount = 0;
var allThreadGUIDs;
var okThreadData = true;


function callback(xml, guid, returnCode) {
    /*****************************************************************************
    function: callbackFunction

    author: djoham@yahoo.com

    description:
			handles all of the callbacks for the test suite. Also
            responsible for launching most of the tests
    *****************************************************************************/

    var errorString = "";
    var guidOK;
    var newOption;
    var returnCodeOK;
    try {
        if (testCount == 0) {
            //testGetRemoteXML
            guidOK = testGuid(guid, "testGetRemoteXML");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "success", "testGetRemoteXML");
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testGetRemoteXML");
                    if (lastStatus == true) {
                        //now check the XML
                        var requiredXML = "<test>Hello World</test>";
                        if (__trim(xml, true, true) == requiredXML) {
                            newOption = getTestSuccessOption("testGetRemoteXML -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testGetRemoteXML -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("XML Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("XML Expected ==" + requiredXML);
                            insertOptionElement(newOption);
                        }
                    }
                }
            }

            testCount++;
            createTestResultsHeader("Parameter Testing");
            testMissingResourceID();
            return;
        }

        if (testCount == 1) {
            //testMissingResourceID
            guidOK = testGuid(guid, "testMissingResourceID");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testMissingResourceID");
                var requiredError = "The required parameter 'resourceID' was not found.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testMissingResourceID");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testMissingResourceID -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testMissingResourceID -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testInvalidResourceID1();
            return;
        }

        if (testCount == 2) {
            //testInvalidResourceID1
            guidOK = testGuid(guid, "testInvalidResourceID1");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testInvalidResourceID1");
                var requiredError = "The resourceID passed in was not valid.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testInvalidResourceID1");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testInvalidResourceID1 -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testInvalidResourceID1 -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testInvalidResourceID2();
            return;
        }
        

        if (testCount == 3) {
            //testInvalidResourceID2
            guidOK = testGuid(guid, "testInvalidResourceID2");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testInvalidResourceID2");
                var requiredError = "The resourceID passed in was not valid.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testInvalidResourceID2");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testInvalidResourceID2 -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testInvalidResourceID2 -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testMissingAuthenticationCode();
            return;
        }
        
                
        if (testCount == 4) {
            //testMissingAuthenticationCode
            guidOK = testGuid(guid, "testMissingAuthenticationCode");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testMissingAuthenticationCode");
                var requiredError = "The required parameter 'authenticationCode' was not found.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testMissingAuthenticationCode");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testMissingAuthenticationCode -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testMissingAuthenticationCode -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testInvalidAuthenticationCode();
            return;
        }

        if (testCount == 5) {
            //testInvalidAuthenticationCode
            guidOK = testGuid(guid, "testInvalidAuthenticationCode");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testInvalidAuthenticationCode");
                var requiredError = "Authentication failure.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testInvalidAuthenticationCode");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testInvalidAuthenticationCode -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testInvalidAuthenticationCode -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testInvalidCallbackFunction();
            //this the invalid callback function will not call this test function (hense the name)
            //I will call it myself. 5 seconds should be enough since I'm creating an error
            //on the proxy side so it doesn't have to go out and get any data
            window.setTimeout("callback()", 5000);
            return;
        }

                
        if (testCount == 6) {
        	//the only test here is to ensure that xmlIOProxyGetLastLoadStatus has "xmlIOProxyGetLastLoadStatus-Error" in it
            //The real error has an unknown string after this and isn't useful for a test case.
            //It would be useful for a programmer.
            var lastStatus = xmlIOProxyGetLastLoadStatus();
            if (lastStatus.indexOf("xmlIOProxyLoadData-Error") == 0) {
                newOption = getTestSuccessOption("testInvalidCallbackFunction -- Success");
                insertOptionElement(newOption);
            }
            else {
                newOption = getTestFailureOption("testInvalidCallbackFunction -- Failure");
                insertOptionElement(newOption);
                newOption = getTestFailureOption("xmlIOProxyGetLastLoadStatus() Returned ==" + lastStatus);
                insertOptionElement(newOption);
                newOption = getTestFailureOption("xmlIOProxyGetLastLoadStatus() should start with \"xmlIOLoadXML-Error\"");
                insertOptionElement(newOption);
			}  
            
            testCount++;
            createTestResultsHeader("Server-Side Error Tests");
            testServerSide404();
            return;          
        }

        if (testCount == 7) {
            //testServerSide404
            guidOK = testGuid(guid, "testServerSide404");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testServerSide404");
                var requiredError = "The requested URL (http://xmljs.sourceforge.net/tools/xmlIOProxy/idontexist.xml) was not found.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testServerSide404");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testServerSide404 -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testServerSide404 -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

            testCount++;
            testServerSideUnknownHost();
            return;
        }
        if (testCount == 8) {
            //testServerSideUnknownHost
            guidOK = testGuid(guid, "testServerSideUnknownHost");
            if (guidOK == true) {
                returnCodeOK = testReturnCode(returnCode, "error", "testServerSideUnknownHost");
                var requiredError = "The requested URL (http://unknown.host.exception) was not found.";
                if (returnCodeOK == true) {
                    lastStatus = testLastStatus("xmlIOProxyLoadData-Called callbackFunction", "testServerSideUnknownHost");
                    if (lastStatus == true) {
                        if (__trim(xml, true, true) == requiredError) {
                            newOption = getTestSuccessOption("testServerSideUnknownHost -- Success");
                            insertOptionElement(newOption);
                        }
                        else {
                            newOption = getTestFailureOption("testServerSideUnknownHost -- Failure");
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Returned ==" + xml);
                            insertOptionElement(newOption);
                            newOption = getTestFailureOption("error Expected ==" + requiredError);
                            insertOptionElement(newOption);
                        }
                	}
                }
            }

			createTestResultsHeader("TEST COMPLETED");
            return;
        }
        
    }
    catch (e) {
        newOption = getTestFailureOption("test harness Failure");
        insertOptionElement(newOption);
        newOption = getTestFailureOption("error: " + e.toString());
        insertOptionElement(newOption);
    }        	



}  //end function callbackFunction



function runxmlIOProxyLoadDataTests() {
    /*****************************************************************************
    function: runTests

    author: djoham@yahoo.com

    description:
			starts the testing process - most of the tests are kicked off in 
            callbackFunction however
    *****************************************************************************/

    testCount = 0;
    if (location.host.toLowerCase().indexOf("sourceforge") > -1) {
    	alert("This test suite is not supported when run from the SourceForge hosting environment.");
        return;
    }
    
    /* catch those trying to run this from a local filesystem
        the first catch should get most since the protocol will be file://
        however, put the rest in in case there are some browsers I don't know about
        that report something like c: (windows) or on UNIX/Mac OSX where
        it might start with a /
    */
    if (location.protocol.toLowerCase().indexOf("file") > -1 || 
        location.protocol.substr(1,1).toLowerCase() == ":" || 
        location.protocol.substr(0,1) == "/" ) { 
        alert("This test suite must be run from within a web server containing one of XML for <SCRIPT>'s proxies.");
        return;
    }
    
    if (document.getElementById("txtProxyServer").value.toLowerCase().indexOf(location.host.toLowerCase()) < 0 ) {
        alert("This test suite must be run from the same server and port (" + location.host + ") that this page originated from.");
        return;
    }
    
    clearTestResults();
    if (document.getElementById("txtProxyServer").value == "") {
    	alert("Please enter a proxy server.");
        document.getElementById("txtProxyServer").focus();
        return;
    }
    proxyServer = document.getElementById("txtProxyServer").value;
    createTestResultsHeader("Starting Test Run");
    createTestResultsHeader("Geting remote XML");
    testGetRemoteXML();

} // end function runTests()





function testInvalidAuthenticationCode() {
    /*****************************************************************************
    function: testInvalidAuthenticationCode

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if the authentication code passed in is invalid
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "0", "callback", "invalid")

} // end function testInvalidAuthenticationCode



function testInvalidCallbackFunction() {
    /*****************************************************************************
    function: testInvalidCallbackFunction

    author: djoham@yahoo.com

    description:
    		Tests to ensure that xmlIO returns a successful status condition in
            xmlIOLoadXMLGetLastStatus if the callback function passed in is invalid
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "0", "invalidcallback", "password"); 

} // end testInvalidCallbackFunction


function testInvalidResourceID1() {
    /*****************************************************************************
    function: testInvalidResourceID1

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if an invalid (in this case, too high) resourceID is passed in
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "10", "callback", "password"); 


} //end function testInvalidResourceID1



function testInvalidResourceID2() {
    /*****************************************************************************
    function: testInvalidResourceID2

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if an invalid (in this case, negative) resourceID is passed in
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "-1", "callback", "password"); 


} //end function testInvalidResourceID2



function testGetRemoteXML() {
    /*****************************************************************************
    function: testGetRemoteXML

    author: djoham@yahoo.com

    description:
			Assuming the proxy and the location of the test XML have
            been set up properly, this test run should return the XML
            located in remoteXML.xml
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "0", "callback", "password")

} // end function testGetRemoteXML


function testGuid(guid, testName) {
    /*****************************************************************************
    function: testGuid

    author: djoham@yahoo.com

    description:
    		compares the GUID passed in with the global guid stored in globalGuid
            if they are the same, do nothing and return true. If they are different, write
            errors to the result output and return false
    *****************************************************************************/

    if (guid != returnGuid) {
        errorString = "The GUID passed back from the proxy (" + guid + ") did not match the GUID assigned from the xmlIO function (" + returnGuid + ")";
        var newOption = getTestFailureOption(testName + " --- Failure");
        insertOptionElement(newOption);
        var newOption = getTestFailureOption(errorString);
        insertOptionElement(newOption);
        return false;
	}
    else {
    	return true;
    }
    
} // end function testGuid


function testLastStatus(requiredStatus, testName) {
    /*****************************************************************************
    function: testLastStatus

    author: djoham@yahoo.com

    description:
    		compares the lastStatus passed in with the lastStatus as reported by xmlIO
            if they are the same, do nothing and return true. If they are different, write
            errors to the result output and return false
    *****************************************************************************/

    var lastStatus = xmlIOProxyGetLastLoadStatus();
    if (requiredStatus != lastStatus) {
        errorString = "The xmlIOLoadXMLLastStatus passed back from xmlIO.js (" + lastStatus + ") did not match the required status (" + requiredStatus + ")";
        var newOption = getTestFailureOption(testName + " --- Failure");
        insertOptionElement(newOption);
        var newOption = getTestFailureOption(errorString);
        insertOptionElement(newOption);
        return false;
	}
    else {
    	return true;
    }

} // end testLastStatus



function testMissingAuthenticationCode() {
    /*****************************************************************************
    function: testMissingAuthenticationCode

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if the authentication code is not passed in
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "0", "callback", "")

} // end function testMissingAuthenticationCode


function testMissingResourceID() {
    /*****************************************************************************
    function: testMissingResourceID

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if the resourceID is not passed in
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "", "callback", "password")

} // end function testMissingResourceID


function testReturnCode(returnCodeReturned, returnCodeRequired, testName) {
    /*****************************************************************************
    function: testReturnCode

    author: djoham@yahoo.com

    description:
    			Compares the return code passed back from the proxy to 
                the return code required. If they are the same, do nothing
                and return true. If they are different, write errors
                to the retult output and return false
    *****************************************************************************/

	if (returnCodeReturned != returnCodeRequired) {
        errorString = "The return passed back from the proxy (" + returnCodeReturned + ") did not match the required turn code (" + returnCodeRequired + ").";
        var newOption = getTestFailureOption(testName + " --- Failure");
        insertOptionElement(newOption);
        var newOption = getTestFailureOption(errorString);
        insertOptionElement(newOption);
        return false;
	}
    else {
    	return true;
    }    	

} // end function testReturnCode


function testServerSideUnknownHost() {
    /*****************************************************************************
    function: testServerSideUnknownHost

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if the resourceID specified returns an unknown host
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "2", "callback", "password")

} // end testServerSide404

function testServerSide404() {
    /*****************************************************************************
    function: testServerSide404

    author: djoham@yahoo.com

    description:
    		Tests to ensure that the proxy returns the correct error condition
            if the resourceID specified returns a 404 
    *****************************************************************************/

    returnGuid = xmlIOProxyLoadData(proxyServer, "1", "callback", "password")

} // end testServerSide404


function testThreading() {
    /*****************************************************************************
    function: testThreading

    author: djoham@yahoo.com

    description:
                Calls xmlIOProxyLoadData three times in quick succession. Tests
                to make sure the API handles multiple calls to the API
                correctly
    *****************************************************************************/
    threadGUID1 = xmlIOProxyLoadData(proxyServer, "3", "callback", "password");
    threadGUID2 = xmlIOProxyLoadData(proxyServer, "4", "callback", "password");
    threadGUID3 = xmlIOProxyLoadData(proxyServer, "5", "callback", "password");
    allThreadGUIDs = threadGUID1 + threadGUID2 + threadGUID3;


} //end testThreading
