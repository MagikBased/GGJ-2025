extends Node2D

@export var bubble_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var bubble_speed: float = 100

func _ready():
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_Timer_timeout():
	spawn_bubble()

func spawn_bubble():
	var bubble = bubble_scene.instantiate()
	
	var screen_size = get_viewport_rect().size
	var x = randf_range(-50, screen_size.x + 50) 
	var y = randf_range(-50, screen_size.y + 50)
	bubble.position = Vector2(x, y)
	
	var center = screen_size / 2
	bubble.direction = (center - bubble.position).normalized()
	
	bubble.speed = bubble_speed
	
	$Bubbles.add_child(bubble)

func _on_timer_timeout() -> void:
	spawn_bubble()
