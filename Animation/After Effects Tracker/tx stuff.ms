x1 = $ExposeTransform01.worldEulerX
y1 = $ExposeTransform01.worldEulerY
z1 = $ExposeTransform01.worldEulerZ

x2 = $ExposeTransform02.worldEulerX
y2 = $ExposeTransform02.worldEulerY
z2 = $ExposeTransform02.worldEulerZ

r1 = eulerangles x1 y1 z1
p1 = $'car01 - dummy'.position

b = box pos:p1 rotation:r1

select b

$.rotation = r1

$.transform.rotationPart = r1



d1 = $'car01 - dummy'
d2 = $'car02 - dummy'

r1 = d1.transform.rotationPart as eulerangles
r2 = d1.transform.rotationPart as eulerangles


r1 = d1.transform
r2 = d1.transform

d2

show $

x1 = $ExposeTransform01.worldEulerX
y1 = $ExposeTransform01.worldEulerY
z1 = $ExposeTransform01.worldEulerZ

x2 = $ExposeTransform02.worldEulerX
y2 = $ExposeTransform02.worldEulerY
z2 = $ExposeTransform02.worldEulerZ

r1 = eulerangles x1 y1 z1
r2 = eulerangles x2 y2 z2
r = eulerangles ((x1+x2)/2) ((y1+y2)/2) ((z1+z2)/2) 

p1 = $'car01 - dummy'.position

r = ([x1,y1,z1] + [x2,y2,z2]) / 2
r = (r1 + r2) / 2


b = box pos:p1 rotation:r
select b

tx = $.transform
tx.row4 = r
$.transform = tx
