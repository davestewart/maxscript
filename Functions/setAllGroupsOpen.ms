function setAllGroupsOpen state =
	(
	for obj in helpers do if isGroupHead obj then setGroupOpen obj state
	)
	
setAllGroupsOpen false