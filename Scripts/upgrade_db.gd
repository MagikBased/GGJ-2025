extends Node

const ICON_PATH = "res://Sprites/Icons/"
const UPGRADES = {
	"PetCursor1": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "A pet cursor who wanders and clicks on bubbles",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"2": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "A pet cursor who wanders and clicks on bubbles",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"3": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "A pet cursor who wanders and clicks on bubbles",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"PetCursor3": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Your pet cursors move and click faster",
		"level": "Level: 3",
		"prerequisite": ["PetCursor2"],
	},
	"PetCursor4": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Get a second pet cursor",
		"level": "Level: 4",
		"prerequisite": ["PetCursor3"],
	},
	"PetCursor5": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Your pet cursors move and click faster",
		"level": "Level: 5",
		"prerequisite": ["PetCursor4"],
	},
	"PetCursor6": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Get a second pet cursor",
		"level": "Level: 6",
		"prerequisite": ["PetCursor5"],
	},
	"PetCursor7": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Your pet cursors move and click faster",
		"level": "Level: 7",
		"prerequisite": ["PetCursor6"],
	},
	"PetCursor8": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Get a second pet cursor",
		"level": "Level: 8",
		"prerequisite": ["PetCursor7"],
	},
	#"Upgrade ": {
		#"icon": ICON_PATH + ".svg",
		#"displayname": "",
		#"details": "",
		#"level": "Level: ",
		#"prerequisite": [],
	#},
	#"Upgrade Name": {
		#"icon": ICON_PATH + ".svg",
		#"displayname": "",
		#"details": "",
		#"level": "Level: ",
		#"prerequisite": [],
	#},
}
