
gLabel = ""
gPrompt = ""

rollout roPrompt "MaxScript prompt" width:304 height:112
(
	editText edtPrompt "" pos:[8,40] width:280 height:17
	label lblPrompt "Label" pos:[16,16] width:272 height:16
	button btnOK "OK" pos:[136,72] width:72 height:22
	button btnCancel "Cancel" pos:[216,72] width:72 height:22
	
	on roPrompt open do
	(
		lblPrompt.text = gLabel + ":"
		edtPrompt.text = gPrompt
	)
	on edtPrompt entered text do destroydialog roPrompt
	on btnOK pressed do destroydialog roPrompt 
	on btnCancel pressed do
	(
		destroydialog roPrompt 
	)
)

struct ui (
	function prompt strLabel strPrompt =
	(
		gLabel	= strLabel
		gPrompt	= strPrompt
		createdialog roPrompt modal:true
		return roPrompt.edtPrompt.text
	)
)
	
s = ui.prompt "Please enter a filename" ""

