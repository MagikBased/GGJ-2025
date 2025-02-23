extends Node

const ICON_PATH = "res://Sprites/Icons/"
const UPGRADES = {
	"PetCursor1": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Three pet cursors who wander and clicks on bubbles",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"PetCursor2": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Your pet cursors move and click faster",
		"level": "Level: 2",
		"prerequisite": ["PetCursor1"],
	},
	"PetCursor3": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Three more pet cursors",
		"level": "Level: 3",
		"prerequisite": ["PetCursor2"],
	},
	"PetCursor4": {
		"icon": ICON_PATH + "pet_cursor.svg",
		"displayname": "Pet Cursor",
		"details": "Three more pet cursors",
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
		"details": "Three more pet cursors",
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
		"details": "Three more pet cursors",
		"level": "Level: 8",
		"prerequisite": ["PetCursor7"],
	},
	"health": {
		"icon": ICON_PATH + "heart.svg",
		"displayname": "Health",
		"details": "Heals you for 20 HP",
		"level": "N/A",
		"prerequisite": [],
	},
	"Immolate1": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "The area around you pops bubbles.",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"Immolate2": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the damage of your Immolate",
		"level": "Level: 2",
		"prerequisite": ["Immolate1"],
	},
	"Immolate3": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the size and damage of your Immolate",
		"level": "Level: 3",
		"prerequisite": ["Immolate2"],
	},
	"Immolate4": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the damage of your Immolate",
		"level": "Level: 4",
		"prerequisite": ["Immolate3"],
	},
	"Immolate5": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the damage of your Immolate",
		"level": "Level: 5",
		"prerequisite": ["Immolate4"],
	},
	"Immolate6": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the size of your Immolate",
		"level": "Level: 6",
		"prerequisite": ["Immolate5"],
	},
	"Immolate7": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the size of your Immolate",
		"level": "Level: 7",
		"prerequisite": ["Immolate6"],
	},
	"Immolate8": {
		"icon": ICON_PATH + "fire.svg",
		"displayname": "Immolate",
		"details": "Increase the damage and size of your Immolate",
		"level": "Level: 8",
		"prerequisite": ["Immolate7"],
	},
	#"Toothpick1": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "A toothpick will randomly attack",
		#"level": "Level: 1",
		#"prerequisite": [],
	#},
	#"Toothpick2": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Increases the damage of your toothpick",
		#"level": "Level: 2",
		#"prerequisite": ["Toothpick1"],
	#},
	#"Toothpick3": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Get a second Toothpick",
		#"level": "Level: 3",
		#"prerequisite": ["Toothpick2"],
	#},
	#"Toothpick4": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Increases the damage of your toothpick",
		#"level": "Level: 4",
		#"prerequisite": ["Toothpick3"],
	#},
	#"Toothpick5": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Increases the damage of your toothpick",
		#"level": "Level: 5",
		#"prerequisite": ["Toothpick4"],
	#},
	#"Toothpick6": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Increases the damage of your toothpick",
		#"level": "Level: 6",
		#"prerequisite": ["Toothpick5"],
	#},
	#"Toothpick7": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Get a third Toothpick",
		#"level": "Level: 7",
		#"prerequisite": ["Toothpick6"],
	#},
	#"Toothpick8": {
		#"icon": ICON_PATH + "toothpick.svg",
		#"displayname": "Toothpick",
		#"details": "Increases the damage of your toothpick",
		#"level": "Level: 8",
		#"prerequisite": ["Toothpick7"],
	#},
	"ClickDamage1": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"ClickDamage2": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 2",
		"prerequisite": ["ClickDamage1"],
	},
	"ClickDamage3": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 3",
		"prerequisite": ["ClickDamage2"],
	},
	"ClickDamage4": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 4",
		"prerequisite": ["ClickDamage3"],
	},
	"ClickDamage5": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 5",
		"prerequisite": ["ClickDamage4"],
	},
	"ClickDamage6": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 6",
		"prerequisite": ["ClickDamage5"],
	},
	"ClickDamage7": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 7",
		"prerequisite": ["ClickDamage6"],
	},
	"ClickDamage8": {
		"icon": ICON_PATH + "uparrow.svg",
		"displayname": "Click Damage",
		"details": "Increases your click damage",
		"level": "Level: 8",
		"prerequisite": ["ClickDamage7"],
	},
	"Exp1": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 1",
		"prerequisite": [],
	},
	"Exp2": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 2",
		"prerequisite": ["Exp1"],
	},
	"Exp3": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 3",
		"prerequisite": ["Exp2"],
	},
	"Exp4": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 4",
		"prerequisite": ["Exp3"],
	},
	"Exp5": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 5",
		"prerequisite": ["Exp4"],
	},
	"Exp6": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 6",
		"prerequisite": ["Exp5"]
	},
	"Exp7": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 7",
		"prerequisite": ["Exp6"],
	},
	"Exp8": {
		"icon": ICON_PATH + "uparrowblue.svg",
		"displayname": "Experience Multiplier",
		"details": "Increases the amount of experience you gain per gem",
		"level": "Level: 8",
		"prerequisite": ["Exp7"],
	},
	#"Upgrade Name": {
		#"icon": ICON_PATH + ".svg",
		#"displayname": "",
		#"details": "",
		#"level": "Level: ",
		#"prerequisite": [],
	#},
}
