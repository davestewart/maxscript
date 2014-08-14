/*s = sliderManipulator()
s.xPos = 0.05
s.yPos = 0.1

gw.setTransform $.transform


gw.setPos 0 0 500 500


gw.marker [0,0,0] #smallCircle
gw.updateScreen()

gw.resetUpdateRect()



gw.hTransPoint [0,0,0]
*/


s = sliderManipulator()

fn moveManip = 
	(
	node		= geometry[1]
	winSize		= [gw.getWinSizeX(),gw.getWinSizeY(),0]
	winPos		= gw.wTransPoint node.pos
	s.xPos		= winPos[1] / winSize[1]
	s.yPos		= winPos[2] / winSize[2]
	)

registerRedrawViewsCallback moveManip

unregisterRedrawViewsCallback moveManip
