// =========================================================================
//
// scripts.js - scripts to handle functionality of the main web site
//
// =========================================================================
//
// Copyright (C) 2001, 2002, 2003 - David Joham (djoham@yahoo.com)
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

function configureJSNavigation() {
    /***********************************************************************************
    function: configureJSNavigation()

    author: djoham@yahoo.com

    Description:  sets up the navigation divs so that they can be clicked on rather
                  than always having to click on the link.

    ************************************************************************************/

    //the area that we're interested in is the linkBar div. Get all the divs
    //first and then find the linkBar
    if (document.getElementById) {
        try {
            var divs = document.getElementsByTagName("div");
            var intCount = divs.length;

            for (intLoop = 0; intLoop < intCount; intLoop++) {
                var div = divs[intLoop];
                var attributes = div.attributes;
                try {
                    if (attributes.getNamedItem("class").value == "linkBar") {
                        //we've found the linkBar
                        //we're interested in all of the hoverNavigation divs under the linkBar div

                        //linkBar variable is only for code clarity
                        var linkBar = divs.item(intLoop);
                        var linkDivs = linkBar.childNodes;
                        var intCount2 = linkDivs.length;
                        for (intLoop2 = 0; intLoop2 < intCount2; intLoop2++) {
                            var linkDiv = linkDivs.item(intLoop2);
                            try {
                                var classType = linkDiv.attributes.getNamedItem("class").value;
                                if ( classType.toLowerCase().indexOf("hover") > -1) {
                                    //we've found a hoverNavigation div. Get the href value of its
                                    //link child node and then set its onclick event
                                    var link = link = linkDiv.getElementsByTagName("a").item(0);
                                    if (link != null) {
                                        var command = "linkDiv.onclick = function(){location.replace(\"" + link + "\")}";
                                        eval(command);
                                    }
                                }
                            }
                            catch (e) {
                                //alert("1" + e);
                                //no op
                            }
                        }

                        //we're done
                        break;
                    }
                }
                catch (ee) {
                    //no op
                    //alert("2" + ee);
                }
            }
        }
        catch (eee) {
            //something went horribly wrong. The user will have to click the links
            //alert("3" + eee);
        }
    }
} //end function configureJSNavigation


function launch4xClassicDomSample() {
    /***********************************************************************************
    function: launch4xClassicDomSample()

    author: djoham@yahoo.com

    Description:  opens a new window with the 4x sample application

    ************************************************************************************/

    window.open("./../sampleApplications/classicDom/domSampleApplication4xBrowsers/index.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");


} // end function launch4xDomSample

function launchClassicDOMTestSuite() {

    /***********************************************************************************
    function: launchClassicDOMTestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the DOM test suite as the
                         active page

    ************************************************************************************/

    window.open("./../testSuites/classicDomTest/domTestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchDOMTestSuite


function launchModernClassicDomSample() {
    /***********************************************************************************
    function: launchModernClassicDomSample()

    author: djoham@yahoo.com

    Description:    opens a new window with the modern sample application

    ************************************************************************************/

    window.open("./../sampleApplications/classicDom/domSampleApplicationModernBrowsers/contactManager.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchModernDomSample


function launchProxyTestSuite() {

    /***********************************************************************************
    function: launchProxyTestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the proxy test suite as the
                         active page

    ************************************************************************************/

    window.open("./../testSuites/proxyTest/proxyTestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchDOMTestSuite



function launchSAXSample1() {

    /***********************************************************************************
    function: launchSAXSample1

    author: djoham@yahoo.com

    Description:    opens a new window with the SAX Sample application 1

    ************************************************************************************/

    window.open("./../sampleApplications/sax/saxSampleApplication1/saxSampleApplication1.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=yes,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchSAXSample1


function launchSAXTestSuite() {

    /***********************************************************************************
    function: launchSAXTestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the SAX test suite as the
                         active page

    ************************************************************************************/

    window.open("./../testSuites/saxTest/saxTestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchSAXTestSuite


function launchSAXTreeViewSample() {

    /***********************************************************************************
    function: launchSAXTreeViewSample

    author: djoham@yahoo.com

    Description:    opens a new window with the SAX Tree View sample

    ************************************************************************************/

    window.open("./../sampleApplications/sax/saxTreeViewSample/saxTreeViewSample.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=yes,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchSAXTreeViewSample



function launchTagPathClassicDomSample() {

    /***********************************************************************************
    function: launchTagPathClassicDomSample

    author: djoham@yahoo.com

    Description:    opens a new window with the TagPath DOM Sample as the
                         active page

    ************************************************************************************/

    window.open("./../sampleApplications/classicDom/domSampleApplicationTagPath/domTagPathExample.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchTagPathDomSample


function launchW3CDomSampleContactManager() {
    /***********************************************************************************
    function: launchW3CDomSampleContactManager()

    author: djoham@yahoo.com

    Description:    opens a new window with the W3C Contact Manager Sample Application

    ************************************************************************************/

    window.open("./../sampleApplications/w3cDom/contactManager/contactManager.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");


} // end function launch W3CDomSampleContactManager


function launchW3CDOMLevel1TestSuite() {
    /***********************************************************************************
    function: launchW3CDOMLevel1TestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the W3C DOM Level 1 test suite

    ************************************************************************************/

    window.open("./../testSuites/w3cDomTest/DOMLevel1/w3cDomTestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launch launchW3CDOMLevel1TestSuite



function launchW3CDOMLevel2TestSuite() {
    /***********************************************************************************
    function: launchW3CDOMLevel2TestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the W3C DOM Level 2 test suite

    ************************************************************************************/

    window.open("./../testSuites/w3cDomTest/DOMLevel2/w3cDom2TestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launch launchW3CDOMLevel2TestSuite


function launchW3CDOMSampleApplicationsTestSuite() {
    /***********************************************************************************
    function: launchW3CDOMSampleApplicationsTestSuite()

    author: djoham@yahoo.com

    Description:    opens a new window with the W3C DOM Sample Applications test suite

    ************************************************************************************/

    window.open("./../testSuites/w3cDomTest/DOMSampleApps/w3cDomSampleAppsTestSuite.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launch launchW3CDOMLevel2TestSuite



function launchXMLEscapeSample() {
    /***********************************************************************************
    function: launchXMLEscapeSample()

    author: djoham@yahoo.com

    Description:    opens a new window with the XMLEscape sample

    ************************************************************************************/

    window.open("./../toolSamples/xmlEscape/xmlEscape.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchXMLEscapeSample



function launchXMLIOCookieSample() {
    /***********************************************************************************
    function: launchXMLIOSample()

    author: djoham@yahoo.com

    Description:    opens a new window with the XMLIO cookie sample application

    ************************************************************************************/

    window.open("./../toolSamples/xmlIOCookies/xmlIOCookies.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchXMLIOCookieSample



function launchXMLIOLoadLocalDataSample() {
    /***********************************************************************************
    function: launchXMLIOLoadLocalDataSample()

    author: djoham@yahoo.com

    Description:    opens a new window with the XMLIOLoadLocalData sample application

    ************************************************************************************/

    window.open("./../toolSamples/xmlLoadLocalData/xmlIOLoadLocalData.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");


} // end function launchXMLIOLoadLocalDataSample



function launchXMLIOProxySample() {
    /***********************************************************************************
    function: launchXMLProxySample()

    author: djoham@yahoo.com

    Description:    opens a new window with the XMLIO Proxy sample application

    ************************************************************************************/

    window.open("./../toolSamples/xmlIOProxy/xmlIOProxy.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

} // end function launchXMLIOProxySample


function launchXPathContactManagerSampleApp() {
    /***********************************************************************************
    function: launchXPathContactManagerSampleApp()

    author: djoham@yahoo.com

    Description:    opens a new window with the XPath Contact Manager Sample Application

    ************************************************************************************/

    window.open("./../contributedAdd-ons/xpath/sampleApplications/contactManager/contactManager.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");


} // end function launch launchXPathSampleContactManager



function launchXPathQueryExamplesSampleApp() {
    /***********************************************************************************
    function: launchXPathQueryExamplesSampleApp()

    author: djoham@yahoo.com

    Description:    opens a new window with the XPath examples sample application

    ************************************************************************************/

    window.open("./../contributedAdd-ons/xpath/sampleApplications/samplePaths/xpathexamples.html", "hndl", "location=no,menubar=no,resizable=no,scrollbars=no,status=no,titlebar=no,toolbar=no,width=800,height=500");

}






