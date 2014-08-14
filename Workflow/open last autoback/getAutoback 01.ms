files = getFiles "$max\\Autoback\\Autobak*"
print files

for f in files do print (getFileCreateDate f)

