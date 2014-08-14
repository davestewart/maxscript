macroscript spinner_precision
category:"Tools" 
internalcategory:"Tools"
Tooltip:"Spinner precision"
buttontext:"Spn. precision"

	(
	rollout roSpinner "Spinner Precision" width:168 height:32
		(
		radioButtons rdo1 "" pos:[8,8] width:155 height:16 labels:#("0", "1", "2", "3", "4") columns:5
		on rdo1 changed state do
			(
			preferences.spinnerPrecision=(state as integer - 1)
			)
		on roSpinner open do
			(
			rdo1.state = (preferences.spinnerPrecision + 1)
			)
		)
	try(
		createdialog roSpinner
		cui.RegisterDialogBar roSpinner 
		)
	catch()
	)
	
--macros.run "tools" "spinner_precision"