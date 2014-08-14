target = $.modifiers[1]
prop = substring ((getPropNames target)[1] as String) 1 100
execute ("$.modifiers[1]." + prop)
classOf (execute ("$.modifiers[1]." + prop))
