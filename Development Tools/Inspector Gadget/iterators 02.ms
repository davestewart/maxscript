
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
			--if classof obj != Array AND classof obj != MAXModifierArray then (throw ("ArrayIterator > " +(classof obj as string)+ " passed where Array expected");false)
			--else
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
					--format ("PropertyIterator > object '" +obj as string+ "' does not have iteratable properties\n")
					false
			)
		)
		),
		function next =
	(
			index += 1
			try(Property obj items[index] (getProperty obj items[index]))
			catch()
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
