class_name InkSplat
extends Node2D

@export var fade_duration: float = 1
@export var max_speed_multiplier: float = 2
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

var is_fading: bool = false

func _ready() -> void:
	rotation = randf_range(0, PI * 2)
	if not area.is_connected("mouse_entered", Callable(self, "_on_mouse_entered")):
		area.connect("mouse_entered", Callable(self, "_on_mouse_entered"))

func _process(delta: float) -> void:
	if is_fading:
		sprite.modulate.a -= delta / fade_duration
		if sprite.modulate.a <= 0:
			queue_free()

func _on_mouse_entered() -> void:
	is_fading = true

func _on_area_2d_mouse_exited() -> void:
	is_fading = false

func boost_bubble_speed(bubble: Node) -> void:
	var current_multiplier = max(1.0, max_speed_multiplier * sprite.modulate.a)
	bubble.speed *= current_multiplier

func reset_bubble_speed(bubble: Node) -> void:
	var current_multiplier = max_speed_multiplier * sprite.modulate.a
	bubble.speed /= current_multiplier
