for o in objects do roAnimation.axObj.ListItems.Add index:o.name
Index:undefined 
Key:undefined 
Text:undefined 
Icon:undefined 
SmallIcon:undefined


roAnimation.axObj.refresh()




for li in roAnimation.axObj.ListItems do
(
	obj = getnodebyname (li.text)
	format "%\n" obj.pos
 )

show roAnimation.axObj.ListItems[1] to:sc
(getnodebyname "GeoSphere01").pos



arr=for i = 1 to 10 collect random 1 roAnimation.axObj.ListItems.count

for i in arr do roAnimation.axObj.ListItems[i].Selected=true


setfocus roAnimation.axObj


roAnimation.axObj.TextBackground-- : ListTextBackgroundConstants( #lvwTransparent | #lvwOpaque )
roAnimation.axObj.Sorted =true

showevents roAnimation.axObj

r2=ray [0,0,0] [1,0,0]
r1.dir==r2.dir

r1.dir*=5

r1