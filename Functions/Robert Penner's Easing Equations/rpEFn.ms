struct rpEFn (
 	-- ---
 	-- Easing Equotations by Robert Penner
 	-- httpwww.robertpenner.com
 	-- The BSD License httpwww.opensource.orglicensesbsd-license.php
 	-- ---
 	-- maxScript port by Georg Duemlein
 	-- 2007-04-18
 	-- httpwww.preset.de
 	-- ---
 	-- previews httpwww.gizma.comeasing
 	-- ---
 	-- t current time
 	-- b start value
 	-- c end value
 	-- d duration
 	-- ---
 	-- simple linear tweening - no easing, no acceleration
 	fn linearTween t b c d = (
 			ctd + b
 	),
 	--  quadratic easing in - accelerating from zero velocity
 	fn easeInQuad t b c d = (
 		t = d
 		ctt + b
 	),
 	-- quadratic easing out - decelerating to zero velocity
 	fn easeOutQuad t b c d = (
 		t = d
 		-c  t  (t-2) + b
 	),
 	-- quadratic easing inout - acceleration until halfway, then deceleration
 	fn easeInOutQuad t b c d = (
 		t = d2
 		if (t  1) then (
 			c  2  t  t + b
 		)else(
 			t-=1
 			-c  2  (t (t - 2) - 1) + b
 		)
 	),
 	-- cubic easing in - accelerating from zero velocity
 	fn easeInCubic t b c d = (
 		t = d
 		cttt + b
 	),
 	-- cubic easing out - decelerating to zero velocity
 	fn easeOutCubic t b c d = (
 		t = d
 		t-=1
 		c(ttt + 1) + b
 	),
 	-- cubic easing inout - acceleration until halfway, then deceleration
 	fn easeInOutCubic t b c d = (
 		t = d2
 		if (t  1) then (
 			c2ttt + b
 		)else(
 			t -= 2
 			c2(ttt + 2) + b
 		)
 	),
 	-- quartic easing in - accelerating from zero velocity
 	fn easeInQuart t b c d = (
 		t = d
 		ctttt + b
 	),
 	-- quartic easing out - decelerating to zero velocity
 	fn easeOutQuart t b c d = (
 		t = d
 		t -= 1
 		-c  (tttt - 1) + b
 	),
 	-- quartic easing inout - acceleration until halfway, then deceleration
 	fn easeInOutQuart t b c d = (
 		t = d2
 		if (t  1) then(
 			c2tttt + b
 		)else(
 			t -= 2
 			-c2  (tttt - 2) + b
 		)
 	),
 	-- quintic easing in - accelerating from zero velocity
 	fn easeInQuint t b c d = (
 		t = d
 		cttttt + b
 	),
 	-- quintic easing out - decelerating to zero velocity
 	fn easeOutQuint t b c d = (
 		t = d
 		t -= 1
 		c(ttttt + 1) + b
 	),
 	-- quintic easing inout - acceleration until halfway, then deceleration
 	fn easeInOutQuint t b c d = (
 		t = d2
 		if (t  1) then (
 			c2ttttt + b
 		)else(
 			t -= 2
 			c2(ttttt + 2) + b
 		)
 	),
 	-- sinusoidal easing in - accelerating from zero velocity
 	fn easeInSine t b c d = (
 		-c  cos (td  (180  2)) + c + b
 	),
 	-- sinusoidal easing out - decelerating to zero velocity
 	fn easeOutSine t b c d = (
 		c  sin (td  90) + b
 	),
 	-- sinusoidal easing inout - accelerating until halfway, then decelerating
 	fn easeInOutSine t b c d = (
 		-c2  (cos(180  td) - 1) + b
 	),
 	-- exponential easing in - accelerating from zero velocity
 	fn easeInExpo t b c d = (
 		c  pow 2 (10  (td - 1)) + b
 	),
 	-- exponential easing out - decelerating to zero velocity
 	fn easeOutExpo t b c d = (
 		c   (-pow 2 (-10  td) + 1 ) + b
 	),
 	-- exponential easing inout - accelerating until halfway, then decelerating
 	fn easeInOutExpo t b c d = (
 		t = d2
 		if (t  1) then (
 			c  2  pow 2 (10.  (t - 1)) + b
 		)else(
 			t -= 1
 			c  2   (-pow 2 (-10.  t) + 2 ) + b
 		)
 	),
 	-- circular easing in - accelerating from zero velocity
 	fn easeInCirc t b c d = (
 		t = d
 		-c  (sqrt(1 - tt) - 1) + b
 	),
 	-- circular easing out - decelerating to zero velocity
 	fn easeOutCirc t b c d = (
 		t = d
 		t -= 1
 		c  sqrt(1 - tt) + b
 	),
 	-- circular easing inout - acceleration until halfway, then deceleration
 	fn easeInOutCirc t b c d = (
 		t = d2
 		if (t  1) then (
 			-c2.  (sqrt(1. - tt) - 1.) + b
 		)else(
 			t -= 2
 			c2.  (sqrt(1. - tt) + 1.) + b
 		)
 	)
 )
 
 -- sample
 d = 50.
 t = 0.
 	
 while t  d do (
 	v1 = v2 = v3 = 0
 	v1 = rpEFn.linearTween t 0. 100. d
 	v2 = rpEFn.easeInOutQuad t 1. 100. d
 	v3 = rpEFn.easeInOutQuad t 0. 1. (d2)
 	sp = sphere pos[v1, 0, v2] radius(.5 + v3)
 	sp.wirecolor = [255,255,255]  v3
 	-- ---
 	t += .5
 	max zoomext sel all
 )
 