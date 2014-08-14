{
	function GravityUI() 
	{

		// Read and evaluate all the files that contain libraries of methods used by this script.
		this.includeScripts = [ "lib/vectorMath.jsx", "lib/bouncingBallSimulation.jsx" ];
		for (var i = 0; i < this.includeScripts.length; i++) {
			var scriptFile = new File(this.includeScripts[i]);
			scriptFile.open();
			eval(scriptFile.read());
			scriptFile.close();
		}

		function on_run_click() 
		{
			if (app.project == null) {
				alert("Please open a project, establish an active comp, select at least one layer, and run again.");
				return;
			}
			var activeItem = app.project.activeItem;
			if (activeItem == null || !(activeItem instanceof CompItem)) {
				alert("Please establish an active comp, select at least one layer, and run again.");
				return;
			}
			var activeComp = activeItem;
			var selectedLayers = activeComp.selectedLayers;
			if (selectedLayers == null || selectedLayers.length < 1) {
				alert("Please select at least one layer and run again.");
				return;
			}
			
			for (var i = 0; i < selectedLayers.length; i++) {
				gravityUI.bouncingBallSimulation.setBallLayer(selectedLayers[i]);

				gravityUI.bouncingBallSimulation.startTime     = activeComp.workAreaStart;
				gravityUI.bouncingBallSimulation.endTime       = activeComp.workAreaStart + activeComp.workAreaDuration;
				gravityUI.bouncingBallSimulation.frameRate     = activeComp.frameRate;
				gravityUI.bouncingBallSimulation.frameDuration = activeComp.frameDuration;

				if (gravityUI.comp_bounds_radio.value == true) {
					gravityUI.bouncingBallSimulation.setBounds(0,activeComp.width,0,activeComp.height);
				} else {
					with(gravityUI) {
						bouncingBallSimulation.setBounds(custom_left, custom_right, custom_top, custom_bottom);
					}
				}

				gravityUI.bouncingBallSimulation.runSimulation();
				gravityUI.bouncingBallSimulation.setBallLayer(null);
			}
		}

		function on_help_click() 
		{
			// Too much help to show in one alert!
			// Show it in 3 successive windows

		   var view_more = confirm("Gravity Demo\n\n" +
		      "This demo runs a 2D simulation of objects bouncing inside a box-shaped enclosure.\n"  +
		      "The simulation is performed on each selected layer in the active comp.\n\n" +
		      "Run Simulation:\n" +
		      "    Press this button to generate keyframes for each layer, based on the.\n\n" +
		      "View more help?");
		   if (view_more) {
		      view_more = confirm("Parameters controlled with this UI:\n\n" +
			  "Bounds:\n" +
			  "    The bounds specify walls against which the objects will bounce. " +
			  "Choose \"Comp Bounds\" to bounce against the edges of the active comp. " +
			  "Choose \"Custom Bounds\" and you can edit the left, right, top, and bottom " +
			  "bounds of the enclosure.\n\n" +
			  "Drag:\n" +
			  "    Corresponds to air resistance. A value of 0 means no air resistance. " +
			  "Higher values will exert a force that acts opposite the direction of travel.\n\n" +
			  "Elasticity:\n" +
			  "    Controls the amount of energy retained when the object bounces against a wall. " +
			  "A value of 0 means all energy is lost and the object splats to a halt. " +
			  "A value of 1 means all energy is retained, and the object bounces off at full speed.\n\n" +
			  "Gravity:\n" +
			  "    Gravity always acts in a downward direction. Higher values mean stronger gravity.\n\n" +
			  "Density:\n"+
			  "    Higher values mean denser objects. Denser objects are less affected by drag. " +
			  "Mass is calculated as density times width times height. " +
			  "Width and height are determined implicitly (see next screen).\n\n" +
			  "View more help?");
		   }
		   if (view_more) {
			alert("Parameters determined by the active comp or the layer:\n\n"+
			  "Start Time and End Time:\n"+
			  "    Keyframes are only generated between the start time and end time. " +
			  "These times will match the work area of the active comp.\n\n" +
			  "Frame Rate:\n"+
			  "    Keyframes are generated with a frequency that matches the frame rate of the active comp.\n\n" +
			  "Height and Width:\n"+
			  "    Height and width determine the edges of the object when it bounces off a wall. " +
			  "They also determine the mass of the object, calculated as area times density. " +
			  "Height and width are calculated independently for each selected layer. " +
			  "The width is the layer width multiplied by x-scale. "+
			  "The height is the layer height multiplied by y-scale.\n\n"+
			  "Start Position:\n"+
			  "    Before the simulation is run, each layer's position at the start time is recorded. " +
			  "This becomes the start position for the simulation.\n\n" +
			  "Start Velocity:\n"+
			  "    Before the simulation is run, each layer's velocity at the start time is recorded. " +
			  "This becomes the start velocity for the simulation.");
		   }
		}

		function on_comp_bounds_click()
		{
			gravityUI.left_edittext.hide();
			gravityUI.right_edittext.hide();
			gravityUI.top_edittext.hide();
			gravityUI.bottom_edittext.hide();
			gravityUI.left_displaytext.show();
			gravityUI.right_displaytext.show();
			gravityUI.top_displaytext.show();
			gravityUI.bottom_displaytext.show();
			gravityUI.updateBoundsDisplayTextFromActiveComp();
		}
	
		function on_custom_bounds_click()
		{
			gravityUI.left_edittext.show();
			gravityUI.right_edittext.show();
			gravityUI.top_edittext.show();
			gravityUI.bottom_edittext.show();
			gravityUI.left_displaytext.hide();
			gravityUI.right_displaytext.hide();
			gravityUI.top_displaytext.hide();
			gravityUI.bottom_displaytext.hide();
		}
		
		function on_custom_boundstext_click()
		{
		with(gravityUI) {
			var parsedValue = parseFloat(this.text);
			var parsesFully = !isNaN(parsedValue) && (parsedValue == this.text);

			// If the entire new value does not parse to a number, restore the saved value and return.
			//
			if (!parsesFully) {
				if (this == left_edittext) {
					this.text = custom_left;
				}
				if (this == right_edittext) {
					this.text = custom_right;
				}
				if (this == top_edittext) {
					this.text = custom_top;
				}
				if (this == bottom_edittext) {
					this.text = custom_bottom;
				}
				this.notify();
				return;
			}

			// save the changed value
			if (this == left_edittext) {
				custom_left = parsedValue;
			}
			if (this == right_edittext) {
				custom_right = parsedValue;
			}
			if (this == top_edittext) {
				custom_top = parsedValue;
			}
			if (this == bottom_edittext) {
				custom_bottom = parsedValue;
			}

			// make sure left < right and top < bottom
			if (custom_left >= custom_right) {
				if (this == left_edittext) {
					right_edittext.text = custom_left + 1;
					right_edittext.notify();
				} else {
					left_edittext.text = custom_right - 1;
					left_edittext.notify();
				}
			}
			if (custom_top >= custom_bottom) {
				if (this == top_edittext) {
					bottom_edittext.text = custom_top + 1;
					bottom_edittext.notify();
				} else {
					top_edittext.text = custom_bottom - 1;
					top_edittext.notify();
				}
			}
		} 
		}
			
		function on_drag_slider_changed()
		{
			// drag is stored in slider as [1..100], and in 
			// edittext&simulation as [0..10]
			with(gravityUI) {
				if (Math.abs(bouncingBallSimulation.drag * 10 - this.value)>0.5) {
					bouncingBallSimulation.drag = 0.1 * this.value;
					drag_edittext.text = bouncingBallSimulation.drag.toString();
					drag_edittext.notify();
				}
			}
		}
		function on_drag_text_changed()
		{
			// drag is stored in slider as [1..100], and in 
			// edittext&simulation as [0..10]
			with(gravityUI) {
				if (bouncingBallSimulation.drag != this.text) {
					bouncingBallSimulation.drag = this.text;
					drag_slider.value = this.text * 10.0;
					drag_slider.notify();
				}
			}
		}
		function on_elasticity_slider_changed()
		{
			// elasticity is stored in slider as [1..100], and in 
			// edittext&simulation as [0..1]
			with(gravityUI) {
				if (Math.abs(bouncingBallSimulation.elasticity * 100 - this.value)>0.5) {
					bouncingBallSimulation.elasticity = 0.01 * this.value;
					elasticity_edittext.text = bouncingBallSimulation.elasticity.toString();
					elasticity_edittext.notify();
				}
			}
		}
		function on_elasticity_text_changed()
		{
			// elasticity is stored in slider as [1..100], and in 
			// edittext&simulation as [0..1]
			with(gravityUI) {
				if (bouncingBallSimulation.elasticity != this.text) {
					bouncingBallSimulation.elasticity = this.text;
					elasticity_slider.value = this.text * 100.0;
					elasticity_slider.notify();
				}
			}
		}
		function on_gravity_slider_changed()
		{
			// gravity is stored in slider as [1..5000], which maps to 
			// edittext&simulation as [1..50]
			with(gravityUI) {
				if (Math.abs(bouncingBallSimulation.gravity[1] * 10 - this.value) > 0.5) {
					bouncingBallSimulation.gravity = [0,this.value * 0.1,0];
					gravity_edittext.text = (this.value * 0.1).toString();
					gravity_edittext.notify();
				}
			}
		}
		function on_gravity_text_changed()
		{
			with(gravityUI) {
				if ((bouncingBallSimulation.gravity[1]).toString() != this.text){
					bouncingBallSimulation.gravity = [0,this.text,0];//[0,this.text.toFloat(),0];
					gravity_slider.value = this.text * 10;//.toFloat();
					gravity_slider.notify();
				}
			}
		}
		function on_density_slider_changed()
		{
			// density is stored in slider as [1..100], which maps to 
			// edittext&simulation as [1..100]
			with(gravityUI) {
				if (Math.abs(bouncingBallSimulation.density - this.value) > 0.5) {
					bouncingBallSimulation.density = this.value;
					density_edittext.text = this.value.toString();
					density_edittext.notify();
				}
			}
		}
		function on_density_text_changed()
		{
			with(gravityUI) {
				if ((bouncingBallSimulation.density).toString() != this.text){
					bouncingBallSimulation.density = this.text;
					density_slider.value = this.text;
					density_slider.notify();
				}
			}
		}

		function my_updateBoundsDisplayTextFromActiveComp()
		{
			if (app.project != null && app.project.activeItem != null &&
			    app.project.activeItem instanceof CompItem) {
				var activeComp = app.project.activeItem;
				this.left_displaytext.text = 0;
				this.right_displaytext.text = activeComp.width;
				this.top_displaytext.text = 0;
				this.bottom_displaytext.text = activeComp.height;
				this.left_displaytext.notify();
				this.right_displaytext.notify();
				this.top_displaytext.notify();
				this.bottom_displaytext.notify();
			}
		}

		function my_updateBoundsEditTextFromActiveComp()
		{
			if (app.project != null && app.project.activeItem != null &&
			    app.project.activeItem instanceof CompItem) {
				var activeComp = app.project.activeItem;
				this.custom_left = 0;
				this.custom_right = activeComp.width;
				this.custom_top = 0;
				this.custom_bottom = activeComp.height;
				with(this) {
					left_edittext.text = custom_left;
					right_edittext.text = custom_right;
					top_edittext.text = custom_top;
					bottom_edittext.text = custom_bottom;
					left_edittext.notify();
					right_edittext.notify();
					top_edittext.notify();
					bottom_edittext.notify();
				}
			}
		}

		function my_initUI() {
			with (this) {
				drag_edittext.text = bouncingBallSimulation.drag;
				drag_edittext.notify();
				drag_slider.value = bouncingBallSimulation.drag*10;
				drag_slider.notify();
				elasticity_edittext.text = bouncingBallSimulation.elasticity;
				elasticity_edittext.notify();
				elasticity_slider.value = bouncingBallSimulation.elasticity*100;
				elasticity_slider.notify();
				gravity_edittext.text = bouncingBallSimulation.gravity[1];
				gravity_edittext.notify();
				gravity_slider.value = bouncingBallSimulation.gravity[1]*10;
				gravity_slider.notify();
				density_edittext.text = bouncingBallSimulation.density;
				density_edittext.notify();
				density_slider.value = bouncingBallSimulation.density;
				density_slider.notify();
				updateBoundsDisplayTextFromActiveComp();
				updateBoundsEditTextFromActiveComp();
			}
		}

		// Define member-type methods as variables
		// 
		this.initUI 		= my_initUI;
		this.updateBoundsDisplayTextFromActiveComp = my_updateBoundsDisplayTextFromActiveComp;
		this.updateBoundsEditTextFromActiveComp    = my_updateBoundsEditTextFromActiveComp;

		// Create the bouncing ball simulation
		this.bouncingBallSimulation = new BouncingBallSimulation();

		// Store the default values for custom bouncing bounds
		this.custom_left   = 0;
		this.custom_right  = 100;
		this.custom_top    = 0;
		this.custom_bottom = 100;
		
		// Create and show a floating palette
		//
		this.my_palette = new Window("palette","Bouncing Ball");
		this.my_palette.bounds = [300,100,520,375];

		// "Run" Button
		this.run_button = this.my_palette.add("button", [10,10,150,30], "Run Simulation");

		// "Help" Button 
		this.help_button = this.my_palette.add("button", [160,10,210,30], "?");

		// "Bounds" Panel
		this.bounds_panel = this.my_palette.add("panel", [10,35,210,135], "Bounds");
		this.comp_bounds_radio   = this.bounds_panel.add("radiobutton", [10, 20, 95, 40], "Comp Bounds");
		this.custom_bounds_radio = this.bounds_panel.add("radiobutton", [100, 20, 190, 40], "Custom Bounds");
		this.comp_bounds_radio.value = true;
		this.bounds_panel.add("statictext", [ 10, 45,  55, 65], "Left:");
		this.bounds_panel.add("statictext", [100, 45, 145, 65], "Right:");
		this.bounds_panel.add("statictext", [ 10, 70,  55, 90], "Top:");
		this.bounds_panel.add("statictext", [100, 70, 145, 90], "Bottom:");
		this.left_displaytext   = this.bounds_panel.add("edittext", [ 60, 45,  95, 65], this.custom_left, {readonly:true});
		this.right_displaytext  = this.bounds_panel.add("edittext", [155, 45, 190, 65], this.custom_right, {readonly:true});
		this.top_displaytext    = this.bounds_panel.add("edittext", [ 60, 70,  95, 90], this.custom_top, {readonly:true});
		this.bottom_displaytext = this.bounds_panel.add("edittext", [155, 70, 190, 90], this.custom_bottom, {readonly:true});
		this.left_edittext    = this.bounds_panel.add("edittext", [ 60, 45,  95, 65], this.custom_left);
		this.right_edittext   = this.bounds_panel.add("edittext", [155, 45, 190, 65], this.custom_right);
		this.top_edittext     = this.bounds_panel.add("edittext", [ 60, 70,  95, 90], this.custom_top);
		this.bottom_edittext  = this.bounds_panel.add("edittext", [155, 70, 190, 90], this.custom_bottom);
		this.left_edittext.hide();
		this.right_edittext.hide();
		this.top_edittext.hide();
		this.bottom_edittext.hide();

		// "Controls" Panel
		this.control_panel = this.my_palette.add("panel", [10,140,210,265], "Controls");
		this.control_panel.add("statictext", [10, 20, 55, 40], "Drag:");
		this.drag_edittext  = this.control_panel.add("edittext", [60, 20, 95, 40], "0.0");
		this.drag_slider	 = this.control_panel .add("slider", [100, 20, 190, 40], 
						this.bouncingBallSimulation.drag*10, 0, 100);
		this.control_panel.add("statictext", [10, 45, 55, 65], "Elasticity:");
		this.elasticity_edittext = this.control_panel.add("edittext", [60, 45, 95, 65], "1.0");
		this.elasticity_slider 	 = this.control_panel.add("slider", [100, 45, 190, 65], 
						this.bouncingBallSimulation.elasticity*100, 0, 100);
		this.control_panel.add("statictext", [10, 70, 55, 90], "Gravity:");
		this.gravity_edittext = this.control_panel.add("edittext", [60, 70, 95, 90], "98.0");
		this.gravity_slider 	 = this.control_panel.add("slider", [100, 70, 190, 90], 
						this.bouncingBallSimulation.gravity*10, 0.0, 5000.0);	
		this.control_panel.add("statictext", [10, 95, 55, 115], "Density:");
		this.density_edittext = this.control_panel.add("edittext", [60, 95, 95, 115], "10");
		this.density_slider 	 = this.control_panel.add("slider", [100, 95, 190, 115], 
						this.bouncingBallSimulation.density, 1, 100);	

		// callbacks
		this.run_button.onClick 			= on_run_click;
		this.help_button.onClick 			= on_help_click;
		//
		this.comp_bounds_radio.onClick			= on_comp_bounds_click;
		this.custom_bounds_radio.onClick		= on_custom_bounds_click;
		//
		this.left_edittext.onChange			= on_custom_boundstext_click;
		this.right_edittext.onChange			= on_custom_boundstext_click;
		this.top_edittext.onChange			= on_custom_boundstext_click;
		this.bottom_edittext.onChange			= on_custom_boundstext_click;
		//
		this.drag_slider.onChange			= on_drag_slider_changed;
		this.drag_edittext.onChange			= on_drag_text_changed;
		this.elasticity_slider.onChange			= on_elasticity_slider_changed;
		this.elasticity_edittext.onChange		= on_elasticity_text_changed;
		this.gravity_slider.onChange			= on_gravity_slider_changed;
		this.gravity_edittext.onChange			= on_gravity_text_changed;
		this.density_slider.onChange			= on_density_slider_changed;
		this.density_edittext.onChange			= on_density_text_changed;

		this.my_palette.show();
	}
	var gravityUI = new GravityUI();
	gravityUI.initUI();	
}
