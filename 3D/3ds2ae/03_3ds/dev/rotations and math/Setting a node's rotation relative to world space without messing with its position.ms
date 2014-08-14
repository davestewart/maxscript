-- Setting a node's rotation relative to world space without messing with its position: 
fn setNodeWorldRotation theNode theRot = 
( 
in coordsys (transmatrix theNode.transform.pos) 
theNode.rotation = theRot 
) 
setNodeWorldRotation $ (eulerangles 45 45 0) 
