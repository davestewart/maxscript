fn drawText p txt col = (
	gw.setTransform(Matrix3 1)
	p = gw.hTransPoint p
	gw.hText p txt color:col
	)

fn prepText = 
	(
	-- setup
		if viewport.activeViewport != lastViewport do
		(
		completeredraw()
		lastViewport = viewport.activeViewport 
		)
	-- colors
	if cp1 !=undefined then col = ro1.cp1.color else col=color 0 0 0
	if $.count>0 then
		(
		for obj in $ do drawText obj.pos obj.name col
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
		)
	)

prepText()
