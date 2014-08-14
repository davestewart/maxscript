-- the function
	function addArgs arg1 arg2 =
	(
		if classof arg1==String OR classof arg2==String then
			return (arg1 as string + arg2 as string)
		else return arg1+arg2
	)

-- exmaple
	addArgs 1 6
	addArgs "hello" "dave"


-- calling a functio with a keyword argument
	function functionCaller thefunct arg1 arg2 =
	(
		theFunct arg1 arg2
	)

-- example
	functionCaller addArgs 4 6
	functionCaller addArgs "Dave " "Stewart"



/*
The point of this exercise is to show that I could write a recursive function that needs only be used once,
and takes a keyword argument as what to do...

eg... I say recurse nodes and use the checkNode function:







recurseTreeAndCall checkNode

*/