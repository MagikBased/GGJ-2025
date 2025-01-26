extends Node2D

@warning_ignore("unused_signal")
signal bubble_popped

@export var hp: float = 1
@export var speed: float = 100.0
@export var damage: float = 1
@export var knockback_recovery = 3.5
@export var experience = 5
@export var enemy_damage = 1

@export var bubble_hover_sounds: Array[AudioStream] = []

var shrink_scale: float = 0.8
var hover_animation_duration: float = 0.2
var amplitude: float = 30.0
var frequency: float = 2.0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var exp_gem_scene = preload("res://Scenes/exp_gem.tscn")
var exp_spawn_chance: float = 1

var direction: Vector2
var is_hovering: bool = false
var current_scale: Vector2
var base_position: Vector2
var time_elapsed: float = 0.0
var target_position: Vector2
var spawn_side: String
var camera: Camera2D
var can_spawn_gem: bool = false
var player: Player

func _ready() -> void:
	direction = (target_position - position).normalized()
	current_scale = $Sprite2D.scale
	base_position = position
	connect("bubble_popped", Callable(player, "_on_bubble_popped"))

func _process(delta: float) -> void:
	time_elapsed += delta
	base_position += direction * speed * delta
	var perpendicular = Vector2(-direction.y, direction.x)
	var sine_offset = perpendicular * sin(time_elapsed * frequency) * amplitude
	position = base_position + sine_offset
	var target_scale = current_scale * (shrink_scale if is_hovering else 1.0)
	$Sprite2D.scale = $Sprite2D.scale.lerp(target_scale, delta / hover_animation_duration)
	
	if is_out_of_bounds():
		player.take_damage(damage)
		queue_free()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and can_spawn_gem:
		try_spawn_exp_gem()

func try_spawn_exp_gem() -> void:
	if randi() % 100 < exp_spawn_chance * 100:
		var gem = exp_gem_scene.instantiate()
		gem.experience = experience
		gem.global_position = global_position
		gem.camera = camera
		get_parent().add_child(gem)

func is_out_of_bounds() -> bool:
	var viewport_size = Vector2(camera.get_viewport().size)
	var camera_rect = Rect2(camera.global_position - camera.zoom * viewport_size / 2, camera.zoom * viewport_size)

	var buffer_distance = 100.0 * current_scale.x
	var top_left = camera_rect.position - Vector2(buffer_distance, buffer_distance)
	var bottom_right = camera_rect.position + camera_rect.size + Vector2(buffer_distance, buffer_distance)

	match spawn_side:
		"up":
			return position.y > bottom_right.y
		"down":
			return position.y < top_left.y
		"left":
			return position.x > bottom_right.x
		"right":
			return position.x < top_left.x
		_:
			return false

func pop() -> void:
	emit_signal("bubble_popped", global_position)
	can_spawn_gem = true
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	is_hovering = true
	if !audio_stream_player_2d.playing:
		if bubble_hover_sounds.size() > 0:
			var random_sound = bubble_hover_sounds[randi() % bubble_hover_sounds.size()]
			audio_stream_player_2d.stream = random_sound
			audio_stream_player_2d.play()

func _on_area_2d_mouse_exited() -> void:
	is_hovering = false
