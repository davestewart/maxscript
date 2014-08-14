p = $.pos
p about [0,0,0]

mx = (matrix3 [1,0,0] [0,1,0] [0,0,1] p)
rotateZ mx 1
mx.translationPart
