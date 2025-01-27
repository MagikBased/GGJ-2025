class_name Player
extends Node2D

@export var camera: Camera2D
@export var bubble_pop_sounds: Array[AudioStream] = []
var overlapping_bubbles: Array[Node2D] = []
@onready var collect_area: Area2D = $CollectArea
@onready var exp_bar = get_node("%ExperienceBar")
@onready var health_bar = get_node("%HealthBar")
@onready var bubble_pops: AudioStreamPlayer2D = $BubblePops
@onready var damage_sound: AudioStreamPlayer2D = $DamageSound
@onready var immolate: Sprite2D = $Immolate
@onready var immolate_timer: Timer = $Immolate/ImmolateTimer
@onready var immolate_area: Area2D = $Immolate/ImmolateArea
@onready var coin_label: Label = %CoinLabel

const ITEM_OPTION = preload("res://Scenes/item_option.tscn")
const PET_CURSOR = preload("res://Scenes/pet_cursor.tscn")

var experience = 0
var experience_level = 1
var collected_experience = 0
var experience_multiplier: float = 1.0
var hp = 80
var maxhp = 80
var armor = 0
var click_damage = 5


var bubbles_popped = 0

var pet_cursor_speed_multiplier: float = 1.0
var pet_cursor_timer_multiplier: float = 1.0

var immolate_bubbles: Array[Node2D]
var immolate_damage: float = 10.0
var immolate_active: bool = false
var immolate_cooldown: float = 1
var immolate_scale_multiplier: float = 2.0

var shake_timer: float = 0.0
var shake_intensity: float = 5.0
var shake_duration: float = 0.2
var shake_frequency: float = 50.0

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	#if main_menu.infHP:
		#maxhp = 10000000
		#hp = 10000000
	#print(main_menu.infHP)
	health_bar.value = hp
	health_bar.max_value = maxhp
	
	print(hp)
	
	$ClickArea.connect("area_entered", Callable(self, "_on_area_entered"))
	$ClickArea.connect("area_exited", Callable(self, "_on_area_exited"))
	set_exp_bar(experience,calculate_experience_cap())
	immolate.visible = false
	immolate_area.monitoring = false
	immolate_timer.wait_time = immolate_cooldown
	immolate_timer.connect("timeout", Callable(self, "_on_immolate_timeout"))
	immolate_timer.stop()
	

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
	var main_menu: Panel = %MainMenu
	if !main_menu.infHP:
		hp -= clamp(damage-armor,1.0,999.0)
	#print("Took damage HP: ", hp)
	damage_sound.play()
	shake_timer = shake_duration
	#health_bar.max_value = maxhp
	health_bar.value = hp
	if hp <= 0:
		GameRef.get_node("%MainMenu").visible = true
		reset_game()
		get_tree().paused = true

func reset_game() -> void:
	hp = maxhp
	experience = 0
	collected_experience = 0
	experience_level = 1
	var main_menu: Panel = %MainMenu
	main_menu.coins = 1000
	main_menu.update_coin_label()
	var level_up_panel: LevelUpPanel = %LevelUpPanel
	level_up_panel.upgrade_options = []
	level_up_panel.collected_upgrades = []
	var spawner: Node2D = $"../Managers/Spawner"
	for node in get_tree().get_nodes_in_group("bubble"):
		if node.get_parent() == spawner:
			node.queue_free()
	for node in get_tree().get_nodes_in_group("loot"):
		if node.get_parent() == spawner:
			node.queue_free()
	for node in get_tree().get_nodes_in_group("pet"):
		node.queue_free()
	for node in get_tree().get_nodes_in_group("splat"):
		node.queue_free()
	spawner.time = 0
	click_damage = 5
	experience_multiplier = 1.0
	pet_cursor_speed_multiplier = 1.0
	pet_cursor_timer_multiplier = 1.0
	immolate_damage = 0
	immolate_active = false
	$Immolate.visible = false
	$Immolate/ImmolateArea.monitoring = false
	$Immolate/ImmolateTimer.stop()
	calculate_experience(0)
	var level_label = GameRef.ui_manager.get_node("%LevelLabel")
	level_label.text = str("Level: ",experience_level)
	health_bar.value = hp
	health_bar.max_value = maxhp

func calculate_experience(gem_experience):
	gem_experience *= experience_multiplier
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

func calculate_experience_cap() -> int:
	if experience_level < 3:
		return experience_level * 10
	elif experience_level < 10:
		return 100 + (experience_level - 3) * 20
	elif experience_level < 20:
		return 200 + (experience_level - 9) * 40
	elif experience_level < 40:
		return 600 + (experience_level - 19) * 80
	else:
		return 2200 + (experience_level - 39) * 120


func set_exp_bar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value

func levelup():
	GameRef.get_node("%LevelUpSound").play()
	var level_label = GameRef.ui_manager.get_node("%LevelLabel")
	level_label.text = str("Level: ",experience_level)
	var level_up_panel = GameRef.get_node("%LevelUpPanel")
	#var upgrade_options = GameRef.get_node("%UpgradeOptions")
	var offscreen_position = Vector2(1600, get_viewport().size.y / 2 - 360)
	level_up_panel.position = offscreen_position
	var target_position = Vector2(get_viewport().size.x / 2 - 400, get_viewport().size.y / 2 - 360)
	level_up_panel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = ITEM_OPTION.instantiate()
		option_choice.item = level_up_panel.get_random_item()
		GameRef.get_node("%UpgradeOptions").add_child(option_choice)
		options += 1
	var tween = level_up_panel.create_tween()
	tween.tween_property(level_up_panel, "position", target_position, 0.2)
	tween.tween_property(level_up_panel, "modulate:a", 1.0, 0.5)
	get_tree().paused = true

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
				var main_menu: Panel = %MainMenu
				main_menu.coins += 1
				coin_label.text = str ("x ", main_menu.coins)


func _on_bubble_popped(pos: Vector2) -> void:
	if bubble_pop_sounds.size() > 0:
		var random_sound = bubble_pop_sounds[randi() % bubble_pop_sounds.size()]
		bubble_pops.stream = random_sound
		bubble_pops.global_position = pos
		bubble_pops.play()

func _on_immolate_timeout() -> void:
	for bubble in immolate_bubbles:
		if bubble and bubble.is_in_group("bubble"):
			bubble.hp -= immolate_damage
			if bubble.hp <= 0:
				bubble.pop()
	immolate_timer.start()

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

func upgrade_character(upgrade) -> void:
	match upgrade:
		"PetCursor1":
			_spawn_pet_cursor(3)
			_update_pet_cursors()
		"PetCursor2":
			pet_cursor_speed_multiplier += 0.25
			pet_cursor_timer_multiplier -= .25
			_update_pet_cursors()
		"PetCursor3":
			_spawn_pet_cursor(3)
			_update_pet_cursors()
		"PetCursor4":
			_spawn_pet_cursor(3)
			_update_pet_cursors()
		"PetCursor5":
			pet_cursor_speed_multiplier += 0.25
			pet_cursor_timer_multiplier -= .1
			_update_pet_cursors()
		"PetCursor6":
			_spawn_pet_cursor(3)
			_update_pet_cursors()
		"PetCursor7":
			pet_cursor_speed_multiplier += 0.25
			_update_pet_cursors()
		"PetCursor8":
			_spawn_pet_cursor(3)
			_update_pet_cursors()
		
		"Immolate1":
			_activate_immolate()
		"Immolate2":
			immolate_damage += 2
			_activate_immolate()
		"Immolate3":
			immolate_damage += 4
			immolate_scale_multiplier += 1
			immolate_timer.wait_time = max(0.5, immolate_timer.wait_time - 0.5)
			_activate_immolate()
		"Immolate4":
			immolate_damage += 2
			_activate_immolate()
		"Immolate5":
			immolate_damage += 2
			_activate_immolate()
		"Immolate6":
			immolate_scale_multiplier += 1
			_activate_immolate()
		"Immolate7":
			immolate_damage += 2
			_activate_immolate()
		"Immolate8":
			immolate_scale_multiplier += 0.5
			immolate_damage += 4
			_activate_immolate()
		"Toothpick1":
			pass
		"Toothpick2":
			pass
		"Toothpick3":
			pass
		"Toothpick4":
			pass
		"Toothpick5":
			pass
		"Toothpick6":
			pass
		"Toothpick7":
			pass
		"Toothpick8":
			pass
		"Exp1":
			experience_multiplier += 0.1
		"Exp2":
			experience_multiplier += 0.2
		"Exp3":
			experience_multiplier += 0.3
		"Exp4":
			experience_multiplier += 0.3
		"Exp5":
			experience_multiplier += 0.3
		"Exp6":
			experience_multiplier += 0.3
		"Exp7":
			experience_multiplier += 0.3
		"Exp8":
			experience_multiplier += 0.4

		"ClickDamage1","ClickDamage2","ClickDamage3","ClickDamage4","ClickDamage5","ClickDamage6","ClickDamage7","ClickDamage8":
			click_damage += 1
		"health":
			hp += 20
			hp = clamp(hp,0,maxhp)
	var option_children = GameRef.get_node("%UpgradeOptions").get_children()
	for i in option_children:
		i.queue_free()
	GameRef.get_node("%LevelUpPanel").upgrade_options.clear()
	GameRef.get_node("%LevelUpPanel").collected_upgrades.append(upgrade)
	GameRef.get_node("%LevelUpPanel").visible = false
	get_tree().paused = false
	calculate_experience(0)


func _spawn_pet_cursor(count: int) -> void:
	for i in range(count):
		var pet_cursor = PET_CURSOR.instantiate()
		pet_cursor.camera = camera
		pet_cursor.add_to_group("pet_cursors")
		get_parent().add_child(pet_cursor)

func _update_pet_cursors() -> void:
	for pet_cursor in get_tree().get_nodes_in_group("pet_cursors"):
		pet_cursor.update_speed_and_timer(pet_cursor_speed_multiplier, pet_cursor_timer_multiplier)

func _activate_immolate() -> void:
	if !immolate_active:
		immolate_active = true
		immolate.visible = true
		immolate_area.monitoring = true
		immolate_timer.start()
	immolate.scale = Vector2.ONE * immolate_scale_multiplier
	print("immolate scale: " , immolate_scale_multiplier)
	#immolate_area.scale = Vector2.ONE * immolate_scale_multiplier

func _on_immolate_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("bubble"):
		immolate_bubbles.append(parent)

func _on_immolate_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.is_in_group("bubble"):
		immolate_bubbles.erase(parent)
