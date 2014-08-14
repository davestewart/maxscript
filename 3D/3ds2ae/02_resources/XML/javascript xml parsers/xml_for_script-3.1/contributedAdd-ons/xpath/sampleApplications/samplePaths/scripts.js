// =========================================================================
//
// scripts.js- sample code for the TagPath DOM example in XML for <SCRIPT>
//
// =========================================================================
//
// Copyright (C) 2001, 2002 - David Joham (djoham@yahoo.com)
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

var parser;
var domDoc;
var htmlizexml;

var xml = ""
+ '<rootnode>\n'
+ '<tag1 id="1">text node 1 <!--comment node--> text node 2</tag1>\n'
+ '<tag1 id="2"><? piTarget piData?>foo2</tag1>\n'
+ '<tag1 id="3">foo3</tag1>\n'
+ '<tag1 id="4">foo4\n'
+ '\t<tag>\n'
+ '\t\t<a pin="1"><b>b1 text</b></a>\n'
+ '\t\t<a pin="2"><b>b2 text</b></a>\n'
+ '\t\t<a pin1="3">\n'
+ '\t\t\t<b>\n'
+ '\t\t\t\t<tag>no attribute</tag>\n'
+ '\t\t\t\t<tag tid="red">Red-Taggy</tag>\n'
+ '\t\t\t\t<tag tid="green">Green-Taggy</tag>\n'
+ '\t\t\t\t<tag id1="1" id2="2">Multi-Taggy</tag>\n'
+ '\t\t\t</b>\n'
+ '\t\t</a>\n'
+ '\t</tag>\n'
+ '</tag1>\n'
+ '</rootnode>';


function findNode(){
    /*************************************************************************************
    Function:       findNode

    author:         djoham@yahoo.com

    description:
		tells the DOM object to search for the node
    ************************************************************************************/


    var xpathExpression;
    if (document.getElementById("rdoPreBuilt").checked == true) {
        var selector = document.getElementById("xpathPreBuiltSelector")
        xpathExpression = selector[selector.selectedIndex].value;
    }
    else {
        xpathExpression = document.getElementById("xpathCustomExpressionText").value;
    }

    var xpathNodeSet = domDoc.selectNodeSet(xpathExpression);

    showReturnedNodes(xpathNodeSet);


}


function init(){
    /*************************************************************************************
    Function:       init

    author:         djoham@yahoo.com

    description:
		sets up the DOM object
    ************************************************************************************/
	 parser = new DOMImplementation();
     parser.preserveWhiteSpace = true;

     domDoc = parser.loadXML(xml);

     htmlizedxml = htmlizeit(domDoc.toString());

     document.getElementById("divxml").innerHTML = htmlizedxml;

} // end function init()

function htmlizeit(xml) {
    /*************************************************************************************
    Function:       htmlizeit

    author:         djoham@yahoo.com

    description:
        This takes the XML and turns it into displayable HTML. Note that I've told the
        XML processor to maintain whitespace which is why the /n and /t are still here
        otherwise it wouldn't work.
    ************************************************************************************/

    var ret = "";
    var lineBreakRegEx = /\n/g;
    var tabRegEx = /\t/g;

    //convert XML to HTML
    ret = parser.escapeString(xml);

    ret = ret.replace(lineBreakRegEx, "<br>");
    ret = ret.replace(tabRegEx, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");

    return ret;

}

function showReturnedNodes(nodeSet) {
    /*************************************************************************************
    Function:       showReturnedNodes

    author:         djoham@yahoo.com

    description:
		This is kinda an ugly hack to highlight the returned nodes in the nodeset
        It's not perfect, but for the xpath expressions in the pre-built select box
        it works pretty well...
    ************************************************************************************/

    var intLoop;
    var intCount = nodeSet.getLength();
    var highlightText = "<span style='background-color: yellow; padding-left: 2px; padding-right: 2px; border: solid red 1px; margin-left: 2px; margin-right: 2px; font-weight: bold'>";
    var noticeDivHTMLStart = "<div style='margin: 20px; text-align: center'>"
    var noticeDivHTMLEnd = "<div style='margin-top: 25px; text-align: right'><input type='button' class='launchButton' onclick='init()' value='Return To XML' /></div></div>";

    var workingHTML = htmlizedxml;

    try {
        window.status = intCount + " nodes returned";
    }
    catch(e) {
        //no op
    }

    for (intLoop = 0; intLoop < intCount; intLoop++) {

        //the thought here is to basically find each node
        //that is returned inside the original workingHTML
        //keeping in mind that the workingHTML was generated
        //by taking the original XML of all the nodes and HTMLizing it.

        //once we find the internal node, wrap a span around it
        //so that it gets highlighted
        var node = nodeSet.item(intLoop);

        var nodexml = node.toString();

        if (trim(nodexml, true, true) == "") {
            continue;
        }

        var nodehtml = htmlizeit(nodexml);

        var nodeStart = workingHTML.indexOf(nodehtml);

        var tmpHtml = workingHTML.substr(0, nodeStart);

        tmpHtml+=highlightText + workingHTML.substr(nodeStart, workingHTML.length);

        var endHighlight;

        if (node.getNodeType() == DOMNode.ELEMENT_NODE ||
            node.getNodeType() == DOMNode.COMMENT_NODE ||
            node.getNodeType() == DOMNode.PROCESSING_INSTRUCTION_NODE ) {
            endHighlight = tmpHtml.indexOf("&gt;", nodeStart + highlightText.length) + 4;
        }
        else if (node.getNodeType() == DOMNode.ATTRIBUTE_NODE) {
            //all of my nodes use double quotes for their attributes so account for the &quot;
            //this wouldn't work if the nodes used single quotes (I'd have to be more creative
            //in finding out what I was using)
            endHighlight = tmpHtml.indexOf("&quot;", nodeStart + highlightText.length + 6) + 6;
        }
        else {
            endHighlight = nodeStart + highlightText.length + node.toString().length
        }


        workingHTML = tmpHtml.substring(0, endHighlight );

        //alert(workingHTML);
        workingHTML += "</span>" + tmpHtml.substr(endHighlight, tmpHtml.length);


    }

    if (nodeSet.length == 0) {
        document.getElementById("divxml").innerHTML = noticeDivHTMLStart + "The XPath query returned zero nodes. Your expression may be valid, but not supported." + noticeDivHTMLEnd;
    }
    else if (workingHTML.length < htmlizedxml.length) {
        //this is if something really bad happened and the goofy string manipulation stuff above failed
        document.getElementById("divxml").innerHTML = noticeDivHTMLStart + "Unable to display results of XPath query." + noticeDivHTMLEnd;
    }
    else {
        document.getElementById("divxml").innerHTML = workingHTML;
    }

}

function changeExpressionType(type) {
    /*************************************************************************************
    Function:       changeExpressionType

    author:         djoham@yahoo.com

    description:
        Handles the user request to change the way they enter in the xpath expression
    ************************************************************************************/

    if (type == 0) {
        document.getElementById("xpathCustomExpressionText").style.display = "none";
        document.getElementById("xpathPreBuiltSelector").style.display ="inline";
        document.getElementById("xpathPreBuiltSelector").focus();
    }
    else {
        document.getElementById("xpathPreBuiltSelector").style.display = "none";
        document.getElementById("xpathCustomExpressionText").style.display = "inline";
        document.getElementById("xpathCustomExpressionText").focus();
    }


}

