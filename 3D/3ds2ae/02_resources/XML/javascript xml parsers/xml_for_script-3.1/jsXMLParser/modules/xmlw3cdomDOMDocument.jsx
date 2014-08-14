/**
 * @class  DOMDocument - The Document interface represents the entire HTML or XML document.
 *   Conceptually, it is the root of the document tree, and provides the primary access to the document's data.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  implementation : DOMImplementation - the creator Implementation
 */
DOMDocument = function(implementation) {
  this._class = addClass(this._class, "DOMDocument");
  this.DOMNode = DOMNode;
  this.DOMNode(this);

  this.doctype = null;                           // The Document Type Declaration (see DocumentType) associated with this document
  this.implementation = implementation;          // The DOMImplementation object that handles this document.
  this.documentElement = null;                   // This is a convenience attribute that allows direct access to the child node that is the root element of the document
  this.all  = new Array();                       // The list of all Elements

  this.nodeName  = "#document";
  this.nodeType = DOMNode.DOCUMENT_NODE;
  this._id = 0;
  this._lastId = 0;
  this._parseComplete = false;                   // initially false, set to true by parser

  this.ownerDocument = this;

  this._performingImportNodeOperation = false;
};
DOMDocument.prototype = new DOMNode;

/**
 * @method DOMDocument.getDoctype - Java style gettor for .doctype
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocument
 */
DOMDocument.prototype.getDoctype = function DOMDocument_getDoctype() {
  return this.doctype;
};

/**
 * @method DOMDocument.getImplementation - Java style gettor for .implementation
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMImplementation
 */
DOMDocument.prototype.getImplementation = function DOMDocument_implementation() {
  return this.implementation;
};

/**
 * @method DOMDocument.getDocumentElement - Java style gettor for .documentElement
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocumentElement
 */
DOMDocument.prototype.getDocumentElement = function DOMDocument_getDocumentElement() {
  return this.documentElement;
};

/**
 * @method DOMDocument.createElement - Creates an element of the type specified.
 *   Note that the instance returned implements the Element interface,
 *   so attributes can be specified directly on the returned object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  tagName : string - The name of the element type to instantiate.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMElement - The new Element object.
 */
DOMDocument.prototype.createElement = function DOMDocument_createElement(tagName) {
  // throw Exception if the tagName string contains an illegal character
  if (this.ownerDocument.implementation.errorChecking && (!this.ownerDocument.implementation._isValidName(tagName))) {
    throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
  }

  // create DOMElement specifying 'this' as ownerDocument
  var node = new DOMElement(this);

  // assign values to properties (and aliases)
  node.tagName  = tagName;
  node.nodeName = tagName;

  // add Element to 'all' collection
  this.all[this.all.length] = node;

  return node;
};

/**
 * @method DOMDocument.createDocumentFragment - CCreates an empty DocumentFragment object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocumentFragment - The new DocumentFragment object
 */
DOMDocument.prototype.createDocumentFragment = function DOMDocument_createDocumentFragment() {
  // create DOMDocumentFragment specifying 'this' as ownerDocument
  var node = new DOMDocumentFragment(this);

  return node;
};

/**
 * @method DOMDocument.createTextNode - Creates a Text node given the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - The data for the node.
 *
 * @return : DOMText - The new Text object.
 */
DOMDocument.prototype.createTextNode = function DOMDocument_createTextNode(data) {
  // create DOMText specifying 'this' as ownerDocument
  var node = new DOMText(this);

  // assign values to properties (and aliases)
  node.data      = data;
  node.nodeValue = data;

  // set initial length
  node.length    = data.length;

  return node;
};

/**
 * @method DOMDocument.createComment - Creates a Text node given the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - The data for the node.
 *
 * @return : DOMComment - The new Comment object.
 */
DOMDocument.prototype.createComment = function DOMDocument_createComment(data) {
  // create DOMComment specifying 'this' as ownerDocument
  var node = new DOMComment(this);

  // assign values to properties (and aliases)
  node.data      = data;
  node.nodeValue = data;

  // set initial length
  node.length    = data.length;

  return node;
};

/**
 * @method DOMDocument.createCDATASection - Creates a CDATASection node whose value is the specified string.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - The data for the node.
 *
 * @return : DOMCDATASection - The new CDATASection object.
 */
DOMDocument.prototype.createCDATASection = function DOMDocument_createCDATASection(data) {
  // create DOMCDATASection specifying 'this' as ownerDocument
  var node = new DOMCDATASection(this);

  // assign values to properties (and aliases)
  node.data      = data;
  node.nodeValue = data;

  // set initial length
  node.length    = data.length;

  return node;
};

/**
 * @method DOMDocument.createProcessingInstruction - Creates a ProcessingInstruction node given the specified target and data strings.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  target : string - The target part of the processing instruction.
 * @param  data   : string - The data for the node.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMProcessingInstruction - The new ProcessingInstruction object.
 */
DOMDocument.prototype.createProcessingInstruction = function DOMDocument_createProcessingInstruction(target, data) {
  // throw Exception if the target string contains an illegal character
  if (this.ownerDocument.implementation.errorChecking && (!this.implementation._isValidName(target))) {
    throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
  }

  // create DOMProcessingInstruction specifying 'this' as ownerDocument
  var node = new DOMProcessingInstruction(this);

  // assign values to properties (and aliases)
  node.target    = target;
  node.nodeName  = target;
  node.data      = data;
  node.nodeValue = data;

  // set initial length
  node.length    = data.length;

  return node;
};

/**
 * @method DOMDocument.createAttribute - Creates an Attr of the given name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - The name of the attribute.
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMAttr - The new Attr object.
 */
DOMDocument.prototype.createAttribute = function DOMDocument_createAttribute(name) {
  // throw Exception if the name string contains an illegal character
  if (this.ownerDocument.implementation.errorChecking && (!this.ownerDocument.implementation._isValidName(name))) {
    throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
  }

  // create DOMAttr specifying 'this' as ownerDocument
  var node = new DOMAttr(this);

  // assign values to properties (and aliases)
  node.name     = name;
  node.nodeName = name;

  return node;
};

/**
 * @method DOMDocument.createElementNS - Creates an element of the type specified,
 *   within the specified namespace.
 *   Note that the instance returned implements the Element interface,
 *   so attributes can be specified directly on the returned object.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI  : string - The namespace URI of the element.
 * @param  qualifiedName : string - The qualified name of the element type to instantiate.
 *
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMElement - The new Element object.
 */
DOMDocument.prototype.createElementNS = function DOMDocument_createElementNS(namespaceURI, qualifiedName) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if the Namespace is invalid
    if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName)) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }

    // throw Exception if the qualifiedName string contains an illegal character
    if (!this.ownerDocument.implementation._isValidName(qualifiedName)) {
      throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
    }
  }

  // create DOMElement specifying 'this' as ownerDocument
  var node  = new DOMElement(this);
  var qname = this.implementation._parseQName(qualifiedName);

  // assign values to properties (and aliases)
  node.nodeName     = qualifiedName;
  node.namespaceURI = namespaceURI;
  node.prefix       = qname.prefix;
  node.localName    = qname.localName;
  node.tagName      = qualifiedName;

  // add Element to 'all' collection
  this.all[this.all.length] = node;

  return node;
};

/**
 * @method DOMDocument.createAttributeNS - Creates an Attr of the given name
 *   within the specified namespace.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI  : string - The namespace URI of the attribute.
 * @param  qualifiedName : string - The qualified name of the attribute.
 *
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 *
 * @return : DOMAttr - The new Attr object.
 */
DOMDocument.prototype.createAttributeNS = function DOMDocument_createAttributeNS(namespaceURI, qualifiedName) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if the Namespace is invalid
    if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName, true)) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }

    // throw Exception if the qualifiedName string contains an illegal character
    if (!this.ownerDocument.implementation._isValidName(qualifiedName)) {
      throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
    }
  }

  // create DOMAttr specifying 'this' as ownerDocument
  var node  = new DOMAttr(this);
  var qname = this.implementation._parseQName(qualifiedName);

  // assign values to properties (and aliases)
  node.nodeName     = qualifiedName
  node.namespaceURI = namespaceURI
  node.prefix       = qname.prefix;
  node.localName    = qname.localName;
  node.name         = qualifiedName
  node.nodeValue    = "";

  return node;
};

/**
 * @method DOMDocument.createNamespace - Creates an Namespace of the given name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  qualifiedName : string - The qualified name of the attribute.
 *
 * @return : DOMNamespace - The new Namespace object.
 */
DOMDocument.prototype.createNamespace = function DOMDocument_createNamespace(qualifiedName) {
  // create DOMNamespace specifying 'this' as ownerDocument
  var node  = new DOMNamespace(this);
  var qname = this.implementation._parseQName(qualifiedName);

  // assign values to properties (and aliases)
  node.nodeName     = qualifiedName
  node.prefix       = qname.prefix;
  node.localName    = qname.localName;
  node.name         = qualifiedName
  node.nodeValue    = "";

  return node;
};

/**
 * @method DOMDocument.getElementById - Return the Element whose ID is given by elementId
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  elementId : string - The unique ID of the Element
 *
 * @return : DOMElement - The requested DOMElement
 */
DOMDocument.prototype.getElementById = function DOMDocument_getElementById(elementId) {
//  return this._ids[elementId];
  retNode = null;

  // loop through all Elements in the 'all' collection
  for (var i=0; i < this.all.length; i++) {
    var node = this.all[i];

    // if id matches & node is alive (ie, connected (in)directly to the documentElement)
    if ((node.id == elementId) && (node._isAncestor(node.ownerDocument.documentElement))) {
      retNode = node;
      break;
    }
  }

  return retNode;
};



/**
 * @method DOMDocument._genId - generate a unique internal id
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string - The unique (serial) id
 */
DOMDocument.prototype._genId = function DOMDocument__genId() {
  this._lastId += 1;                             // increment lastId (to generate unique id)

  return this._lastId;
};


/**
 * @method DOMDocument._isValidNamespace - test if Namespace is valid
 *  ie, not valid if;
 *    the qualifiedName is malformed, or
 *    the qualifiedName has a prefix and the namespaceURI is null, or
 *    the qualifiedName has a prefix that is "xml" and the namespaceURI is
 *     different from "http://www.w3.org/XML/1998/namespace" [Namespaces].
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  namespaceURI  : string - the namespace URI
 * @param  qualifiedName : string - the QName
 * @Param  isAttribute   : boolean - true, if the requesting node is an Attr
 *
 * @return : boolean
 */
DOMDocument.prototype._isValidNamespace = function DOMDocument__isValidNamespace(namespaceURI, qualifiedName, isAttribute) {

  if (this._performingImportNodeOperation == true) {
    //we're doing an importNode operation (or a cloneNode) - in both cases, there
    //is no need to perform any namespace checking since the nodes have to have been valid
    //to have gotten into the DOM in the first place
    return true;
  }

  var valid = true;
  // parse QName
  var qName = this.implementation._parseQName(qualifiedName);


  //only check for namespaces if we're finished parsing
  if (this._parseComplete == true) {

    // if the qualifiedName is malformed
    if (qName.localName.indexOf(":") > -1 ){
        valid = false;
    }

    if ((valid) && (!isAttribute)) {
        // if the namespaceURI is not null
        if (!namespaceURI) {
        valid = false;
        }
    }

    // if the qualifiedName has a prefix
    if ((valid) && (qName.prefix == "")) {
        valid = false;
    }

  }

  // if the qualifiedName has a prefix that is "xml" and the namespaceURI is
  //  different from "http://www.w3.org/XML/1998/namespace" [Namespaces].
  if ((valid) && (qName.prefix == "xml") && (namespaceURI != "http://www.w3.org/XML/1998/namespace")) {
    valid = false;
  }

  return valid;
}

/**
 * @method DOMDocument.toString - Serialize the document into an XML string
 *
 * @author David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMDocument.prototype.toString = function DOMDocument_toString() {
  return "" + this.childNodes;
} // end function getXML


/**
 * @class  DOMElement - By far the vast majority of objects (apart from text) that authors encounter
 *   when traversing a document are Element nodes.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMElement = function(ownerDocument) {
  this._class = addClass(this._class, "DOMElement");
  this.DOMNode  = DOMNode;
  this.DOMNode(ownerDocument);

  this.tagName = "";                             // The name of the element.
  this.id = "";                                  // the ID of the element

  this.nodeType = DOMNode.ELEMENT_NODE;
};
DOMElement.prototype = new DOMNode;

/**
 * @method DOMElement.getTagName - Java style gettor for .TagName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMElement.prototype.getTagName = function DOMElement_getTagName() {
  return this.tagName;
};

/**
 * @method DOMElement.getAttribute - Retrieves an attribute value by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - The name of the attribute to retrieve
 *
 * @return : string - The Attr value as a string, or the empty string if that attribute does not have a specified value.
 */
DOMElement.prototype.getAttribute = function DOMElement_getAttribute(name) {
  var ret = "";

  // if attribute exists, use it
  var attr = this.attributes.getNamedItem(name);

  if (attr) {
    ret = attr.value;
  }

  return ret; // if Attribute exists, return its value, otherwise, return ""
};

/**
 * @method DOMElement.setAttribute - Retrieves an attribute value by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name  : string - The name of the attribute to create or alter
 * @param  value : string - Value to set in string form
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attribute is readonly.
 */
DOMElement.prototype.setAttribute = function DOMElement_setAttribute(name, value) {
  // if attribute exists, use it
  var attr = this.attributes.getNamedItem(name);

  if (!attr) {
    attr = this.ownerDocument.createAttribute(name);  // otherwise create it
  }

  var value = new String(value);

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if Attribute is readonly
    if (attr._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if the value string contains an illegal character
    if (!this.ownerDocument.implementation._isValidString(value)) {
      throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
    }
  }

  if (this.ownerDocument.implementation._isIdDeclaration(name)) {
    this.id = value;  // cache ID for getElementById()
  }

  // assign values to properties (and aliases)
  attr.value     = value;
  attr.nodeValue = value;

  // update .specified
  if (value.length > 0) {
    attr.specified = true;
  }
  else {
    attr.specified = false;
  }

  // add/replace Attribute in NamedNodeMap
  this.attributes.setNamedItem(attr);
};

/**
 * @method DOMElement.removeAttribute - Removes an attribute by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name  : string - The name of the attribute to remove
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 */
DOMElement.prototype.removeAttribute = function DOMElement_removeAttribute(name) {
  // delegate to DOMNamedNodeMap.removeNamedItem
  return this.attributes.removeNamedItem(name);
};

/**
 * @method DOMElement.getAttributeNode - Retrieves an Attr node by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name  : string - The name of the attribute to remove
 *
 * @return : DOMAttr - The Attr node with the specified attribute name or null if there is no such attribute.
 */
DOMElement.prototype.getAttributeNode = function DOMElement_getAttributeNode(name) {
  // delegate to DOMNamedNodeMap.getNamedItem
  return this.attributes.getNamedItem(name);
};

/**
 * @method DOMElement.setAttributeNode - Adds a new attribute
 *   If an attribute with that name is already present in the element, it is replaced by the new one
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newAttr : DOMAttr - The attribute node to be attached
 *
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Element is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *
 * @return : DOMAttr - If the newAttr attribute replaces an existing attribute with the same name,
 *   the previously existing Attr node is returned, otherwise null is returned.
 */
DOMElement.prototype.setAttributeNode = function DOMElement_setAttributeNode(newAttr) {
  // if this Attribute is an ID
  if (this.ownerDocument.implementation._isIdDeclaration(newAttr.name)) {
    this.id = newAttr.value;  // cache ID for getElementById()
  }

  // delegate to DOMNamedNodeMap.setNamedItem
  return this.attributes.setNamedItem(newAttr);
};

/**
 * @method DOMElement.removeAttributeNode - Removes the specified attribute
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  oldAttr  : DOMAttr - The Attr node to remove from the attribute list
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Element is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *
 * @return : DOMAttr - The Attr node that was removed.
 */
DOMElement.prototype.removeAttributeNode = function DOMElement_removeAttributeNode(oldAttr) {
  // throw Exception if Attribute is readonly
  if (this.ownerDocument.implementation.errorChecking && oldAttr._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // get item index
  var itemIndex = this.attributes._findItemIndex(oldAttr._id);

  // throw Exception if node does not exist in this map
  if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
    throw(new DOMException(DOMException.NOT_FOUND_ERR));
  }

  return this.attributes._removeChild(itemIndex);
};

/**
 * @method DOMElement.getAttributeNS - Retrieves an attribute value by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : string - The Attr value as a string, or the empty string if that attribute does not have a specified value.
 */
DOMElement.prototype.getAttributeNS = function DOMElement_getAttributeNS(namespaceURI, localName) {
  var ret = "";

  // delegate to DOMNAmedNodeMap.getNamedItemNS
  var attr = this.attributes.getNamedItemNS(namespaceURI, localName);


  if (attr) {
    ret = attr.value;
  }

  return ret;  // if Attribute exists, return its value, otherwise return ""
};

/**
 * @method DOMElement.setAttributeNS - Sets an attribute value by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  qualifiedName : string - the qualified name of the required node
 * @param  value        : string - Value to set in string form
 *
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 */
DOMElement.prototype.setAttributeNS = function DOMElement_setAttributeNS(namespaceURI, qualifiedName, value) {
  // call DOMNamedNodeMap.getNamedItem
  var attr = this.attributes.getNamedItem(namespaceURI, qualifiedName);

  if (!attr) {  // if Attribute exists, use it
    // otherwise create it
    attr = this.ownerDocument.createAttributeNS(namespaceURI, qualifiedName);
  }

  var value = new String(value);

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if Attribute is readonly
    if (attr._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if the Namespace is invalid
    if (!this.ownerDocument._isValidNamespace(namespaceURI, qualifiedName)) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }

    // throw Exception if the value string contains an illegal character
    if (!this.ownerDocument.implementation._isValidString(value)) {
      throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
    }
  }

  // if this Attribute is an ID
  if (this.ownerDocument.implementation._isIdDeclaration(name)) {
    this.id = value;  // cache ID for getElementById()
  }

  // assign values to properties (and aliases)
  attr.value     = value;
  attr.nodeValue = value;

  // update .specified
  if (value.length > 0) {
    attr.specified = true;
  }
  else {
    attr.specified = false;
  }

  // delegate to DOMNamedNodeMap.setNamedItem
  this.attributes.setNamedItemNS(attr);
};

/**
 * @method DOMElement.removeAttributeNS - Removes an attribute by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 *
 * @return : DOMAttr
 */
DOMElement.prototype.removeAttributeNS = function DOMElement_removeAttributeNS(namespaceURI, localName) {
  // delegate to DOMNamedNodeMap.removeNamedItemNS
  return this.attributes.removeNamedItemNS(namespaceURI, localName);
};

/**
 * @method DOMElement.getAttributeNodeNS - Retrieves an Attr node by namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : DOMAttr - The Attr node with the specified attribute name or null if there is no such attribute.
 */
DOMElement.prototype.getAttributeNodeNS = function DOMElement_getAttributeNodeNS(namespaceURI, localName) {
  // delegate to DOMNamedNodeMap.getNamedItemNS
  return this.attributes.getNamedItemNS(namespaceURI, localName);
};

/**
 * @method DOMElement.setAttributeNodeNS - Adds a new attribute
 *   If an attribute with that name is already present in the element, it is replaced by the new one
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newAttr      : DOMAttr - the attribute node to be attached
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if the Attrbute is readonly.
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *  The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMAttr - If the newAttr attribute replaces an existing attribute with the same name,
 *   the previously existing Attr node is returned, otherwise null is returned.
 */
DOMElement.prototype.setAttributeNodeNS = function DOMElement_setAttributeNodeNS(newAttr) {
  // if this Attribute is an ID
  if ((newAttr.prefix == "") &&  this.ownerDocument.implementation._isIdDeclaration(newAttr.name)) {
    this.id = newAttr.value;  // cache ID for getElementById()
  }

  // delegate to DOMNamedNodeMap.setNamedItemNS
  return this.attributes.setNamedItemNS(newAttr);
};

/**
 * @method DOMElement.hasAttribute - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - the name of the required node
 *
 * @return : boolean
 */
DOMElement.prototype.hasAttribute = function DOMElement_hasAttribute(name) {
  // delegate to DOMNamedNodeMap._hasAttribute
  return this.attributes._hasAttribute(name);
}

/**
 * @method DOMElement.hasAttributeNS - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : boolean
 */
DOMElement.prototype.hasAttributeNS = function DOMElement_hasAttributeNS(namespaceURI, localName) {
  // delegate to DOMNamedNodeMap._hasAttributeNS
  return this.attributes._hasAttributeNS(namespaceURI, localName);
}

/**
 * @method DOMElement.toString - Serialize this Element and its children into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMElement.prototype.toString = function DOMElement_toString() {
  var ret = "";

  // serialize namespace declarations
  var ns = this._namespaces.toString();
  if (ns.length > 0) ns = " "+ ns;

  // serialize Attribute declarations
  var attrs = this.attributes.toString();
  if (attrs.length > 0) attrs = " "+ attrs;

  // serialize this Element
  ret += "<" + this.nodeName + ns + attrs +">";
  ret += this.childNodes.toString();;
  ret += "</" + this.nodeName+">";

  return ret;
}

/**
 * @class  DOMAttr - The Attr interface represents an attribute in an Element object
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMAttr = function(ownerDocument) {
  this._class = addClass(this._class, "DOMAttr");
  this.DOMNode = DOMNode;
  this.DOMNode(ownerDocument);

  this.name      = "";                           // the name of this attribute

  // If this attribute was explicitly given a value in the original document, this is true; otherwise, it is false.
  // Note that the implementation is in charge of this attribute, not the user.
  // If the user changes the value of the attribute (even if it ends up having the same value as the default value)
  // then the specified flag is automatically flipped to true
  // (I wish! You will need to use setValue to 'automatically' update specified)
  this.specified = false;

  this.value     = "";                           // the value of the attribute is returned as a string

  this.nodeType  = DOMNode.ATTRIBUTE_NODE;

  this.ownerElement = null;                      // set when Attr is added to NamedNodeMap

  // disable childNodes
  this.childNodes = null;
  this.attributes = null;
};
DOMAttr.prototype = new DOMNode;

/**
 * @method DOMAttr.getName - Java style gettor for .name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMAttr.prototype.getName = function DOMAttr_getName() {
  return this.nodeName;
};

/**
 * @method DOMAttr.getSpecified - Java style gettor for .specified
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : boolean
 */
DOMAttr.prototype.getSpecified = function DOMAttr_getSpecified() {
  return this.specified;
};

/**
 * @method DOMAttr.getValue - Java style gettor for .value
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMAttr.prototype.getValue = function DOMAttr_getValue() {
  return this.nodeValue;
};

/**
 * @method DOMAttr.setValue - Java style settor for .value
 *   alias for DOMAttr.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  value : string - the new attribute value
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMAttr.prototype.setValue = function DOMAttr_setValue(value) {
  // throw Exception if Attribute is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // delegate to setNodeValue
  this.setNodeValue(value);
};

/**
 * @method DOMAttr.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  value : string - the new attribute value
 */
DOMAttr.prototype.setNodeValue = function DOMAttr_setNodeValue(value) {
  this.nodeValue = new String(value);
  this.value     = this.nodeValue;
  this.specified = (this.value.length > 0);
};

/**
 * @method DOMAttr.toString - Serialize this Attr into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMAttr.prototype.toString = function DOMAttr_toString() {
  var ret = "";

  // serialize Attribute
  ret += this.nodeName +"=\""+ this.__escapeString(this.nodeValue) +"\"";

  return ret;
}

DOMAttr.prototype.getOwnerElement = function() {

    return this.ownerElement;

}

/**
 * @class  DOMNamespace - The Namespace interface represents an namespace in an Element object
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMNamespace = function(ownerDocument) {
  this._class = addClass(this._class, "DOMNamespace");
  this.DOMNode = DOMNode;
  this.DOMNode(ownerDocument);

  this.name      = "";                           // the name of this attribute

  // If this attribute was explicitly given a value in the original document, this is true; otherwise, it is false.
  // Note that the implementation is in charge of this attribute, not the user.
  // If the user changes the value of the attribute (even if it ends up having the same value as the default value)
  // then the specified flag is automatically flipped to true
  // (I wish! You will need to use _setValue to 'automatically' update specified)
  this.specified = false;

  this.value     = "";                           // the value of the attribute is returned as a string

  this.nodeType  = DOMNode.NAMESPACE_NODE;
};
DOMNamespace.prototype = new DOMNode;

/**
 * @method DOMNamespace.getValue - Java style gettor for .value
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNamespace.prototype.getValue = function DOMNamespace_getValue() {
  return this.nodeValue;
};

/**
 * @method DOMNamespace.setValue - utility function to set value (rather than direct assignment to .value)
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  value : string - the new namespace value
 */
DOMNamespace.prototype.setValue = function DOMNamespace_setValue(value) {
  // assign values to properties (and aliases)
  this.nodeValue = new String(value);
  this.value     = this.nodeValue;
};

/**
 * @method DOMNamespace.toString - Serialize this Attr into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNamespace.prototype.toString = function DOMNamespace_toString() {
  var ret = "";

  // serialize Namespace Declaration
  if (this.nodeName != "") {
    ret += this.nodeName +"=\""+ this.__escapeString(this.nodeValue) +"\"";
  }
  else {  // handle default namespace
    ret += "xmlns=\""+ this.__escapeString(this.nodeValue) +"\"";
  }

  return ret;
}

/**
 * @class  DOMCharacterData - parent abstract class for DOMText and DOMComment
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMCharacterData = function(ownerDocument) {
  this._class = addClass(this._class, "DOMCharacterData");
  this.DOMNode  = DOMNode;
  this.DOMNode(ownerDocument);

  this.data   = "";
  this.length = 0;
};
DOMCharacterData.prototype = new DOMNode;

/**
 * @method DOMCharacterData.getData - Java style gettor for .data
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMCharacterData.prototype.getData = function DOMCharacterData_getData() {
  return this.nodeValue;
};

/**
 * @method DOMCharacterData.setData - Java style settor for .data
 *  alias for DOMCharacterData.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - the character data
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMCharacterData.prototype.setData = function DOMCharacterData_setData(data) {
  // delegate to setNodeValue
  this.setNodeValue(data);
};

/**
 * @method DOMCharacterData.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - the node value
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Attribute is readonly.
 */
DOMCharacterData.prototype.setNodeValue = function DOMCharacterData_setNodeValue(data) {
  // throw Exception if Attribute is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // assign values to properties (and aliases)
  this.nodeValue = new String(data);
  this.data   = this.nodeValue;

  // update length
  this.length = this.nodeValue.length;
};

/**
 * @method DOMCharacterData.getLength - Java style gettor for .length
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMCharacterData.prototype.getLength = function DOMCharacterData_getLength() {
  return this.nodeValue.length;
};

/**
 * @method DOMCharacterData.substringData - Extracts a range of data from the node
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int - Start offset of substring to extract
 * @param  count  : int - The number of characters to extract
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *
 * @return : string - The specified substring.
 *   If the sum of offset and count exceeds the length, then all characters to the end of the data are returned.
 */
DOMCharacterData.prototype.substringData = function DOMCharacterData_substringData(offset, count) {
  var ret = null;

  if (this.data) {
    // throw Exception if offset is negative or greater than the data length,
    // or the count is negative
    if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset > this.data.length) || (count < 0))) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }

    // if count is not specified
    if (!count) {
      ret = this.data.substring(offset); // default to 'end of string'
    }
    else {
      ret = this.data.substring(offset, offset + count);
    }
  }

  return ret;
};

/**
 * @method DOMCharacterData.appendData - Append the string to the end of the character data of the node.
 *   Upon success, data provides access to the concatenation of data and the DOMString specified.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  arg : string - The string to append
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.appendData    = function DOMCharacterData_appendData(arg) {
  // throw Exception if DOMCharacterData is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // append data
  this.setData(""+ this.data + arg);
};

/**
 * @method DOMCharacterData.insertData - Insert a string at the specified character offset.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int    - The character offset at which to insert
 * @param  arg    : string - The string to insert
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *   or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.insertData    = function DOMCharacterData_insertData(offset, arg) {
  // throw Exception if DOMCharacterData is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  if (this.data) {
    // throw Exception if offset is negative or greater than the data length,
    if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >  this.data.length))) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }

    // insert data
    this.setData(this.data.substring(0, offset).concat(arg, this.data.substring(offset)));
  }
  else {
    // throw Exception if offset is negative or greater than the data length,
    if (this.ownerDocument.implementation.errorChecking && (offset != 0)) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }

    // set data
    this.setData(arg);
  }
};

/**
 * @method DOMCharacterData.deleteData - Remove a range of characters from the node.
 *   Upon success, data and length reflect the change
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int - The offset from which to remove characters
 * @param  count  : int - The number of characters to delete.
 *   If the sum of offset and count exceeds length then all characters from offset to the end of the data are deleted
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *   or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.deleteData    = function DOMCharacterData_deleteData(offset, count) {
  // throw Exception if DOMCharacterData is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  if (this.data) {
    // throw Exception if offset is negative or greater than the data length,
    if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >  this.data.length) || (count < 0))) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }

    // delete data
    if(!count || (offset + count) > this.data.length) {
      this.setData(this.data.substring(0, offset));
    }
    else {
      this.setData(this.data.substring(0, offset).concat(this.data.substring(offset + count)));
    }
  }
};

/**
 * @method DOMCharacterData.replaceData - Replace the characters starting at the specified character offset with the specified string
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int    - The offset from which to start replacing
 * @param  count  : int    - The number of characters to replace.
 *   If the sum of offset and count exceeds length, then all characters to the end of the data are replaced
 * @param  arg    : string - The string with which the range must be replaced
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 *   or if the specified count is negative.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this CharacterData is readonly.
 */
DOMCharacterData.prototype.replaceData   = function DOMCharacterData_replaceData(offset, count, arg) {
  // throw Exception if DOMCharacterData is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  if (this.data) {
    // throw Exception if offset is negative or greater than the data length,
    if (this.ownerDocument.implementation.errorChecking && ((offset < 0) || (offset >  this.data.length) || (count < 0))) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }

    // replace data
    this.setData(this.data.substring(0, offset).concat(arg, this.data.substring(offset + count)));
  }
  else {
    // set data
    this.setData(arg);
  }
};

/**
 * @class  DOMText - The Text interface represents the textual content (termed character data in XML) of an Element or Attr.
 *   If there is no markup inside an element's content, the text is contained in a single object implementing the Text interface
 *   that is the only child of the element. If there is markup, it is parsed into a list of elements and Text nodes that form the
 *   list of children of the element.
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMText = function(ownerDocument) {
  this._class = addClass(this._class, "DOMText");
  this.DOMCharacterData  = DOMCharacterData;
  this.DOMCharacterData(ownerDocument);

  this.nodeName  = "#text";
  this.nodeType  = DOMNode.TEXT_NODE;
};
DOMText.prototype = new DOMCharacterData;

/**
 * @method DOMText.splitText - Breaks this Text node into two Text nodes at the specified offset,
 *   keeping both in the tree as siblings. This node then only contains all the content up to the offset point.
 *   And a new Text node, which is inserted as the next sibling of this node, contains all the content at and after the offset point.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int - The offset at which to split, starting from 0.
 *
 * @throws : DOMException - INDEX_SIZE_ERR: Raised if specified offset is negative or greater than the number of 16-bit units in data,
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Text is readonly.
 *
 * @return : DOMText - The new Text node
 */
DOMText.prototype.splitText = function DOMText_splitText(offset) {
  var data, inode;

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if Node is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if offset is negative or greater than the data length,
    if ((offset < 0) || (offset > this.data.length)) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }
  }

  if (this.parentNode) {
    // get remaining string (after offset)
    data  = this.substringData(offset);

    // create new TextNode with remaining string
    inode = this.ownerDocument.createTextNode(data);

    // attach new TextNode
    if (this.nextSibling) {
      this.parentNode.insertBefore(inode, this.nextSibling);
    }
    else {
      this.parentNode.appendChild(inode);
    }

    // remove remaining string from original TextNode
    this.deleteData(offset);
  }

  return inode;
};

/**
 * @method DOMText.toString - Serialize this Text into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMText.prototype.toString = function DOMText_toString() {
  return this.__escapeString(""+ this.nodeValue);
}

/**
 * @class  DOMCDATASection - CDATA sections are used to escape blocks of text containing characters that would otherwise be regarded as markup.
 *   The only delimiter that is recognized in a CDATA section is the "\]\]\>" string that ends the CDATA section
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMCDATASection = function(ownerDocument) {
  this._class = addClass(this._class, "DOMCDATASection");
  this.DOMCharacterData  = DOMCharacterData;
  this.DOMCharacterData(ownerDocument);

  this.nodeName  = "#cdata-section";
  this.nodeType  = DOMNode.CDATA_SECTION_NODE;
};
DOMCDATASection.prototype = new DOMCharacterData;

/**
 * @method DOMCDATASection.splitText - Breaks this CDATASection node into two CDATASection nodes at the specified offset,
 *   keeping both in the tree as siblings. This node then only contains all the content up to the offset point.
 *   And a new CDATASection node, which is inserted as the next sibling of this node, contains all the content at and after the offset point.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  offset : int - The offset at which to split, starting from 0.
 *
 * @return : DOMCDATASection - The new CDATASection node
 */
DOMCDATASection.prototype.splitText = function DOMCDATASection_splitText(offset) {
  var data, inode;

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if Node is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if offset is negative or greater than the data length,
    if ((offset < 0) || (offset > this.data.length)) {
      throw(new DOMException(DOMException.INDEX_SIZE_ERR));
    }
  }

  if(this.parentNode) {
    // get remaining string (after offset)
    data  = this.substringData(offset);

    // create new CDATANode with remaining string
    inode = this.ownerDocument.createCDATASection(data);

    // attach new CDATANode
    if (this.nextSibling) {
      this.parentNode.insertBefore(inode, this.nextSibling);
    }
    else {
      this.parentNode.appendChild(inode);
    }

     // remove remaining string from original CDATANode
    this.deleteData(offset);
  }

  return inode;
};

/**
 * @method DOMCDATASection.toString - Serialize this CDATASection into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMCDATASection.prototype.toString = function DOMCDATASection_toString() {
  var ret = "";
  //do NOT unescape the nodeValue string in CDATA sections!
  ret += "<![CDATA[" + this.nodeValue + "\]\]\>";

  return ret;
}

/**
 * @class  DOMComment - This represents the content of a comment, i.e., all the characters between the starting '<!--' and ending '-->'
 *
 * @extends DOMCharacterData
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMComment = function(ownerDocument) {
  this._class = addClass(this._class, "DOMComment");
  this.DOMCharacterData  = DOMCharacterData;
  this.DOMCharacterData(ownerDocument);

  this.nodeName  = "#comment";
  this.nodeType  = DOMNode.COMMENT_NODE;
};
DOMComment.prototype = new DOMCharacterData;

/**
 * @method DOMComment.toString - Serialize this Comment into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMComment.prototype.toString = function DOMComment_toString() {
  var ret = "";

  ret += "<!--" + this.nodeValue + "-->";

  return ret;
}

/**
 * @class  DOMProcessingInstruction - The ProcessingInstruction interface represents a "processing instruction",
 *   used in XML as a way to keep processor-specific information in the text of the document
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMProcessingInstruction = function(ownerDocument) {
  this._class = addClass(this._class, "DOMProcessingInstruction");
  this.DOMNode  = DOMNode;
  this.DOMNode(ownerDocument);

  // The target of this processing instruction.
  // XML defines this as being the first token following the markup that begins the processing instruction.
  this.target = "";

  // The content of this processing instruction.
  // This is from the first non white space character after the target to the character immediately preceding the ?>
  this.data   = "";

  this.nodeType  = DOMNode.PROCESSING_INSTRUCTION_NODE;
};
DOMProcessingInstruction.prototype = new DOMNode;

/**
 * @method DOMProcessingInstruction.getTarget - Java style gettor for .target
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.getTarget = function DOMProcessingInstruction_getTarget() {
  return this.nodeName;
};

/**
 * @method DOMProcessingInstruction.getData - Java style gettor for .data
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.getData = function DOMProcessingInstruction_getData() {
  return this.nodeValue;
};

/**
 * @method DOMProcessingInstruction.setData - Java style settor for .data
 *   alias for DOMProcessingInstruction.setNodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - The new data of this processing instruction.
 */
DOMProcessingInstruction.prototype.setData = function DOMProcessingInstruction_setData(data) {
  // delegate to setNodeValue
  this.setNodeValue(data);
};

/**
 * @method DOMProcessingInstruction.setNodeValue - Java style settor for .nodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  data : string - The new data of this processing instruction.
 */
DOMProcessingInstruction.prototype.setNodeValue = function DOMProcessingInstruction_setNodeValue(data) {
  // throw Exception if DOMNode is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // assign values to properties (and aliases)
  this.nodeValue = new String(data);
  this.data = this.nodeValue;
};

/**
 * @method DOMProcessingInstruction.toString - Serialize this ProcessingInstruction into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMProcessingInstruction.prototype.toString = function DOMProcessingInstruction_toString() {
  var ret = "";

  ret += "<?" + this.nodeName +" "+ this.nodeValue + " ?>";

  return ret;
}

/**
 * @class  DOMDocumentFragment - DocumentFragment is a "lightweight" or "minimal" Document object.
 *
 * @extends DOMNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMDocumentFragment = function(ownerDocument) {
  this._class = addClass(this._class, "DOMDocumentFragment");
  this.DOMNode = DOMNode;
  this.DOMNode(ownerDocument);

  this.nodeName  = "#document-fragment";
  this.nodeType = DOMNode.DOCUMENT_FRAGMENT_NODE;
};
DOMDocumentFragment.prototype = new DOMNode;

/**
 * @method DOMDocumentFragment.toString - Serialize this DocumentFragment into an XML string
 *
 * @author David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMDocumentFragment.prototype.toString = function DOMDocumentFragment_toString() {
  var xml = "";
  var intCount = this.getChildNodes().getLength();

  // create string concatenating the serialized ChildNodes
  for (intLoop = 0; intLoop < intCount; intLoop++) {
    xml += this.getChildNodes().item(intLoop).toString();
  }

  return xml;
}

///////////////////////
//  NOT IMPLEMENTED  //
///////////////////////
DOMDocumentType    = function() { alert("DOMDocumentType.constructor(): Not Implemented"   ); };
DOMEntity          = function() { alert("DOMEntity.constructor(): Not Implemented"         ); };
DOMEntityReference = function() { alert("DOMEntityReference.constructor(): Not Implemented"); };
DOMNotation        = function() { alert("DOMNotation.constructor(): Not Implemented"       ); };


Strings = new Object()
Strings.WHITESPACE = " \t\n\r";
Strings.QUOTES = "\"'";

Strings.isEmpty = function Strings_isEmpty(strD) {
    return (strD == null) || (strD.length == 0);
};
Strings.indexOfNonWhitespace = function Strings_indexOfNonWhitespace(strD, iB, iE) {
  if(Strings.isEmpty(strD)) return -1;
  iB = iB || 0;
  iE = iE || strD.length;

  for(var i = iB; i < iE; i++)
    if(Strings.WHITESPACE.indexOf(strD.charAt(i)) == -1) {
      return i;
    }
  return -1;
};
Strings.lastIndexOfNonWhitespace = function Strings_lastIndexOfNonWhitespace(strD, iB, iE) {
  if(Strings.isEmpty(strD)) return -1;
  iB = iB || 0;
  iE = iE || strD.length;

  for(var i = iE - 1; i >= iB; i--)
    if(Strings.WHITESPACE.indexOf(strD.charAt(i)) == -1)
      return i;
  return -1;
};
Strings.indexOfWhitespace = function Strings_indexOfWhitespace(strD, iB, iE) {
  if(Strings.isEmpty(strD)) return -1;
  iB = iB || 0;
  iE = iE || strD.length;

  for(var i = iB; i < iE; i++)
    if(Strings.WHITESPACE.indexOf(strD.charAt(i)) != -1)
      return i;
  return -1;
};
Strings.replace = function Strings_replace(strD, iB, iE, strF, strR) {
  if(Strings.isEmpty(strD)) return "";
  iB = iB || 0;
  iE = iE || strD.length;

  return strD.substring(iB, iE).split(strF).join(strR);
};
Strings.getLineNumber = function Strings_getLineNumber(strD, iP) {
  if(Strings.isEmpty(strD)) return -1;
  iP = iP || strD.length;

  return strD.substring(0, iP).split("\n").length
};
Strings.getColumnNumber = function Strings_getColumnNumber(strD, iP) {
  if(Strings.isEmpty(strD)) return -1;
  iP = iP || strD.length;

  var arrD = strD.substring(0, iP).split("\n");
  var strLine = arrD[arrD.length - 1];
  arrD.length--;
  var iLinePos = arrD.join("\n").length;

  return iP - iLinePos;
};


StringBuffer = function() {this._a=new Array();};
StringBuffer.prototype.append = function StringBuffer_append(d){this._a[this._a.length]=d;};
StringBuffer.prototype.toString = function StringBuffer_toString(){return this._a.join("");};
