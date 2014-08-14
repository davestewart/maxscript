m = netrender.getmanager() --get a NetManager instance

m.connect #automatic "255.255.255.0" 

if( m.QueryControl #wait ) do m.getcontrol()
m.wantControl=false
 


-- SUBMITTING JOBS --

job = m.newjob() -- file: "c:\\share\\test.max"

job.suspended = false
job.suspended = true

job.state

job.includeMaps = true --turn on "Include Maps"


srv_list = m.getservers() --get the server list to assign to the job

job.fromFrame = 20
job.toframe = 25
job.frameOutputName = "c:/temp/renders/test.tga"
job.name = "Coaster 18 - bg"

job.outputWidth
 

job.submit servers:srv_list --specify which servers to use for the job

-- job.submit() --this uses all servers for the job

m.wantcontrol

--showinterface m