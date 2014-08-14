-- script:	spherical spline
-- author:	dave stewart
-- date:	18th december 2006
-- max:		5+




ss2 = splineshape()

vSpans = (segments / turns)

for i = 0 to vSpans - 1 do
(
	addnewspline ss2
--	format "%\n" (i as string)
	si = i + 1
	addknot ss2 si #corner #curve knots[1]
	for j = 1 to knots.count - 1 by (segments / turns) do
	(
		ki = i + j
		format "%	%\n" (si as string) (ki as string)
		addknot ss2 si #corner #curve knots[ki]
	)
	addknot ss2 si #corner #curve knots[knots.count]
)
	
updateshape ss2
ss2.vertexTicks = on
select ss2
