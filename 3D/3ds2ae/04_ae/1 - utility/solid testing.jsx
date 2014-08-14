obj=app.project.item(1).layer(1)
prop=obj.property("Rotation").value//.addKey(time)


obj=app.project.item(1).layer(1)
str=""

function pad(d){
	var str=""
	for(i=0;i<d;i++)str+="	"
	return str
	}

function walk(obj,d){
	for(var i=1;i<=obj.numProperties;i++){
		str+=(pad(d))+i+" : "+String(obj.property(i).name)+"\n"
		try{
			walk(obj.property(i),d+1)
		}
		catch(err){}
		}
	}

walk(obj,0)
	alert(str)
