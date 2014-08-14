zip = "E:\\05 - Scripting\\MaxScript\\projects\\For Scripters\\Property Explorer\\dotnet treeview 01.mzp"
tmp = sysinfo.tempdir

d = msZip.unloadPackage zip &tmp ""

run = tmp + "\mzp.run"
if doesFileExist run do
(
	f = openfile run mode:"r"
)

format "%\n" (readtoken f)

readLine f

print (readtoken "name \"dotnet treeview 01\"")