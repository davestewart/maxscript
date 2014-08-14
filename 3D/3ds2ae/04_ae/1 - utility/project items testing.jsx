
str=""
items=app.project.items
for(i=1;i<=items.length;i++)str+=String(items[i].name)+" : " + String(items[i].typeName)+ "\n"
alert(str)

/*
item=app.project.item(5)
str=""
for (prop in item)str+=prop+"\n"
//alert(str)
//alert(item.parentFolder.name)
item.parentFolder=1
*/


str=""
items=app.project.items
for(i=1;i<=items.length;i++)str+=String(items[i].name)+" : " + String(items[i].typeName)+ "\n"
alert(str)

