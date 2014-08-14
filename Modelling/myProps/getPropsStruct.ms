-- buildUICtrlDataStructArr-v0_10.ms
--
-- 08.19.01, swami*, a.k.a. "codeWarrior()", swami@cfl.rr.com
-- Written for MAX R4.20
--
-- This function stores UI control item data in an array of data structures.

fn buildUICtrlDataStructArr rol =
(
	struct UICtrlStruct (rol,rName,cType,ctrl,cName,cText,enabled)
	
	ss		=stringstream ""
	format "%" rol to:ss
	fs		=filterString (ss as string) ":"
	rName	=fs[2]
	
	cnt=0
	UICtrlArr=
	for c in rol.controls collect
(
		cnt		+=1
		ss		 =stringstream ""
		format "%" c to:ss
		fs		 =filterString (ss as string) ":"
		cType	 =subString fs[1] 1 (fs[1].count-7)
		
		UICtrlStruct					\
				rol:		rol			\
				rName:		rName		\
				cType:		cType		\
				ctrl:		c			\
				cName:		fs[2]		\
				cText:		c.text		\
				enabled:	c.enabled
)
)
