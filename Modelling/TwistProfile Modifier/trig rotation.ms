x = $.pos.x
y = $.pos.y

amount = 5
x = cos(amount) * x - sin(amount) * y
y = cos(amount) * y + sin(amount) * x

$.pos = [x,y,0]