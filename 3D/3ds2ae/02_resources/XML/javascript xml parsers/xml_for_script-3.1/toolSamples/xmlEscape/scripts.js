// =========================================================================
//
// scripts.js - example code for the xmlEscape functions
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


function escapeXML() {
    /*******************************************************************************************************************
    function: escapeXML

    Author: djoham@yahoo.com

    Description:
        calls the function to convert the XML into valid HTML
    *********************************************************************************************************************/

    var xml = document.getElementById("txtXML").value
    var html;

    html = xmlEscapeXMLToHTML(xml);
    document.getElementById("txtHTML").value = html;

} // end function escapeXML


function unescapeHTML() {
    /*******************************************************************************************************************
    function: unescapeHTML

    Author: djoham@yahoo.com

    Description:
        calls the function to convert the HTML into XML
    *********************************************************************************************************************/

    var html = document.getElementById("txtHTML").value;
    var xml;

    xml = xmlUnescapeHTMLToXML(html);
    document.getElementById("txtXML").value = xml;


} // end function unescapeHTML