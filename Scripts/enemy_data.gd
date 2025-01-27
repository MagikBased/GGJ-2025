class_name EnemyData
extends Resource

@export var sprite: Texture
@export var hp: float = 1.0
@export var speed: float = 100.0
@export var scale: float = 1.0
@export var damage: float = 1.0
@export var knockback_recovery: float = 3.5
@export var experience: int = 5
@export var exp_spawn_chance: float = 1.0
@export var amplitude: float = 30.0
@export var frequency: float = 2.0
@export var split: bool = false
@export var splat: bool = false
@export var split_bubble: EnemyData 
