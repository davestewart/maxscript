-- ------------------------------------------------------------------------------------------------------------------------
--
--  ██  ██                     ██                    
--  ██  ██                     ██                    
--  ██ █████ █████ ████ █████ █████ █████ ████ █████ 
--  ██  ██   ██ ██ ██      ██  ██   ██ ██ ██   ██    
--  ██  ██   █████ ██   █████  ██   ██ ██ ██   █████ 
--  ██  ██   ██    ██   ██ ██  ██   ██ ██ ██      ██ 
--  ██  ████ █████ ██   █████  ████ █████ ██   █████ 
--
-- ------------------------------------------------------------------------------------------------------------------------
-- Iterators

	struct NullIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			true
		),
		function next =
	(
			undefined
		),
		function hasNext =
	(
			false
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			false
		),
		initialized = init()
)

	struct ArrayIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			if classof obj != Array AND classof obj != MAXModifierArray then (throw ("ArrayIterator > " +(classof obj as string)+ " passed where Array expected");false)
			else
		(
				items = obj
				true
		)
		),
		function next =
	(
			index += 1
			obj[index]
		),
		function hasNext =
	(
			index < obj.count
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			rewind()
			while hasNext() do callback (next())
			true
		),
		initialized = init()
)

	struct SelectionIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			if isValidNode obj then
		(
				items = #(obj)
				obj = undefined
				true
		)
			else if classof obj != ObjectSet then (throw ("SelectionIterator > " +(classof obj as string)+ " passed where ObjectSet expected");false)
			else
		(
				items = obj as Array
				obj = undefined
				true
		)
		),
		function next =
	(
			index += 1
			items[index]
		),
		function hasNext =
	(
			index < items.count
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			rewind()
			while hasNext() do callback (next())
			true
		),
		initialized = init()
)

	struct ChildIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			if obj == undefined then (throw "ChildIterator > obj is undefined";false)
			else if	classof obj == ObjectSet OR classof obj == Array then (throw "ChildIterator > more than one object passed";false)
			else if	NOT isproperty obj "children" then (throw ("ChildIterator > object '" +obj as string+ "' does not have a .children property");false)
			else
		(
				items = obj.children
				true
		)
		),
		function next =
	(
			index += 1
			items[index]
		),
		function hasNext =
	(
			index < items.count
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			rewind()
			while hasNext() do callback (next())
			true
		),
		initialized = init()
)

	struct Property
(
		object,
		name,
		value
)

	struct PropertyIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			if obj == undefined then (throw "PropertyIterator > obj is undefined";false)
			else if	classof obj == ObjectSet OR classof obj == Array then (throw "PropertyIterator > more than one object passed";false)
			else
		(
				try
			(
					items = getPropNames obj
					true
			)
				catch
			(
					format ("PropertyIterator > object '" +obj as string+ "' does not have iteratable properties\n")
					false
			)
		)
		),
		function next =
	(
			index += 1
			Property obj items[index] (getProperty obj items[index])
		),
		function hasNext =
	(
			if items == undefined then false else index < items.count
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			rewind()
			while hasNext() do callback (next())
			true
		),
		initialized = init()
)

	struct SubAnimIterator
(
		obj,
		items = #(),
		index = 0,
		function init =
	(
			if obj == undefined then (throw "PropertyIterator > obj is undefined";false)
			else if	classof obj == ObjectSet OR classof obj == Array then (throw "PropertyIterator > more than one object passed";false)
			else
		(
				items = getSubAnimNames obj
				true
		)
		),
		function next =
	(
			index += 1
			getsubanim obj index
		),
		function hasNext =
	(
			index < items.count
		),
		function rewind =
	(
			index = 0
		),
		function iterate callback =
	(
			rewind()
			while hasNext() do callback (next())
			true
		),
		initialized = init()
)
	
	format "Iterators declared...\n"

-- ------------------------------------------------------------------------------------------------------------------------
--
--  ██████          ██       
--  ██              ██       
--  ██     █████ █████ █████ 
--  ██     ██ ██ ██ ██ ██ ██ 
--  ██     ██ ██ ██ ██ █████ 
--  ██     ██ ██ ██ ██ ██    
--  ██████ █████ █████ █████ 
--
-- ------------------------------------------------------------------------------------------------------------------------
-- Code


/*
	$.pos.controller.keys[1]
	
	colors = DotNetClass "System.Drawing.Color"

	c = ChildIterator $
	p = PropertyIterator $
	s = SubAnimIterator $.baseobject
	col = PropertyIterator colors
	
	iterators = #(c, p, s, col)

	i = ArrayIterator #(1,2,3,4,5)
	i = ChildIterator $
	i = PropertyIterator $
	i = SubAnimIterator $.baseobject
	i = PropertyIterator colors
	
	iterators = #(i)

	for i in iterators do
(
		i.rewind()
		while i.hasNext() do print (i.next())
)	
	
	i = ChildIterator "jjkhjkh"
	
	i = PropertyIterator 1
	
fn trace obj =
(
	format "% (%) > %\n" (classof obj) obj.name obj.value
	try(obj.value += 10)
	catch()
)

fn traceSubAnim obj =
(
    format "%. % (%) : %\n" obj.index obj.name (classof obj.object) obj.object
)

fn traceProperties obj =
(
    format "% : %\n" obj.name obj.value
)

fn traceElements obj =
(
    format "% (%)\n" obj (classof obj)
)

fn processElements obj =
(
	obj.scale += 2
)

i = SelectionIterator $
i.iterate processElements

i = SubAnimIterator $.baseobject
i.iterate traceSubAnim

i = PropertyIterator $
i.iterate traceProperties

i = ArrayIterator #(1,2,3)
i.iterate traceElements
*/

