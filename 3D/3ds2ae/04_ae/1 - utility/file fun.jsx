
if (app.project != null){
    app.project.close(CloseOptions.DO_NOT_SAVE_CHANGES);
	}

var pfile = fileGetDialog("Select a project file to open", "EggP aep");

if (pfile == null){
    alert("No project file selected. Aborting. " ) ;
	}
else{
    var my_project = app.open( pfile );
    var default_text_filename;
    var suffix_index = pfile.name.lastIndexOf(".aep");
    if (suffix_index != -1){
        default_text_filename = pfile.name.substring(0,suffix_index);
	    }
    else{
        default_text_filename = pfile.name;
    	}
    default_text_filename += "_compnames.txt";
    var text_file = filePutDialog("Select a file to output your results",
    default_text_filename, "TEXT txt");
    if (text_file == null){
        alert("No output file selected. Aborting. " ) ;
    	}
    	
    else{
        text_file.open("w","TEXT","????");
        // Write the heading of the file:
        text_file.writeln("Here is a list of all the comps in " +
        pfile.name);
        text_file.writeln();
        for (var i = 1; i <= app.project.numItems; i++){
            if (app.project.item(i) instanceof CompItem){
                text_file.writeln(app.project.item(i).name);
        	    }
        	}
        text_file.close();
        alert("All done!");
    	}
	}
