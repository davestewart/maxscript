ba=#{}

rowcount=$.baseobject.segments
for i = 2 to ((getnumverts $)-2) by (rowcount*2) do join ba #{i..(i+rowcount-1)}

ba

setVertSelection $ ($.modifiers[#Edit_Mesh]) ba



360.0/(200*2)