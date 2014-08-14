{
	// This script finds and/or replaces text in all the selected text layers.
	// 
	// It presents a UI with two text entry areas, one for a "find" string,
	// and one for a "replace" string.
	//
	// When the user clicks the "Find All" button, then the selection is modified 
	// to include only those text layers that include the "find" string as a text 
	// value.  Values in all keyframes will be examined.
	//
	// When the user clicks the "Replace All" button, the selection is modified as
	// in "Find All", and all instances of "find" string are replaced with the 
	// "replace" string. Values in all keyframes will be replaced.
	//
	// A button labeled "?" provides a brief explanation.

	var myFindString    = "";
	var myReplaceString = "";

	// This function is used during "Find All"
	// It deselects the layer if it is not a text layer, or if it does not
	// contain the find string.
	function deselectLayerIfFindStringNotFound(theLayer, findString)
	{
		var foundIt = false;

		// Get the sourceText property, if there is one.
		var sourceText = theLayer.sourceText;
		if (sourceText != null) {
			if (sourceText.numKeys == 0) {
				// textValue is a TextDocument. Check the string inside
				if (sourceText.value.text.indexOf(findString) != -1) {
					foundIt = true;
				}
			} else {
				// Do it for each keyframe:
				for (var keyIndex = 1; keyIndex <= sourceText.numKeys; keyIndex++) {
					// textValue is a TextDocument. Check the string inside
					var oldString = sourceText.keyValue(keyIndex).text;
					if (sourceText.keyValue(keyIndex).text.indexOf(findString) != -1) {
						foundIt = true;
						break;
					}
				}
			}
		}
		// Deselect if necessary
		if (foundIt == false) {
			theLayer.selected = false;
		}
	}

	// This function is called when the "Find All" button is clicked.
	// It narrows the set of selected layers within the active comp.
	// Only text layers containing the "Find String" will remain selected.
	function onFindAll()
	{
		// Show a message and return if there is no find string.
		if (myFindString == "") {
			alert("Find string is the empty string. The selection was not changed");
			return;
		}

		// Start an undo group.  By using this with an endUndoGroup(), you
		// allow users to undo the whole script with one undo operation.
		app.beginUndoGroup("Find All");

		// Get the active comp
		var activeItem = app.project.activeItem;
		if (activeItem != null && (activeItem instanceof CompItem)){
			
			// check each selected layer in the active comp
			var activeComp = activeItem;
			var selectedLayers = activeComp.selectedLayers;
			for (var i = 0; i < selectedLayers.length; i++) {
				deselectLayerIfFindStringNotFound(selectedLayers[i], myFindString);
			}
		}
		app.endUndoGroup();
	}

	// This function takes totalString and replaces all instances of 
	// findString with replaceString.
	// Returns the changed string.
	function replaceTextInString(totalString, findString, replaceString)
	{
		// Use a regular expression for the replace.
		// The "g" flag will direct the replace() method to change all instances
		// of the findString instead of just the first.
		var regularExpression = new RegExp(findString,"g");
		var newString = totalString.replace(regularExpression, replaceString);
		return newString;
	}

	// This function replaces findString with replaceString in the layer's 
	// sourceText property.
	// The method changes all keyframes, if there are keyframes, or just 
	// the value, if there are not keyframes.
	function replaceTextInLayer(theLayer, findString, replaceString)
	{
		var changedSomething = false;

		// Get the sourceText property, if there is one.
		var sourceText = theLayer.sourceText;
		if (sourceText != null) {
			if (sourceText.numKeys == 0) {
				// textValue is a TextDocument. Retrieve the string inside
				var oldString = sourceText.value.text;
				if (oldString.indexOf(findString) != -1) {
					var newString = replaceTextInString(oldString, findString, replaceString);
					if (oldString != newString) {
						sourceText.setValue(newString);
						changedSomething = true;
					}
				}
			} else {
				// Do it for each keyframe:
				for (var keyIndex = 1; keyIndex <= sourceText.numKeys; keyIndex++) {
					// textValue is a TextDocument. Retrieve the string inside
					var oldString = sourceText.keyValue(keyIndex).text;
					if (oldString.indexOf(findString) != -1) {
						var newString = replaceTextInString(oldString, findString, replaceString);
						if (oldString != newString) {
							sourceText.setValueAtKey(keyIndex,newString);
							changedSomething = true;
						}
					}
				}
			}
		}
		// Return a boolean saying whether we replaced the text
		return changedSomething;
	}

	// Called when the "Replace All" button is clicked
	// Replaces the "Find String" with the "Replace String" everywhere within 
	// the set of selected layers.  Does not change the selected flag of any layers.
	function onReplaceAll()
	{
		// Show a message and return if there is no find string.
		if (myFindString == "") {
			alert("Find string is the empty string. No changes were made");
			return;
		}

		// Start an undo group.  By using this with an endUndoGroup(), you
		// allow users to undo the whole script with one undo operation.
		app.beginUndoGroup("Replace All");

		// If we don't make any changes, we'll put up an alert at the end.
		var numLayersChanged = 0;

		// Get the active comp
		var activeItem = app.project.activeItem;
		if (activeItem != null && (activeItem instanceof CompItem)){
			
			var activeComp = activeItem;
			
			// try to apply to every selected layer
			var selectedLayers = activeComp.selectedLayers;
			for (var i = 0; i < selectedLayers.length; i++) {

				var curLayer = selectedLayers[i];

				// The method returns true if it changes any text, false otherwise.
				if (replaceTextInLayer(curLayer, myFindString, myReplaceString) == true) {
					numLayersChanged++;
				}
			}
		}
		// Print a message if no layers were affected
		if (numLayersChanged == 0) {
			// Note: if you put quotes in the interior of the string,
			// they must be preceded by a backslash, as in \"blue\" below.
			alert("The string " + myFindString + " was not found in any of the selected layers. No changes were made");
		}

		app.endUndoGroup();
	}

	// Called when the "Find String" is edited
	function onFindStringChanged()
	{
		myFindString = this.text;
	}

	// Called when the "Replace String" is edited
	function onReplaceStringChanged()
	{
		myReplaceString = this.text;
	}

	// Called when the "?" button is clicked
	function onShowHelp()
	{
		alert("Click \"Find All\" to narrow the selected layers to include only those\n" +
		      "    text layers containing the \"Find String\" in a value or keyframe value.\n" +
		      "Click \"Replace All\" to replace all instances of \"Find String\" with \"Replace String\";\n" +
                      "    replacements are made only within selected text layers, and the selection remains unchanged.\n" +
                      "    Text is replaced in all values of all keyframes of selected text layers");
	}

	// Create and show a floating palette
	//
	var my_palette = new Window("palette","Find and Replace");
	my_palette.bounds = [300,100,520,200];

	// "Find String" label and text entry
	my_palette.add("statictext", [10, 20, 88, 40], "Find String:");
	var findEditText = my_palette.add("edittext", [88,20,210, 40],   "");
	findEditText.onChange = onFindStringChanged;

	// "Replace String" label and text entry
	my_palette.add("statictext", [10, 45, 88, 65], "Replace String:");
	var replaceEditText = my_palette.add("edittext", [88,45,210, 65],   "");
	replaceEditText.onChange = onReplaceStringChanged;

	// "Find All", "Replace All" and "?" Buttons
	var findButton    = my_palette.add("button", [5, 70, 80,90], "Find All");
	var replaceButton = my_palette.add("button", [85, 70,165,90], "Replace All");
	var helpButton    = my_palette.add("button", [170,70,210,90], "?");
	findButton.onClick    = onFindAll;
	replaceButton.onClick = onReplaceAll;
	helpButton.onClick    = onShowHelp;

	my_palette.show();
}
