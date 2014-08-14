<%@ Language="JavaScript" %>
<%
  // =========================================================================
  //
  // ASPProxy.asp - ASP implementation for xmljsProxy (ported from JSProxy.jsp)
  //
  // version 3.1
  //
  // =========================================================================
  //
  // Copyright (C) 2003 David Joham (djoham@yahoo.com) and Jon van Noort (jon@webarcana.com.au)
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
  // Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
  //

  var errorString;


  /*****************************************************************
  		    RESOURCES - this ties resourceID's to URLS
        put your own resources here and update the size of the array
  *****************************************************************/

  var resourceURLs = new Array();

  //*********************************************************************
  //                TEST SUITE VARIABLES - uncomment if you
  //					want to run this proxy through
  //							the test suite
  //
  //	resourceURLs = new Array(3);
  //	resourceURLs[0] = "http://xmljs.sourceforge.net/testSuites/proxyTest/remoteXML.xml";  //will return the file
  //	resourceURLs[1] = "http://xmljs.sourceforge.net/tools/xmlIOProxy/idontexist.xml";     //will return a 404
  //	resourceURLs[2] = "http://unknown.host.exception";    //will return unknown host
  //*********************************************************************

  /*****************************************************************
  				EXAMPLES of RSS News Feeds
  resourceURLs[0] = "http://rss.com.com/2547-12-0-5.xml"; //news.com
  resourceURLs[1] = "http://slashdot.org/slashdot.rdf"; //slashdot
  resourceURLs[2] = "http://www.kde.org/dotkdeorg.rdf"; //KDE News
  ******************************************************************/

  /*****************************************************************
  AUTHENTICATION - ensures the proxy can't be used without knowing the
                   authentication code. For full security, use the proxy with SSL
                   security turned on.

  		    	NOTE! The proxy WILL NOT WORK if the authentication
                  code is left unchanged

                  NOTE! The serverAuthenticationCode cannot contain spaces
                  unless you want to manually URL Encode the spaces
                  when you call the proxy through the xmlIOLoadXML functions


  *****************************************************************/
  var serverAuthenticationCode = "authentication code not set";

  //Uncomment out the following line if you would like to run this proxy through the test suite
  // var serverAuthenticationCode = "password";

  var resourceIDString         = ""+ Request("resourceID");
  var guid                     = ""+ Request("guid");
  var callbackFunction         = ""+ Request("callbackFunction");
  var clientAuthenticationCode = ""+ Request("authenticationCode");

  //check to see if we're a go for proxying
  var okToProxy = true;

  if (resourceIDString == "") {
  	okToProxy = false;
    errorString = "The required parameter 'resourceID' was not found.";
  }

  if (guid == "") {
  	okToProxy = false;
    errorString = "The required parameter 'guid' was not found.";
  }

  if (callbackFunction == "") {
  	okToProxy = false;
    errorString = "The required parameter 'callbackFunction' was not found.";
  }

  if (clientAuthenticationCode == "") {
  	okToProxy = false;
    errorString = "The required parameter 'authenticationCode' was not found.";
  }

  //check for okToProxy here because if the clientAuthenticationCode is null or "", the following will be caught as well and we don't want it to
  if (okToProxy && (clientAuthenticationCode != serverAuthenticationCode)) {
  	okToProxy = false;
    errorString = "Authentication failure.";
  }

  //check for okToProxy here because if the resourceIDString is null, the following will throw an exception which we don't want
  if (okToProxy && ((parseInt(resourceIDString) > resourceURLs.length -1) || (parseInt(resourceIDString) < 0))) {
  	okToProxy = false;
    errorString = "The resourceID passed in was not valid.";
  }

  if (serverAuthenticationCode == "authentication code not set") {
  	okToProxy = false;
    errorString = "The authentication code on the proxy has not been set. The proxy can not function until the authentication code is set.";
  }

  //make sure we have all the params we need and that the resourceID exists in our list
  if (okToProxy) {
    var url = resourceURLs[parseInt(resourceIDString)];
    var ret;
    var okRead = true;

    // create the HTTP object
    var xmlhttp = new ActiveXObject ("Microsoft.XMLHTTP");

    // setup http connection
    xmlhttp.open("GET", url, false);
    xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=UTF-8");

    // fetch the document
    xmlhttp.send();

    // test for http errors
    if (xmlhttp.status != 200) {
      okRead = false;
      errorString = "The requested URL ("+ url +") was not found."
    }

    if (okRead == true) {
      ret = xmlhttp.responseText;

      //change the HTML into something the browser cannot parse into a DOM tree. The makes
      //the client side rendering faster as well as helps to avoid any potential for abuse
      ret = ret.replace(/</g, '«'); //charCode(171)
      ret = ret.replace(/>/g, '»'); //charCode(187)
      ret = ret.replace(/&/g, '§'); //charCode(167)
      writeBeginningHTML(guid, callbackFunction, "success");
      Response.Write(ret);
    }
    else {
  	//this is probably a 404 or timeout errorr
      writeBeginningHTML(guid, callbackFunction, "error");
      Response.Write(errorString);
    }

    writeEndHTML();
  }
  else {
    //something went wrong before we could even proxy. Write an error
    var errCallbackFunction;
    var errGuid;

    if (callbackFunction == "") {
    	errCallbackFunction = "unknown";
    }
    else {
    	errCallbackFunction = callbackFunction;
    }

    if (guid == "") {
    	errGuid = "unknown";
    }
    else {
    	errGuid = guid;
    }

    writeBeginningHTML(errGuid, errCallbackFunction, "error");

    //write the error string
    Response.Write(errorString);

    //end the HTML
    writeEndHTML();
  }

  function writeBeginningHTML(guid, callBackFunction, returnCode) {
  	Response.Write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">");
  	Response.Write("<head>");
  	Response.Write("<title>");
  	Response.Write("Proxy Data");
  	Response.Write("</title>");
  	Response.Write("<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">");
  	Response.Write("</head>");
  	Response.Write("<body onload=\"top.__getXMLFromIFrame('" + guid + "', '" + callBackFunction + "', '"  + returnCode + "', document.getElementById('xmlData').value)\">");
  	Response.Write("<div style=\"position: absolute; left: -2000px;\">");
  	Response.Write("<textarea id=\"xmlData\" rows=\"1\" cols=\"1\">");
  } // end writeBeginningHTML

  function writeEndHTML() {
  	Response.Write("</textarea>");
  	Response.Write("</div>");
  	Response.Write("</body>");
  	Response.Write("</html>");
  }
%>
