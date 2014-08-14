ax=ro1.ax
ax=ro1.ax.listitems[1]
show ax showHidden:false

show ax showHidden:true
showmethods ax showHidden:true
showmethods ax showHidden:false


ax.aboutbox()




--ax.FindItem sz:string Where:undefined Index:undefined fPartial:undefined
-- where: column : integer
-- index: start from : integer
-- fPartial : find just a little bit : boolean integer

x=ax.finditem "250" 0 4 1

show x

x.Index


(ax.GetFirstVisible()).selected=true

setfocus ro1.ax
