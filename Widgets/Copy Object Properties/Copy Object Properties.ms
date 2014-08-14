-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Copy Object Properties
-- Copies as many properties from one object to another
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.2
-- max version:	all
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
--
-- history:		 - created
--
-------------------------------------------------------------------------------------------------------------------------------

macroScript CopyObjectProperties
	category:"Tools"
	buttonText:"Copy properties from another object..."
	tooltip:"Copy Object Properties"
(
	-----------------------------------------------------------------------------------------------------
	-- variables
	

	-----------------------------------------------------------------------------------------------------
	-- variables
	
		local objSrc	= pickObject message:"Select object to copy properties from..."
		local selTrg	= getCurrentSelection()
		
	-----------------------------------------------------------------------------------------------------
	-- code
	
		-- look at adding an option to allow modifiers to be checked
	
		-- do the copy
			if objSrc != undefined AND selTrg != undefined do
			(
				local propNames	= getPropNames objSrc
				for propName in propNames do
				(
					local propValue = getProperty objSrc propName
					for objTrg in selTrg do
					(
						if isProperty objTrg propName do
						(
							setproperty objTrg propName propValue
						)
					)
				)
			)

)

