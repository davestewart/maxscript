fn pad strStr strPad:"0" length:2 =
(
	strStr = strStr as string
	while strStr.count < length do strStr = strPad + strStr
	return strStr
)

str="we are all booksellers
our vision
to create richer, more satisfying lives thorugh knowledge and entertainment
our mission
to be the preferred place for knowledge and entertainment throughout the world
our values
individuality community discovery familiarity
our personality
engaging spirited inspiring sincere
we are all import members of the team, to be treated with respect and trust
we are all Borders"

arr = filterstring str "\n"
--for i = 1 to arr.count do arr[i] = filterstring arr[i] " "

x = 0
y = 0
for i = 1 to arr.count do
(
	col = random (color 128 128 128) (color 200 200 200)
	local arrWords = filterstring arr[i] " "
	local arrObjects = #()
	for j = 1 to arrWords.count do
	(
		-- text
			tStr	= arrWords[j]
			tName	= "text " + (pad i) + "," + (pad j) + " - "+tStr
			t = text text:tStr font:"Bordersville" kerning:-4 name:tName wirecolor:col
		-- position
			w = (t.max - t.min)[1]
			t.pos.x = x + (w/2)
			x += w + 30
			t.pos.y = y
			t.steps = 2
		-- objects
			append arrObjects t
	)
	local gName = "group " + (pad i) + " - " + arr[i]
	local gGroup = group arrObjects name:gName 
	setGroupOpen gGroup true
	
	y += -160
	x = 0
)
	
	