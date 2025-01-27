class_name SpawnInfo
extends Resource

@export var time_start:int
@export var time_end:int
@export var enemy:Resource = preload("res://Scenes/bubble.tscn")
@export var enemy_data: EnemyData
@export var enemy_number:int
@export var enemy_spawn_delay:int

var spawn_delay_counter = 0
