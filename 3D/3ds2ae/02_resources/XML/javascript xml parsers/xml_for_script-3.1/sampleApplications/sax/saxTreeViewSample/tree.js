// =========================================================================
//
// tree.js- sample code for the SAX Parser in XML for <SCRIPT>
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


// Menu Tree Node - From builder.com
// Modified by Raymond Irving Jan 14,2002


/**************************************************************************************
                                        GLOBALS
***************************************************************************************/

// Variable that is used to store the current scroll position of a window
var yoffset = 0;
var io_text=[]; // added by raymond

function Tree(variable, id) {
    /*************************************************************************************
    Function:       Tree
    ************************************************************************************/

    // The Tree object constructor takes the name of a variable
    // to which the tree object is assigned (for use in event
    // handling) and a unique id value (to differentiate one tree
    // from another)

    this.variable = variable;		// The name of a variable by which the tree can be referenced
    this.id = id;				// A unique ID for the tree
    this.nodeID = 0;			// Used to give each node of the tree a unique ID
    this.nodes = new Array();		// An array consisting of the root nodes of the tree
    this.openedMarker = "-  ";	// String used to indicate that a node has been opened
    this.closedMarker = "+  ";	// String used to indicate that a node has been closed
    this.leafMarker = "*  ";	// String used to indicate a leaf of the tree
    this.addNode = Tree_addNode;		// Add a root node to the tree
    this.display = Tree_display;		// Display the tree
    this.loadState = Tree_loadState;	// Load the state of the tree from cookies
    this.saveState = Tree_saveState;	// Save the state of the tree using cookies
    this.getState = Tree_getState;		// Get a string that contains the current state of each tree node
    this.setState = Tree_setState;		// Set the state of each tree node from a string
    this.getNodeID = Tree_getNodeID;	// Returns a new node ID
    this.getNode = Tree_getNode;		// Returns the node corresponding to a specific ID
    this.setMarkers = Tree_setMarkers;	// Sets the opened, closed, and leaf markers of the tree
}  // end function Tree

function Tree_addNode(node) {
    /*************************************************************************************
    Function:       Tree_addNode

    Description:
        Add a root node to the tree
    ************************************************************************************/

    this.nodes[this.nodes.length] = node;

}  // end function Tree_addNode


function Tree_display() {
    /*************************************************************************************
    Function:       Tree_display

    Description:
        Display the tree object
    ************************************************************************************/
    io_clear();
    for(var i=0; i<this.nodes.length; ++i){
        this.nodes[i].display();
    }
    return io_getText();

}  // end function Tree_display


function Tree_getNode(id) {
    /*************************************************************************************
    Function:       Tree_setState

    Description:
        Returns the node corresponding to a specific ID
    ************************************************************************************/
    for(var i=0; i<this.nodes.length; ++i) {
        var node = this.nodes[i].findNode(id);
        if(node != null) return node;
    }
    return null;
}  // end function Tree_getNode


function Tree_getNodeID() {
    /*************************************************************************************
    Function:       Tree_getNodeID

    Description:
        Returns a new node ID
    ************************************************************************************/

    return this.nodeID++;

}  // end function Tree_getNodeID


function Tree_getState() {
    /*************************************************************************************
    Function:       Tree_display

    Description:
        Get a string that contains the current state of each tree node
    ************************************************************************************/
    var s = ""
    for(var i=0; i<this.nodes.length; ++i);
    s += this.nodes[i].getState();
    return s;
}  // end function Tree_getState


function Tree_loadState() {
    /*************************************************************************************
    Function:       Tree_display

    Description:
        Load the state of the tree from cookies - modified by raymond
    ************************************************************************************/
    //var s = getCookie("yoffset")
    //if(s != null) yoffset = s
    //s = getCookie(this.id)
    //if(s != null && s!="") this.setState(s)

}  // end function Tree_loadState


function Tree_saveState() {
    /*************************************************************************************
    Function:       Tree_display

    Description:
        Save the state of the tree using cookies - modified by raymond
    ************************************************************************************/
    //setCookie(this.id, this.getState())
    //setCookie("yoffset", yoffset)

}  // end function Tree_saveState


function Tree_setMarkers(opened, closed, leaf) {
    /*************************************************************************************
    Function:       Tree_setState

    Description:
        Sets the opened, closed, and leaf markers of the tree
    ************************************************************************************/
    this.openedMarker = opened
    this.closedMarker = closed
    this.leafMarker = leaf

}  // end function Tree_setMarkers


function Tree_setState(s) {
    /*************************************************************************************
    Function:       Tree_setState

    Description:
        Set the state of each tree node from a string
    ************************************************************************************/

    for(var i=0; i<this.nodes.length; ++i) {
        s = this.nodes[i].setState(s);
    }

}  // end function Tree_setState


function Tree_stateChange(tree, nodeID) {
    /*************************************************************************************
    Function:       Tree_setState

    Description:
        Handles the clicking of a tree's marker
    ************************************************************************************/
    // Get scroll position
    if(navigator.appName == "Netscape") {
        yoffset = window.pageYOffset;
    }
    else {
        yoffset = window.document.body.scrollTop;
    }
    node = tree.getNode(nodeID);
    // Change the opened/closed state of the node
    if(node != null && node.nodes.length > 0) {
        node.changeState();
    }

}  //end function Tree_stateChange






function Node(name, link, target, tree) {
    /*************************************************************************************
    Function:       Node

    Description:
        The Node object represents a node of a tree
        It is defined using the name (text) of the node, a hypertext link,
        a target window or frame, and a reference to the tree in which the
        node is contained
    ************************************************************************************/
    this.name = name;			// Text of the node
    this.link = link;			// Hypertext link
    this.target = target;			// Window or frame name
    this.tree = tree;			// Reference to containing tree
    this.nodes = new Array();		// Array of sub-nodes
    this.opened = false;			// Is the node expanded
    this.id = tree.getNodeID();		// A unique ID within the tree
    this.addNode = Node_addNode;		// Add a sub-node
    this.display = Node_display;		// Display the node
    this.open = Node_open;			// Expand the node
    this.close = Node_close;		// Close the node
    this.changeState = Node_changeState;	// Change the expanded state of the node
    this.findNode = Node_findNode;		// Returns a node with a specified ID
    this.getState = Node_getState;		// Returns a string that describes the expanded state of the node & its sub-nodes
    this.setState = Node_setState;		// Sets the expanded state of a node and its sub-nodes

}  // end function Node


function Node_addNode(node) {
    /*************************************************************************************
    Function:       Node_addNode

    Description:
        Add a sub-node
    ************************************************************************************/
    this.nodes[this.nodes.length] = node;

}  // end function Node_addNode


function Node_changeState() {
    /*************************************************************************************
    Function:       Node_open

    Description:
        Change the expanded state of the node
    ************************************************************************************/
    if(this.opened) {
        this.close();
    }
    else {
        this.open();
    }

}  // end function Node_changeState


function Node_close() {
    /*************************************************************************************
    Function:       Node_close

    Description:
        Close the node
    ************************************************************************************/
    this.opened = false
    this.tree.saveState()
    this.tree.onredraw()

}  // end function Node_close


function Node_display() {
    /*************************************************************************************
    Function:       Node_display

    Description:
        Display the node
    ************************************************************************************/
    if(this.nodes.length == 0) {
        io_write('<blockquote class="treenode">');
        writeAnchor(this.tree.variable, this.id, this.tree.leafMarker, this.link, this.target, this.name);
        io_write('</blockquote>');
    }
    else if (this.opened) {
        io_write('<blockquote class="treenode">');
        writeAnchor(this.tree.variable, this.id, this.tree.openedMarker, this.link, this.target, this.name);
        for(var i=0; i<this.nodes.length; ++i) {
            this.nodes[i].display();
        }
        io_write('</blockquote>');
    }
    else {
        io_write('<blockquote class="treenode">');
        writeAnchor(this.tree.variable, this.id, this.tree.closedMarker, this.link, this.target, this.name);
        io_write('</blockquote>');
    }

}  // end function Node_display


function Node_findNode(id) {
    /*************************************************************************************
    Function:       Node_open

    Description:
        Returns a node with a specified ID
    ************************************************************************************/
    if(this.id == id) {
        return this;
    }
    for(var i=0; i<this.nodes.length; ++i) {
        var node = this.nodes[i].findNode(id);
        if(node != null) {
            return node;
        }
    }
    return null;

}  // end function Node_findNode


function Node_getState() {
    /*************************************************************************************
    Function:       Node_open

    Description:
        Returns a string that describes the expanded state of the node & its sub-nodes
    ************************************************************************************/
    var s = "";
    if(this.opened) {
        s += "1";
    }
    else {
        s += 0;
    }
    for(var i=0; i<this.nodes.length; ++i) {
        s += this.nodes[i].getState();
    }

    return s;

}  // end function Node_getState


function Node_open() {
    /*************************************************************************************
    Function:       Node_open

    Description:
        Expand the node
    ************************************************************************************/
    this.opened = true;
    this.tree.saveState();
    var urls = window.location.href.split("#",1);
    this.tree.onredraw();

}  // end function Node_open


function Node_setState(s) {
    /*************************************************************************************
    Function:       Node_open

    Description:
        Sets the expanded state of a node and its sub-nodes
    ************************************************************************************/
    if(s == null || s == "") {
        return;
    }

    var bit = s.substring(0,1);

    if(bit == "1") {
        this.opened = true;
    }
    else {
        this.opened = false;
    }

    s = s.substring(1);
    for(var i=0; i<this.nodes.length; ++i) {
        s = this.nodes[i].setState(s);
    }
    return s;

}  // end function Node_setState


/***************************************************************************************
                                    HELPER FUNCTIONS
****************************************************************************************/





function io_clear(){
    /*************************************************************************************
    Function:       io_clear

    Description:
        IO Write/Clear - add by Raymond Irving
    ************************************************************************************/

    io_text=[];

}  // end function io_clear


function io_getText(){
    /*************************************************************************************
    Function:       io_getText
    ************************************************************************************/

    return io_text.join('');

}  // end function io_getText


function io_write(text){
    /*************************************************************************************
    Function:       io_write
    ************************************************************************************/
    io_text[io_text.length]=text;

}  // end function io_write


function removeBlanks(s) {
    /*************************************************************************************
    Function:       Tree_setState

    Description:
        Removes any blanks in a string
    ************************************************************************************/
    var temp = "";
    for(var i=0; i<s.length; ++i) {
        var c = s.charAt(i);
        if(c != " ") {
            temp += c;
        }
    }

    return temp;

}  // end function removeBlanks


function writeAnchor(treeref, id, marker, link, target, name) {
    /*************************************************************************************
    Function:       Node_addNode

    Description:
        Write the anchor tags associated with a node
    ************************************************************************************/
    io_write('<a href="javascript:void(null);" onclick="return Tree_stateChange('+treeref+","+id+');" class="treemarker">')
    io_write(marker)
    io_write('</a>')
    io_write('<a href="'+link+'"')
    if(target != "") io_write(' target="'+this.target+'"')
    io_write(' class="treenode">')
    io_write(name)
    io_write('</a>')

}  // end function writeAnchor

