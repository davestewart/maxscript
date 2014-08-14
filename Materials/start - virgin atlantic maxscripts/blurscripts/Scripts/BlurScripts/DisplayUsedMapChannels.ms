-------------------------------------------------------------------------------
-- DisplayUsedMapChannels.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 08/06/01
-- Modified On: 08/08/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- What this script does: 
-- Displays all map channels that the selected material slot requires.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals 

global get_map_channels
global display_map_channels

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn get_map_channels mat =
	(
	an_error = false
	x = #()
	m = #()
	get_maps_from_mat mat x
	for i in x do
		(
		try
			(
			if classof i.coords == StandardUVGen then
				(
				if i.coords.mappingType == 0 and i.coords.mapping == 0 then
					(
					if finditem m i.coords.mapChannel == 0 then append m i.coords.mapChannel
					)
				)
			else if classof i.coords == StandardXYZGen then
				(
				if i.coords.coordType == 2 then
					(
					if finditem m i.coords.mapChannel == 0 then append m i.coords.mapChannel
					)
				)
			)
		catch
			(
			an_error = true
			)
		)
	if an_error == true then
		(
		MessageBox "At least one error has occured reading this material, it may include a map type that is not maxscript accessible. Such maps will not return any map channel value." title:"DisplayUsedMapChannels"
		)
	return m
	)
	
fn display_map_channels mat =
	(
	the_array = get_map_channels mat
	if the_array.count == 0 then MessageBox "No Map Channels are being used by this material" title:"DisplayUsedMapChannels"
	else 
		(
		sort the_array
		to_print = "Map Channels Required: "
		for i = 1 to the_array.count do
			(
			to_print += the_array[i] as string
			if i != the_array.count then to_print += ", "
			)
		print to_print
		MessageBox to_print title:"DisplayUsedMapChannels"
		)
	)

-- The Script

display_map_channels (meditMaterials[medit.GetActiveMtlSlot()])
)
-------------------------------------------------------------------------------