struct cStruct
	(
	fn test = print "c"
	)
		
struct pStruct
	(
	fn test = print "p",
	c = cStruct ()
	)
	
p = pStruct ()


p.test()