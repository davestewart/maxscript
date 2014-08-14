<?
// =========================================================================
//
// phpProxy.php - PHP reference implementation for xmljsProxy
//
//	Version 3.1
//
// =========================================================================
//
// Copyright (C) 2003 Brandon Zehm (caspian@dotconf.net) and David Joham (djoham@yahoo.com)
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

//visit the XML for <SCRIPT> website at http://xmljs.sourceforge.net


////////////////////////////////////////////////////////////////////
//  function:   doGet
//
//  Author: caspian@dotconf.net
//
//  Description:
//  This function goes out to the net and downloads the requested URL, and returns the data back to the client.
////////////////////////////////////////////////////////////////////
function doGet () {

    // Import incoming parameters
    $authenticationCode = $_GET["authenticationCode"];
    $guid = $_GET["guid"];
    $resourceID = $_GET["resourceID"];
    $callbackFunction = $_GET["callbackFunction"];



    //*********************************************************************
    //  RESOURCES - this ties resourceID's to URLS
    //  put your own resources here in a way similar to the following
    //*********************************************************************
    //*********************************************************************
    //                TEST SUITE VARIABLES - uncomment if you
    //					want to run this proxy through
    //							the test suite
	//
    //	$resourceURLs[0] = "http://xmljs.sourceforge.net/testSuites/proxyTest/remoteXML.xml";  //will return the file
    //	$resourceURLs[1] = "http://xmljs.sourceforge.net/tools/xmlIOProxy/idontexist.xml";     //will return a 404
    //	$resourceURLs[2] = "http://unknown.host.exception";    	//will return unknown host
    //*********************************************************************


    //*********************************************************************
    //                EXAMPLES of RSS News Feeds
    //  $resourceURLs[0] = "http://rss.com.com/2547-12-0-5.xml"; //news.com
    //  $resourceURLs[1] = "http://slashdot.org/slashdot.rdf"; //slashdot
    //  $resourceURLs[2] = "http://www.kde.org/dotkdeorg.rdf"; //KDE News
    //*********************************************************************



    //*********************************************************************************
    //  AUTHENTICATION - ensures the proxy can't be used without knowing the
    //                   authentication code. For full security, use the proxy with SSL
    //                   security turned on.
    //
    //            NOTE! The proxy WILL NOT WORK if the authentication
    //                  code is left unchanged
    //
    //            NOTE! The serverAuthenticationCode cannot contain spaces
    //                  unless you want to manually URL Encode the spaces
    //                  when you call the proxy through the xmlIOLoadXML functions
    //
    //*********************************************************************************

    $serverAuthenticationCode = "authentication code not set";

    //Uncomment out the following line if you would like to run this proxy through the test suite
    //$serverAuthenticationCode = "password";

    // Check to see if we're a go for proxying
    $okToProxy = true;

    if ($resourceID == "") {
        $okToProxy = false;
        $errorString = "The required parameter 'resourceID' was not found.";
    }

    if (!$guid) {
        $okToProxy = false;
        $errorString = "The required parameter 'guid' was not found.";
    }

    if (!$callbackFunction) {
        $okToProxy = false;
        $errorString = "The required parameter 'callbackFunction' was not found.";
    }

    if (!$authenticationCode) {
        $okToProxy = false;
        $errorString = "The required parameter 'authenticationCode' was not found.";
    }

    //check for okToProxy here because if the authenticationCode is null or "", the following will be caught as well and we don't want it to
    if ( ($okToProxy) and ($authenticationCode != $serverAuthenticationCode) ) {
        $okToProxy = false;
        $errorString = "Authentication failure.";
    }

    //check for okToProxy here because if the resourceID is null, the following will throw an exception which we don't want
    if ( ($okToProxy) and (!$resourceURLs[$resourceID]) ) {
        $okToProxy = false;
        $errorString = "The resourceID passed in was not valid.";
    }

    if ($serverAuthenticationCode == "authentication code not set") {
        $okToProxy = false;
        $errorString = "The authentication code on the proxy has not been set. The proxy can not function until the authentication code is set.";
    }



    // Make sure we have all the params we need and that the resourceID exists in our list
    if ($okToProxy) {

        $url = $resourceURLs[$resourceID];
        $ret = "";
        $okRead = true;

        // Connect to the remote webserver, and request the page we want.
        $handle = @fopen ($url, "r");

        // Read that page into $line
        if ($handle) {
            while(!feof($handle)) {
                $ret .= fread($handle, 1024);
            }
        }
        else {
            $okRead = false;
            $errorString = "The requested URL ($url) was not found.";
        }


        if ($okRead == true) {
            //change the HTML into something the browser cannot parse into a DOM tree. The makes
            //the client side rendering faster as well as helps to avoid any potential for abuse
            $ret = str_replace('<', '«', $ret); //String.charAt(171)
            $ret = str_replace('>', '»', $ret); //String.charAt(187)
            $ret = str_replace('&', '§', $ret); //String.charAt(167)
            writeBeginningHTML($guid, $callbackFunction, "success");
            print($ret);
        }
        else {
            //this is probably a 404 or timeout errorr
            writeBeginningHTML($guid, $callbackFunction, "error");
            print($errorString . "\n");
        }
        writeEndHTML();

    }
    else {

        // Something went wrong before we could even proxy. Write an error.
        $errCallbackFunction;
        $errGuid;
        if (!$callbackFunction) {
            $errCallbackFunction = "unknown";
        }
        else {
            $errCallbackFunction = $callbackFunction;
        }

        if (!guid) {
            $errGuid = "unknown";
        }
        else {
            $errGuid = $guid;
        }

        writeBeginningHTML($errGuid, $errCallbackFunction, "error");

        //write the error string
        print($errorString);

        //end the HTML
        writeEndHTML();
    }

} // end doGet


function writeBeginningHTML ($guid, $callbackFunction, $returnCode) {
    print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\"http://www.w3.org/TR/html4/strict.dtd\">\n");
    print("<head>\n");
    print("<title>\n");
    print("Proxy Data\n");
    print("</title>\n");
    print("<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">\n");
    print("</head>\n");
    print("<body onload=\"top.__getXMLFromIFrame('$guid', '$callbackFunction', '$returnCode',document.getElementById('xmlData').value)\">\n");
    print("<div style=\"position: absolute; left: -2000px;\">\n");
    print("<textarea id=\"xmlData\" rows=\"1\" cols=\"1\">\n");

} // end writeBeginningHTML


function writeEndHTML (){
    print("</textarea>\n");
    print("</div>\n");
    print("</body>\n");
    print("</html>\n");
}



// Run the above function(s)
doGet ();



?>
