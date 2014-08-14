<%@ page language="java" import="java.io.IOException, java.io.PrintWriter, java.io.InputStreamReader, java.io.BufferedReader, java.io.StringReader, java.net.URL" %>

<%
// =========================================================================
//
// JSProxy.java - JSP implementation for xmljsProxy (ported from JSProxy.java servlet)
//
// version 3.1
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
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//
	
	String errorString = null;

    //specify the mime type and charset
    response.setContentType("text/html; charset=UTF-8");

    /*****************************************************************
    		    RESOURCES - this ties resourceID's to URLS
          put your own resources here and update the size of the array 
    *****************************************************************/
    
    String[] resourceURLs = new String[0];

    //*********************************************************************
    //                TEST SUITE VARIABLES - uncomment if you
    //					want to run this proxy through
    //							the test suite
	//
    //	String[] resourceURLs = new String[3];
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
    String serverAuthenticationCode = "authentication code not set";

    //Uncomment out the following line if you would like to run this proxy through the test suite
    //String serverAuthenticationCode = "password";

    
    /*****************************************************************
    If this servlet needs to know about a proxy server to see the
    internet, uncomment out the following lines, set the parameters
    as appropriate, and recompile
    ***************************************************************/
    //System.setProperty("http.proxyHost", "myProxyServer");
    //System.setProperty("http.proxyPort", "myProxyPort");
    
    String resourceIDString = request.getParameter("resourceID");
    String guid = request.getParameter("guid");
    String callbackFunction = request.getParameter("callbackFunction");
    String clientAuthenticationCode = request.getParameter("authenticationCode");
    

    //check to see if we're a go for proxying
    boolean okToProxy = true;
    
    if (resourceIDString == null || resourceIDString.equals("") == true ) {
    	okToProxy = false;
        errorString = "The required parameter 'resourceID' was not found.";
    }
    
    if (guid == null || guid.equals("") == true ) {
    	okToProxy = false;
        errorString = "The required parameter 'guid' was not found.";
    }
    
    if (callbackFunction == null || callbackFunction.equals("") == true ) {
    	okToProxy = false;
        errorString = "The required parameter 'callbackFunction' was not found.";
    }
    
    if (clientAuthenticationCode == null || clientAuthenticationCode.equals("") == true ) {
    	okToProxy = false;
        errorString = "The required parameter 'authenticationCode' was not found.";
    }
    
    
    //check for okToProxy here because if the clientAuthenticationCode is null or "", the following will be caught as well and we don't want it to
    if (okToProxy == true && clientAuthenticationCode.equals(serverAuthenticationCode) == false) {
    	okToProxy = false;
        errorString = "Authentication failure.";
    }
    
    //check for okToProxy here because if the resourceIDString is null, the following will throw an exception which we don't want
    if ( (okToProxy == true) && (Integer.parseInt(resourceIDString) > resourceURLs.length -1 || Integer.parseInt(resourceIDString) < 0)) {
    	okToProxy = false;
        errorString = "The resourceID passed in was not valid.";
    }
    
    if (serverAuthenticationCode.equals("authentication code not set")) {
    	okToProxy = false;
        errorString = "The authentication code on the proxy has not been set. The proxy can not function until the authentication code is set.";
    }
    
        
    //make sure we have all the params we need and that the resourceID exists in our list
    if (okToProxy == true) {
    
        String url = resourceURLs[Integer.parseInt(resourceIDString)];
        String line = null;
        String ret = "";
        boolean okRead = true;
        try {
            BufferedReader in = new BufferedReader(new InputStreamReader(new URL(url).openStream()));
            do{
            line = in.readLine();
            if (line != null){
                ret += line + "\n";
            }
            }while (line != null);
        }
        catch (java.net.UnknownHostException e) {
            okRead = false;
        	errorString = "The requested URL (" + url + ") was not found.";
        }
        catch (java.io.FileNotFoundException e) {
            okRead = false;
        	errorString = "The requested URL (" + url + ") was not found.";
        }
        catch (Exception e) {
            okRead = false;
            errorString = e.toString();
        }

        if (okRead == true) {
            //change the HTML into something the browser cannot parse into a DOM tree. The makes 
            //the client side rendering faster as well as helps to avoid any potential for abuse
            ret = ret.replace('<', '«'); //String.charAt(171)
            ret = ret.replace('>', '»'); //String.charAt(187)
            ret = ret.replace('&', '§'); //String.charAt(167)
            writeBeginningHTML(out, guid, callbackFunction, "success");
            out.println(ret);
        }
        else {
        	//this is probably a 404 or timeout errorr
            writeBeginningHTML(out, guid, callbackFunction, "error");
            out.println(errorString);
        }
        writeEndHTML(out);
		
	}
    else {
    	
        //something went wrong before we could even proxy. Write an error
        String errCallbackFunction;
        String errGuid;
        if (callbackFunction == null) {
        	errCallbackFunction = "unknown";
        }
        else {
        	errCallbackFunction = callbackFunction;
        }
        
        if (guid == null) {
        	errGuid = "unknown";
        }
        else {
        	errGuid = guid;
        }
        
        writeBeginningHTML(out, errGuid, errCallbackFunction, "error");
        
        //write the error string
		out.println(errorString);        
		
        //end the HTML
        writeEndHTML(out);
    }
    
%>

<%!

	void writeBeginningHTML(JspWriter out, String guid, String callBackFunction, String returnCode) {
		try {
			out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">");
			out.println("<head>");
			out.println("<title>");
			out.println("Proxy Data");
			out.println("</title>");
			out.println("<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">");
			out.println("</head>");
			out.println("<body onload=\"top.__getXMLFromIFrame('" + guid + "', '" + callBackFunction + "', '"  + returnCode + "', document.getElementById('xmlData').value)\">");
			out.println("<div style=\"position: absolute; left: -2000px;\">");
			out.println("<textarea id=\"xmlData\" rows=\"1\" cols=\"1\">");
		}
		catch (Exception e) {
			//no op
		}
	} // end writeBeginningHTML

	void writeEndHTML(JspWriter out){
		try {
			out.println("</textarea>");
			out.println("</div>");
			out.println("</body>");
			out.println("</html>");
		}
		catch (Exception e) {
			// no op
		}
	}

%>



