struct property
(
	fn get type =
	(
		case type of
		(
			String: 0
			Number: 1
			Bool: 2
			Color: 3
			Font: 4
			Double: 5
			Date: 6
			Picture: 7
			Enum: 8
			EnumFlags: 9
			Category: 10
		)
	)
)
property.get "String"

fn getType prop =
(
	case (classof prop) of
	(
		String: 0		--String
		Integer: 1		--Number
		BooleanClass: 2	--Bool
		Color: 3		--Color
		"Font": 4
		Float: 5		--Double
		"Date": 6
		Bitmaptexture: 7--Picture
		Array: 8		--Enum
		Array: 9		--Enum
		"Category": 10
		default: -1
	)
)	
