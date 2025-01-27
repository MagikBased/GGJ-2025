extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D  # Reference to the sprite

var camera: Camera2D
var target_position: Vector2 = Vector2.ZERO
var speed: float = 100.0
var turn_smoothness: float = 0.1
var click_delay: float = 0.5
var overlapping_bubbles: Array = []

var current_direction: Vector2 = Vector2.RIGHT  # Direction for movement

func _ready() -> void:
	camera = GameRef.camera
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	area_2d.connect("area_entered", Callable(self, "_on_area_entered"))
	area_2d.connect("area_exited", Callable(self, "_on_area_exited"))
	_set_random_target()

func _process(delta: float) -> void:
	if not camera:
		return

	var target_direction = (target_position - global_position).normalized()
	current_direction = current_direction.lerp(target_direction, turn_smoothness)

	global_position += current_direction * speed * delta

	if global_position.distance_to(target_position) < 10.0:
		_set_random_target()

	sprite.rotation = 0

func _on_timer_timeout() -> void:
	if not camera:
		camera = GameRef.camera
	if overlapping_bubbles.size() > 0:
		var bubble = overlapping_bubbles[0]
		bubble.hp -= GameRef.player.click_damage
		if bubble.hp <= 0:
			bubble.pop()
			bubble.can_spawn_gem = true
		_simulate_click()

func _set_random_target() -> void:
	if not camera:
		return
	var viewport_size = Vector2(camera.get_viewport().size)
	var camera_rect = Rect2(camera.global_position - camera.zoom * viewport_size / 2, camera.zoom * viewport_size)

	var x = randf_range(camera_rect.position.x, camera_rect.position.x + camera_rect.size.x)
	var y = randf_range(camera_rect.position.y, camera_rect.position.y + camera_rect.size.y)
	target_position = Vector2(x, y)

func _simulate_click() -> void:
	timer.start(click_delay)

func update_speed_and_timer(speed_multiplier: float, timer_multiplier: float) -> void:
	speed *= speed_multiplier
	timer.wait_time *= timer_multiplier
	if not timer.is_stopped():
		timer.start()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("bubble"):
		overlapping_bubbles.append(parent)

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("bubble"):
		overlapping_bubbles.erase(parent)
