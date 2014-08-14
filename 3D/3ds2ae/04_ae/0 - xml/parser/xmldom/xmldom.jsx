// =========================================================================
//
// xmldom.js - an XML DOM parser in JavaScript.
//
//	This is the classic DOM that has shipped with XML for <SCRIPT>
//  since the beginning. For a more standards-compliant DOM, you may
//  wish to use the standards-compliant W3C DOM that is included
//  with XML for <SCRIPT> versions 3.0 and above
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2000 - 2002, 2003 Michael Houghton (mike@idle.org), Raymond Irving and David Joham (djoham@yahoo.com)
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
//
// Visit the XML for <SCRIPT> home page at http://xmljs.sourceforge.net
//


// =========================================================================
// =========================================================================
// =========================================================================

// CONSTANTS

// =========================================================================
// =========================================================================
// =========================================================================

//define the characters which constitute whitespace, and quotes
var whitespace = "\n\r\t ";
var quotes = "\"'";


// =========================================================================
// =========================================================================
// =========================================================================

// CONVENIENCE FUNCTIONS

// =========================================================================
// =========================================================================
// =========================================================================


function convertEscapes(str) {
    /*******************************************************************************************************************
    function: convertEscapes

    Author: David Joham <djoham@yahoo.com>

    Description:
        Characters such as less-than signs, greater-than signs and ampersands are
        illegal in XML syntax and must be escaped before being inserted into the DOM.
        This function is a convience function to take those escaped characters and
        return them to their original values for processing outside the parser

        This XML Parser automagically converts the content of the XML elements to
        their non-escaped values when xmlNode.getText() is called for every element
        except CDATA.

        EXAMPLES:

        &amp; == &
        &lt; == <
        &gt; == >

    *********************************************************************************************************************/
    // not all Konqueror installations have regex support for some reason. Here's the original code using regexes
    // that is probably a little more efficient if it matters to you
    /*
    var escAmpRegEx = /&amp;/g;
    var escLtRegEx = /&lt;/g;
    var escGtRegEx = /&gt;/g;

    str = str.replace(escAmpRegEx, "&");
    str = str.replace(escLtRegEx, "<");
    str = str.replace(escGtRegEx, ">");
    */
    var gt;

    //&lt;
    gt = -1;
    while (str.indexOf("&lt;", gt + 1) > -1) {
        var gt = str.indexOf("&lt;", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "<";
        newStr = newStr + str.substr(gt + 4, str.length);
        str = newStr;
    }

    //&gt;
    gt = -1;
    while (str.indexOf("&gt;", gt + 1) > -1) {
        var gt = str.indexOf("&gt;", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += ">";
        newStr = newStr + str.substr(gt + 4, str.length);
        str = newStr;
    }

    //&amp;
    gt = -1;
    while (str.indexOf("&amp;", gt + 1) > -1) {
        var gt = str.indexOf("&amp;", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "&";
        newStr = newStr + str.substr(gt + 5, str.length);
        str = newStr;
    }

    return str;
} // end function convertEscapes


function convertToEscapes(str) {
    /*******************************************************************************************************************
    function: convertToEscapes

    Author: David Joham djoham@yahoo.com

    Description:
        Characters such as less-than signs, greater-than signs and ampersands are
        illegal in XML syntax. This function is a convience function to escape those
        characters out to there legal values.

        EXAMPLES:

        < == &lt;
        > == &gt;
        & == &amp;
    *********************************************************************************************************************/
    // not all Konqueror installations have regex support for some reason. Here's the original code using regexes
    // that is probably a little more efficient if it matters to you
    /*
    var escAmpRegEx = /&/g;
    var escLtRegEx = /</g;
    var escGtRegEx = />/g;
    str = str.replace(escAmpRegEx, "&amp;");
    str = str.replace(escLtRegEx, "&lt;");
    str = str.replace(escGtRegEx, "&gt;");
    */

    // start with &
    var gt = -1;
    while (str.indexOf("&", gt + 1) > -1) {
        gt = str.indexOf("&", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "&amp;";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    // now <
    gt = -1;
    while (str.indexOf("<", gt + 1) > -1) {
        var gt = str.indexOf("<", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "&lt;";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }

    //now >
    gt = -1;
    while (str.indexOf(">", gt + 1) > -1) {
        var gt = str.indexOf(">", gt + 1);
        var newStr = str.substr(0, gt);
        newStr += "&gt;";
        newStr = newStr + str.substr(gt + 1, str.length);
        str = newStr;
    }


    return str;
} // end function convertToEscapes


function _displayElement(domElement, strRet) {
    /*******************************************************************************************************************
    function:       _displayElement

    Author: djoham@yahoo.com

    Description:
        returns the XML string associated with the DOM element passed in
        recursively calls itself if child elements are found

    *********************************************************************************************************************/
    if(domElement==null) {
        return;
    }
    if(!(domElement.nodeType=='ELEMENT')) {
        return;
    }

    var tagName = domElement.tagName;
    var tagInfo = "";
    tagInfo = "<" + tagName;

    // attributes
    var attributeList = domElement.getAttributeNames();

    for(var intLoop = 0; intLoop < attributeList.length; intLoop++) {
        var attribute = attributeList[intLoop];
        tagInfo = tagInfo + " " + attribute + "=";
        tagInfo = tagInfo + "\"" + domElement.getAttribute(attribute) + "\"";
    }

    //close the element name
    tagInfo = tagInfo + ">";

    strRet=strRet+tagInfo;

    // children
    if(domElement.children!=null) {
        var domElements = domElement.children;
        for(var intLoop = 0; intLoop < domElements.length; intLoop++) {
            var childNode = domElements[intLoop];
            if(childNode.nodeType=='COMMENT') {
                strRet = strRet + "<!--" + childNode.content + "-->";
            }

            else if(childNode.nodeType=='TEXT') {
                var cont = trim(childNode.content,true,true);
                strRet = strRet + childNode.content;
            }

            else if (childNode.nodeType=='CDATA') {
                var cont = trim(childNode.content,true,true);
                strRet = strRet + "<![CDATA[" + cont + "]]>";
            }

            else {
                strRet = _displayElement(childNode, strRet);
            }
        } // end looping through the DOM elements
    } // end checking for domElements.children = null

    //ending tag
    strRet = strRet + "</" + tagName + ">";
    return strRet;
} // end function displayElement


function firstWhiteChar(str,pos) {
    /*******************************************************************************************************************
    function: firstWhiteChar

    Author: may106@psu.edu ?

    Description:
        return the position of the first whitespace character in str after position pos

    *********************************************************************************************************************/
    if (isEmpty(str)) {
        return -1;
    }

    while(pos < str.length) {
        if (whitespace.indexOf(str.charAt(pos))!=-1) {
            return pos;
        }
        else {
            pos++;
        }
    }
    return str.length;
} // end function firstWhiteChar


function isEmpty(str) {
    /*******************************************************************************************************************
    function: isEmpty

    Author: mike@idle.org

    Description:
        convenience function to identify an empty string

    *********************************************************************************************************************/
    return (str==null) || (str.length==0);

} // end function isEmpty

function trim(trimString, leftTrim, rightTrim) {
    /*******************************************************************************************************************
    function: trim

    Author: may106@psu.edu

    Description:
        helper function to trip a string (trimString) of leading (leftTrim)
        and trailing (rightTrim) whitespace

    *********************************************************************************************************************/
    if (isEmpty(trimString)) {
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
} // end function trim









// =========================================================================
// =========================================================================
// =========================================================================
// XML DOC FUNCTIONS
// =========================================================================
// =========================================================================
// =========================================================================

function XMLDoc(source, errFn) {
    /*******************************************************************************************************************
    function:       XMLDoc

    Author: mike@idle.org

    Description:
        a constructor for an XML document
        source: the string containing the document
        errFn: the (optional) function used to log errors
    *********************************************************************************************************************/
    // stack for document construction

    this.topNode=null;

    // set up the properties and methods for this object

    this.errFn = errFn;          // user defined error functions

    this.createXMLNode = _XMLDoc_createXMLNode;
    this.error = _XMLDoc_error;
    this.getUnderlyingXMLText = _XMLDoc_getUnderlyingXMLText;
    this.handleNode = _XMLDoc_handleNode;
    this.hasErrors = false;      // were errors found during the parse?
    this.insertNodeAfter =  _XMLDoc_insertNodeAfter;
    this.insertNodeInto = _XMLDoc_insertNodeInto;
    this.loadXML = _XMLDoc_loadXML;
	this.parse = _XMLDoc_parse;
    this.parseAttribute = _XMLDoc_parseAttribute;
    this.parseDTD = _XMLDoc_parseDTD;
    this.parsePI = _XMLDoc_parsePI;
    this.parseTag = _XMLDoc_parseTag;
    this.removeNodeFromTree = _XMLDoc_removeNodeFromTree;
    this.replaceNodeContents = _XMLDoc_replaceNodeContents;
    this.selectNode = _XMLDoc_selectNode;
	this.selectNodeText = _XMLDoc_selectNodeText;
	this.source = source;        // the string source of the document

    // parse the document

    if (this.parse()) {
        // we've run out of markup - check the stack is now empty
        if (this.topNode!=null) {
            return this.error("expected close " + this.topNode.tagName);
        }
        else {
            return true;
        }
    }
} // end function XMLDoc


function _XMLDoc_createXMLNode(strXML) {
    /*******************************************************************************************************************
    function:   _XMLDoc_createXMLNode

    Author: djoham@yahoo.com

    Description:
        convienience function to create a new node that inherits
        the properties of the document object
    *********************************************************************************************************************/
    return new XMLDoc(strXML, this.errFn).docNode;

} // end function _XMLDoc_createXMLNode


function _XMLDoc_error(str) {
    /*******************************************************************************************************************
    function:       _XMLDoc_error

    Author: mike@idle.org

    Description:
        used to log an error in parsing or validating
    *********************************************************************************************************************/
    
	this.hasErrors=true;
    if(this.errFn){
        this.errFn("ERROR: " + str);
    }else if(this.onerror){
        this.onerror("ERROR: " + str); 
	}
    return 0;
	
} // end function _XMLDoc_error


function _XMLDoc_getTagNameParams(tag,obj){
    /*******************************************************************************************************************
    function:       _XMLDoc_getTagNameParams

    Author: xwisdom@yahoo.com

    Description:
        convienience function for the nodeSearch routines
    *********************************************************************************************************************/
	var elm=-1,e,s=tag.indexOf('[');
	var attr=[];
	if(s>=0){
		e=tag.indexOf(']');
		if(e>=0)elm=tag.substr(s+1,(e-s)-1);
		else obj.error('expected ] near '+tag);
		tag=tag.substr(0,s);
		if(isNaN(elm) && elm!='*'){
			attr=elm.substr(1,elm.length-1); // remove @
			attr=attr.split('=');
			if(attr[1]) { //remove "
				s=attr[1].indexOf('"');
				attr[1]=attr[1].substr(s+1,attr[1].length-1);
				e=attr[1].indexOf('"');
				if(e>=0) attr[1]=attr[1].substr(0,e);
				else obj.error('expected " near '+tag)
			};elm=-1;
		}else if(elm=='*') elm=-1;
	}
	return [tag,elm,attr[0],attr[1]]
} // end function _XMLDoc_getTagNameParams


function _XMLDoc_getUnderlyingXMLText() {
    /*******************************************************************************************************************
    function:       _XMLDoc_getUnderlyingXMLText

    Author: djoham@yahoo.com

    Description:
        kicks off the process that returns the XML text representation of the XML
        document inclusive of any changes made by the manipulation of the DOM
    *********************************************************************************************************************/
    var strRet = "";
    //for now, hardcode the xml version 1 information. When we handle Processing Instructions later, this
    //should be looked at again
    strRet = strRet + "<?xml version=\"1.0\"?>";
    if (this.docNode==null) {
        return;
    }

    strRet = _displayElement(this.docNode, strRet);
    return strRet;

} // end function _XMLDoc_getCurrentXMLText



function _XMLDoc_handleNode(current) {
    /*******************************************************************************************************************
    function:   _XMLDoc_handleNode

    Author: mike@idle.org

    Description:
        adds a markup element to the document
    *********************************************************************************************************************/

    if ((current.nodeType=='COMMENT') && (this.topNode!=null)) {
        return this.topNode.addElement(current);
    }
    else if ((current.nodeType=='TEXT') ||  (current.nodeType=='CDATA')) {

        // if the current node is a text node:


        // if the stack is empty, and this text node isn't just whitespace, we have
        // a problem (we're not in a document element)

        if(this.topNode==null) {
            if (trim(current.content,true,false)=="") {
                return true;
            }
            else {
                return this.error("expected document node, found: " + current);
            }
        }
        else {
            // otherwise, append this as child to the element at the top of the stack
            return this.topNode.addElement(current);
        }


    }
    else if ((current.nodeType=='OPEN') || (current.nodeType=='SINGLE')) {
        // if we find an element tag (open or empty)
        var success = false;

        // if the stack is empty, this node becomes the document node

        if(this.topNode==null) {
            this.docNode = current;
            current.parent = null;
            success = true;
        }
        else {
            // otherwise, append this as child to the element at the top of the stack
            success = this.topNode.addElement(current);
        }


        if (success && (current.nodeType!='SINGLE')) {
            this.topNode = current;
        }

        // rename it as an element node

        current.nodeType = "ELEMENT";

        return success;
    }

    // if it's a close tag, check the nesting

    else if (current.nodeType=='CLOSE') {

        // if the stack is empty, it's certainly an error

        if (this.topNode==null) {
            return this.error("close tag without open: " +  current.toString());
        }
        else {

            // otherwise, check that this node matches the one on the top of the stack

            if (current.tagName!=this.topNode.tagName) {
                return this.error("expected closing " + this.topNode.tagName + ", found closing " + current.tagName);
            }
            else {
                // if it does, pop the element off the top of the stack
                this.topNode = this.topNode.getParent();
            }
        }
    }
    return true;
} // end function _XMLDoc_handleNode



function _XMLDoc_insertNodeAfter (referenceNode, newNode) {
    /*******************************************************************************************************************
    function:   _XMLDoc_insertNodeAfter

    Author: djoham@yahoo.com

    Description:
        inserts a new XML node after the reference node;

        for example, if we insert the node <tag2>hello</tag2>
        after tag1 in the xml <rootnode><tag1></tag1></rootnode>
        we will end up with <rootnode><tag1></tag1><tag2>hello</tag2></rootnode>

        NOTE: the return value of this function is a new XMLDoc object!!!!

    *********************************************************************************************************************/

    var parentXMLText = this.getUnderlyingXMLText();
    var selectedNodeXMLText = referenceNode.getUnderlyingXMLText();
    var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText) + selectedNodeXMLText.length;
    var newXML = parentXMLText.substr(0,originalNodePos);
    newXML += newNode.getUnderlyingXMLText();
    newXML += parentXMLText.substr(originalNodePos);
    var newDoc = new XMLDoc(newXML, this.errFn);
    return newDoc;

} // end function _XMLDoc_insertNodeAfter



function _XMLDoc_insertNodeInto (referenceNode, insertNode) {
    /*******************************************************************************************************************
    function:   _XMLDoc_insertNodeInto

    Author: mike@idle.org

    Description:
        inserts a new XML node into the reference node;

        for example, if we insert the node <tag2>hello</tag2>
        into tag1 in the xml <rootnode><tag1><tag3>foo</tag3></tag1></rootnode>
        we will end up with <rootnode><tag1><tag2>hello</tag2><tag3>foo</tag3></tag1></rootnode>

        NOTE: the return value of this function is a new XMLDoc object!!!!
    *********************************************************************************************************************/

    var parentXMLText = this.getUnderlyingXMLText();
    var selectedNodeXMLText = referenceNode.getUnderlyingXMLText();
    var endFirstTag = selectedNodeXMLText.indexOf(">") + 1;
    var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText) + endFirstTag;
    var newXML = parentXMLText.substr(0,originalNodePos);
    newXML += insertNode.getUnderlyingXMLText();
    newXML += parentXMLText.substr(originalNodePos);
    var newDoc = new XMLDoc(newXML, this.errFn);
    return newDoc;


} // end function _XMLDoc_insertNodeInto

function _XMLDoc_loadXML(source){
    /*******************************************************************************************************************
    function:   _XMLDoc_insertNodeInto

    Author: xwisdom@yahoo.com

    Description:
    	allows an already existing XMLDoc object to load XML
	*********************************************************************************************************************/
	this.topNode=null;
	this.hasErrors = false;
	this.source=source;
    // parse the document
	return this.parse();

} // end function _XMLDoc_loadXML

function _XMLDoc_parse() {
    /*******************************************************************************************************************
    function:   _XMLDoc_parse

    Author: mike@idle.org

    Description:
        scans through the source for opening and closing tags
        checks that the tags open and close in a sensible order
    *********************************************************************************************************************/

    var pos = 0;

    // set up the arrays used to store positions of < and > characters

    err = false;

    while(!err) {
        var closing_tag_prefix = '';
        var chpos = this.source.indexOf('<',pos);
        var open_length = 1;

        var open;
        var close;

        if (chpos ==-1) {
            break;
        }

        open = chpos;

        // create a text node

        var str = this.source.substring(pos, open);

        if (str.length!=0) {
            err = !this.handleNode(new XMLNode('TEXT',this, str));
        }

        // handle Programming Instructions - they can't reliably be handled as tags

        if (chpos == this.source.indexOf("<?",pos)) {
            pos = this.parsePI(this.source, pos + 2);
            if (pos==0) {
                err=true;
            }
            continue;
        }

        // nobble the document type definition

        if (chpos == this.source.indexOf("<!DOCTYPE",pos)) {
            pos = this.parseDTD(this.source, chpos+ 9);
            if (pos==0) {
                err=true;
            }
            continue;
        }

        // if we found an open comment, we need to ignore angle brackets
        // until we find a close comment

        if(chpos == this.source.indexOf('<!--',pos)) {
            open_length = 4;
            closing_tag_prefix = '--';
        }

        // similarly, if we find an open CDATA, we need to ignore all angle
        // brackets until a close CDATA sequence is found

        if (chpos == this.source.indexOf('<![CDATA[',pos)) {
            open_length = 9;
            closing_tag_prefix = ']]';
        }

        // look for the closing sequence

        chpos = this.source.indexOf(closing_tag_prefix + '>',chpos);
        if (chpos ==-1) {
            return this.error("expected closing tag sequence: " + closing_tag_prefix + '>');
        }

        close = chpos + closing_tag_prefix.length;

        // create a tag node

        str = this.source.substring(open+1, close);

        var n = this.parseTag(str);
        if (n) {
            err = !this.handleNode(n);
        }

        pos = close +1;

    // and loop

    }
    return !err;

} // end function _XMLDoc_parse



function _XMLDoc_parseAttribute(src,pos,node) {
    /*******************************************************************************************************************
    function:   _XMLDoc_parseAttribute

    Author: mike@idle.org

    Description:
        parse an attribute out of a tag string

    *********************************************************************************************************************/

    // chew up the whitespace, if any

    while ((pos<src.length) && (whitespace.indexOf(src.charAt(pos))!=-1)) {
        pos++;
    }

    // if there's nothing else, we have no (more) attributes - just break out

    if (pos >= src.length) {
        return pos;
    }

    var p1 = pos;

    while ((pos < src.length) && (src.charAt(pos)!='=')) {
        pos++;
    }

    var msg = "attributes must have values";

    // parameters without values aren't allowed.

    if(pos >= src.length) {
        return this.error(msg);
    }

    // extract the parameter name

    var paramname = trim(src.substring(p1,pos++),false,true);

    // chew up whitespace

    while ((pos < src.length) && (whitespace.indexOf(src.charAt(pos))!=-1)) {
        pos++;
    }

    // throw an error if we've run out of string

    if (pos >= src.length) {
        return this.error(msg);
    }

    msg = "attribute values must be in quotes";

    // check for a quote mark to identify the beginning of the attribute value

    var quote = src.charAt(pos++);

    // throw an error if we didn't find one

    if (quotes.indexOf(quote)==-1) {
        return this.error(msg);
    }

    p1 = pos;

    while ((pos < src.length) && (src.charAt(pos)!=quote)) {
        pos++;
    }

    // throw an error if we found no closing quote

    if (pos >= src.length) {
        return this.error(msg);
    }

    // store the parameter

    if (!node.addAttribute(paramname,trim(src.substring(p1,pos++),false,true))) {
        return 0;
    }

    return pos;

}  //end function _XMLDoc_parseAttribute



function _XMLDoc_parseDTD(str,pos) {
    /*******************************************************************************************************************
    function:   _XMLDoc_parseDTD

    Author: mike@idle.org

    Description:
        parse a document type declaration

        NOTE: we're just going to discard the DTD

    *********************************************************************************************************************/
    // we're just going to discard the DTD

    var firstClose = str.indexOf('>',pos);

    if (firstClose==-1) {
        return this.error("error in DTD: expected '>'");
    }

    var closing_tag_prefix = '';

    var firstOpenSquare = str.indexOf('[',pos);

    if ((firstOpenSquare!=-1) && (firstOpenSquare < firstClose)) {
        closing_tag_prefix = ']';
    }

    while(true) {
        var closepos = str.indexOf(closing_tag_prefix + '>',pos);

        if (closepos ==-1) {
            return this.error("expected closing tag sequence: " + closing_tag_prefix + '>');
        }

        pos = closepos + closing_tag_prefix.length +1;

        if (str.substring(closepos-1,closepos+2) != ']]>') {
            break;
        }
    }
    return pos;

} // end function _XMLDoc_ParseDTD


function _XMLDoc_parsePI(str,pos) {
    /*******************************************************************************************************************
    function:   _XMLDoc_parsePI

    Author: mike@idle.org

    Description:
        parse a processing instruction

        NOTE: we just swallow them up at the moment

    *********************************************************************************************************************/
    // we just swallow them up

    var closepos = str.indexOf('?>',pos);
    return closepos + 2;

} // end function _XMLDoc_parsePI



function _XMLDoc_parseTag(src) {
    /*******************************************************************************************************************
    function:   _XMLDoc_parseTag

    Author: mike@idle.org

    Description:
        parse out a non-text element (incl. CDATA, comments)
        handles the parsing of attributes
    *********************************************************************************************************************/

    // if it's a comment, strip off the packaging, mark it a comment node
    // and return it

    if (src.indexOf('!--')==0) {
        return new XMLNode('COMMENT', this, src.substring(3,src.length-2));
    }

    // if it's CDATA, do similar

    if (src.indexOf('![CDATA[')==0) {
        return new XMLNode('CDATA', this, src.substring(8,src.length-2));
    }

    var n = new XMLNode();
    n.doc = this;


    if (src.charAt(0)=='/') {
        n.nodeType = 'CLOSE';
        src = src.substring(1);
    }
    else {
        // otherwise it's an open tag (possibly an empty element)
        n.nodeType = 'OPEN';
    }

    // if the last character is a /, check it's not a CLOSE tag

    if (src.charAt(src.length-1)=='/') {
        if (n.nodeType=='CLOSE') {
            return this.error("singleton close tag");
        }
        else {
            n.nodeType = 'SINGLE';
        }

        // strip off the last character

        src = src.substring(0,src.length-1);
    }

    // set up the properties as appropriate

    if (n.nodeType!='CLOSE') {
        n.attributes = new Array();
    }

    if (n.nodeType=='OPEN') {
        n.children = new Array();
    }

    // trim the whitespace off the remaining content

    src = trim(src,true,true);

    // chuck out an error if there's nothing left

    if (src.length==0) {
        return this.error("empty tag");
    }

    // scan forward until a space...

    var endOfName = firstWhiteChar(src,0);

    // if there is no space, this is just a name (e.g. (<tag>, <tag/> or </tag>

    if (endOfName==-1) {
        n.tagName = src;
        return n;
    }

    // otherwise, we should expect attributes - but store the tag name first

    n.tagName = src.substring(0,endOfName);

    // start from after the tag name

    var pos = endOfName;

    // now we loop:

    while(pos< src.length) {
        pos = this.parseAttribute(src, pos, n);
        if (this.pos==0) {
            return null;
        }

        // and loop

    }
    return n;

} // end function _XMLDoc_parseTag



function _XMLDoc_removeNodeFromTree(node) {
    /*******************************************************************************************************************
    function:   _XMLDoc_removeNodeFromTree

    Author: djoham@yahoo.com

    Description:
        removes the specified node from the tree

        NOTE: the return value of this function is a new XMLDoc object

    *********************************************************************************************************************/

    var parentXMLText = this.getUnderlyingXMLText();
    var selectedNodeXMLText = node.getUnderlyingXMLText();
    var originalNodePos = parentXMLText.indexOf(selectedNodeXMLText);
    var newXML = parentXMLText.substr(0,originalNodePos);
    newXML += parentXMLText.substr(originalNodePos + selectedNodeXMLText.length);
    var newDoc = new XMLDoc(newXML, this.errFn);
    return newDoc;
} // end function _XMLDoc_removeNodeFromTree



function _XMLDoc_replaceNodeContents(referenceNode, newContents) {
    /*******************************************************************************************************************
    function:   _XMLDoc_replaceNodeContents

    Author: djoham@yahoo.com

    Description:

        make a node object out of the newContents text
        coming in ----

        The "X" node will be thrown away and only the children
        used to replace the contents of the reference node

        NOTE: the return value of this function is a new XMLDoc object

    *********************************************************************************************************************/

    var newNode = this.createXMLNode("<X>" + newContents + "</X>");
    referenceNode.children = newNode.children;
    return this;
} // end function _XMLDoc_replaceNodeContents


function _XMLDoc_selectNode(tagpath){
    /*******************************************************************************************************************
    function:	_XMLDoc_selectNode

    Author:		xwisdom@yahoo.com

    Description:
    	selects a single node using the nodes tag path.
    	examples: /node1/node2  or  /taga/tag1[0]/tag2
    *********************************************************************************************************************/

	tagpath = trim(tagpath, true, true);
	
	var srcnode,node,tag,params,elm,rg;
	var tags,attrName,attrValue,ok;
	srcnode=node=((this.source)?this.docNode:this);
	if (!tagpath) return node;
	if(tagpath.indexOf('/')==0)tagpath=tagpath.substr(1);
	tagpath=tagpath.replace(tag,'');
	tags=tagpath.split('/');
	tag=tags[0];
	if(tag){
		if(tagpath.indexOf('/')==0)tagpath=tagpath.substr(1);
		tagpath=tagpath.replace(tag,'');
		params=_XMLDoc_getTagNameParams(tag,this);
		tag=params[0];elm=params[1];
		attrName=params[2];attrValue=params[3];
		node=(tag=='*')? node.getElements():node.getElements(tag);
		if (node.length) {
			if(elm<0){
				srcnode=node;var i=0;
				while(i<srcnode.length){
					if(attrName){
						if (srcnode[i].getAttribute(attrName)!=attrValue) ok=false;
						else ok=true;
					}else ok=true;
					if(ok){
						node=srcnode[i].selectNode(tagpath);
						if(node) return node;
					}
					i++;
				}
			}else if (elm<node.length){
				node=node[elm].selectNode(tagpath);
				if(node) return node;
			}
		}
	}
} // end function _XMLDoc_selectNode

function _XMLDoc_selectNodeText(tagpath){
    /*******************************************************************************************************************
    function:	_XMLDoc_selectNodeText

    Author:		xwisdom@yahoo.com

    Description:
    	selects a single node using the nodes tag path and then returns the node text.
    *********************************************************************************************************************/

    var node=this.selectNode(tagpath);
    if (node != null) {
		return node.getText();
	}
    else {
		return null;
	}
} // end function _XMLDoc_selectNodeText








// =========================================================================
// =========================================================================
// =========================================================================
// XML NODE FUNCTIONS
// =========================================================================
// =========================================================================
// =========================================================================


function XMLNode(nodeType,doc, str) {
    /*******************************************************************************************************************
    function: xmlNode

    Author: mike@idle.org

    Description:

        XMLNode() is a constructor for a node of XML (text, comment, cdata, tag, etc)

        nodeType = indicates the node type of the node
        doc == contains a reference to the XMLDoc object describing the document
        str == contains the text for the tag or text entity

    *********************************************************************************************************************/


    // the content of text (also CDATA and COMMENT) nodes
    if (nodeType=='TEXT' || nodeType=='CDATA' || nodeType=='COMMENT' ) {
        this.content = str;
    }
    else {
        this.content = null;
    }

    this.attributes = null; // an array of attributes (used as a hash table)
    this.children = null;   // an array (list) of the children of this node
    this.doc = doc;         // a reference to the document
    this.nodeType = nodeType;          // the type of the node
    this.parent = "";
    this.tagName = "";           // the name of the tag (if a tag node)

    // configure the methods
    this.addAttribute = _XMLNode_addAttribute;
    this.addElement = _XMLNode_addElement;
    this.getAttribute = _XMLNode_getAttribute;
    this.getAttributeNames = _XMLNode_getAttributeNames;
    this.getElementById = _XMLNode_getElementById;
    this.getElements = _XMLNode_getElements;
    this.getText = _XMLNode_getText;
    this.getParent = _XMLNode_getParent;
    this.getUnderlyingXMLText = _XMLNode_getUnderlyingXMLText;
    this.removeAttribute = _XMLNode_removeAttribute;
    this.selectNode = _XMLDoc_selectNode;
	this.selectNodeText = _XMLDoc_selectNodeText;
    this.toString = _XMLNode_toString;

}  // end function XMLNode


function _XMLNode_addAttribute(attributeName,attributeValue) {
    /*******************************************************************************************************************
    function: _XMLNode_addAttribute

    Author: mike@idle.org

    Description:
        add an attribute to a node
    *********************************************************************************************************************/

    //if the name is found, the old value is overwritten by the new value
    this.attributes['_' + attributeName] = attributeValue;
    return true;

} // end function _XMLNode_addAttribute



function _XMLNode_addElement(node) {
    /*******************************************************************************************************************
    function: _XMLNode_addElement

    Author: mike@idle.org

    Description:
        add an element child to a node
    *********************************************************************************************************************/
    node.parent = this;
    this.children[this.children.length] = node;
    return true;

} // end function _XMLNode_addElement


function _XMLNode_getAttribute(name) {
    /*******************************************************************************************************************
    function: _XMLNode_getAttribute

    Author: mike@idle.org

    Description:
        get the value of a named attribute from an element node

        NOTE: we prefix with "_" because of the weird 'length' meta-property

    *********************************************************************************************************************/
    if (this.attributes == null) {
        return null;
    }
    return this.attributes['_' + name];
} // end function _XMLNode_getAttribute



function _XMLNode_getAttributeNames() {
    /*******************************************************************************************************************
    function: _XMLNode_getAttributeNames

    Author: mike@idle.org

    Description:
        get a list of attribute names for the node

        NOTE: we prefix with "_" because of the weird 'length' meta-property

        NOTE: Version 1.0 of getAttributeNames breaks backwards compatibility. Previous to 1.0
        getAttributeNames would return null if there were no attributes. 1.0 now returns an
        array of length 0.


    *********************************************************************************************************************/
    if (this.attributes == null) {
        var ret = new Array();
        return ret;
    }

    var attlist = new Array();

    for (var a in this.attributes) {
        attlist[attlist.length] = a.substring(1);
    }
    return attlist;
} // end function _XMLNode_getAttributeNames

function _XMLNode_getElementById(id) {

    /***********************************************************************************
    Function: getElementById

    Author: djoham@yahoo.com

    Description:
        Brute force searches through the XML DOM tree
        to find the node with the unique ID passed in

    ************************************************************************************/
    var node = this;
    var ret;

    //alert("tag name=" + node.tagName);
    //alert("id=" + node.getAttribute("id"));
    if (node.getAttribute("id") == id) {
        return node;
    }
    else{
        var elements = node.getElements();
        //alert("length=" + rugrats.length);
        var intLoop = 0;
        //do NOT use a for loop here. For some reason
        //it kills some browsers!!!
        while (intLoop < elements.length) {
            //alert("intLoop=" + intLoop);
            var element = elements[intLoop];
            //alert("recursion");
            ret = element.getElementById(id);
            if (ret != null) {
                //alert("breaking");
                break;
            }
            intLoop++;
        }
    }
    return ret;
} // end function _XMLNode_getElementById


function _XMLNode_getElements(byName) {
    /*******************************************************************************************************************
    function:   _XMLNode_getElements

    Author: mike@idle.org

    Description:
        get an array of element children of a node
        with an optional filter by name

        NOTE: Version 1.0 of getElements breaks backwards compatibility. Previous to 1.0
        getElements would return null if there were no attributes. 1.0 now returns an
        array of length 0.


    *********************************************************************************************************************/
    if (this.children==null) {
        var ret = new Array();
        return ret;
    }

    var elements = new Array();
    for (var i=0; i<this.children.length; i++) {
        if ((this.children[i].nodeType=='ELEMENT') && ((byName==null) || (this.children[i].tagName == byName))) {
            elements[elements.length] = this.children[i];
        }
    }
    return elements;
} // end function _XMLNode_getElements



function _XMLNode_getText() {
    /*******************************************************************************************************************
    function:       _XMLNode_getText

    Author: mike@idle.org

    Description:
        a method to get the text of a given node (recursively, if it's an element)
    *********************************************************************************************************************/

    if (this.nodeType=='ELEMENT') {
        if (this.children==null) {
            return null;
        }
        var str = "";
        for (var i=0; i < this.children.length; i++) {
            var t = this.children[i].getText();
            str +=  (t == null ? "" : t);
        }
        return str;
    }
    else if (this.nodeType=='TEXT') {
        return convertEscapes(this.content);
    }
    else {
        return this.content;
    }
} // end function _XMLNode_getText



function _XMLNode_getParent() {
    /*******************************************************************************************************************
    function:       _XMLNode_getParent

    Author: mike@idle.org

    Description:
        get the parent of this node
    *********************************************************************************************************************/
    return this.parent;

} // end function _XMLNode_getParent


function _XMLNode_getUnderlyingXMLText() {
    /*******************************************************************************************************************
    function:       David Joham

    Author: djoham@yahoo.com

    Description:
        returns the underlying XML text for the node
        by calling the _displayElement function
    *********************************************************************************************************************/

    var strRet = "";
    strRet = _displayElement(this, strRet);
    return strRet;

} // end function _XMLNode_getUnderlyingXMLText



function _XMLNode_removeAttribute(attributeName) {
    /*******************************************************************************************************************
    function:       _XMLNode_removeAttribute

    Author: djoham@yahoo.com

    Description:
        remove an attribute from a node
    *********************************************************************************************************************/
    if(attributeName == null) {
        return this.doc.error("You must pass an attribute name into the removeAttribute function");
    }

    //now remove the attribute from the list.
    // I want to keep the logic for adding attribtues in one place. I'm
    // going to get a temp array of attributes and values here and then
    // use the addAttribute function to re-add the attributes
    var attributes = this.getAttributeNames();
    var intCount = attributes.length;
    var tmpAttributeValues = new Array();
    for ( intLoop = 0; intLoop < intCount; intLoop++) {
        tmpAttributeValues[intLoop] = this.getAttribute(attributes[intLoop]);
    }

    // now blow away the old attribute list
    this.attributes = new Array();

    //now add the attributes back to the array - leaving out the one we're removing
    for (intLoop = 0; intLoop < intCount; intLoop++) {
        if ( attributes[intLoop] != attributeName) {
            this.addAttribute(attributes[intLoop], tmpAttributeValues[intLoop]);
        }
    }

return true;

} // end function _XMLNode_removeAttribute



function _XMLNode_toString() {
    /*******************************************************************************************************************
    function:       _XMLNode_toString

    Author: mike@idle.org

    Description:
        produces a diagnostic string description of a node
    *********************************************************************************************************************/
    return "" + this.nodeType + ":" + (this.nodeType=='TEXT' || this.nodeType=='CDATA' || this.nodeType=='COMMENT' ? this.content : this.tagName);

} // end function _XMLNode_toString

























