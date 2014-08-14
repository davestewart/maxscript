
scriptFolder="E:\\03_Scripting\\3ds to ae\\03_3ds\\XML\\"
--scriptFile="controllers.xml"
scriptFile="sphere.xml"

script=scriptFolder+scriptFile

/*
xml=openfile script mode:"r"
while NOT eof xml do readLine xml

sxmlIO.xml2obj xml
*/

st = timeStamp()
	gXmlIO.init()
	gXmlIO.load script
	objs = gXmlIO.xmlDoc.selectNodes "//object"
 	for i=0 to (objs.length-1) do gXmlIO.xml2obj objs[i]
	format "Execute Time:%\%\n" ((100*gXmlIO.exec_time)/(timeStamp()-st))









fromElem = gXmlIO.xmlDoc.selectSingleNode ("//object")

-- create the object from the xml element
fromNode = gXmlIO.xml2obj fromElem

 chkTransform:chkTransform.checked chkBaseObject:chkBaseObject.checked chkModifiers:chkModifiers.checked chkCustAttrib:chkCustAttrib.checked