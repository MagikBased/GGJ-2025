extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var camera: Camera2D

@onready var player = get_tree().get_first_node_in_group("player")
var time = 0

@warning_ignore("unused_signal")
signal changetime(time)

func _ready():
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout():
	time += 1
	for spawn in spawns:
		if time >= spawn.time_start and time <= spawn.time_end:
			if spawn.spawn_delay_counter < spawn.enemy_spawn_delay:
				spawn.spawn_delay_counter += 1
			else:
				spawn.spawn_delay_counter = 0
				var counter = 0
				while counter < spawn.enemy_number:
					var positions = get_random_position()
					var enemy_spawn = spawn.enemy.instantiate()
					enemy_spawn.global_position = positions["spawn_position"]
					enemy_spawn.target_position = positions["target_position"]
					enemy_spawn.spawn_side = positions["spawn_side"]
					enemy_spawn.camera = camera
					enemy_spawn.player = player
					add_child(enemy_spawn)
					counter += 1
	emit_signal("changetime", time)

func get_random_position() -> Dictionary:
	var viewport_size = Vector2(camera.get_viewport().size)
	var camera_rect = Rect2(camera.global_position - camera.zoom * viewport_size / 2, camera.zoom * viewport_size)
	var horizontal_margin = camera_rect.size.x * 0.3
	var vertical_margin = camera_rect.size.y * 0.3

	var top_left = Vector2(camera_rect.position.x - horizontal_margin, camera_rect.position.y - vertical_margin)
	var top_right = Vector2(camera_rect.position.x + camera_rect.size.x + horizontal_margin, camera_rect.position.y - vertical_margin)
	var bottom_left = Vector2(camera_rect.position.x - horizontal_margin, camera_rect.position.y + camera_rect.size.y + vertical_margin)
	var bottom_right = Vector2(camera_rect.position.x + camera_rect.size.x + horizontal_margin, camera_rect.position.y + camera_rect.size.y + vertical_margin)

	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	var target_pos1 = Vector2.ZERO
	var target_pos2 = Vector2.ZERO

	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
			target_pos1 = bottom_left
			target_pos2 = bottom_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
			target_pos1 = top_left
			target_pos2 = top_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
			target_pos1 = top_left
			target_pos2 = bottom_left
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
			target_pos1 = top_right
			target_pos2 = bottom_right

	var spawn_x = randf_range(spawn_pos1.x, spawn_pos2.x)
	var spawn_y = randf_range(spawn_pos1.y, spawn_pos2.y)
	var target_x = randf_range(target_pos1.x, target_pos2.x)
	var target_y = randf_range(target_pos1.y, target_pos2.y)

	return {
		"spawn_position": Vector2(spawn_x, spawn_y),
		"target_position": Vector2(target_x, target_y),
		"spawn_side": pos_side
	}
