str="alert('Success!')"

app="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
scriptFolder="E:\\03_Scripting\\3ds to ae\\04_ae\\1 - utility\\"
scriptFile="test3.jsx"
script=scriptFolder+scriptFile

scriptFS=createFile script
format "%\n" str to:scriptFS
close scriptFS

ShellLaunch ("\""+app+"\"") (" -r "+script)
