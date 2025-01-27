extends Node2D

@warning_ignore("unused_signal")
signal bubble_popped

@export var enemy_type: EnemyData
@export var bubble_hover_sounds: Array[AudioStream]

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var hp: float = 1.0
var speed: float = 100.0
var original_speed: float
var damage: float = 1.0
var knockback_recovery: float = 3.5
var experience: int = 1
var exp_spawn_chance: float = 1.0
var amplitude: float = 30.0
var frequency: float = 2.0
var bubble_scale: float = 1.0

var shrink_scale: float = 0.8
var hover_animation_duration: float = 0.2

var current_scale: Vector2
var base_position: Vector2
var time_elapsed: float = 0.0
var direction: Vector2
var target_position: Vector2 = Vector2.ZERO
var spawn_side: String = ""
var is_hovering: bool = false
var can_spawn_gem: bool = false
var was_popped_by_player: bool = false
var splat: bool
var split: bool

var player: Player
var camera: Camera2D
var exp_gem_scene = preload("res://Scenes/exp_gem.tscn")

func _ready() -> void:
	if enemy_type:
		sprite.texture = enemy_type.sprite
		hp = enemy_type.hp
		speed = enemy_type.speed
		original_speed = speed
		damage = enemy_type.damage
		knockback_recovery = enemy_type.knockback_recovery
		experience = enemy_type.experience
		amplitude = enemy_type.amplitude
		frequency = enemy_type.frequency
		bubble_scale = enemy_type.scale
		exp_spawn_chance = enemy_type.exp_spawn_chance
		sprite.scale = Vector2.ONE * bubble_scale
		sprite.modulate = Color(1, 1, 1, 1)
		splat = enemy_type.splat
		split = enemy_type.split

	current_scale = sprite.scale
	base_position = position
	direction = (target_position - position).normalized()
	connect("bubble_popped", Callable(player, "_on_bubble_popped"))

func _process(delta: float) -> void:
	time_elapsed += delta
	base_position += direction * speed * delta

	var perpendicular = Vector2(-direction.y, direction.x)
	var sine_offset = perpendicular * sin(time_elapsed * frequency) * amplitude
	position = base_position + sine_offset

	var target_scale = current_scale * (shrink_scale if is_hovering else 1.0)
	sprite.scale = sprite.scale.lerp(target_scale, delta / hover_animation_duration)

	if is_out_of_bounds():
		player.take_damage(damage)
		queue_free()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and can_spawn_gem:
		try_spawn_exp_gem()
	if what == NOTIFICATION_PREDELETE and hp <= 0:
		if splat:
			var splat_scene = preload("res://Scenes/ink_splat.tscn")
			var ink_splat = splat_scene.instantiate()
			ink_splat.global_position = global_position
			get_parent().add_child(ink_splat) 
		if split:
			var bubble_scene = preload("res://Scenes/bubble.tscn")
			var split1 = bubble_scene.instantiate()
			split1.enemy_type = enemy_type.split_bubble
			split1.global_position = global_position
			split1.direction = direction
			print(split1.direction)
			split1.camera = camera
			split1.player = player
			get_parent().add_child(split1)
			var split2 = bubble_scene.instantiate()
			split2.enemy_type = enemy_type.split_bubble
			split2.global_position = global_position
			split2.direction = -direction
			print(split2.direction)
			split2.camera = camera
			split2.player = player
			get_parent().add_child(split2)
			split2.direction = -direction

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
	if hp <= 0:
		can_spawn_gem = true
		was_popped_by_player = true
		player.bubbles_popped += 1
		if player.bubbles_popped % 5 == 0:
			#print("spawn coin?")
			pass
	queue_free()

func _on_area_2d_mouse_entered() -> void:
	is_hovering = true
	if !audio_stream_player_2d.playing and bubble_hover_sounds.size() > 0:
		var random_sound = bubble_hover_sounds[randi() % bubble_hover_sounds.size()]
		audio_stream_player_2d.stream = random_sound
		audio_stream_player_2d.play()

func _on_area_2d_mouse_exited() -> void:
	is_hovering = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("splat"):
		var splat = area.get_parent()
		splat.boost_bubble_speed(self)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("splat"):
		speed = original_speed
