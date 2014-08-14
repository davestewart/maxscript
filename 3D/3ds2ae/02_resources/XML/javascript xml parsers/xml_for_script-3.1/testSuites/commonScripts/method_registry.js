// =========================================================================
//
// method_registry.js - object used to track object.method QA status
//
// =========================================================================
//
// Copyright (C) 2003 - Jon van Noort (jon@webarcana.com.au)
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

function method_registry() {
  /*****************************************************************************
  class : method_registry
  author: jon@webarcana.com.au

  description:
	object used to track object.method QA status. 
	
	Test functions use DOM methods in preparation for the focus of the test.
	The method_registry allows the Test Suite to keep track of which methods have been
	'Certified'. If the method has not been certified, or failed any of its test, the 
	test functions that are dependant on the uncertified method will stop and generate 
	a "Failed Dependancies" warning.
	
  *****************************************************************************/

  this.register = new Array();   // the array of 'Class' collections
}

method_registry.prototype.setMethodStatus = function (className, methodName, status) {
/*****************************************************************************
method: setMethodStatus
author: jon@webarcana.com.au

description:
used to 'Certify' or 'UnCertify' the specified Class.Method

params:
  className  : string // the name of the class
  methodName : string // the name of the method
  status     : bool   // the status of the method (true = Functional, false = NonFunctional)
*****************************************************************************/

  if (!this.register[className]) {
    this.register[className] =  new Array();
  }
  this.register[className][methodName] = status;
} ;

method_registry.prototype.getMethodStatus = function (className, methodName) {
/*****************************************************************************
method: setMethodStatus
author: jon@webarcana.com.au

description:
used to 'Certify' or 'UnCertify' the specified Class.Method

params:
  className  : string // the name of the class
  methodName : string // the name of the method

returns      : bool   // the status of the method (true = Functional, false = NonFunctional)
*****************************************************************************/
  return (this.register[className] && this.register[className][methodName]);
} ;
