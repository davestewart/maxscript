// =========================================================================
//
// preMadeSaxEventHandler.js - a pre-built event handler for XML for <SCRIPT>'s SAX Parser
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2001 - 2002 David Joham (djoham@yahoo.com)
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
// visit the XML for <SCRIPT> home page at xmljs.sourceforge.net
//


/*****************************************************************************
                    SAXEventHandler Object
*****************************************************************************/

SAXEventHandler = function() {
    /*****************************************************************************
    function:  SAXEventHandler

    author: djoham@yahoo.com

    description:
        this is the constructor for the object which will be the sink for
        the SAX events
    *****************************************************************************/

    this.characterData = "";   // there is no guarantee that the text event will only fire once
                                                 // for element texts. This variable keeps track of the text that has
                                                 // been returned in the text events. It is reset  when a non-text
                                                 //event is fired and should be read at that time
}  // end function SAXEventHandler



/*****************************************************************************
                    SAXEventHandler Object SAX INTERFACES
*****************************************************************************/


SAXEventHandler.prototype.characters = function(data, start, length) {
    /*****************************************************************************
    function:  characters

    author: djoham@yahoo.com

    description:
        Fires when character data is found

        ****** NOTE******
        there is no guarantee that this event will only fire once for
        text data. Particularly, in the cases of escaped characters,
        this event can be called multiple times. It is best to keep a
        variable around to collect all of the data returned in this event.
        You'll know all of the text is returned when you get a non-characters
        event.

        The variable that this object keeps for just this purpose is this.characterData

        To ensure that text values are handled properly, each event calls the function
        this._handleCharacterData. This event resets the characterData
        variable for non-characters events. It also calls the function
        this._fullCharacterDataReceived.

        since this event can be called many times, you should put your text handling
        code in the function this._fullCharacterDataReceived if you need to act only
        when you know you have all of the character data for the element.

        data is your full XML string
        start is the beginning of the XML character data being reported to you
        end is the end of the XML character data being reported to you

        the data can be retrieved using the following code:
        var data = data.substr(start, length);

        Generally, you won't have any code here. Place your code in
        this._fullCharacterDataReceived instead

    *****************************************************************************/

    this.characterData += data.substr(start, length);

}  // end function characters


SAXEventHandler.prototype.endDocument = function() {
    /*****************************************************************************
    function:  endDocument

    author: djoham@yahoo.com

    description:
        Fires at the end of the document
    *****************************************************************************/

    this._handleCharacterData();

    //place endDocument event handling code below this line

}  // end function endDocument


SAXEventHandler.prototype.endElement = function(name) {
    /*****************************************************************************
    function:  endElement

    author: djoham@yahoo.com

    description:
        Fires at the end of an element

        name == the element name that is ending
    *****************************************************************************/

    this._handleCharacterData();

    //place endElement event handling code below this line


}  // end function endElement


SAXEventHandler.prototype.processingInstruction = function(target, data) {
    /*****************************************************************************
    function:  processingInstruction

    author: djoham@yahoo.com

    description:
        Fires when a processing Instruction is found

        In the following processing instruction:
        <?xml version=\"1.0\"?>

        target == xml
        data == version"1.0"
    *****************************************************************************/
    this._handleCharacterData();

    //place processingInstruction event handling code below this line


}  // end function processingInstruction


SAXEventHandler.prototype.setDocumentLocator = function(locator) {
    /*****************************************************************************
    function:  setDocumentLocator

    author: djoham@yahoo.com

    description:
        This is the first event ever called by the parser.

        locator is a reference to the actual parser object that is parsing
        the XML text. Normally, you won't need to trap for this error
        or do anything with the locator object, but if you do need to,
        this is how you get a reference to the object
    *****************************************************************************/

    this._handleCharacterData();

    //place setDocumentLocator event handling code below this line


}  // end function setDocumentLocator


SAXEventHandler.prototype.startElement = function(name, atts) {
    /*****************************************************************************
    function:  startElement

    author: djoham@yahoo.com

    description:
        Fires at the start of an element

        name == the name of the element that is starting
        atts == an array of element attributes

        The attribute information can be retrieved by calling
        atts.getName([ordinal])  -- zero based
        atts.getValue([ordinal]) -- zero based
        atts.getLength()
        atts.getValueByName([attributeName])

    *****************************************************************************/

    this._handleCharacterData();

    //place startElement event handling code below this line


}  // end function startElement


SAXEventHandler.prototype.startDocument = function() {
    /*****************************************************************************
    function:  startDocument

    author: djoham@yahoo.com

    description:
        Fires at the start of the document
    *****************************************************************************/

    this._handleCharacterData();

    //place startDocument event handling code below this line


}  // end function startDocument


/*****************************************************************************
                    SAXEventHandler Object Lexical Handlers
*****************************************************************************/


SAXEventHandler.prototype.comment = function(data, start, length) {
    /*****************************************************************************
    function:  comment

    author: djoham@yahoo.com

    description:
        Fires when a comment is found

        data is your full XML string
        start is the beginning of the XML character data being reported to you
        end is the end of the XML character data being reported to you

        the data can be retrieved using the following code:
        var data = data.substr(start, length);
    *****************************************************************************/
    this._handleCharacterData();

    //place comment event handling code below this line


}  // end function comment


SAXEventHandler.prototype.endCDATA = function() {
    /*****************************************************************************
    function:  endCDATA

    author: djoham@yahoo.com

    description:
        Fires at the end of a CDATA element
    *****************************************************************************/
    this._handleCharacterData();

    //place endCDATA event handling code below this line


}  // end function endCDATA


SAXEventHandler.prototype.startCDATA = function() {
    /*****************************************************************************
    function:  startCDATA

    author: djoham@yahoo.com

    description:
        Fires at the start of a CDATA element
    *****************************************************************************/
    this._handleCharacterData();

    //place startCDATA event handling code below this line


}  // end function startCDATA


/*****************************************************************************
                    SAXEventHandler Object Error Interface
*****************************************************************************/


SAXEventHandler.prototype.error = function(exception) {
    /*****************************************************************************
    function:  error

    author: djoham@yahoo.com

    description:
        Fires when an error is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place error event handling code below this line


}  // end function error


SAXEventHandler.prototype.fatalError = function(exception) {
    /*****************************************************************************
    function:  fatalError

    author: djoham@yahoo.com

    description:
        Fires when a  fatal error is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place fatalError event handling code below this line


}  // end function fatalError


SAXEventHandler.prototype.warning = function(exception) {
    /*****************************************************************************
    function:  warning

    author: djoham@yahoo.com

    description:
        Fires when a warning is found.

        Information about the exception can be found by calling
        exception.getMessage()
        exception.getLineNumber()
        exception.getColumnNumber()
    *****************************************************************************/
    this._handleCharacterData();

    //place warning event handling code below this line


}  // end function warning


/*****************************************************************************
                   SAXEventHandler Object Internal Functions
*****************************************************************************/


SAXEventHandler.prototype._fullCharacterDataReceived = function(fullCharacterData) {
    /*****************************************************************************
    function:  _fullCharacterDataReceived

    author: djoham@yahoo.com

    description:
        this function is called when we know we are finished getting
        all of the character data. If you need to be sure you handle
        your text processing when you have all of the character data,
        your code for that handling should go here

        fullCharacterData contains all of the character data for the element
    *****************************************************************************/

    //place character (text) event handling code below this line


}  // end function _fullCharacterDataReceived


SAXEventHandler.prototype._handleCharacterData = function()  {
    /*****************************************************************************
    function:  _handleCharacterData

    author: djoham@yahoo.com

    description:
        This internal function is called at the beginning of every event, with the exception
        of the characters event.  It fires the internal event this._fullCharacterDataReceived
        if there is any data in the this.characterData internal variable.
        It then resets the this.characterData variable to blank

        Generally, you will not need to modify this function
    *****************************************************************************/

    // call the function that lets the user know that all of the text data has been received
    // but only if there is data.
    if (this.characterData != "") {
        this._fullCharacterDataReceived(this.characterData);
    }

    //reset the characterData variable
    this.characterData = "";

}  // end function _handleCharacterData

