rollout roTest "Test"
(
	--   ████████████████████████████ -- the more █ characters you add to this line, the worse the offset becomes
	
		function test = -- this line will get highlighted on error!
		(
			someFunction() -- but it should be this line
		)
	
	on roTest open do test()
)

createdialog roTest 300 300