class_name Player
extends Node2D

@export var camera: Camera2D
@export var bubble_pop_sounds: Array[AudioStream] = []
var overlapping_bubbles: Array[Node2D] = []
@onready var collect_area: Area2D = $CollectArea
@onready var exp_bar = get_node("%ExperienceBar")
@onready var bubble_pops: AudioStreamPlayer2D = $BubblePops
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound

var experience = 0
var experience_level = 1
var collected_experience = 0
var hp = 80
var maxhp = 80
var armor = 0
var click_damage = 1

var shake_timer: float = 0.0
var shake_intensity: float = 5.0
var shake_duration: float = 0.2
var shake_frequency: float = 50.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$ClickArea.connect("area_entered", Callable(self, "_on_area_entered"))
	$ClickArea.connect("area_exited", Callable(self, "_on_area_exited"))
	set_exp_bar(experience,calculate_experience_cap())

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var camera_rect = get_camera_rect()
	global_position = mouse_pos.clamp(camera_rect.position, camera_rect.position + camera_rect.size)
	if shake_timer > 0:
		shake_timer -= delta
		var shake_offset = Vector2(
			randf_range(-1, 1) * shake_intensity,
			randf_range(-1, 1) * shake_intensity
		)
		camera.offset = shake_offset
	else:
		camera.offset = Vector2.ZERO

func take_damage(damage: float):
	hp -= clamp(damage-armor,1.0,999.0)
	#print("Took damage HP: ", hp)
	damage_sound.play()
	shake_timer = shake_duration
	#health_bar.max_value = maxhp
	#health_bar.value = hp
	if hp <= 0:
		pass

func calculate_experience(gem_experience):
	var exp_required = calculate_experience_cap()
	collected_experience += gem_experience
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	set_exp_bar(experience,exp_required)

func calculate_experience_cap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 * (experience_level-19) * 8
	else:
		exp_cap = 255 + (experience_level-39) * 12
	return exp_cap

func set_exp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value

func levelup():
	var level_label = GameRef.ui_manager.get_node("%LevelLabel")
	level_label.text = str("Level: ",experience_level)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		pop_bubbles()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("bubble"):
		overlapping_bubbles.append(parent)

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("bubble"):
		overlapping_bubbles.erase(parent)

func pop_bubbles() -> void:
	for bubble in overlapping_bubbles:
		if bubble.is_in_group("bubble"):
			bubble.hp -= click_damage
			if bubble.hp <= 0:
				bubble.pop()

func _on_bubble_popped(pos: Vector2) -> void:
	if bubble_pop_sounds.size() > 0:
		var random_sound = bubble_pop_sounds[randi() % bubble_pop_sounds.size()]
		bubble_pops.stream = random_sound
		bubble_pops.global_position = pos
		bubble_pops.play()

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_experience = area.collect()
		if gem_experience != null:
			calculate_experience(gem_experience)


func get_camera_rect() -> Rect2:
	var viewport_size = Vector2(get_viewport().size)
	var world_position = camera.global_position
	var zoom = camera.zoom
	return Rect2(
		world_position - (zoom * viewport_size / 2),
		zoom * viewport_size
		)
