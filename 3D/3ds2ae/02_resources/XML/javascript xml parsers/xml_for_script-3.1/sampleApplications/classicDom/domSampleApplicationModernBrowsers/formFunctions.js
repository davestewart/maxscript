

// =========================================================================
//
// formFuntions.js - the functionality behind contactManager.html
//
// =========================================================================
//
// Copyright (C) 2001 - David Joham (djoham@yahoo.com)
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
var gCurrentContactOrdinal = 0;

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

    author:         djoham@yahoo.com

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
    if (gobjDatabaseDomTree.getElements("CONTACT").length != 0 ) {
        displayUserData(gCurrentContact);
    }

    //set the buttons correctly
    docRef.cmdAddNew.disabled = false;
    docRef.cmdCancel.disabled = true;
    docRef.cmdSave.disabled = true;

    if (gobjDatabaseDomTree.getElements("CONTACT").length == 0 ) {
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

    author:         djoham@yahoo.com

    description:
        This is the event handler for the Delete button

    ************************************************************************************/
    var id = docRef.txtID.value;
    if (confirm("Are you sure you would like to delete the user\n" + docRef.txtFirstName.value + " " + docRef.txtLastName.value + "?") == true ) {
        // get the previous user if not at the start of the list. Otherwise, get the next

        clearForm();

        resetDom(gobjDatabaseDom.removeNodeFromTree(gCurrentContact))

        if (gCurrentContactOrdinal > 0 ) {
            navigateUserList("previous");
        }
        else {
            navigateUserList("current");
        }


        //now set the buttons appropriately
        docRef.cmdAddNew.disabled = false;

        //if there are no users left, don't enable the edit or delete
        if (gobjDatabaseDomTree.getElements("CONTACT").length != 0 ) {
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

    author:         djoham@yahoo.com

    description:
        This is the event handler for the save button

    ************************************************************************************/
    var strOKSave = checkSaveStatus();
    if (strOKSave == "OK_SAVE") {
        var firstName = convertToEscapes(docRef.txtFirstName.value);
        var lastName = convertToEscapes(docRef.txtLastName.value);
        var address = convertToEscapes(docRef.txtAddress.value);
        var city = convertToEscapes(docRef.txtCity.value);
        var state = convertToEscapes(docRef.txtState.value);
        var zip = convertToEscapes(docRef.txtZip.value);
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

        var strXML = "<FIRSTNAME>" + firstName + "</FIRSTNAME>";
        strXML += "<LASTNAME>" + lastName + "</LASTNAME>";
        strXML += "<ADDRESS>" + address + "</ADDRESS>";
        strXML += "<CITY>" + city + "</CITY>";
        strXML += "<STATE>" + state + "</STATE>";
        strXML += "<ZIPCODE>" + zip + "</ZIPCODE>";


        if (gEditStatus == "edit") {

            resetDom(gobjDatabaseDom.replaceNodeContents(gCurrentContact, strXML));
            navigateUserList("current");

        }
        else {
            //create the new node - add in the open and close tag as in this case
            //we need to create the entire tag
            strXML = "<CONTACT id=\"" + id + "\">" + strXML + "</CONTACT>";

            var newNode = gobjDatabaseDom.createXMLNode(strXML);

            //now add the user to the list, after the one currently selected
            //(if there is one currently selected. If not, insert into)
            if (gobjDatabaseDomTree.getElements("CONTACT").length == 0) {
                //nobody in the list. Do insertInto
                gobjDatbaseDom = gobjDatabaseDom.insertNodeInto(gCurrentContact, newNode);
                gobjDatabaseDomTree = gobjDatabaseDom.docNode;
                navigateUserList("first");
            }
            else {
                resetDom(gobjDatabaseDom.insertNodeAfter(gCurrentContact, newNode));
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

    author:         djoham@yahoo.com

    description:
        Clears the form and populates it with the values from the node
        object passed in

    ************************************************************************************/
    clearForm();

    // the XML parser preserves spaces. In this case, we don't want this, so trim them
    docRef.txtFirstName.value = trim(user.getElements("FIRSTNAME")[0].getText(),true, true);
    docRef.txtLastName.value = trim(user.getElements("LASTNAME")[0].getText(), true, true);
    docRef.txtAddress.value = trim(user.getElements("ADDRESS")[0].getText(), true, true);
    docRef.txtCity.value = trim(user.getElements("CITY")[0].getText(), true, true);
    docRef.txtState.value = trim(user.getElements("STATE")[0].getText(), true, true);
    docRef.txtZip.value = trim(user.getElements("ZIPCODE")[0].getText(), true, true);
    docRef.txtID.value = trim(user.getAttribute("id"), true, true);

} // end function displayUserData

function getContactByOrdinalValue(value){
    /*************************************************************************************
    Function:       getContactByOrdinalValue

    author:         djoham@yahoo.com

    description:
        Gets the (value)th node in the contact tree

    ************************************************************************************/

    var tmpNode = gobjDatabaseDomTree.getElements("CONTACT")[value];
    gCurrentContactOrdinal = value;
    return tmpNode;


} // end function getContactByOrdinalValue


function formInit() {
    /*************************************************************************************
    Function:       formInit()

    author:         djoham@yahoo.com

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
    gobjDatabaseDom = new XMLDoc(docRef.txtDatabase.value, xmlError);
    gobjDatabaseDomTree = gobjDatabaseDom.docNode;

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

    author:         djoham@yahoo.com

    description:
        Calls the userlist object (as appropriate) to get the requested
        user object

    ************************************************************************************/


    var objUser;
    switch (direction) {
        case "next":
            objUser = getContactByOrdinalValue(gCurrentContactOrdinal + 1);
            break;

        case "previous":
            objUser = getContactByOrdinalValue(gCurrentContactOrdinal - 1);
            break;

        case "first":
            objUser = getContactByOrdinalValue(0);
            break;

        case "last":
            objUser = getContactByOrdinalValue(gobjDatabaseDomTree.getElements("CONTACT").length -1);
            break;

        case "current":
            objUser = getContactByOrdinalValue(gCurrentContactOrdinal);
            break;


    } // end switch

    //set the global currently displayed user
    gCurrentContact = objUser;

    //if objUser isn't null set the form
    if (objUser != null ) {
        displayUserData(objUser);
    }

    //decide what to do with the navigation forms
    setNavigationButtonStateForEOFandBOF();

} // end function navigateUserList

function resetDom(newDom) {
    /*************************************************************************************
    Function:       resetDom

    author:         djoham@yahoo.com

    description:
        Sets the global Dom to the the dom passed in and the global dom tree
        to be it's docNode

    ************************************************************************************/

    gobjDatabaseDom = newDom
    gobjDatabaseDomTree = gobjDatabaseDom.docNode;

} // end function resetDom

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

    author:         djoham@yahoo.com

    description:
        I could *not* think of a better name for this function :)
        Checks to see if we're at the first or last contact in the list
        and enables/disables the navigation buttons appropriatly
    ************************************************************************************/

    if (gCurrentContactOrdinal == 0 ) {
        //we're on the first record
        docRef.cmdMoveFirst.disabled = true;
        docRef.cmdMovePrevious.disabled = true;
    }
    else {
        docRef.cmdMoveFirst.disabled = false;
        docRef.cmdMovePrevious.disabled = false;
    }


    if (gCurrentContactOrdinal >= gobjDatabaseDomTree.getElements("CONTACT").length -1) {
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