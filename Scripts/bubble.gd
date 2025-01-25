extends Node2D

@export var speed: float = 100.0
@export var shrink_scale: float = 0.8
@export var hover_animation_duration: float = 0.2
@export var amplitude: float = 30.0
@export var frequency: float = 2.0

var direction: Vector2
var is_hovering: bool = false
var current_scale: Vector2
var base_position: Vector2
var time_elapsed: float = 0.0

func _ready() -> void:
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	current_scale = $Sprite2D.scale
	base_position = position

func _process(delta: float) -> void:
	time_elapsed += delta
	
	base_position += direction * speed * delta
	
	var perpendicular = Vector2(-direction.y, direction.x)
	var sine_offset = perpendicular * sin(time_elapsed * frequency) * amplitude
	position = base_position + sine_offset
	
	var target_scale = current_scale * (shrink_scale if is_hovering else 1.0)
	$Sprite2D.scale = $Sprite2D.scale.lerp(target_scale, delta / hover_animation_duration)

func _on_area_2d_mouse_entered() -> void:
	is_hovering = true

func _on_area_2d_mouse_exited() -> void:
	is_hovering = false
