class_name Game
extends Node2D

@onready var spawner: Node2D = $Managers/Spawner
@onready var experience_bar: ProgressBar = %ExperienceBar
@onready var player: Player = $Cursor

@onready var camera: Camera2D = $Camera2D
@onready var ui_manager: Control = $Managers/CanvasLayer/UIManager

func _ready():
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("restart"):
		var current_scene = get_tree().current_scene
		var scene_path = current_scene.scene_file_path
		get_tree().change_scene_to_file(scene_path)
