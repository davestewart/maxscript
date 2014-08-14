{
	// This script creates and shows a floating palette.
	// The floating palette contains buttons that launch a variety of
	// demo scripts.
	
	// Called when a button is pressed, to invoke its associated script
	function onHelpButtonClick()
	{
		alert("Click a button to run one of the following scripts:\n\n"  +
			"Find and Replace:\n"+
			"       Launches a UI to find and replace text values.\n" +
			"       Finds and replaces text within values and keyframe values of\n" +
                        "       selected text layers of the active comp.\n" +
			"Velocity Arrows:\n" +
			"       Creates one new layer for each selected layer in the active comp.\n" +
			"       Each layer contains an arrow that gives velocity feedback.\n" +
			"       The position of the arrow tracks the selection;\n" +
                        "       the rotation and scale of the arrow indicate the selection's velocity.\n" +
			"Scale Comp:\n" +
			"       Launches a UI to scale the active comp.\n" +
			"       Scales all layers, including cameras, and also the comp dimensions.\n" +
			"Scale Selected Layers:\n" +
			"       Launches a UI to scale the selected layers of the active comp.\n" +
			"       Scales all selected layers, including cameras.\n" +
			"Reverse Layer Order:\n" +
			"       Reverses the order of all layers in the active comp.\n" +
			"Sort by Inpoint:\n"+
			"       Reorders all layers in the active comp by inpoint.\n" +
			"Duplicate with Children:\n"+
			"       Duplicates the selected layer and recursively duplicates all layers that are parented to that layer\n" +
			"       Requires a single selected layer in the active comp.\n"+
			"Gravity:\n"+
			"       Launches a UI to create a gravity and bounce simulation.\n" +
			"       Requires a single selected layer in the active comp.\n"+
			"Cineon Adjust:\n"+
			"       Creates an adjustment guide layer in the active comp.\n" +
			"       The layer has a Cineon Converter effect with Gamma = 2.2 on windows,\n" +
			"       or Gamma = 1.7 on macintosh.  Highlight Rolloff = 0 on both platforms.\n" +
			"Shapetime Insanity:\n"+
			"       Creates a new comp containing hollow squares, rings, and triangles,\n" +
			"       with keyframes for random position, rotation, opacity and scale.\n"+
			""
		      );
	}

	// This function adds a new help button to the palette
	function addHelpButton(palette, buttonRect)
	{
		var newButton = palette.add("button", buttonRect, "?");
		newButton.onClick = onHelpButtonClick;
		return newButton;
	}

	// Called when a button is pressed, to invoke its associated script
	function onScriptButtonClick()
	{
		var prevCurrentFolder = Folder.current;
		Folder.current = this.currentDirectory;

		// The scriptFile variable was set during addButton.
		// Run the script by opening it, reading it, and evaluating its contents.
		var scriptFile = new File(this.scriptFileName);
		scriptFile.open();
		eval(scriptFile.read());
		scriptFile.close();

		Folder.current = prevCurrentFolder;
	}

	// This function adds a new script-launching button to the palette
	function addScriptButton(palette, buttonRect, buttonLabel, buttonCurrentDirectory, buttonScriptName)
	{
		var newButton = palette.add("button", buttonRect, buttonLabel);

		// JavaScript has an unusual but useful bit of functionality.
		// You can just assign a value to a new variable name and JS will
		// store it for you. The lines below create new variables named
		// scriptName and currentDirectory within newButton, and sets them
		// to buttonScriptName and myCurrentDirectory.
		// Later, in the onButtonClick() callback, the button will first
		// re-establish the current directory, then load and
		// run that file.
		newButton.scriptFileName   = buttonScriptName;
		newButton.currentDirectory = buttonCurrentDirectory;

		newButton.onClick = onScriptButtonClick;
		return newButton;
	}

	function isSecurityPrefSet()
	{
		var securitySetting = app.preferences.getPrefAsLong("Main Pref Section",
						"Pref_SCRIPTING_FILE_NETWORK_SECURITY");
		return (securitySetting == 1);
	}

	if (isSecurityPrefSet() == true) {
		//
		// Save the value of the current directory.
		// -- In some cases, the current directory value is lost when button and other
		// callbacks are invoked from a floating palette.
		// -- Some of the buttons in the demo palette need to read other script
		// files.  The most convenient notation for the filenames is to specify them
		// relative to the current directory. And if the current directory is set wrong,
		// then the nested scripts will fail to run correctly.
		// -- to fix this, save the current directory now, and make sure to 
		// re-establish it during onScriptButtonClick(). This will insure that the 
		// files run during onScriptButtonClick() can properly read other script files.
		//
		var myDirectory = Folder.current;
		var demosDirectory = new Folder(myDirectory.absoluteURI + "/(demos)");

		// Horizontal Spacing variables
		var left_margin_width    = 5;
		var right_margin_width   = 5;
		var between_button_width = 5;

		// Width of buttons depends on platform and language
		var button_width;
		if (system.osName.indexOf("Windows") != -1) {
			// Windows system has narrower buttons.
			button_width = 105;
		} else {
			// Mac has wider buttons
			button_width = 120;
		}
		if (app.language == Language.JAPANESE) {
			// Add 20 pixels for japanese machines, default font is wider
			button_width += 17;
		}

		var l_button_left  = left_margin_width;
		var l_button_right = l_button_left + button_width;
                var r_button_left  = l_button_right + between_button_width;
                var r_button_right = r_button_left + button_width;
		var palette_width  = r_button_right + right_margin_width;

		// Create and show a floating palette
		//
		var my_palette = new Window("palette","Script Demos");
		my_palette.bounds = [300,100,300+palette_width,255];
		var button1 = addScriptButton(my_palette,[l_button_left,   5, l_button_right, 25], 
				"Find and Replace",    demosDirectory, "FindAndReplaceText.jsx");
		var button2 = addScriptButton(my_palette,[r_button_left,  5, r_button_right, 25], 
				"Velocity Arrows",     demosDirectory, "VelocityArrows.jsx");

		var button3 = addScriptButton(my_palette,[l_button_left,  30, l_button_right, 50], 
				"Scale Comp", 		demosDirectory, "ScaleComp.jsx");
		var button4 = addScriptButton(my_palette,[r_button_left,  30, r_button_right, 50], 
				"Scale Selected Layers", demosDirectory, "ScaleSelectedLayers.jsx");

		var button5 = addScriptButton(my_palette,[l_button_left,  55, l_button_right, 75], 
				"Reverse Layer Order", demosDirectory, "ReverseLayerOrder.jsx");
		var button6 = addScriptButton(my_palette,[r_button_left,  55, r_button_right, 75], 
				"Sort by Inpoint",     demosDirectory, "SortByInpoint.jsx");

		var button7 = addScriptButton(my_palette,[l_button_left,  80, l_button_right, 100], 
				"Duplicate with Children",   demosDirectory, "DuplicateWithChildren.jsx");
		var button8 = addScriptButton(my_palette,[r_button_left,  80, r_button_right, 100], 
				"Render and Email",    myDirectory,    "Render_and_email.jsx");

		var button9 = addScriptButton(my_palette,[l_button_left,  105, l_button_right, 125], 
				"Gravity",   		demosDirectory, "Gravity.jsx");
		var button10 = addScriptButton(my_palette,[r_button_left,  105, r_button_right, 125], 
				"Cineon Adjust",       demosDirectory, "CineonAdjust.jsx");

		var button11 = addScriptButton(my_palette,[l_button_left,  130, l_button_right, 150], 
				"Shapetime Insanity",   demosDirectory, "ShapetimeInsanity.jsx");
		var button12 = addHelpButton(  my_palette,[r_button_left,  130, r_button_right, 150]);

		my_palette.show();
	} else {
		alert ("This demo requires the scripting security preference to be set.\n" +
			"Go to the \"General\" panel of your application preferences,\n" +
			"and make sure that \"Allow Scripts to Write Files and Access Network\" is checked.");
	}
}
