extends Panel

@export var filled_icon: Texture
@export var empty_icon: Texture
@onready var infinite_hp: Button = $VBox/HBoxContainer4/InfiniteHP
var infHP: bool
var coins: int = 0
var upgrades: Dictionary = {}
@onready var coin_label: Label = $VBox/HBoxContainer4/CoinLabel
@onready var buttons = [
	$VBox/HBoxContainer/MaxHealth,
	$VBox/HBoxContainer/Damage,
	$VBox/HBoxContainer2/Experience,
	$"VBox/HBoxContainer2/Immolate Dmg",
	$VBox/HBoxContainer3/PetCursor,
	$VBox/HBoxContainer3/Armour
]
var upgrade_costs: Array = [50, 150, 300]

func _ready() -> void:
	_initialize_upgrades()
	update_coin_label()
	infinite_hp.text = "Infinite HP: OFF"

func _initialize_upgrades() -> void:
	for button in buttons:
		if button is Button:
			var icons = button.get_children()
			upgrades[button.name] = {
				"costs": upgrade_costs,
				"icons": icons,
				"current_level": 0
			}
			_initialize_icons(icons)

	#$VBox/HBoxContainer/MaxHealth.connect("pressed", Callable(self, "_on_max_health_pressed"))
	#$VBox/HBoxContainer/Damage.connect("pressed", Callable(self, "_on_damage_pressed"))
	#$VBox/HBoxContainer2/Experience.connect("pressed", Callable(self, "_on_experience_pressed"))
	#$"VBox/HBoxContainer2/Immolate Dmg".connect("pressed", Callable(self, "_on_immolate_dmg_pressed"))
	#$VBox/HBoxContainer3/PetCursor.connect("pressed", Callable(self, "_on_pet_cursor_pressed"))
	#$VBox/HBoxContainer3/Armour.connect("pressed", Callable(self, "_on_armour_pressed"))

func _initialize_icons(icons: Array) -> void:
	for icon in icons:
		if icon is TextureRect:
			icon.texture = empty_icon

func _on_play_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false

func _on_max_health_pressed() -> void:
	print("here max")
	_handle_upgrade("MaxHealth")

func _on_damage_pressed() -> void:
	print("here dmg")
	_handle_upgrade("Damage")

func _on_experience_pressed() -> void:
	print("here exp")
	_handle_upgrade("Experience")

func _on_immolate_dmg_pressed() -> void:
	print("here immo")
	_handle_upgrade("Immolate Dmg")

func _on_pet_cursor_pressed() -> void:
	print("here pet")
	_handle_upgrade("PetCursor")

func _on_armour_pressed() -> void:
	print("here armr")
	_handle_upgrade("Armour")

func _handle_upgrade(button_name: String) -> void:
	return
	var upgrade = upgrades.get(button_name)
	if upgrade:
		var level = upgrade["current_level"]
		var costs = upgrade["costs"]
		var icons = upgrade["icons"]

		if level < costs.size() and coins >= costs[level]:
			# Deduct coins and upgrade
			coins -= costs[level]
			icons[level].texture = filled_icon
			upgrade["current_level"] += 1
			update_coin_label()
		else:
			print("Not enough coins or fully upgraded!")

func update_coin_label() -> void:
	coin_label.text = "Coins: %d" % coins


func _on_button_pressed() -> void:
	infHP = not infHP
	if infHP:
		infinite_hp.text = "Infinite HP: ON"
	else:
		infinite_hp.text = "Infinite HP: OFF"
