extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var camera: Camera2D
@export var enemies: Array[EnemyData]

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
					
					# Assign the enemy_type from SpawnInfo
					enemy_spawn.enemy_type = spawn.enemy_data
					
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

	var spawn_rect = Rect2(
		camera_rect.position - Vector2(horizontal_margin, vertical_margin),
		camera_rect.size + Vector2(horizontal_margin * 2, vertical_margin * 2)
	)

	var target_rect = camera_rect

	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos = Vector2.ZERO
	var target_pos = Vector2.ZERO

	match pos_side:
		"up":
			spawn_pos = Vector2(
				randf_range(spawn_rect.position.x, spawn_rect.position.x + spawn_rect.size.x),
				spawn_rect.position.y
			)
			target_pos = Vector2(
				randf_range(target_rect.position.x, target_rect.position.x + target_rect.size.x),
				target_rect.position.y + target_rect.size.y
			)
		"down":
			spawn_pos = Vector2(
				randf_range(spawn_rect.position.x, spawn_rect.position.x + spawn_rect.size.x),
				spawn_rect.position.y + spawn_rect.size.y
			)
			target_pos = Vector2(
				randf_range(target_rect.position.x, target_rect.position.x + target_rect.size.x),
				target_rect.position.y
			)
		"right":
			spawn_pos = Vector2(
				spawn_rect.position.x + spawn_rect.size.x,
				randf_range(spawn_rect.position.y, spawn_rect.position.y + spawn_rect.size.y)
			)
			target_pos = Vector2(
				target_rect.position.x,
				randf_range(target_rect.position.y, target_rect.position.y + target_rect.size.y)
			)
		"left":
			spawn_pos = Vector2(
				spawn_rect.position.x,
				randf_range(spawn_rect.position.y, spawn_rect.position.y + spawn_rect.size.y)
			)
			target_pos = Vector2(
				target_rect.position.x + target_rect.size.x,
				randf_range(target_rect.position.y, target_rect.position.y + target_rect.size.y)
			)

	return {
		"spawn_position": spawn_pos,
		"target_position": target_pos,
		"spawn_side": pos_side
	}
