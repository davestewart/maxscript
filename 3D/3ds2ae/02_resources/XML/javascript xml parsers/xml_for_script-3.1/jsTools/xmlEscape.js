// =========================================================================
//
// xmlEscape.js - api for the xmlEscape functions
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2000 - 2002 Michael Houghton (mike@idle.org) and David Joham (djoham@yahoo.com)
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

function xmlEscapeXMLToHTML(xmlData) {
    /*************************************************************************************
    Function:       xmlEscapeXMLToHTML

    author:         xwisdom@yahoo.com

    description:
        Encodes XML data for use in a web page

    ************************************************************************************/
    var gt; 

    var str = xmlData;

    //replace < with «
    gt = -1;
    while (str.indexOf("<", gt + 1) > -1) {
        var gt = str.indexOf("<", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "«";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    //replace > with »
    gt = -1;
    while (str.indexOf(">", gt + 1) > -1) {
        var gt = str.indexOf(">", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "»";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    //replace & with §
    gt = -1;
    while (str.indexOf("&", gt + 1) > -1) {
        var gt = str.indexOf("&", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "§";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    return str

}  // end function xmlEscapeXMLToHTML


function xmlUnescapeHTMLToXML(xmlData)  {
    /*************************************************************************************
    Function:       xmlUnescapeHTMLToXML

    author:         xwisdom@yahoo.com

    description:
        Decodes XML previously encoded with xmlEscapeXMLToHTML

    ************************************************************************************/
    var str = xmlData;

    var gt;

    //replace « with <
    gt = -1;
    while (str.indexOf("«", gt + 1) > -1) {
        var gt = str.indexOf("«", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "<";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }


    //replace » with >
    gt = -1;
    while (str.indexOf("»", gt + 1) > -1) {
        var gt = str.indexOf("»", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += ">";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    //replace § with &
    gt = -1;
    while (str.indexOf("§", gt + 1) > -1) {
        var gt = str.indexOf("§", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "&";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    return str

}// end function xmlUnescapeHTMLToXML
