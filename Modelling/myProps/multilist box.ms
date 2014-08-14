rollout test "test" 
( MultiListBox mlb "MultiListBox" items:#("A","B","C") selection:#(1,3) 
on mlb selected val do format "selected: % - %\n" val mlb.selection[val] 
on mlb doubleclicked val do format "doubleclicked: % - %\n" val mlb.selection[val] 
on mlb selectionEnd do format "selectionEnd: %\n" mlb.selection 
) 
rof=newrolloutfloater "tester" 200 300 
addrollout test rof 
test.mlb.items 
test.mlb.selection=1 
test.mlb.selection=#(1,3) 
test.mlb.selection=#{} 
