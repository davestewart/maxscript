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

var objDom = new XMLDoc('');


function findNode(){
    /*************************************************************************************
    Function:       findNode

    author:         djoham@yahoo.com

    description:
		tells the DOM object to search for the node
    ************************************************************************************/
	// note the first / the doc root of the current node, therefor /rootnode is not required
	var tagpath=document.getElementById("tagPath").value;
	var node = objDom.selectNode(tagpath);
	if(node) {
		alert(node.getText());
	}
	else {
		alert('Node not found in path "'+tagpath+'"')
	}
}


function init(){
    /*************************************************************************************
    Function:       init

    author:         djoham@yahoo.com

    description:
		sets up the DOM object
    ************************************************************************************/
	objDom.loadXML(document.getElementById("xmldata").value);
} // end function init()

