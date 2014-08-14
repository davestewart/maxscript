

// =========================================================================
//
// formFuntions.js - the functionality behind contactManager.html
//
// =========================================================================
//
// Copyright (C) 2001, 2003 - David Joham (djoham@yahoo.com)
//                          - Jon van Noort (jon@webarcana.com.au)
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





//page level variables
var docRef = document.frmContactManager;
var gEditStatus = "";
var gCurrentContact;
var gobjDatabaseDom;
var gobjDatabaseDomTree;


var contactNodeSet;

function checkSaveStatus() {
    /*************************************************************************************
    Function:       checkSaveStatus()

    author:         djoham@yahoo.com

    description:
        This function checks to see if all of the fields are present
        in the properties and that the zip code is numeric. If the
        rules are met, returns OK_SAVE. Otherwise, returns
        an error condition

    ************************************************************************************/

    var strRet = "OK_SAVE"; // assume things are OK

    //check first name
    if (trim(docRef.txtFirstName.value, true, true) == "") {
        strRet = "First Name Required";
        return strRet;
    }

    if (trim(docRef.txtLastName.value, true, true) == "") {
        strRet = "Last Name Required";
        return strRet;
    }

    if (trim(docRef.txtAddress.value, true, true) == "") {
        strRet = "Address Required";
        return strRet;
    }

    if (trim(docRef.txtCity.value, true, true) == "") {
        strRet = "City Required";
        return strRet;
    }

    if (trim(docRef.txtState.value, true, true) == "") {
        strRet = "State Required";
        return strRet;
    }

    if (trim(docRef.txtZip.value, true, true) == "") {
        strRet = "Zip Code Required";
        return strRet;
    }

    if (isNaN(docRef.txtZip.value) == true) {
        strRet = "Zip Code Must be Numeric";
        return strRet;
    }

    return strRet;

} // end function checkSaveStatus

function clearForm() {
    /*************************************************************************************
    Function:       clearForm()

    author:         djoham@yahoo.com

    description:
        Clears the form

    ************************************************************************************/

    docRef.txtFirstName.value = "";
    docRef.txtLastName.value = "";
    docRef.txtAddress.value = "";
    docRef.txtCity.value = "";
    docRef.txtState.value = "";
    docRef.txtZip.value = "";
    docRef.txtID.value = "";

} // end function clearForm

function cmdAddNewClicked() {
    /*************************************************************************************
    Function:       cmdAddNewClicked()

    author:         djoham@yahoo.com

    description:
        This is the event handler for the new button. Enable
        all of the edit boxes, disable the navigation and
        enable/disable the action buttons as appropriate

    ************************************************************************************/
    //set the saved UserID
    gSavedUserId = docRef.txtID.value;

    //enable the edit boxes
    setEditBoxDisabledState(false);

    //disable the navigation
    setNavigationButtonsDisabledState(true);

    //clear the form for the new user
    clearForm()

    //set the buttons to be what they need to be
    docRef.cmdAddNew.disabled = true;
    docRef.cmdEdit.disabled = true;
    docRef.cmdDelete.disabled = true;
    docRef.cmdSave.disabled = false;
    docRef.cmdCancel.disabled = false;

    //set the focus to the first name
    docRef.txtFirstName.focus();

    gEditStatus = "new";

} // end function cmdAddNewClicked

function cmdCancelClicked() {
    /*************************************************************************************
    Function:       cmdCancelClicked()

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        This is the event handler for the cancel button

    ************************************************************************************/
    //enable navigation
    setNavigationButtonsDisabledState(false);

    //disable editing
    setEditBoxDisabledState(true);

    clearForm();

    //ok here's the deal. I always want to go back to the user I was just
    //on. In the case of no contacts in the list, I don't want to do anything

    if (contactNodeSet.length != 0 ) {
        displayUserData(gCurrentContact);
    }

    //set the buttons correctly
    docRef.cmdAddNew.disabled = false;
    docRef.cmdCancel.disabled = true;
    docRef.cmdSave.disabled = true;

    if (contactNodeSet.getLength() == 0 ) {
        docRef.cmdEdit.disabled = true;
        docRef.cmdDelete.disabled = true;
    }
    else {
        docRef.cmdEdit.disabled = false;
        docRef.cmdDelete.disabled = false;
    }

    setNavigationButtonStateForEOFandBOF();


} // end function cmdCancelClicked


function cmdDeleteClicked() {
    /*************************************************************************************
    Function:       cmdDeleteClicked()

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        This is the event handler for the Delete button

    ************************************************************************************/
    var id = docRef.txtID.value;
    if (confirm("Are you sure you would like to delete the user\n" + docRef.txtFirstName.value + " " + docRef.txtLastName.value + "?") == true ) {
        // get the previous user if not at the start of the list. Otherwise, get the next

        clearForm();
        gobjDatabaseDomTree.removeChild(gCurrentContact);

        //now set the buttons appropriately

        //add new will always be enabled
        docRef.cmdAddNew.disabled = false;

        //if there are users left, enable the edit or delete
        //and navigate to the correct user
        if (gobjDatabaseDomTree.getElementsByTagName("CONTACT").length != 0 ) {
            if (gCurrentContact.getPreviousSibling() ) {
                navigateUserList("previous");
            }
            else {
                navigateUserList("next");
            }

            docRef.cmdEdit.disabled = false;
            docRef.cmdDelete.disabled = false;
        }
        else {
            //the main node now will be the CONTACTS node (which is really
            //gobjDatabaseDomTree) to allow me to
            //do a insertNodeInto when/if I do an add
            gCurrentContact = gobjDatabaseDomTree;
            docRef.cmdEdit.disabled = true;
            docRef.cmdDelete.disabled = true;
            setNavigationButtonsDisabledState(true);
        }

        docRef.cmdCancel.disabled = true;
        docRef.cmdSave.disabled = true;

    } // end confirming
} // end function cmdDeleteClicked

function cmdEditClicked() {
    /*************************************************************************************
    Function:       cmdEditClicked()

    author:         djoham@yahoo.com

    description:
        This is the event handler for the edit button

    ************************************************************************************/
    //set the saved UserID
    gSavedUserId = docRef.txtID.value;

    //disable navigation
    setNavigationButtonsDisabledState(true);

    //enable editing
    setEditBoxDisabledState(false);

    //set the buttons to be what they need to be
    docRef.cmdAddNew.disabled = true;
    docRef.cmdEdit.disabled = true;
    docRef.cmdDelete.disabled = true;
    docRef.cmdSave.disabled = false;
    docRef.cmdCancel.disabled = false;

    //set the focus to the first name
    docRef.txtFirstName.focus();

    gEditStatus = "edit";

} // end function cmdEditClicked

function cmdSaveClicked() {
    /*************************************************************************************
    Function:       cmdSaveClicked()

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        This is the event handler for the save button

    ************************************************************************************/
    var strOKSave = checkSaveStatus();
    if (strOKSave == "OK_SAVE") {

        var firstName = docRef.txtFirstName.value;
        var lastName = docRef.txtLastName.value;
        var address = docRef.txtAddress.value;
        var city = docRef.txtCity.value;
        var state = docRef.txtState.value;
        var zip = docRef.txtZip.value;
        var id;

        if (gEditStatus == "edit" ) {
            //we're editing. Set the id for the user object
            id = gCurrentContact.getAttribute("id");
        }
        else {
            //I need a new ID. The number of seconds since 1970 will do
            id = new Date().getTime();
        }

        //now try to save it by constructing the node as necessary
        //the edit (replaceNodeContents doesn't need the open and close CONTACT tags,
        //in fact, if you put them there bad things happen. replaceNodeContents
        //maintains the CONTACT tag's attributes, so all we need to do
        //is replace the data inside.


        if (gEditStatus == "edit") {
          with (gCurrentContact) {
            getElementsByTagName("FIRSTNAME").item(0).getFirstChild().setNodeValue(firstName);
            getElementsByTagName("LASTNAME").item(0).getFirstChild().setNodeValue(lastName);
            getElementsByTagName("ADDRESS").item(0).getFirstChild().setNodeValue(address);
            getElementsByTagName("CITY").item(0).getFirstChild().setNodeValue(city);
            getElementsByTagName("STATE").item(0).getFirstChild().setNodeValue(state);
            getElementsByTagName("ZIPCODE").item(0).getFirstChild().setNodeValue(zip);
          }
          navigateUserList("current");
        }
        else {
            // create new Contact Node
            var newContactNode = gobjDatabaseDom.createElement('CONTACT');

            // create id attribute
            newContactNode.setAttribute('id', id);

            // create FIRSTNAME node + text node containing value
            var newFirstnameNode = gobjDatabaseDom.createElement('FIRSTNAME');
            newFirstnameNode.appendChild(gobjDatabaseDom.createTextNode(firstName));
            newContactNode.appendChild(newFirstnameNode);

            // create LASTNAME node + text node containing value
            var newLastnameNode = gobjDatabaseDom.createElement('LASTNAME');
            newLastnameNode.appendChild(gobjDatabaseDom.createTextNode(lastName));
            newContactNode.appendChild(newLastnameNode);

            // create ADDRESS node + text node containing value
            var newAddressNode = gobjDatabaseDom.createElement('ADDRESS');
            newAddressNode.appendChild(gobjDatabaseDom.createTextNode(address));
            newContactNode.appendChild(newAddressNode);

            // create CITY node + text node containing value
            var newCityNode = gobjDatabaseDom.createElement('CITY');
            newCityNode.appendChild(gobjDatabaseDom.createTextNode(city));
            newContactNode.appendChild(newCityNode);

            // create STATE node + text node containing value
            var newStateNode = gobjDatabaseDom.createElement('STATE');
            newStateNode.appendChild(gobjDatabaseDom.createTextNode(state));
            newContactNode.appendChild(newStateNode);

            // create ZIPCODE node + text node containing value
            var newZipcodeNode = gobjDatabaseDom.createElement('ZIPCODE');
            newZipcodeNode.appendChild(gobjDatabaseDom.createTextNode(zip));
            newContactNode.appendChild(newZipcodeNode);

            //now add the user to the list, after the one currently selected
            //(if there is one currently selected. If not, insert into)
            if (gobjDatabaseDomTree.getElementsByTagName("CONTACT").getLength() == 0) {

                //nobody in the list.
                gobjDatabaseDomTree.appendChild(newContactNode);

                navigateUserList("first");
            }
            else {
                var nextSib = gCurrentContact.getNextSibling();
                if (nextSib) {
                  gobjDatabaseDomTree.insertBefore(newContactNode, nextSib);
                }
                else {
                  gobjDatabaseDomTree.appendChild(newContactNode);
                }
                navigateUserList("next");
            }
        }

        //disable the edit boxes
        setEditBoxDisabledState(true);

        //enable the command buttons as appropriate
        docRef.cmdAddNew.disabled = false;
        docRef.cmdEdit.disabled = false;
        docRef.cmdDelete.disabled = false;
        docRef.cmdCancel.disabled = true;
        docRef.cmdSave.disabled = true;

    }
    else {
        alert("I was unable to save the user.\nThe error message reported was:\n" + strOKSave);
    }

} // end function cmdSaveClicked


function displayUserData(user) {
    /*************************************************************************************
    Function:       displayUserData()

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        Clears the form and populates it with the values from the node
        object passed in

    ************************************************************************************/
    clearForm();

    // the XML parser preserves spaces. In this case, we don't want this, so trim them
    docRef.txtFirstName.value = trim(user.getElementsByTagName("FIRSTNAME").item(0).getFirstChild().getNodeValue(),true, true);
    docRef.txtLastName.value = trim(user.getElementsByTagName("LASTNAME").item(0).getFirstChild().getNodeValue(), true, true);
    docRef.txtAddress.value = trim(user.getElementsByTagName("ADDRESS").item(0).getFirstChild().getNodeValue(), true, true);
    docRef.txtCity.value = trim(user.getElementsByTagName("CITY").item(0).getFirstChild().getNodeValue(), true, true);
    docRef.txtState.value = trim(user.getElementsByTagName("STATE").item(0).getFirstChild().getNodeValue(), true, true);
    docRef.txtZip.value = trim(user.getElementsByTagName("ZIPCODE").item(0).getFirstChild().getNodeValue(), true, true);
    docRef.txtID.value = trim(user.getAttribute("id"), true, true);

} // end function displayUserData


function formInit() {
    /*************************************************************************************
    Function:       formInit()

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        Called when the application is first launched. Sets up
        objects and form controls

    ************************************************************************************/
    //the application is 800px wide and 500px tall
    var xPos = screen.width/2 - 400;
    var yPos = screen.height/2 -255;

    window.moveTo(xPos,yPos);

    //first set up the database object. In this test case, I know I have data,
    //in real-world cases, we would want to check

    var parser = new DOMImplementation();
    gobjDatabaseDom = parser.loadXML(docRef.txtDatabase.value);
    gobjDatabaseDomTree = gobjDatabaseDom.getDocumentElement();

    //display the first contact
    navigateUserList("first");

    // enable the add new button
    docRef.cmdAddNew.disabled = false;
    docRef.cmdEdit.disabled = false;
    docRef.cmdDelete.disabled = false;

} // end function formInit


function navigateUserList(direction) {
    /*************************************************************************************
    Function:       navigateUserList

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        Calls the userlist object (as appropriate) to get the requested
        user object

    ************************************************************************************/

    switch (direction) {
        case "next":
            gCurrentContact = gCurrentContact.getNextSibling();
            break;

        case "previous":
            gCurrentContact = gCurrentContact.getPreviousSibling();
            break;

        case "first":
            contactNodeSet = gobjDatabaseDomTree.getChildNodes();
            gCurrentContact = contactNodeSet.item(0);
            break;

        case "last":
            gCurrentContact = contactNodeSet.item(contactNodeSet.getLength() -1);
            break;

    } // end switch


    if (gCurrentContact != null ) {
        displayUserData(gCurrentContact);
    }

    //decide what to do with the navigation forms
    setNavigationButtonStateForEOFandBOF();

} // end function navigateUserList


function setEditBoxDisabledState(state) {
    /*************************************************************************************
    Function:       setEditBoxDisabledState()

    author:         djoham@yahoo.com

    description:
        Sets the edit boxes to be the state passed in

    ************************************************************************************/

    docRef.txtFirstName.disabled = state;
    docRef.txtLastName.disabled = state;
    docRef.txtAddress.disabled = state;
    docRef.txtCity.disabled = state;
    docRef.txtState.disabled = state;
    docRef.txtZip.disabled = state;

} // end function setEditBoxDisabledState


function setNavigationButtonsDisabledState (state) {
    /*************************************************************************************
    Function:       setNavigationButtonsDisabledState()

    author:         djoham@yahoo.com

    description:
        Sets the navigation buttons to be the state passed in

    ************************************************************************************/

    docRef.cmdMoveFirst.disabled = state;
    docRef.cmdMovePrevious.disabled = state;
    docRef.cmdMoveNext.disabled = state;
    docRef.cmdMoveLast.disabled = state;

} // end function setNavigationButtonDisabledState


function setNavigationButtonStateForEOFandBOF() {
    /*************************************************************************************
    Function:       setNavigationButtonStateForEOFandBOF

    author:         djoham@yahoo.com & jon@webarcana.com.au

    description:
        I could *not* think of a better name for this function :)
        Checks to see if we're at the first or last contact in the list
        and enables/disables the navigation buttons appropriatly
    ************************************************************************************/

    if (!gCurrentContact.getPreviousSibling()) {
        //we're on the first record
        docRef.cmdMoveFirst.disabled = true;
        docRef.cmdMovePrevious.disabled = true;
    }
    else {
        docRef.cmdMoveFirst.disabled = false;
        docRef.cmdMovePrevious.disabled = false;
    }


    if (!gCurrentContact.getNextSibling()) {
        //we're on the last record
        docRef.cmdMoveLast.disabled = true;
        docRef.cmdMoveNext.disabled = true;
    }
    else {
        docRef.cmdMoveLast.disabled = false;
        docRef.cmdMoveNext.disabled = false;
    }

} // end function setNavigationButtonStateForEOFandBOF


function xmlError(e) {
    /*************************************************************************************
    Function:       xmlError

    author:         djoham@yahoo.com

    description:
        Sets the navigation buttons to be the state passed in

    ************************************************************************************/
    alert("There has been an error accessing the XML Database. The error is:\n" + e)
} // end function xmlError

