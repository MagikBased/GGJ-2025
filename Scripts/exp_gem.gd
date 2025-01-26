extends Node2D

@export var experience = 1
@export var min_bounce_distance = 150.0
@export var max_bounce_distance = 300.0
@export var bounce_duration = 0.5
@export var total_bounces = 2

var target = null
var speed = -8
var bounce_count = 0
var is_collectable = false
var bounce_timer = 0.0
var bounce_magnitude = max_bounce_distance
var bounce_direction = Vector2.ZERO
var current_bounce_start: Vector2
var current_bounce_target: Vector2
var vertical_peak = 0.0
var collecting_away_phase = true
var allow_collection = false
var camera: Camera2D

@onready var sprite = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	choose_random_bounce_direction()

func _physics_process(delta):
	if bounce_count < total_bounces:
		bounce_timer += delta
		var t = bounce_timer / bounce_duration
		t = clamp(t, 0.0, 1.0)
		global_position = calculate_bounce_position(t)
		global_position = clamp_to_camera_bounds(global_position)  # Clamp position
		if t >= 1.0:
			bounce_count += 1
			bounce_timer = 0.0
			if bounce_count < total_bounces:
				prepare_next_bounce()
			else:
				is_collectable = true
				collision.disabled = false
				speed = -8
	elif target != null and is_collectable:
		if collecting_away_phase:
			global_position += (global_position - target.global_position).normalized() * abs(speed) * delta
			speed += 800 * delta
			if speed > 350:
				collecting_away_phase = false
				speed = 350
				allow_collection = true
		else:
			global_position = global_position.move_toward(target.global_position, speed * delta)
			speed += 800 * delta
		global_position = clamp_to_camera_bounds(global_position)  # Clamp position

func clamp_to_camera_bounds(pos: Vector2) -> Vector2:
	var camera_rect = get_camera_rect()
	return pos.clamp(camera_rect.position, camera_rect.position + camera_rect.size)


func choose_random_bounce_direction():
	collision.disabled = true
	is_collectable = false
	var angle = randf_range(-PI / 4, PI / 4)
	bounce_direction = Vector2(cos(angle), sin(angle)).normalized()
	bounce_magnitude = randf_range(min_bounce_distance, max_bounce_distance)
	prepare_next_bounce()

func prepare_next_bounce():
	current_bounce_start = global_position
	current_bounce_target = global_position + (bounce_direction * bounce_magnitude)
	vertical_peak = bounce_magnitude * 0.5
	bounce_magnitude *= 0.5

func calculate_bounce_position(t: float) -> Vector2:
	var horizontal = current_bounce_start.lerp(current_bounce_target, t)
	var vertical = -4.0 * vertical_peak * t * (t - 1.0)
	return horizontal + Vector2(0, vertical)

func collect():
	if is_collectable and allow_collection:
		collision.call_deferred("set", "disabled", true)
		sprite.visible = false
		queue_free()
		return experience

func get_camera_rect() -> Rect2:
	var viewport_size = Vector2(get_viewport().size)
	var camera_position = camera.global_position
	var zoom = camera.zoom
	return Rect2(
		camera_position - (zoom * viewport_size / 2),
		zoom * viewport_size
	)
