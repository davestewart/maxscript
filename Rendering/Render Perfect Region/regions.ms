
regions = Dictionary()

regions.setItem #hspin (Box2 0 0 880 620)
regions.setItem #tilt (Box2 40 180 830 430)
regions.setItem #tiltstrip (Box2 410 220 200 240)
regions.setItem #all (Box2 0 0 1200 800)
regions.setItem #dplex (Box2 230 180 650 430)
regions.setItem #optics (Box2 0 0 880 610)
regions.setItem #opticsFront (Box2 440 100 300 440)
regions.setItem #opticsBack (Box2 220 100 300 340)
regions.setItem #idle (Box2 120 90 800 580)



regions.setItem #default (Box2 250 180 630 430)

function setCrop type =
(
	local region = regions.getItem type
	viewport.setRegionRect 4 region
	region
)

function getCrop =
(
	viewport.getRegionRect 4
)

setCrop #idle

getCrop()
regions

shelllaunch (getdir #autoback) ""