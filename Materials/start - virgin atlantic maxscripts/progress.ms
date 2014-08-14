escapeenable

progressStart "Updating particle birth script..."
m = 100000
for i= 1 to m do
	(
	progressUpdate (i as float/ m) * 1000
	if getProgressCancel() == true then setProgressCancel true
	)
progressEnd()
