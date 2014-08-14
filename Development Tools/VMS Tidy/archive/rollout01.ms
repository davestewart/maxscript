--UI Tidy test rollout

try(destroyDialog VMSTidyTestRo);catch()

rollout VMSTidyTestRo "VMS Tidy - Test Rollout" width:196 height:396
(
	-- interface
		include  "interface01.ms"
)


createDialog VMSTidyTestRo

