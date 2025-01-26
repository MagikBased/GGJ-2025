extends Control

@onready var player = GameRef.player
@onready var label_name: Label = $LabelName
@onready var label_description: Label = $LabelDescription
@onready var label_level: Label = $LabelLevel
@onready var item_icon: TextureRect = $ItemIcon

var item = null

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade",Callable(player,"upgrade_character"))
	if item == null:
		pass
		#item="food"
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _on_button_pressed() -> void:
	emit_signal("selected_upgrade", item)
