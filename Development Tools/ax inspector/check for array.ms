

local an_array
try(
	getProperty ax.listItems #_newEnum;
	an_array = true
	)
catch(
	an_array = false
	)
if an_array == true then
	(
	for li in ax.listItems do li.bold = true
	)