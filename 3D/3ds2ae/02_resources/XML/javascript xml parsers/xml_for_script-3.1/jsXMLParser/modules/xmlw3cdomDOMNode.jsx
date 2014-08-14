/**
 * @class  DOMNodeList - provides the abstraction of an ordered collection of nodes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - the ownerDocument
 * @param  parentNode    : DOMNode - the node that the DOMNodeList is attached to (or null)
 */
DOMNodeList = function(ownerDocument, parentNode) {
  this._class = addClass(this._class, "DOMNodeList");
  this._nodes = new Array();

  this.length = 0;
  this.parentNode = parentNode;
  this.ownerDocument = ownerDocument;

  this._readonly = false;
};

/**
 * @method DOMNodeList.getLength - Java style gettor for .length
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : int
 */
DOMNodeList.prototype.getLength = function DOMNodeList_getLength() {
  return this.length;
};

/**
 * @method DOMNodeList.item - Returns the indexth item in the collection.
 *   If index is greater than or equal to the number of nodes in the list, this returns null.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  index : int - Index into the collection.
 *
 * @return : DOMNode - The node at the indexth position in the NodeList, or null if that is not a valid index
 */
DOMNodeList.prototype.item = function DOMNodeList_item(index) {
  var ret = null;

  if ((index >= 0) && (index < this._nodes.length)) { // bounds check
    ret = this._nodes[index];                    // return selected Node
  }

  return ret;                                    // if the index is out of bounds, default value null is returned
};

/**
 * @method DOMNodeList._findItemIndex - find the item index of the node with the specified internal id
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  id : int - unique internal id
 *
 * @return : int
 */
DOMNodeList.prototype._findItemIndex = function DOMNodeList__findItemIndex(id) {
  var ret = -1;

  // test that id is valid
  if (id > -1) {
    for (var i=0; i<this._nodes.length; i++) {
      // compare id to each node's _id
      if (this._nodes[i]._id == id) {            // found it!
        ret = i;
        break;
      }
    }
  }

  return ret;                                    // if node is not found, default value -1 is returned
};

/**
 * @method DOMNodeList._insertBefore - insert the specified Node into the NodeList before the specified index
 *   Used by DOMNode.insertBefore(). Note: DOMNode.insertBefore() is responsible for Node Pointer surgery
 *   DOMNodeList._insertBefore() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild      : DOMNode - the Node to be inserted
 * @param  refChildIndex : int     - the array index to insert the Node before
 */
DOMNodeList.prototype._insertBefore = function DOMNodeList__insertBefore(newChild, refChildIndex) {
  if ((refChildIndex >= 0) && (refChildIndex < this._nodes.length)) { // bounds check
    // get array containing children prior to refChild
    var tmpArr = new Array();
    tmpArr = this._nodes.slice(0, refChildIndex);

    if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {  // node is a DocumentFragment
      // append the children of DocumentFragment
      tmpArr = tmpArr.concat(newChild.childNodes._nodes);
    }
    else {
      // append the newChild
      tmpArr[tmpArr.length] = newChild;
    }

    // append the remaining original children (including refChild)
    this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex));

    this.length = this._nodes.length;            // update length
  }
};

/**
 * @method DOMNodeList._replaceChild - replace the specified Node in the NodeList at the specified index
 *   Used by DOMNode.replaceChild(). Note: DOMNode.replaceChild() is responsible for Node Pointer surgery
 *   DOMNodeList._replaceChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild      : DOMNode - the Node to be inserted
 * @param  refChildIndex : int     - the array index to hold the Node
 */
DOMNodeList.prototype._replaceChild = function DOMNodeList__replaceChild(newChild, refChildIndex) {
  var ret = null;

  if ((refChildIndex >= 0) && (refChildIndex < this._nodes.length)) { // bounds check
    ret = this._nodes[refChildIndex];            // preserve old child for return

    if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {  // node is a DocumentFragment
      // get array containing children prior to refChild
      var tmpArr = new Array();
      tmpArr = this._nodes.slice(0, refChildIndex);

      // append the children of DocumentFragment
      tmpArr = tmpArr.concat(newChild.childNodes._nodes);

      // append the remaining original children (not including refChild)
      this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex + 1));
    }
    else {
      // simply replace node in array (links between Nodes are made at higher level)
      this._nodes[refChildIndex] = newChild;
    }
  }

  return ret;                                   // return replaced node
};

/**
 * @method DOMNodeList._removeChild - remove the specified Node in the NodeList at the specified index
 *   Used by DOMNode.removeChild(). Note: DOMNode.removeChild() is responsible for Node Pointer surgery
 *   DOMNodeList._replaceChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  refChildIndex : int - the array index holding the Node to be removed
 */
DOMNodeList.prototype._removeChild = function DOMNodeList__removeChild(refChildIndex) {
  var ret = null;

  if (refChildIndex > -1) {                              // found it!
    ret = this._nodes[refChildIndex];                    // return removed node

    // rebuild array without removed child
    var tmpArr = new Array();
    tmpArr = this._nodes.slice(0, refChildIndex);
    this._nodes = tmpArr.concat(this._nodes.slice(refChildIndex +1));

    this.length = this._nodes.length;            // update length
  }

  return ret;                                   // return removed node
};

/**
 * @method DOMNodeList._appendChild - append the specified Node to the NodeList
 *   Used by DOMNode.appendChild(). Note: DOMNode.appendChild() is responsible for Node Pointer surgery
 *   DOMNodeList._appendChild() simply modifies the internal data structure (Array).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild      : DOMNode - the Node to be inserted
 */
DOMNodeList.prototype._appendChild = function DOMNodeList__appendChild(newChild) {

  if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {  // node is a DocumentFragment
    // append the children of DocumentFragment
    this._nodes = this._nodes.concat(newChild.childNodes._nodes);
  }
  else {
    // simply add node to array (links between Nodes are made at higher level)
    this._nodes[this._nodes.length] = newChild;
  }

  this.length = this._nodes.length;              // update length
};

/**
 * @method DOMNodeList._cloneNodes - Returns a NodeList containing clones of the Nodes in this NodeList
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  deep : boolean - If true, recursively clone the subtree under each of the nodes;
 *   if false, clone only the nodes themselves (and their attributes, if it is an Element).
 * @param  parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNodeList - NodeList containing clones of the Nodes in this NodeList
 */
DOMNodeList.prototype._cloneNodes = function DOMNodeList__cloneNodes(deep, parentNode) {
  var cloneNodeList = new DOMNodeList(this.ownerDocument, parentNode);

  // create list containing clones of each child
  for (var i=0; i < this._nodes.length; i++) {
    cloneNodeList._appendChild(this._nodes[i].cloneNode(deep));
  }

  return cloneNodeList;
};

/**
 * @method DOMNodeList.toString - Serialize this NodeList into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNodeList.prototype.toString = function DOMNodeList_toString() {
  var ret = "";

  // create string containing the concatenation of the string values of each child
  for (var i=0; i < this.length; i++) {
    ret += this._nodes[i].toString();
  }

  return ret;
};

/**
 * @class  DOMNamedNodeMap - used to represent collections of nodes that can be accessed by name
 *  typically a set of Element attributes
 *
 * @extends DOMNodeList - note W3C spec says that this is not the case,
 *   but we need an item() method identicle to DOMNodeList's, so why not?
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - the ownerDocument
 * @param  parentNode    : DOMNode - the node that the DOMNamedNodeMap is attached to (or null)
 */
DOMNamedNodeMap = function(ownerDocument, parentNode) {
  this._class = addClass(this._class, "DOMNamedNodeMap");
  this.DOMNodeList = DOMNodeList;
  this.DOMNodeList(ownerDocument, parentNode);
};
DOMNamedNodeMap.prototype = new DOMNodeList;

/**
 * @method DOMNamedNodeMap.getNamedItem - Retrieves a node specified by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - Name of a node to retrieve
 *
 * @return : DOMNode
 */
DOMNamedNodeMap.prototype.getNamedItem = function DOMNamedNodeMap_getNamedItem(name) {
  var ret = null;

  // test that Named Node exists
  var itemIndex = this._findNamedItemIndex(name);

  if (itemIndex > -1) {                          // found it!
    ret = this._nodes[itemIndex];                // return NamedNode
  }

  return ret;                                    // if node is not found, default value null is returned
};

/**
 * @method DOMNamedNodeMap.setNamedItem - Adds a node using its nodeName attribute
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  arg : DOMNode - A node to store in a named node map.
 *   The node will later be accessible using the value of the nodeName attribute of the node.
 *   If a node with that name is already present in the map, it is replaced by the new one.
 *
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *  The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMNode - If the new Node replaces an existing node with the same name the previously existing Node is returned,
 *   otherwise null is returned
 */
DOMNamedNodeMap.prototype.setNamedItem = function DOMNamedNodeMap_setNamedItem(arg) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if arg was not created by this Document
    if (this.ownerDocument != arg.ownerDocument) {
      throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
    }

    // throw Exception if DOMNamedNodeMap is readonly
    if (this._readonly || (this.parentNode && this.parentNode._readonly)) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if arg is already an attribute of another Element object
    if (arg.ownerElement && (arg.ownerElement != this.parentNode)) {
      throw(new DOMException(DOMException.INUSE_ATTRIBUTE_ERR));
    }
  }

  // get item index
  var itemIndex = this._findNamedItemIndex(arg.name);
  var ret = null;

  if (itemIndex > -1) {                          // found it!
    ret = this._nodes[itemIndex];                // use existing Attribute

    // throw Exception if DOMAttr is readonly
    if (this.ownerDocument.implementation.errorChecking && ret._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }
    else {
      this._nodes[itemIndex] = arg;                // over-write existing NamedNode
    }
  }
  else {
    this._nodes[this.length] = arg;              // add new NamedNode
  }

  this.length = this._nodes.length;              // update length

  arg.ownerElement = this.parentNode;            // update ownerElement

  return ret;                                    // return old node or null
};

/**
 * @method DOMNamedNodeMap.removeNamedItem - Removes a node specified by name.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - The name of a node to remove
 *
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 *
 * @return : DOMNode - The node removed from the map or null if no node with such a name exists.
 */
DOMNamedNodeMap.prototype.removeNamedItem = function DOMNamedNodeMap_removeNamedItem(name) {
  var ret = null;
  // test for exceptions
  // throw Exception if DOMNamedNodeMap is readonly
  if (this.ownerDocument.implementation.errorChecking && (this._readonly || (this.parentNode && this.parentNode._readonly))) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // get item index
  var itemIndex = this._findNamedItemIndex(name);

  // throw Exception if there is no node named name in this map
  if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
    throw(new DOMException(DOMException.NOT_FOUND_ERR));
  }

  // get Node
  var oldNode = this._nodes[itemIndex];

  // throw Exception if Node is readonly
  if (this.ownerDocument.implementation.errorChecking && oldNode._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // return removed node
  return this._removeChild(itemIndex);
};

/**
 * @method DOMNamedNodeMap.getNamedItemNS - Retrieves a node specified by name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : DOMNode
 */
DOMNamedNodeMap.prototype.getNamedItemNS = function DOMNamedNodeMap_getNamedItemNS(namespaceURI, localName) {
  var ret = null;

  // test that Named Node exists
  var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

  if (itemIndex > -1) {                          // found it!
    ret = this._nodes[itemIndex];                // return NamedNode
  }

  return ret;                                    // if node is not found, default value null is returned
};

/**
 * @method DOMNamedNodeMap.setNamedItemNS - Adds a node using
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  arg : string - A node to store in a named node map.
 *   The node will later be accessible using the value of the nodeName attribute of the node.
 *   If a node with that name is already present in the map, it is replaced by the new one.
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - INUSE_ATTRIBUTE_ERR: Raised if arg is an Attr that is already an attribute of another Element object.
 *   The DOM user must explicitly clone Attr nodes to re-use them in other elements.
 *
 * @return : DOMNode - If the new Node replaces an existing node with the same name the previously existing Node is returned,
 *   otherwise null is returned
 */
DOMNamedNodeMap.prototype.setNamedItemNS = function DOMNamedNodeMap_setNamedItemNS(arg) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if DOMNamedNodeMap is readonly
    if (this._readonly || (this.parentNode && this.parentNode._readonly)) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if arg was not created by this Document
    if (this.ownerDocument != arg.ownerDocument) {
      throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
    }

    // throw Exception if arg is already an attribute of another Element object
    if (arg.ownerElement && (arg.ownerElement != this.parentNode)) {
      throw(new DOMException(DOMException.INUSE_ATTRIBUTE_ERR));
    }
  }

  // get item index
  var itemIndex = this._findNamedItemNSIndex(arg.namespaceURI, arg.localName);
  var ret = null;

  if (itemIndex > -1) {                          // found it!
    ret = this._nodes[itemIndex];                // use existing Attribute
    // throw Exception if DOMAttr is readonly
    if (this.ownerDocument.implementation.errorChecking && ret._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }
    else {
      this._nodes[itemIndex] = arg;                // over-write existing NamedNode
    }
  }
  else {
    this._nodes[this.length] = arg;              // add new NamedNode
  }

  this.length = this._nodes.length;              // update length

  arg.ownerElement = this.parentNode;


  return ret;                                    // return old node or null
};

/**
 * @method DOMNamedNodeMap.removeNamedItemNS - Removes a node specified by name.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node with the specified namespaceURI and localName in this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this NamedNodeMap is readonly.
 *
 * @return : DOMNode - The node removed from the map or null if no node with such a name exists.
 */
DOMNamedNodeMap.prototype.removeNamedItemNS = function DOMNamedNodeMap_removeNamedItemNS(namespaceURI, localName) {
  var ret = null;

  // test for exceptions
  // throw Exception if DOMNamedNodeMap is readonly
  if (this.ownerDocument.implementation.errorChecking && (this._readonly || (this.parentNode && this.parentNode._readonly))) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // get item index
  var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

  // throw Exception if there is no matching node in this map
  if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
    throw(new DOMException(DOMException.NOT_FOUND_ERR));
  }

  // get Node
  var oldNode = this._nodes[itemIndex];

  // throw Exception if Node is readonly
  if (this.ownerDocument.implementation.errorChecking && oldNode._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  return this._removeChild(itemIndex);             // return removed node
};

/**
 * @method DOMNamedNodeMap._findNamedItemIndex - find the item index of the node with the specified name
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - the name of the required node
 *
 * @return : int
 */
DOMNamedNodeMap.prototype._findNamedItemIndex = function DOMNamedNodeMap__findNamedItemIndex(name) {
  var ret = -1;

  // loop through all nodes
  for (var i=0; i<this._nodes.length; i++) {
    // compare name to each node's nodeName
    if (this._nodes[i].name == name) {         // found it!
      ret = i;
      break;
    }
  }

  return ret;                                    // if node is not found, default value -1 is returned
};

/**
 * @method DOMNamedNodeMap._findNamedItemNSIndex - find the item index of the node with the specified namespaceURI and localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : int
 */
DOMNamedNodeMap.prototype._findNamedItemNSIndex = function DOMNamedNodeMap__findNamedItemNSIndex(namespaceURI, localName) {
  var ret = -1;

  // test that localName is not null
  if (localName) {
    // loop through all nodes
    for (var i=0; i<this._nodes.length; i++) {
      // compare name to each node's namespaceURI and localName
      if ((this._nodes[i].namespaceURI == namespaceURI) && (this._nodes[i].localName == localName)) {
        ret = i;                                 // found it!
        break;
      }
    }
  }

  return ret;                                    // if node is not found, default value -1 is returned
};

/**
 * @method DOMNamedNodeMap._hasAttribute - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  name : string - the name of the required node
 *
 * @return : boolean
 */
DOMNamedNodeMap.prototype._hasAttribute = function DOMNamedNodeMap__hasAttribute(name) {
  var ret = false;

  // test that Named Node exists
  var itemIndex = this._findNamedItemIndex(name);

  if (itemIndex > -1) {                          // found it!
    ret = true;                                  // return true
  }

  return ret;                                    // if node is not found, default value false is returned
}

/**
 * @method DOMNamedNodeMap._hasAttributeNS - Returns true if specified node exists
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : boolean
 */
DOMNamedNodeMap.prototype._hasAttributeNS = function DOMNamedNodeMap__hasAttributeNS(namespaceURI, localName) {
  var ret = false;

  // test that Named Node exists
  var itemIndex = this._findNamedItemNSIndex(namespaceURI, localName);

  if (itemIndex > -1) {                          // found it!
    ret = true;                                  // return true
  }

  return ret;                                    // if node is not found, default value false is returned
}

/**
 * @method DOMNamedNodeMap._cloneNodes - Returns a NamedNodeMap containing clones of the Nodes in this NamedNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNamedNodeMap - NamedNodeMap containing clones of the Nodes in this DOMNamedNodeMap
 */
DOMNamedNodeMap.prototype._cloneNodes = function DOMNamedNodeMap__cloneNodes(parentNode) {
  var cloneNamedNodeMap = new DOMNamedNodeMap(this.ownerDocument, parentNode);

  // create list containing clones of all children
  for (var i=0; i < this._nodes.length; i++) {
    cloneNamedNodeMap._appendChild(this._nodes[i].cloneNode(false));
  }

  return cloneNamedNodeMap;
};

/**
 * @method DOMNamedNodeMap.toString - Serialize this NodeMap into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNamedNodeMap.prototype.toString = function DOMNamedNodeMap_toString() {
  var ret = "";

  // create string containing concatenation of all (but last) Attribute string values (separated by spaces)
  for (var i=0; i < this.length -1; i++) {
    ret += this._nodes[i].toString() +" ";
  }

  // add last Attribute to string (without trailing space)
  if (this.length > 0) {
    ret += this._nodes[this.length -1].toString();
  }

  return ret;
};

/**
 * @class  DOMNamespaceNodeMap - used to represent collections of namespace nodes that can be accessed by name
 *  typically a set of Element attributes
 *
 * @extends DOMNamedNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - the ownerDocument
 * @param  parentNode    : DOMNode - the node that the DOMNamespaceNodeMap is attached to (or null)
 */
DOMNamespaceNodeMap = function(ownerDocument, parentNode) {
  this._class = addClass(this._class, "DOMNamespaceNodeMap");
  this.DOMNamedNodeMap = DOMNamedNodeMap;
  this.DOMNamedNodeMap(ownerDocument, parentNode);
};
DOMNamespaceNodeMap.prototype = new DOMNamedNodeMap;

/**
 * @method DOMNamespaceNodeMap._findNamedItemIndex - find the item index of the node with the specified localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  localName : string - the localName of the required node
 *
 * @return : int
 */
DOMNamespaceNodeMap.prototype._findNamedItemIndex = function DOMNamespaceNodeMap__findNamedItemIndex(localName) {
  var ret = -1;

  // loop through all nodes
  for (var i=0; i<this._nodes.length; i++) {
    // compare name to each node's nodeName
    if (this._nodes[i].localName == localName) {         // found it!
      ret = i;
      break;
    }
  }

  return ret;                                    // if node is not found, default value -1 is returned
};


/**
 * @method DOMNamespaceNodeMap._cloneNodes - Returns a NamespaceNodeMap containing clones of the Nodes in this NamespaceNodeMap
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  parentNode : DOMNode - the new parent of the cloned NodeList
 *
 * @return : DOMNamespaceNodeMap - NamespaceNodeMap containing clones of the Nodes in this NamespaceNodeMap
 */
DOMNamespaceNodeMap.prototype._cloneNodes = function DOMNamespaceNodeMap__cloneNodes(parentNode) {
  var cloneNamespaceNodeMap = new DOMNamespaceNodeMap(this.ownerDocument, parentNode);

  // create list containing clones of all children
  for (var i=0; i < this._nodes.length; i++) {
    cloneNamespaceNodeMap._appendChild(this._nodes[i].cloneNode(false));
  }

  return cloneNamespaceNodeMap;
};

/**
 * @method DOMNamespaceNodeMap.toString - Serialize this NamespaceNodeMap into an XML string
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string
 */
DOMNamespaceNodeMap.prototype.toString = function DOMNamespaceNodeMap_toString() {
  var ret = "";

  // identify namespaces declared local to this Element (ie, not inherited)
  for (var ind = 0; ind < this._nodes.length; ind++) {
    // if namespace declaration does not exist in the containing node's, parentNode's namespaces
    var ns = null;
    try {
        var ns = this.parentNode.parentNode._namespaces.getNamedItem(this._nodes[ind].localName);
    }
    catch (e) {
        //breaking to prevent default namespace being inserted into return value
        break;
    }
    if (!(ns && (""+ ns.nodeValue == ""+ this._nodes[ind].nodeValue))) {
      // display the namespace declaration
      ret += this._nodes[ind].toString() +" ";
    }
  }

  return ret;
};

/**
 * @class  DOMNode - The Node interface is the primary datatype for the entire Document Object Model.
 *   It represents a single node in the document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  ownerDocument : DOMDocument - The Document object associated with this node.
 */
DOMNode = function(ownerDocument) {
  this._class = addClass(this._class, "DOMNode");

  if (ownerDocument) {
    this._id = ownerDocument._genId();           // generate unique internal id
  }

  this.namespaceURI = "";                        // The namespace URI of this node (Level 2)
  this.prefix       = "";                        // The namespace prefix of this node (Level 2)
  this.localName    = "";                        // The localName of this node (Level 2)

  this.nodeName = "";                            // The name of this node
  this.nodeValue = "";                           // The value of this node
  this.nodeType = 0;                             // A code representing the type of the underlying object

  // The parent of this node. All nodes, except Document, DocumentFragment, and Attr may have a parent.
  // However, if a node has just been created and not yet added to the tree, or if it has been removed from the tree, this is null
  this.parentNode      = null;

  // A NodeList that contains all children of this node. If there are no children, this is a NodeList containing no nodes.
  // The content of the returned NodeList is "live" in the sense that, for instance, changes to the children of the node object
  // that it was created from are immediately reflected in the nodes returned by the NodeList accessors;
  // it is not a static snapshot of the content of the node. This is true for every NodeList, including the ones returned by the getElementsByTagName method.
  this.childNodes      = new DOMNodeList(ownerDocument, this);

  this.firstChild      = null;                   // The first child of this node. If there is no such node, this is null
  this.lastChild       = null;                   // The last child of this node. If there is no such node, this is null.
  this.previousSibling = null;                   // The node immediately preceding this node. If there is no such node, this is null.
  this.nextSibling     = null;                   // The node immediately following this node. If there is no such node, this is null.

  this.attributes = new DOMNamedNodeMap(ownerDocument, this);   // A NamedNodeMap containing the attributes of this node (if it is an Element) or null otherwise.
  this.ownerDocument   = ownerDocument;          // The Document object associated with this node
  this._namespaces = new DOMNamespaceNodeMap(ownerDocument, this);  // The namespaces in scope for this node

  this._readonly = false;
};

// nodeType constants
DOMNode.ELEMENT_NODE                = 1;
DOMNode.ATTRIBUTE_NODE              = 2;
DOMNode.TEXT_NODE                   = 3;
DOMNode.CDATA_SECTION_NODE          = 4;
DOMNode.ENTITY_REFERENCE_NODE       = 5;
DOMNode.ENTITY_NODE                 = 6;
DOMNode.PROCESSING_INSTRUCTION_NODE = 7;
DOMNode.COMMENT_NODE                = 8;
DOMNode.DOCUMENT_NODE               = 9;
DOMNode.DOCUMENT_TYPE_NODE          = 10;
DOMNode.DOCUMENT_FRAGMENT_NODE      = 11;
DOMNode.NOTATION_NODE               = 12;
DOMNode.NAMESPACE_NODE              = 13;

/**
 * @method DOMNode.hasAttributes
 *
 * @author Jon van Noort (jon@webarcana.com.au) & David Joham (djoham@yahoo.com)
 *
 * @return : boolean
 */
DOMNode.prototype.hasAttributes = function DOMNode_hasAttributes() {
    if (this.attributes.length == 0) {
        return false;
    }
    else {
        return true;
    }
};

/**
 * @method DOMNode.getNodeName - Java style gettor for .nodeName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNode.prototype.getNodeName = function DOMNode_getNodeName() {
  return this.nodeName;
};

/**
 * @method DOMNode.getNodeValue - Java style gettor for .NodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : string
 */
DOMNode.prototype.getNodeValue = function DOMNode_getNodeValue() {
  return this.nodeValue;
};

/**
 * @method DOMNode.setNodeValue - Java style settor for .NodeValue
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  nodeValue : string - unique internal id
 */
DOMNode.prototype.setNodeValue = function DOMNode_setNodeValue(nodeValue) {
  // throw Exception if DOMNode is readonly
  if (this.ownerDocument.implementation.errorChecking && this._readonly) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  this.nodeValue = nodeValue;
};

/**
 * @method DOMNode.getNodeType - Java style gettor for .nodeType
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : int
 */
DOMNode.prototype.getNodeType = function DOMNode_getNodeType() {
  return this.nodeType;
};

/**
 * @method DOMNode.getParentNode - Java style gettor for .parentNode
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getParentNode = function DOMNode_getParentNode() {
  return this.parentNode;
};

/**
 * @method DOMNode.getChildNodes - Java style gettor for .childNodes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getChildNodes = function DOMNode_getChildNodes() {
  return this.childNodes;
};

/**
 * @method DOMNode.getFirstChild - Java style gettor for .firstChild
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getFirstChild = function DOMNode_getFirstChild() {
  return this.firstChild;
};

/**
 * @method DOMNode.getLastChild - Java style gettor for .lastChild
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getLastChild = function DOMNode_getLastChild() {
  return this.lastChild;
};

/**
 * @method DOMNode.getPreviousSibling - Java style gettor for .previousSibling
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getPreviousSibling = function DOMNode_getPreviousSibling() {
  return this.previousSibling;
};

/**
 * @method DOMNode.getNextSibling - Java style gettor for .nextSibling
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNode
 */
DOMNode.prototype.getNextSibling = function DOMNode_getNextSibling() {
  return this.nextSibling;
};

/**
 * @method DOMNode.getAttributes - Java style gettor for .attributes
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMNamedNodeList
 */
DOMNode.prototype.getAttributes = function DOMNode_getAttributes() {
  return this.attributes;
};

/**
 * @method DOMNode.getOwnerDocument - Java style gettor for .ownerDocument
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : DOMDocument
 */
DOMNode.prototype.getOwnerDocument = function DOMNode_getOwnerDocument() {
  return this.ownerDocument;
};

/**
 * @method DOMNode.getNamespaceURI - Java style gettor for .namespaceURI
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getNamespaceURI = function DOMNode_getNamespaceURI() {
  return this.namespaceURI;
};

/**
 * @method DOMNode.getPrefix - Java style gettor for .prefix
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getPrefix = function DOMNode_getPrefix() {
  return this.prefix;
};

/**
 * @method DOMNode.setPrefix - Java style settor for .prefix
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param   prefix : String
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - INVALID_CHARACTER_ERR: Raised if the string contains an illegal character
 * @throws : DOMException - NAMESPACE_ERR: Raised if the Namespace is invalid
 *
 */
DOMNode.prototype.setPrefix = function DOMNode_setPrefix(prefix) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if DOMNode is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if the prefix string contains an illegal character
    if (!this.ownerDocument.implementation._isValidName(prefix)) {
      throw(new DOMException(DOMException.INVALID_CHARACTER_ERR));
    }

    // throw Exception if the Namespace is invalid;
    //  if the specified prefix is malformed,
    //  if the namespaceURI of this node is null,
    //  if the specified prefix is "xml" and the namespaceURI of this node is
    //   different from "http://www.w3.org/XML/1998/namespace",
    if (!this.ownerDocument._isValidNamespace(this.namespaceURI, prefix +":"+ this.localName)) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }

    // throw Exception if we are trying to make the attribute look like a namespace declaration;
    //  if this node is an attribute and the specified prefix is "xmlns"
    //   and the namespaceURI of this node is different from "http://www.w3.org/2000/xmlns/",
    if ((prefix == "xmlns") && (this.namespaceURI != "http://www.w3.org/2000/xmlns/")) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }

    // throw Exception if we are trying to make the attribute look like a default namespace declaration;
    //  if this node is an attribute and the qualifiedName of this node is "xmlns" [Namespaces].
    if ((prefix == "") && (this.localName == "xmlns")) {
      throw(new DOMException(DOMException.NAMESPACE_ERR));
    }
  }

  // update prefix
  this.prefix = prefix;

  // update nodeName (QName)
  if (this.prefix != "") {
    this.nodeName = this.prefix +":"+ this.localName;
  }
  else {
    this.nodeName = this.localName;  // no prefix, therefore nodeName is simply localName
  }
};

/**
 * @method DOMNode.getLocalName - Java style gettor for .localName
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : String
 */
DOMNode.prototype.getLocalName = function DOMNode_getLocalName() {
  return this.localName;
};

/**
 * @method DOMNode.insertBefore - Inserts the node newChild before the existing child node refChild.
 *   If refChild is null, insert newChild at the end of the list of children.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild : DOMNode - The node to insert.
 * @param  refChild : DOMNode - The reference node, i.e., the node before which the new node must be inserted
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node being inserted.
 */
DOMNode.prototype.insertBefore = function DOMNode_insertBefore(newChild, refChild) {
  var prevNode;

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if DOMNode is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if newChild was not created by this Document
    if (this.ownerDocument != newChild.ownerDocument) {
      throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
    }

    // throw Exception if the node is an ancestor
    if (this._isAncestor(newChild)) {
      throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
    }
  }

  if (refChild) {                                // if refChild is specified, insert before it
    // find index of refChild
    var itemIndex = this.childNodes._findItemIndex(refChild._id);

    // throw Exception if there is no child node with this id
    if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
      throw(new DOMException(DOMException.NOT_FOUND_ERR));
    }

    // if the newChild is already in the tree,
    var newChildParent = newChild.parentNode;
    if (newChildParent) {
      // remove it
      newChildParent.removeChild(newChild);
    }

    // insert newChild into childNodes
    this.childNodes._insertBefore(newChild, this.childNodes._findItemIndex(refChild._id));

    // do node pointer surgery
    prevNode = refChild.previousSibling;

    // handle DocumentFragment
    if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
      if (newChild.childNodes._nodes.length > 0) {
        // set the parentNode of DocumentFragment's children
        for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
          newChild.childNodes._nodes[ind].parentNode = this;
        }

        // link refChild to last child of DocumentFragment
        refChild.previousSibling = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
      }
    }
    else {
      newChild.parentNode = this;                // set the parentNode of the newChild
      refChild.previousSibling = newChild;       // link refChild to newChild
    }
  }
  else {                                         // otherwise, append to end
    prevNode = this.lastChild;
    this.appendChild(newChild);
  }

  if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
    // do node pointer surgery for DocumentFragment
    if (newChild.childNodes._nodes.length > 0) {
      if (prevNode) {
        prevNode.nextSibling = newChild.childNodes._nodes[0];
      }
      else {                                         // this is the first child in the list
        this.firstChild = newChild.childNodes._nodes[0];
      }

      newChild.childNodes._nodes[0].previousSibling = prevNode;
      newChild.childNodes._nodes[newChild.childNodes._nodes.length-1].nextSibling = refChild;
    }
  }
  else {
    // do node pointer surgery for newChild
    if (prevNode) {
      prevNode.nextSibling = newChild;
    }
    else {                                         // this is the first child in the list
      this.firstChild = newChild;
    }

    newChild.previousSibling = prevNode;
    newChild.nextSibling     = refChild;
  }

  return newChild;
};

/**
 * @method DOMNode.replaceChild - Replaces the child node oldChild with newChild in the list of children,
 *   and returns the oldChild node.
 *   If the newChild is already in the tree, it is first removed.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild : DOMNode - The node to insert.
 * @param  oldChild : DOMNode - The node being replaced in the list.
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node that was replaced
 */
DOMNode.prototype.replaceChild = function DOMNode_replaceChild(newChild, oldChild) {
  var ret = null;

  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if DOMNode is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if newChild was not created by this Document
    if (this.ownerDocument != newChild.ownerDocument) {
      throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
    }

    // throw Exception if the node is an ancestor
    if (this._isAncestor(newChild)) {
      throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
    }
  }

  // get index of oldChild
  var index = this.childNodes._findItemIndex(oldChild._id);

  // throw Exception if there is no child node with this id
  if (this.ownerDocument.implementation.errorChecking && (index < 0)) {
    throw(new DOMException(DOMException.NOT_FOUND_ERR));
  }

  // if the newChild is already in the tree,
  var newChildParent = newChild.parentNode;
  if (newChildParent) {
    // remove it
    newChildParent.removeChild(newChild);
  }

  // add newChild to childNodes
  ret = this.childNodes._replaceChild(newChild, index);


  if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
    // do node pointer surgery for Document Fragment
    if (newChild.childNodes._nodes.length > 0) {
      for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
        newChild.childNodes._nodes[ind].parentNode = this;
      }

      if (oldChild.previousSibling) {
        oldChild.previousSibling.nextSibling = newChild.childNodes._nodes[0];
      }
      else {
        this.firstChild = newChild.childNodes._nodes[0];
      }

      if (oldChild.nextSibling) {
        oldChild.nextSibling.previousSibling = newChild;
      }
      else {
        this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
      }

      newChild.childNodes._nodes[0].previousSibling = oldChild.previousSibling;
      newChild.childNodes._nodes[newChild.childNodes._nodes.length-1].nextSibling = oldChild.nextSibling;
    }
  }
  else {
    // do node pointer surgery for newChild
    newChild.parentNode = this;

    if (oldChild.previousSibling) {
      oldChild.previousSibling.nextSibling = newChild;
    }
    else {
      this.firstChild = newChild;
    }
    if (oldChild.nextSibling) {
      oldChild.nextSibling.previousSibling = newChild;
    }
    else {
      this.lastChild = newChild;
    }
    newChild.previousSibling = oldChild.previousSibling;
    newChild.nextSibling = oldChild.nextSibling;
  }
  return ret;
};

/**
 * @method DOMNode.removeChild - Removes the child node indicated by oldChild from the list of children, and returns it.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  oldChild : DOMNode - The node being removed.
 *
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 * @throws : DOMException - NOT_FOUND_ERR: Raised if there is no node named name in this map.
 *
 * @return : DOMNode - The node being removed.
 */
DOMNode.prototype.removeChild = function DOMNode_removeChild(oldChild) {
  // throw Exception if DOMNamedNodeMap is readonly
  if (this.ownerDocument.implementation.errorChecking && (this._readonly || oldChild._readonly)) {
    throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
  }

  // get index of oldChild
  var itemIndex = this.childNodes._findItemIndex(oldChild._id);

  // throw Exception if there is no child node with this id
  if (this.ownerDocument.implementation.errorChecking && (itemIndex < 0)) {
    throw(new DOMException(DOMException.NOT_FOUND_ERR));
  }

  // remove oldChild from childNodes
  this.childNodes._removeChild(itemIndex);

  // do node pointer surgery
  oldChild.parentNode = null;

  if (oldChild.previousSibling) {
    oldChild.previousSibling.nextSibling = oldChild.nextSibling;
  }
  else {
    this.firstChild = oldChild.nextSibling;
  }
  if (oldChild.nextSibling) {
    oldChild.nextSibling.previousSibling = oldChild.previousSibling;
  }
  else {
    this.lastChild = oldChild.previousSibling;
  }

  oldChild.previousSibling = null;
  oldChild.nextSibling = null;
  return oldChild;
};

/**
 * @method DOMNode.appendChild - Adds the node newChild to the end of the list of children of this node.
 *   If the newChild is already in the tree, it is first removed.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  newChild : DOMNode - The node to add
 *
 * @throws : DOMException - HIERARCHY_REQUEST_ERR: Raised if the node to insert is one of this node's ancestors
 * @throws : DOMException - WRONG_DOCUMENT_ERR: Raised if arg was created from a different document than the one that created this map.
 * @throws : DOMException - NO_MODIFICATION_ALLOWED_ERR: Raised if this Node is readonly.
 *
 * @return : DOMNode - The node added
 */
DOMNode.prototype.appendChild = function DOMNode_appendChild(newChild) {
  // test for exceptions
  if (this.ownerDocument.implementation.errorChecking) {
    // throw Exception if Node is readonly
    if (this._readonly) {
      throw(new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR));
    }

    // throw Exception if arg was not created by this Document
    if (this.ownerDocument != newChild.ownerDocument) {
      throw(new DOMException(DOMException.WRONG_DOCUMENT_ERR));
    }

    // throw Exception if the node is an ancestor
    if (this._isAncestor(newChild)) {
      throw(new DOMException(DOMException.HIERARCHY_REQUEST_ERR));
    }
  }

  // if the newChild is already in the tree,
  var newChildParent = newChild.parentNode;
  if (newChildParent) {
    // remove it
    newChildParent.removeChild(newChild);
  }

  // add newChild to childNodes
  this.childNodes._appendChild(newChild);

  if (newChild.nodeType == DOMNode.DOCUMENT_FRAGMENT_NODE) {
    // do node pointer surgery for DocumentFragment
    if (newChild.childNodes._nodes.length > 0) {
      for (var ind = 0; ind < newChild.childNodes._nodes.length; ind++) {
        newChild.childNodes._nodes[ind].parentNode = this;
      }

      if (this.lastChild) {
        this.lastChild.nextSibling = newChild.childNodes._nodes[0];
        newChild.childNodes._nodes[0].previousSibling = this.lastChild;
        this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
      }
      else {
        this.lastChild = newChild.childNodes._nodes[newChild.childNodes._nodes.length-1];
        this.firstChild = newChild.childNodes._nodes[0];
      }
    }
  }
  else {
    // do node pointer surgery for newChild
    newChild.parentNode = this;
    if (this.lastChild) {
      this.lastChild.nextSibling = newChild;
      newChild.previousSibling = this.lastChild;
      this.lastChild = newChild;
    }
    else {
      this.lastChild = newChild;
      this.firstChild = newChild;
    }
  }

  return newChild;
};

/**
 * @method DOMNode.hasChildNodes - This is a convenience method to allow easy determination of whether a node has any children.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @return : boolean - true if the node has any children, false if the node has no children
 */
DOMNode.prototype.hasChildNodes = function DOMNode_hasChildNodes() {
  return (this.childNodes.length > 0);
};

/**
 * @method DOMNode.cloneNode - Returns a duplicate of this node, i.e., serves as a generic copy constructor for nodes.
 *   The duplicate node has no parent (parentNode returns null.).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  deep : boolean - If true, recursively clone the subtree under the specified node;
 *   if false, clone only the node itself (and its attributes, if it is an Element).
 *
 * @return : DOMNode
 */
DOMNode.prototype.cloneNode = function DOMNode_cloneNode(deep) {
  // use importNode to clone this Node
  //do not throw any exceptions
  try {
     return this.ownerDocument.importNode(this, deep);
  }
  catch (e) {
     //there shouldn't be any exceptions, but if there are, return null
     return null;
  }
};

/**
 * @method DOMNode.normalize - Puts all Text nodes in the full depth of the sub-tree underneath this Element into a "normal" form
 *   where only markup (e.g., tags, comments, processing instructions, CDATA sections, and entity references) separates Text nodes,
 *   i.e., there are no adjacent Text nodes.
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 */
DOMNode.prototype.normalize = function DOMNode_normalize() {
  var inode;
  var nodesToRemove = new DOMNodeList();

  if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {
    var adjacentTextNode = null;

    // loop through all childNodes
    for(var i = 0; i < this.childNodes.length; i++) {
      inode = this.childNodes.item(i);

      if (inode.nodeType == DOMNode.TEXT_NODE) { // this node is a text node
        if (inode.length < 1) {                  // this text node is empty
          nodesToRemove._appendChild(inode);      // add this node to the list of nodes to be remove
        }
        else {
          if (adjacentTextNode) {                // if previous node was also text
            adjacentTextNode.appendData(inode.data);     // merge the data in adjacent text nodes
            nodesToRemove._appendChild(inode);    // add this node to the list of nodes to be removed
          }
          else {
              adjacentTextNode = inode;              // remember this node for next cycle
          }
        }
      }
      else {
        adjacentTextNode = null;                 // (soon to be) previous node is not a text node
        inode.normalize();                       // normalise non Text childNodes
      }
    }

    // remove redundant Text Nodes
    for(var i = 0; i < nodesToRemove.length; i++) {
      inode = nodesToRemove.item(i);
      inode.parentNode.removeChild(inode);
    }
  }
};

/**
 * @method DOMNode.isSupported - Test if the DOM implementation implements a specific feature
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  feature : string - The package name of the feature to test. the legal only values are "XML" and "CORE" (case-insensitive).
 * @param  version : string - This is the version number of the package name to test. In Level 1, this is the string "1.0".
 *
 * @return : boolean
 */
DOMNode.prototype.isSupported = function DOMNode_isSupported(feature, version) {
  // use Implementation.hasFeature to determin if this feature is supported
  return this.ownerDocument.implementation.hasFeature(feature, version);
}

/**
 * @method DOMNode.getElementsByTagName - Returns a NodeList of all the Elements with a given tag name
 *   in the order in which they would be encountered in a preorder traversal of the Document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  tagname : string - The name of the tag to match on. The special value "*" matches all tags
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getElementsByTagName = function DOMNode_getElementsByTagName(tagname) {
  // delegate to _getElementsByTagNameRecursive
  return this._getElementsByTagNameRecursive(tagname, new DOMNodeList(this.ownerDocument));
};

/**
 * @method DOMNode._getElementsByTagNameRecursive - implements getElementsByTagName()
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  tagname  : string      - The name of the tag to match on. The special value "*" matches all tags
 * @param  nodeList : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
DOMNode.prototype._getElementsByTagNameRecursive = function DOMNode__getElementsByTagNameRecursive(tagname, nodeList) {
  if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {

    if((this.nodeName == tagname) || (tagname == "*")) {
      nodeList._appendChild(this);               // add matching node to nodeList
    }

    // recurse childNodes
    for(var i = 0; i < this.childNodes.length; i++) {
      nodeList = this.childNodes.item(i)._getElementsByTagNameRecursive(tagname, nodeList);
    }
  }

  return nodeList;
};

/**
 * @method DOMNode.getXML - Returns the String XML of the node and all of its children
 *
 * @author Jon van Noort (jon@webarcana.com.au) and David Joham (djoham@yahoo.com)
 *
 * @return : string - XML String of the XML of the node and all of its children
 */
DOMNode.prototype.getXML = function DOMNode_getXML() {
  return this.toString();
}


/**
 * @method DOMNode.getElementsByTagNameNS - Returns a NodeList of all the Elements with a given namespaceURI and localName
 *   in the order in which they would be encountered in a preorder traversal of the Document tree.
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 *
 * @return : DOMNodeList
 */
DOMNode.prototype.getElementsByTagNameNS = function DOMNode_getElementsByTagNameNS(namespaceURI, localName) {
  // delegate to _getElementsByTagNameNSRecursive
  return this._getElementsByTagNameNSRecursive(namespaceURI, localName, new DOMNodeList(this.ownerDocument));
};

/**
 * @method DOMNode._getElementsByTagNameNSRecursive - implements getElementsByTagName()
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  namespaceURI : string - the namespace URI of the required node
 * @param  localName    : string - the local name of the required node
 * @param  nodeList     : DOMNodeList - The accumulating list of matching nodes
 *
 * @return : DOMNodeList
 */
DOMNode.prototype._getElementsByTagNameNSRecursive = function DOMNode__getElementsByTagNameNSRecursive(namespaceURI, localName, nodeList) {
  if (this.nodeType == DOMNode.ELEMENT_NODE || this.nodeType == DOMNode.DOCUMENT_NODE) {

    if (((this.namespaceURI == namespaceURI) || (namespaceURI == "*")) && ((this.localName == localName) || (localName == "*"))) {
      nodeList._appendChild(this);               // add matching node to nodeList
    }

    // recurse childNodes
    for(var i = 0; i < this.childNodes.length; i++) {
      nodeList = this.childNodes.item(i)._getElementsByTagNameNSRecursive(namespaceURI, localName, nodeList);
    }
  }

  return nodeList;
};

/**
 * @method DOMNode._isAncestor - returns true if node is ancestor of this
 *
 * @author Jon van Noort (jon@webarcana.com.au), David Joham (djoham@yahoo.com) and Scott Severtson
 *
 * @param  node         : DOMNode - The candidate ancestor node
 *
 * @return : boolean
 */
DOMNode.prototype._isAncestor = function DOMNode__isAncestor(node) {
  // if this node matches, return true,
  // otherwise recurse up (if there is a parentNode)
  return ((this == node) || ((this.parentNode) && (this.parentNode._isAncestor(node))));
}

/**
 * @method DOMNode.importNode - Imports a node from another document to this document.
 *   The returned node has no parent; (parentNode is null).
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  importedNode : Node - The Node to be imported
 * @param  deep         : boolean - If true, recursively clone the subtree under the specified node;
 *   if false, clone only the node itself (and its attributes, if it is an Element).
 *
 * @return : DOMNode
 */
DOMNode.prototype.importNode = function DOMNode_importNode(importedNode, deep) {
  var importNode;

  //there is no need to perform namespace checks since everything has already gone through them
  //in order to have gotten into the DOM in the first place. The following line
  //turns namespace checking off in ._isValidNamespace
  this.getOwnerDocument()._performingImportNodeOperation = true;

  try {
    if (importedNode.nodeType == DOMNode.ELEMENT_NODE) {
        if (!this.ownerDocument.implementation.namespaceAware) {
        // create a local Element (with the name of the importedNode)
        importNode = this.ownerDocument.createElement(importedNode.tagName);

        // create attributes matching those of the importedNode
        for(var i = 0; i < importedNode.attributes.length; i++) {
            importNode.setAttribute(importedNode.attributes.item(i).name, importedNode.attributes.item(i).value);
        }
        }
        else {
        // create a local Element (with the name & namespaceURI of the importedNode)
        importNode = this.ownerDocument.createElementNS(importedNode.namespaceURI, importedNode.nodeName);

        // create attributes matching those of the importedNode
        for(var i = 0; i < importedNode.attributes.length; i++) {
            importNode.setAttributeNS(importedNode.attributes.item(i).namespaceURI, importedNode.attributes.item(i).name, importedNode.attributes.item(i).value);
        }

        // create namespace definitions matching those of the importedNode
        for(var i = 0; i < importedNode._namespaces.length; i++) {
            importNode._namespaces._nodes[i] = this.ownerDocument.createNamespace(importedNode._namespaces.item(i).localName);
            importNode._namespaces._nodes[i].setValue(importedNode._namespaces.item(i).value);
        }
        }
    }
    else if (importedNode.nodeType == DOMNode.ATTRIBUTE_NODE) {
        if (!this.ownerDocument.implementation.namespaceAware) {
        // create a local Attribute (with the name of the importedAttribute)
        importNode = this.ownerDocument.createAttribute(importedNode.name);
        }
        else {
        // create a local Attribute (with the name & namespaceURI of the importedAttribute)
        importNode = this.ownerDocument.createAttributeNS(importedNode.namespaceURI, importedNode.nodeName);

        // create namespace definitions matching those of the importedAttribute
        for(var i = 0; i < importedNode._namespaces.length; i++) {
            importNode._namespaces._nodes[i] = this.ownerDocument.createNamespace(importedNode._namespaces.item(i).localName);
            importNode._namespaces._nodes[i].setValue(importedNode._namespaces.item(i).value);
        }
        }

        // set the value of the local Attribute to match that of the importedAttribute
        importNode.setValue(importedNode.value);
    }
    else if (importedNode.nodeType == DOMNode.DOCUMENT_FRAGMENT) {
        // create a local DocumentFragment
        importNode = this.ownerDocument.createDocumentFragment();
    }
    else if (importedNode.nodeType == DOMNode.NAMESPACE_NODE) {
        // create a local NamespaceNode (with the same name & value as the importedNode)
        importNode = this.ownerDocument.createNamespace(importedNode.nodeName);
        importNode.setValue(importedNode.value);
    }
    else if (importedNode.nodeType == DOMNode.TEXT_NODE) {
        // create a local TextNode (with the same data as the importedNode)
        importNode = this.ownerDocument.createTextNode(importedNode.data);
    }
    else if (importedNode.nodeType == DOMNode.CDATA_SECTION_NODE) {
        // create a local CDATANode (with the same data as the importedNode)
        importNode = this.ownerDocument.createCDATASection(importedNode.data);
    }
    else if (importedNode.nodeType == DOMNode.PROCESSING_INSTRUCTION_NODE) {
        // create a local ProcessingInstruction (with the same target & data as the importedNode)
        importNode = this.ownerDocument.createProcessingInstruction(importedNode.target, importedNode.data);
    }
    else if (importedNode.nodeType == DOMNode.COMMENT_NODE) {
        // create a local Comment (with the same data as the importedNode)
        importNode = this.ownerDocument.createComment(importedNode.data);
    }
    else {  // throw Exception if nodeType is not supported
        throw(new DOMException(DOMException.NOT_SUPPORTED_ERR));
    }

    if (deep) {                                    // recurse childNodes
        for(var i = 0; i < importedNode.childNodes.length; i++) {
        importNode.appendChild(this.ownerDocument.importNode(importedNode.childNodes.item(i), true));
        }
    }

    //reset _performingImportNodeOperation
    this.getOwnerDocument()._performingImportNodeOperation = false;
    return importNode;
  }
  catch (eAny) {
    //reset _performingImportNodeOperation
    this.getOwnerDocument()._performingImportNodeOperation = false;

    //re-throw the exception
    throw eAny;
  }//djotemp
};

/**
 * @method DOMNode.escapeString - escape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  str : string - The string to be escaped
 *
 * @return : string - The escaped string
 */
DOMNode.prototype.__escapeString = function DOMNode__escapeString(str) {

  //the sax processor already has this function. Just wrap it
  return __escapeString(str);
};

/**
 * @method DOMNode.unescapeString - unescape special characters
 *
 * @author Jon van Noort (jon@webarcana.com.au)
 *
 * @param  str : string - The string to be unescaped
 *
 * @return : string - The unescaped string
 */
DOMNode.prototype.__unescapeString = function DOMNode__unescapeString(str) {

  //the sax processor already has this function. Just wrap it
  return __unescapeString(str);
};



