keyTimes = for k in $.pos.controller.keys collect k.time / framerate
str = ""
for t in keyTimes do str += ((t as integer / ticksperframe) as string) + ","
fname = getsavefilename()
f = openfile fname mode:"w"
format "%" str to:f
close f