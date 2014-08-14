// functions
	function getDebuggerState(){ 
		return Boolean(app.preferences.getPrefAsLong("Main Pref Section", "Pref_JAVASCRIPT_DEBUGGER"))
		}


	function setDebuggerState(state){ 
		app.preferences.savePrefAsLong("Main Pref Section", "Pref_JAVASCRIPT_DEBUGGER", Number(state)) 
		app.preferences.saveToDisk(); 
		app.preferences.reload(); 
		} 

// script 
	setDebuggerState(false) 

	try{thisWillBreakIt}
	catch(e){} 

	alert(getDebuggerState())

