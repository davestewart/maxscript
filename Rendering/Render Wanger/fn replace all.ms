fn replaceAll str outStr inStr =
(
	-- str the original string
	-- the string/character to replace
	-- the replacement string/character
	return (while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr)
)
