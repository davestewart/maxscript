c = $Camera01
p = plane transform:c.transform pos:c.target.pos

renderSize = [renderHeight, renderWidth * renderPixelAspect]
cameraSize = 
cx = distance c p
car = tan (c.fov / 2)

cy = car * cx * 2
p.width = cy
p.length = cy * renderSize.x / renderSize.y
