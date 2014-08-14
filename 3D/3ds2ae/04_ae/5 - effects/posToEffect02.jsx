posArr=new Array(
	%
	)

comp=app.project.activeItem
prop=comp.selectedProperties[0]

for(i=0;i<posArr.length;i++){
	prop.setValueAtTime(i/25, posArr[i])
	}