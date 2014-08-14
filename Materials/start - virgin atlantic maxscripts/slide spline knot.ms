with undo on
	(
	sp=(getSplineSelection $) [1]
	kn= (getKnotSelection $ sp)[1]
	
	p1=getKnotPoint $ sp kn
	p2=getInVec $ sp kn
	d=p2-p1
	
	setKnotPoint $ sp kn (p1+d)
	
	updateShape $
	)