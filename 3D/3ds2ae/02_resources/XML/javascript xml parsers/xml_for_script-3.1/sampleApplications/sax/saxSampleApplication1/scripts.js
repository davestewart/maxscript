// =========================================================================
//
// scripts.js- sample code for the SAX Parser in XML for <SCRIPT>
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


/**************************************************************************************
                                        GLOBALS
***************************************************************************************/

var xmlTextArray
var xmlCDataArray
var xmlAttrArray


/**************************************************************************************
                                        FUNCTIONS
***************************************************************************************/

function showTagInfo(xpath){
    /*************************************************************************************
    Function:       void showTagInfo(xpath)

    author:         xwisdom@yahoo.com

    description:
        displays information about a node. Uses the node's xpath info

    ************************************************************************************/

    var textValue;
    var cdataValue;

    textValue = trim(xmlTextArray[xpath]);

    if (textValue == "" || textValue == null) {
        textValue = "No text value for this node";
    }

    cdataValue = trim(xmlCDataArray[xpath]);


    if (cdataValue == "" || cdataValue == null) {
        cdataValue = "No CDATA value for this node";
    }

    var src='Text:\n '+textValue+'\n\n' +'CDATA:\n '+cdataValue +'\n\n'

    if(xmlAttrArray[xpath]){
        var arr=xmlAttrArray[xpath]
        var atts=''
        for (i in arr){
            // name = value
            atts+=i+'='+arr[i]+'\n';
        }
        src+='Attributes:\n '+atts
    }

    alert(xpath+'\n\n'+src)

} // end function showTagInfo


function startParser() {
    /*************************************************************************************
    Function:       void startParser(xmldata)

    author:         xwisdom@yahoo.com

    description:
        starts the sax2 parser

    ************************************************************************************/

    var ixml = document.getElementById("xmldata").value;

    var arr,src='' ,parser = new SAXDriver();
    var handler = new xmlHandler();


    // pass handlers to the sax2 parser
    parser.setDocumentHandler(handler);
    parser.setErrorHandler(handler);
    parser.setLexicalHandler(handler);

    parser.parse(ixml);// start parsing

    // get errors from sax2 parser
    var err='\n'+handler.getError();

    xmlTextArray=handler.getText_Array()
    xmlCDataArray=handler.getCDATA_Array()
    xmlAttrArray=handler.getAttr_Array()

    arr=handler.getPath_Array();
    for (i=0;i<arr.length;i++){
        src+='<a href="javascript:void(null)" onclick="showTagInfo(\''+arr[i]+'\')">'+arr[i]+'</a>\n'
    }

    if(document.all){
        document.all.divout.innerHTML='Parsing completed  | Click on the links below for more info:<br><pre>'+src+'</pre>'
    }else if(document.getElementById){
        document.getElementById('divout').innerHTML='Parsing completed | Click on the links below for more info:<br><pre>'+src+'</pre>'
    }else{
        alert('Requires a DOM compatible browser for this test')
    }

}// end function startParser



/***************************************************************************************
                                        SAX EVENT HANDLER
***************************************************************************************/


xmlHandler = function() {
    /*************************************************************************************
    Function:       xmlHandler

    author:         xwisdom@yahoo.com

    description:
    	constructor for the xmlHandler object

    ************************************************************************************/
    this.m_strError=''
    this.m_treePath=[]
    this.m_xPath=[''] // stores current path info
    this.m_text=['']
    this.m_cdata=['']
    this.m_attr=['']
    this.m_pi=['']
    this.cdata=false

} // end function xmlHandler


xmlHandler.prototype.characters = function(data, start, length) {
    /*************************************************************************************
    Function:       object.characters(String data, Int start, Int length)
					-> data: xml data
					-> start of text/cdata entity
					-> length of text/cdata entity

    author:         xwisdom@yahoo.com

    description:
    	this event is triggered whenever a text/cdata entity is encounter by the sax2 parser

    ************************************************************************************/

    // capture characters from CDATA and Text entities
    var text=data.substr(start, length);
    if (text=='\n' ) return null // get ride of blank text lines
    if (this.m_treePath.length>0){
        if(this.cdata==false){
            if (!this.m_text[this.m_xPath.join('/')]) {
                this.m_text[this.m_xPath.join('/')]='';
            }
            this.m_text[this.m_xPath.join('/')]+=text;
        }
        else {
            if (!this.m_cdata[this.m_xPath.join('/')]) {
                this.m_cdata[this.m_xPath.join('/')]='';
            }
            this.m_cdata[this.m_xPath.join('/')]+=text;
        }
    }

} // end function characters


xmlHandler.prototype.comment = function(data, start, length) {
    /*************************************************************************************
    Function:       object.comment(String data, Int start, Int length)

    author:         xwisdom@yahoo.com

    description:
		triggered whenever a comment <!-- text --> is found. Same as the character event

    ************************************************************************************/

    var comment=data.substr(start, length)

} // end function comment


xmlHandler.prototype.endCDATA = function() {
    /*************************************************************************************
    Function:       object.endCDATA()

    author:         xwisdom@yahoo.com

    description:
    	triggered at the end of cdata entity

    ************************************************************************************/

    // end of CDATA entity
    this.cdata=false

} // end function endCDATA


xmlHandler.prototype.endDocument = function() {
    /*************************************************************************************
    Function:       object.endDocument()

    author:         xwisdom@yahoo.com

    description:
    	end of document parsing - last event triggered by the sax2 parser

    ************************************************************************************/

} // end function end Document


xmlHandler.prototype.endElement = function(name) {
    /*************************************************************************************
    Function:       object.endElement(String tagname)
					-> tagname: name of tag

    author:         xwisdom@yahoo.com

    description:
    	last event trigger when a node is encounter by the sax2 parser

    ************************************************************************************/

    this.m_xPath=this.m_xPath.slice(0,-1)

} // end function endElement


xmlHandler.prototype.error = function(exception) {
    /*************************************************************************************
    Function:       object.error(String exception)

    author:         xwisdom@yahoo.com

    description:
		triggered whenever an error is encounter by the sax2 parser

    ************************************************************************************/

    this.m_strError+='Error:'+exception.getMessage()+'\n'

} // end function error


xmlHandler.prototype.fatalError = function(exception) {
    /*************************************************************************************
    Function:       object.fatalError(String exception)

    author:         xwisdom@yahoo.com

    description:
		triggered whenever an error is encounter by the sax2 parser

    ************************************************************************************/

    this.m_strError+='fata error:'+exception.getMessage()+'\n'

} // end function fatalError


xmlHandler.prototype.getAttr_Array= function() {
    /*************************************************************************************
    Function:       getAttr_Array

    author:         xwisdom@yahoo.com
    ************************************************************************************/

    return this.m_attr;

}   // end function getAttr_Array


xmlHandler.prototype.getCDATA_Array= function() {
    /*************************************************************************************
    Function:       getCDATA_Array

    author:         xwisdom@yahoo.com
    ************************************************************************************/
    return this.m_cdata;

}  // end function getCDATA_Array


xmlHandler.prototype.getError = function() {
    /*************************************************************************************
    Function:       getError

    author:         xwisdom@yahoo.com
    ************************************************************************************/

    return this.m_strError;

}  // end function getError


xmlHandler.prototype.getPath_Array = function() {
    /*************************************************************************************
    Function:       getError

    author:         xwisdom@yahoo.com
    ************************************************************************************/
	return this.m_treePath;
}  // end function getPath_Array


xmlHandler.prototype.getText_Array = function() {
    /*************************************************************************************
    Function:       getText_Array

    author:         xwisdom@yahoo.com
    ************************************************************************************/
    return this.m_text;

} // getTextArray


xmlHandler.prototype.processingInstruction = function(target, data) {
    /*************************************************************************************
    Function:       object.processingInstruction(String target, String data)
						-> target: is tagname of the pi
						-> data: is the content of the pi

    author:         xwisdom@yahoo.com

    description:
    	capture PI data here

    ************************************************************************************/

} // end function processingInstruction


xmlHandler.prototype.setDocumentLocator = function(locator) {
    /*************************************************************************************
    Function:       object.setDocumentLocator(SAXDriver locator)

    author:         xwisdom@yahoo.com

    description:
		passes an instance of the SAXDriver to the handler

    ************************************************************************************/

    this.m_locator = locator;

}  // end function setDocumentLocator


xmlHandler.prototype.startCDATA = function() {
    /*************************************************************************************
    Function:       object.startCDATA()

    author:         xwisdom@yahoo.com

    description:
    	triggered whenever a cdata entity is encounter by the sax2 parser

    ************************************************************************************/


    // start of CDATA entity
    this.cdata=true

} // end function startCDATA


xmlHandler.prototype.startDocument = function() {
    /*************************************************************************************
    Function:       object.startDocument()

    author:         xwisdom@yahoo.com

    description:
    	start of document - first event triggered by the sax2 parser

    ************************************************************************************/

} // end function startDocument


xmlHandler.prototype.startElement = function(name, atts) {
    /*************************************************************************************
    Function:       object.startElement(String tagname,Array content)
					-> tagname: name of tag
					-> content: [["attribute1", "value1"], ["attribute2", "value2"],....,n]

    author:         xwisdom@yahoo.com

    description:
    	First event trigger when a node is encounter by the sax2 parser
    	the name and attribute contents are passed to this event

    ************************************************************************************/

    // Note: the following code is used to store info about the node
    // into arrays for use the xpath layout

    var cpath,att_count=atts.getLength()
    this.m_xPath[this.m_xPath.length]=name
    cpath=this.m_xPath.join('/')
    this.m_treePath[this.m_treePath.length]=cpath

    if (att_count) {
        var attr=[]
        for (i=0;i<att_count;i++){
            attr[atts.getName(i)]=atts.getValue(i)
        }
        this.m_attr[this.m_xPath.join('/')]=attr;
    }

} // end function startElement


xmlHandler.prototype.warning = function(exception) {
    /*************************************************************************************
    Function:       object.warninng(String exception)

    author:         xwisdom@yahoo.com

    description:
		triggered whenever an error is encounter by the sax2 parser

    ************************************************************************************/

    this.m_strError+='Warning:'+exception.getMessage()+'\n'

} // end function warning








