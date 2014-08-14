(
local a=1
fn outer=
(
	fn inner=
	(
		format "Inner: %\n" a
	)
	format "Outer: %\n" a
	inner()
)
	
outer()
)