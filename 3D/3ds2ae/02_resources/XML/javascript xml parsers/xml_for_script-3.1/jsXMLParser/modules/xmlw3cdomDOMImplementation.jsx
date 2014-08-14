alert('OK!')

// =========================================================================
//
// xmlw3cdom.js - a W3C compliant DOM parser for XML for <SCRIPT>
//
// version 3.1
//
// =========================================================================
//
// Copyright (C) 2002, 2003, 2004 Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
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
// Contains text (used within comments to methods) from the
//  XML Path Language (XPath) Version 1.0 W3C Recommendation
//  Copyright © 16 November 1999 World Wide Web Consortium,
//  (Massachusetts Institute of Technology,
//  European Research Consortium for Informatics and Mathematics, Keio University).
//  All Rights Reserved.
//  (see: http://www.w3.org/TR/2000/WD-DOM-Level-1-20000929/)

/*
 * @function addClass - add new className to classCollection
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  classCollectionStr : string - list of existing class names
 *   (separated and top and tailed with '|'s)
 * @param  newClass           : string - new class name to add
 *
 * @return : string - the new classCollection, with new className appended,
 *   (separated and top and tailed with '|'s)
 */
function addClass(classCollectionStr, newClass) {
  if (classCollectionStr) {
    if (classCollectionStr.indexOf("|"+ newClass +"|") < 0) {
      classCollectionStr += newClass + "|";
    }
  }
  else {
    classCollectionStr = "|"+ newClass + "|";
  }

  return classCollectionStr;
}
alert('OK')
/**
 * @class  DOMException - raised when an operation is impossible to perform
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  code : int - the exception code (one of the DOMException constants)
 */
DOMException = function(code) {
  this._class = addClass(this._class, "DOMException");

  this.code = code;
};

// DOMException constants
// Introduced in DOM Level 1:
DOMException.INDEX_SIZE_ERR                 = 1;
DOMException.DOMSTRING_SIZE_ERR             = 2;
DOMException.HIERARCHY_REQUEST_ERR          = 3;
DOMException.WRONG_DOCUMENT_ERR             = 4;
DOMException.INVALID_CHARACTER_ERR          = 5;
DOMException.NO_DATA_ALLOWED_ERR            = 6;
DOMException.NO_MODIFICATION_ALLOWED_ERR    = 7;
DOMException.NOT_FOUND_ERR                  = 8;
DOMException.NOT_SUPPORTED_ERR              = 9;
DOMException.INUSE_ATTRIBUTE_ERR            = 10;

// Introduced in DOM Level 2:
DOMException.INVALID_STATE_ERR              = 11;
DOMException.SYNTAX_ERR                     = 12;
DOMException.INVALID_MODIFICATION_ERR       = 13;
DOMException.NAMESPACE_ERR                  = 14;
DOMException.INVALID_ACCESS_ERR             = 15;


/**
 * @class  DOMImplementation - provides a number of methods for performing operations
 *   that are independent of any particular instance of the document object model.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 */
DOMImplementation = function() {
  this._class = addClass(this._class, "DOMImplementation");
  this._p = null;

  this.preserveWhiteSpace = false;  // by default, ignore whitespace
  this.namespaceAware = true;       // by default, handle namespaces
  this.errorChecking  = true;       // by default, test for exceptions
};


/**
 * @method DOMImplementation.escapeString - escape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  str : string - The string to be escaped
 *
 * @return : string - The escaped string
 */
DOMImplementation.prototype.escapeString = function DOMNode__escapeString(str) {

  //the sax processor already has this function. Just wrap it
  return __escapeString(str);
};

/**
 * @method DOMImplementation.unescapeString - unescape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  str : string - The string to be unescaped
 *
 * @return : string - The unescaped string
 */
DOMImplementation.prototype.unescapeString = function DOMNode__unescapeString(str) {

  //the sax processor already has this function. Just wrap it
  return __unescapeString(str);
};

/**
 * @method DOMImplementation.hasFeature - Test if the DOM implementation implements a specific feature
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  feature : string - The package name of the feature to test. the legal only values are "XML" and "CORE" (case-insensitive).
 * @param  version : string - This is the version number of the package name to test. In Level 1, this is the string "1.0".
 *
 * @return : boolean
 */
DOMImplementation.prototype.hasFeature = function DOMImplementation_hasFeature(feature, version) {

  var ret = false;
  if (feature.toLowerCase() == "xml") {
    ret = (!version || (version == "1.0") || (version == "2.0"));
  }
  else if (feature.toLowerCase() == "core") {
    ret = (!version || (version == "2.0"));
  }

  return ret;
};

/**
 * @method DOMImplementation.loadXML - parse XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  xmlStr : string - the XML string
 *
 * @return : DOMDocument
 */
DOMImplementation.prototype.loadXML = function DOMImplementation_loadXML(xmlStr) {
  // create SAX Parser
  var parser;

  try {
    parser = new XMLP(xmlStr);
  }
  catch (e) {
    alert("Error Creating the SAX Parser. Did you include xmlsax.js or tinyxmlsax.js in your web page?\nThe SAX parser is needed to populate XML for <SCRIPT>'s W3C DOM Parser with data.");
  }

  // create DOM Document
  var doc = new DOMDocument(this);

  // populate Document with Parsed Nodes
  this._parseLoop(doc, parser);

  // set parseComplete flag, (Some validation Rules are relaxed if this is false)
  doc._parseComplete = true;

  return doc;
};


/**
 * @method DOMImplementation.translateErrCode - convert DOMException Code
 *   to human readable error message;
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  code : int - the DOMException code
 *
 * @return : string - the human readbale error message
 */
DOMImplementation.prototype.translateErrCode = function DOMImplementation_translateErrCode(code) {
  var msg = "";

  switch (code) {
    case DOMException.INDEX_SIZE_ERR :                // 1
       msg = "INDEX_SIZE_ERR: Index out of bounds";
       break;

    case DOMException.DOMSTRING_SIZE_ERR :            // 2
       msg = "DOMSTRING_SIZE_ERR: The resulting string is too long to fit in a DOMString";
       break;

    case DOMException.HIERARCHY_REQUEST_ERR :         // 3
       msg = "HIERARCHY_REQUEST_ERR: The Node can not be inserted at this location";
       break;

    case DOMException.WRONG_DOCUMENT_ERR :            // 4
       msg = "WRONG_DOCUMENT_ERR: The source and the destination Documents are not the same";
       break;

    case DOMException.INVALID_CHARACTER_ERR :         // 5
       msg = "INVALID_CHARACTER_ERR: The string contains an invalid character";
       break;

    case DOMException.NO_DATA_ALLOWED_ERR :           // 6
       msg = "NO_DATA_ALLOWED_ERR: This Node / NodeList does not support data";
       break;

    case DOMException.NO_MODIFICATION_ALLOWED_ERR :   // 7
       msg = "NO_MODIFICATION_ALLOWED_ERR: This object cannot be modified";
       break;

    case DOMException.NOT_FOUND_ERR :                 // 8
       msg = "NOT_FOUND_ERR: The item cannot be found";
       break;

    case DOMException.NOT_SUPPORTED_ERR :             // 9
       msg = "NOT_SUPPORTED_ERR: This implementation does not support function";
       break;

    case DOMException.INUSE_ATTRIBUTE_ERR :           // 10
       msg = "INUSE_ATTRIBUTE_ERR: The Attribute has already been assigned to another Element";
       break;

// Introduced in DOM Level 2:
    case DOMException.INVALID_STATE_ERR :             // 11
       msg = "INVALID_STATE_ERR: The object is no longer usable";
       break;

    case DOMException.SYNTAX_ERR :                    // 12
       msg = "SYNTAX_ERR: Syntax error";
       break;

    case DOMException.INVALID_MODIFICATION_ERR :      // 13
       msg = "INVALID_MODIFICATION_ERR: Cannot change the type of the object";
       break;

    case DOMException.NAMESPACE_ERR :                 // 14
       msg = "NAMESPACE_ERR: The namespace declaration is incorrect";
       break;

    case DOMException.INVALID_ACCESS_ERR :            // 15
       msg = "INVALID_ACCESS_ERR: The object does not support this function";
       break;

    default :
       msg = "UNKNOWN: Unknown Exception Code ("+ code +")";
  }

  return msg;
}

/**
 * @method DOMImplementation._parseLoop - process SAX events
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  doc : DOMDocument - the Document to contain the parsed XML string
 * @param  p   : XMLP        - the SAX Parser
 *
 * @return : DOMDocument
 */
DOMImplementation.prototype._parseLoop = function DOMImplementation__parseLoop(doc, p) {
  var iEvt, iNode, iAttr, strName;
  iNodeParent = doc;

  var el_close_count = 0;

  var entitiesList = new Array();
  var textNodesList = new Array();

  // if namespaceAware, add default namespace
  if (this.namespaceAware) {
    var iNS = doc.createNamespace(""); // add the default-default namespace
    iNS.setValue("http://www.w3.org/2000/xmlns/");
    doc._namespaces.setNamedItem(iNS);
  }

  // loop until SAX parser stops emitting events
  while(true) {
    // get next event
    iEvt = p.next();

    if (iEvt == XMLP._ELM_B) {                      // Begin-Element Event
      var pName = p.getName();                      // get the Element name
      pName = trim(pName, true, true);              // strip spaces from Element name

      if (!this.namespaceAware) {
        iNode = doc.createElement(p.getName());     // create the Element

        // add attributes to Element
        for(var i = 0; i < p.getAttributeCount(); i++) {
          strName = p.getAttributeName(i);          // get Attribute name
          iAttr = iNode.getAttributeNode(strName);  // if Attribute exists, use it

          if(!iAttr) {
            iAttr = doc.createAttribute(strName);   // otherwise create it
          }

          iAttr.setValue(p.getAttributeValue(i));   // set Attribute value
          iNode.setAttributeNode(iAttr);            // attach Attribute to Element
        }
      }
      else {  // Namespace Aware
        // create element (with empty namespaceURI,
        //  resolve after namespace 'attributes' have been parsed)
        iNode = doc.createElementNS("", p.getName());

        // duplicate ParentNode's Namespace definitions
        iNode._namespaces = iNodeParent._namespaces._cloneNodes(iNode);

        // add attributes to Element
        for(var i = 0; i < p.getAttributeCount(); i++) {
          strName = p.getAttributeName(i);          // get Attribute name

          // if attribute is a namespace declaration
          if (this._isNamespaceDeclaration(strName)) {
            // parse Namespace Declaration
            var namespaceDec = this._parseNSName(strName);

            if (strName != "xmlns") {
              iNS = doc.createNamespace(strName);   // define namespace
            }
            else {
              iNS = doc.createNamespace("");        // redefine default namespace
            }
            iNS.setValue(p.getAttributeValue(i));   // set value = namespaceURI

            iNode._namespaces.setNamedItem(iNS);    // attach namespace to namespace collection
          }
          else {  // otherwise, it is a normal attribute
            iAttr = iNode.getAttributeNode(strName);        // if Attribute exists, use it

            if(!iAttr) {
              iAttr = doc.createAttributeNS("", strName);   // otherwise create it
            }

            iAttr.setValue(p.getAttributeValue(i));         // set Attribute value
            iNode.setAttributeNodeNS(iAttr);                // attach Attribute to Element

            if (this._isIdDeclaration(strName)) {
              iNode.id = p.getAttributeValue(i);    // cache ID for getElementById()
            }
          }
        }

        // resolve namespaceURIs for this Element
        if (iNode._namespaces.getNamedItem(iNode.prefix)) {
          iNode.namespaceURI = iNode._namespaces.getNamedItem(iNode.prefix).value;
        }

        //  for this Element's attributes
        for (var i = 0; i < iNode.attributes.length; i++) {
          if (iNode.attributes.item(i).prefix != "") {  // attributes do not have a default namespace
            if (iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix)) {
              iNode.attributes.item(i).namespaceURI = iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix).value;
            }
          }
        }
      }

      // if this is the Root Element
      if (iNodeParent.nodeType == DOMNode.DOCUMENT_NODE) {
        iNodeParent.documentElement = iNode;        // register this Element as the Document.documentElement
      }

      iNodeParent.appendChild(iNode);               // attach Element to parentNode
      iNodeParent = iNode;                          // descend one level of the DOM Tree
    }

    else if(iEvt == XMLP._ELM_E) {                  // End-Element Event
      iNodeParent = iNodeParent.parentNode;         // ascend one level of the DOM Tree
    }

    else if(iEvt == XMLP._ELM_EMP) {                // Empty Element Event
      pName = p.getName();                          // get the Element name
      pName = trim(pName, true, true);              // strip spaces from Element name

      if (!this.namespaceAware) {
        iNode = doc.createElement(pName);           // create the Element

        // add attributes to Element
        for(var i = 0; i < p.getAttributeCount(); i++) {
          strName = p.getAttributeName(i);          // get Attribute name
          iAttr = iNode.getAttributeNode(strName);  // if Attribute exists, use it

          if(!iAttr) {
            iAttr = doc.createAttribute(strName);   // otherwise create it
          }

          iAttr.setValue(p.getAttributeValue(i));   // set Attribute value
          iNode.setAttributeNode(iAttr);            // attach Attribute to Element
        }
      }
      else {  // Namespace Aware
        // create element (with empty namespaceURI,
        //  resolve after namespace 'attributes' have been parsed)
        iNode = doc.createElementNS("", p.getName());

        // duplicate ParentNode's Namespace definitions
        iNode._namespaces = iNodeParent._namespaces._cloneNodes(iNode);

        // add attributes to Element
        for(var i = 0; i < p.getAttributeCount(); i++) {
          strName = p.getAttributeName(i);          // get Attribute name

          // if attribute is a namespace declaration
          if (this._isNamespaceDeclaration(strName)) {
            // parse Namespace Declaration
            var namespaceDec = this._parseNSName(strName);

            if (strName != "xmlns") {
              iNS = doc.createNamespace(strName);   // define namespace
            }
            else {
              iNS = doc.createNamespace("");        // redefine default namespace
            }
            iNS.setValue(p.getAttributeValue(i));   // set value = namespaceURI

            iNode._namespaces.setNamedItem(iNS);    // attach namespace to namespace collection
          }
          else {  // otherwise, it is a normal attribute
            iAttr = iNode.getAttributeNode(strName);        // if Attribute exists, use it

            if(!iAttr) {
              iAttr = doc.createAttributeNS("", strName);   // otherwise create it
            }

            iAttr.setValue(p.getAttributeValue(i));         // set Attribute value
            iNode.setAttributeNodeNS(iAttr);                // attach Attribute to Element

            if (this._isIdDeclaration(strName)) {
              iNode.id = p.getAttributeValue(i);    // cache ID for getElementById()
            }
          }
        }

        // resolve namespaceURIs for this Element
        if (iNode._namespaces.getNamedItem(iNode.prefix)) {
          iNode.namespaceURI = iNode._namespaces.getNamedItem(iNode.prefix).value;
        }

        //  for this Element's attributes
        for (var i = 0; i < iNode.attributes.length; i++) {
          if (iNode.attributes.item(i).prefix != "") {  // attributes do not have a default namespace
            if (iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix)) {
              iNode.attributes.item(i).namespaceURI = iNode._namespaces.getNamedItem(iNode.attributes.item(i).prefix).value;
            }
          }
        }
      }

      // if this is the Root Element
      if (iNodeParent.nodeType == DOMNode.DOCUMENT_NODE) {
        iNodeParent.documentElement = iNode;        // register this Element as the Document.documentElement
      }

      iNodeParent.appendChild(iNode);               // attach Element to parentNode
    }
    else if(iEvt == XMLP._TEXT || iEvt == XMLP._ENTITY) {                   // TextNode and entity Events
      // get Text content
      var pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());
      
	  if (!this.preserveWhiteSpace ) {
		if (trim(pContent, true, true) == "") {
			pContent = ""; //this will cause us not to create the text node below
		}
	  }
	  
      if (pContent.length > 0) {                    // ignore empty TextNodes
        var textNode = doc.createTextNode(pContent);
        iNodeParent.appendChild(textNode); // attach TextNode to parentNode

        //the sax parser breaks up text nodes when it finds an entity. For
        //example hello&lt;there will fire a text, an entity and another text
        //this sucks for the dom parser because it looks to us in this logic
        //as three text nodes. I fix this by keeping track of the entity nodes
        //and when we're done parsing, calling normalize on their parent to
        //turn the multiple text nodes into one, which is what DOM users expect
        //the code to do this is at the bottom of this function
        if (iEvt == XMLP._ENTITY) {
            entitiesList[entitiesList.length] = textNode;
        }
		else {
			//I can't properly decide how to handle preserve whitespace
			//until the siblings of the text node are built due to 
			//the entitiy handling described above. I don't know that this
			//will be all of the text node or not, so trimming is not appropriate
			//at this time. Keep a list of all the text nodes for now
			//and we'll process the preserve whitespace stuff at a later time.
			textNodesList[textNodesList.length] = textNode;
		}
      }
    }
    else if(iEvt == XMLP._PI) {                     // ProcessingInstruction Event
      // attach ProcessingInstruction to parentNode
      iNodeParent.appendChild(doc.createProcessingInstruction(p.getName(), p.getContent().substring(p.getContentBegin(), p.getContentEnd())));
    }
    else if(iEvt == XMLP._CDATA) {                  // CDATA Event
      // get CDATA data
      pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());

      if (!this.preserveWhiteSpace) {
        pContent = trim(pContent, true, true);      // trim whitespace
        pContent.replace(/ +/g, ' ');               // collapse multiple spaces to 1 space
      }

      if (pContent.length > 0) {                    // ignore empty CDATANodes
        iNodeParent.appendChild(doc.createCDATASection(pContent)); // attach CDATA to parentNode
      }
    }
    else if(iEvt == XMLP._COMMENT) {                // Comment Event
      // get COMMENT data
      var pContent = p.getContent().substring(p.getContentBegin(), p.getContentEnd());

      if (!this.preserveWhiteSpace) {
        pContent = trim(pContent, true, true);      // trim whitespace
        pContent.replace(/ +/g, ' ');               // collapse multiple spaces to 1 space
      }

      if (pContent.length > 0) {                    // ignore empty CommentNodes
        iNodeParent.appendChild(doc.createComment(pContent));  // attach Comment to parentNode
      }
    }
    else if(iEvt == XMLP._DTD) {                    // ignore DTD events
    }
    else if(iEvt == XMLP._ERROR) {
      throw(new DOMException(DOMException.SYNTAX_ERR));
      // alert("Fatal Error: " + p.getContent() + "\nLine: " + p.getLineNumber() + "\nColumn: " + p.getColumnNumber() + "\n");
      // break;
    }
    else if(iEvt == XMLP._NONE) {                   // no more events
      if (iNodeParent == doc) {                     // confirm that we have recursed back up to root
        break;
      }
      else {
        throw(new DOMException(DOMException.SYNTAX_ERR));  // one or more Tags were not closed properly
      }
    }
  }

  //normalize any entities in the DOM to a single textNode
  var intCount = entitiesList.length;
  for (intLoop = 0; intLoop < intCount; intLoop++) {
      var entity = entitiesList[intLoop];
      //its possible (if for example two entities were in the
      //same domnode, that the normalize on the first entitiy
      //will remove the parent for the second. Only do normalize
      //if I can find a parent node
      var parentNode = entity.getParentNode();
      if (parentNode) {
          parentNode.normalize();
		  
		  //now do whitespace (if necessary)
		  //it was not done for text nodes that have entities
		  if(!this.preserveWhiteSpace) {
		  		var children = parentNode.getChildNodes();
				var intCount2 = children.getLength();
				for ( intLoop2 = 0; intLoop2 < intCount2; intLoop2++) {
					var child = children.item(intLoop2);
					if (child.getNodeType() == DOMNode.TEXT_NODE) {
						var childData = child.getData();
						childData = trim(childData, true, true);
						childData.replace(/ +/g, ' ');
						child.setData(childData);
					}
				}
		  }
      }
  }
  
  //do the preserve whitespace processing on the rest of the text nodes
  //It's possible (due to the processing above) that the node will have been
  //removed from the tree. Only do whitespace checking if parentNode is not null.
  //This may duplicate the whitespace processing for some nodes that had entities in them
  //but there's no way around that
  if (!this.preserveWhiteSpace) {
  	var intCount = textNodesList.length;
	for (intLoop = 0; intLoop < intCount; intLoop++) {
		var node = textNodesList[intLoop];
		if (node.getParentNode() != null) {
			var nodeData = node.getData();
			nodeData = trim(nodeData, true, true);
			nodeData.replace(/ +/g, ' ');
			node.setData(nodeData);
		}
	}
  
  }
};

/**
 * @method DOMImplementation._isNamespaceDeclaration - Return true, if attributeName is a namespace declaration
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  attributeName : string - the attribute name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isNamespaceDeclaration = function DOMImplementation__isNamespaceDeclaration(attributeName) {
  // test if attributeName is 'xmlns'
  return (attributeName.indexOf('xmlns') > -1);
}

/**
 * @method DOMImplementation._isIdDeclaration - Return true, if attributeName is an id declaration
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  attributeName : string - the attribute name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isIdDeclaration = function DOMImplementation__isIdDeclaration(attributeName) {
  // test if attributeName is 'id' (case insensitive)
  return (attributeName.toLowerCase() == 'id');
}

/**
 * @method DOMImplementation._isValidName - Return true,
 *   if name contains no invalid characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - the candidate name
 *
 * @return : boolean
 */
DOMImplementation.prototype._isValidName = function DOMImplementation__isValidName(name) {
  // test if name contains only valid characters
  return name.match(re_validName);
}
re_validName = /^[a-zA-Z_:][a-zA-Z0-9\.\-_:]*$/;

/**
 * @method DOMImplementation._isValidString - Return true, if string does not contain any illegal chars
 *  All of the characters 0 through 31 and character 127 are nonprinting control characters.
 *  With the exception of characters 09, 10, and 13, (Ox09, Ox0A, and Ox0D)
 *  Note: different from _isValidName in that ValidStrings may contain spaces
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - the candidate string
 *
 * @return : boolean
 */
DOMImplementation.prototype._isValidString = function DOMImplementation__isValidString(name) {
  // test that string does not contains invalid characters
  return (name.search(re_invalidStringChars) < 0);
}
re_invalidStringChars = /\x01|\x02|\x03|\x04|\x05|\x06|\x07|\x08|\x0B|\x0C|\x0E|\x0F|\x10|\x11|\x12|\x13|\x14|\x15|\x16|\x17|\x18|\x19|\x1A|\x1B|\x1C|\x1D|\x1E|\x1F|\x7F/

/**
 * @method DOMImplementation._parseNSName - parse the namespace name.
 *  if there is no colon, the
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  qualifiedName : string - The qualified name
 *
 * @return : NSName - [
 *                     .prefix        : string - The prefix part of the qname
 *                     .namespaceName : string - The namespaceURI part of the qname
 *                    ]
 */
DOMImplementation.prototype._parseNSName = function DOMImplementation__parseNSName(qualifiedName) {
  var resultNSName = new Object();

  resultNSName.prefix          = qualifiedName;  // unless the qname has a namespaceName, the prefix is the entire String
  resultNSName.namespaceName   = "";

  // split on ':'
  delimPos = qualifiedName.indexOf(':');

  if (delimPos > -1) {
    // get prefix
    resultNSName.prefix        = qualifiedName.substring(0, delimPos);

    // get namespaceName
    resultNSName.namespaceName = qualifiedName.substring(delimPos +1, qualifiedName.length);
  }

  return resultNSName;
}

/**
 * @method DOMImplementation._parseQName - parse the qualified name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  qualifiedName : string - The qualified name
 *
 * @return : QName
 */
DOMImplementation.prototype._parseQName = function DOMImplementation__parseQName(qualifiedName) {
  var resultQName = new Object();

  resultQName.localName = qualifiedName;  // unless the qname has a prefix, the local name is the entire String
  resultQName.prefix    = "";

  // split on ':'
  delimPos = qualifiedName.indexOf(':');

  if (delimPos > -1) {
    // get prefix
    resultQName.prefix    = qualifiedName.substring(0, delimPos);

    // get localName
    resultQName.localName = qualifiedName.substring(delimPos +1, qualifiedName.length);
  }

  return resultQName;
}
