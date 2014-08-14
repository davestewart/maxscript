---Try to find the name of the Floater

		-- attempt to print name of Floater
			sf = openFile scriptFullPath mode:"r"
		
			while (NOT eof sf) do
			(

			skipToString sf "newRolloutFloater"
			print (readLine sf)
			--print (readLine sf)
/*				if (findString (readLine sf) "newRolloutFloater") != undefined then
					if (not eof sf) then (
						i = filePos sf
						s = readLine sf
						if (findString s "newRolloutFloater") == undefined then	
							print s
						else seek sf i
					)
*/
			)
