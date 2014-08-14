

-- source
	input = ""
	fileName = "../mzp.run"
	f = openFile fileName more:"r"
	while not eof f do input += readline f + "\n"
	close f
	input


-- basic regexp
	rx			= dotNetClass "System.Text.RegularExpressions.RegEx"
	pattern		= "(name|description)\s+\"([^\"]+)\""
	pattern		= "([A-Z][a-z]+) ([A-Z][a-z]+)"
	pattern		= "([Mm]ax[^$]+)"
	pattern		= "\"([^\"]+)\""
	pattern		= "([A-Z][a-z]+)"
	rxOptions	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
	
	
-- matching function
	fn regexMatch source pattern options: =
	(
		local groups
		local results	= #()
		local rx		= dotNetClass "System.Text.RegularExpressions.RegEx"
		local matches	= if options == unsupplied then rx.match source pattern else rx.match source pattern options
		while matches.Success do
		(
			groups		= for i = 1 to matches.Groups.count - 1 collect matches.groups.item[i].value
			matches		= matches.nextMatch()
			append results groups
		)
		results
	)

-- match
	pattern		= "(\w+)\s+\"?([^\"\n]+)\"?"
	regexMatch input pattern options:rxOptions.Multiline
	
	
	
-- code
	result = rx.Equals objA objB
	result = rx.Escape str
	result = rx.IsMatch input pattern
	result = rx.IsMatch input pattern rxOptions
	result = rx.Match input pattern
	result = rx.Match input pattern rxOptions
	result = rx.Matches input pattern
	result = rx.Matches input pattern rxOptions.Multiline -- this one
	result = rx.ReferenceEquals objA objB
	result = rx.Replace input pattern replacement
	result = rx.Replace input pattern evaluator
	result = rx.Replace input pattern evaluator rxOptions
	result = rx.Replace input pattern replacement rxOptions
	result = rx.Split input pattern
	result = rx.Split input pattern rxOptions
	result = rx.Unescape str
	
-- add to inspector gadget
	IG.add result
	IG.add result.item[1].groups.item[0].captures.item[0]

-- loop through matches
	for i = 0 to result.count - 1 do print (result.item[i].groups.item[i].value)
	
-- show indivisual match
	result.item[1].value
	
-- show methods
	showmethods result


/*
	matches		= rx.matches str pattern


	splits		= rx.split str pattern


	show matches


	for i = 0 to matches.count - 1 do show (matches.item[i].captures.item[0].value)


	m.item[0].captures.item[0].value


	m = rx.Match str "name\s+\"([^\"]+)"


	showmethods m

	mt = m.nextMatch()

	mt.value


	showmethods rx
*/