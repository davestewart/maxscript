fn drawText p txt = (
gw.setTransform(Matrix3 1)
p = gw.hTransPoint p
gw.hText p txt
gw.enlargeUpdateRect #whole
gw.updateScreen()
)
