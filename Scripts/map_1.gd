extends Node2D

var player_1 : CharacterBody2D
var player_2 : CharacterBody2D
@onready var camera = $Players/Camera2D

var grenade_item_scene  = preload("res://Scene/grenades.tscn")
var speed_item_scene  = preload("res://Scene/speed_item.tscn")
var damage_item_scene  = preload("res://Scene/damage_item.tscn")
var heart_item_scene = preload("res://Scene/heart.tscn")
var random_box_scene = preload("res://Scene/mystry_box.tscn") #this is item
@export var min_zoom := Vector2(1, 1)       # زوم قريب (عندما يكون اللاعبان بعيدين)
@export var max_zoom := Vector2(1.5, 1.5)       # زوم بعيد (عندما يكون اللاعبان قريبين)
@export var zoom_speed := 5.0
@export var max_distance := 1000.0
@export var zoom_player_die : Vector2 = Vector2(2.5,2.5)
var if_die_effect : bool = false
@export var safe_margin: float = 200.0  # مسافة الأمان من الحواف
@export var extra_margin: float = 100.0   # مسافة أمان إضافية بين اللاعبين
@export var distance_padding: float = 100.0       # مسافة إضافية بين اللاعبين


func _ready():
	player_1 = get_node("Players/player_1")
	player_2 = get_node("Players/player_2")
	#make the projectile node
	$Players/player_1.projectiles_node = $projectiles
	$Players/player_2.projectiles_node = $projectiles

func _process(delta):
	#ui
	#die partcels system
	if player_1 and player_2:
		if ($Players/player_1.die_effect and not if_die_effect) or ($Players/player_2.die_effect and not if_die_effect):
			if_die_effect = true
			$timers/if_die_effect_timer.start()
			$Players/kill_effect.emitting = true
			if $Players/player_1.die_effect:$Players/kill_effect.position = $Players/player_1.the_last_pos
			elif $Players/player_2.die_effect:$Players/kill_effect.position = $Players/player_2.the_last_pos
	
	$timers/item_spown_timer.wait_time = item_spown_timer

	if player_1 and player_2:
		# ✅ مركز الكاميرا = منتصف اللاعبين
		var center_position = (player_1.global_position + player_2.global_position) / 2.0
		camera.global_position = camera.global_position.lerp(center_position, 0.1)

		# ✅ حساب المسافة بين اللاعبين
		var distance = player_1.global_position.distance_to(player_2.global_position)

		# ✅ نسبة الزوم بناءً على المسافة
		var zoom_factor = clamp(distance / max_distance, 0.0, 1.0)

		# ✅ عكس اتجاه الزوم:
		var target_zoom = min_zoom.lerp(max_zoom, 1.0 - zoom_factor)
		target_zoom.x -= 0.25
		target_zoom.y -= 0.25
		# ✅ حركة ناعمة
		camera.zoom = camera.zoom.move_toward(target_zoom, delta * zoom_speed)

	elif player_2:
		camera.position = player_2.position
		camera.zoom = zoom_player_die

	elif player_1:
		camera.position = player_1.position
		camera.zoom = zoom_player_die






#choice a random position to spown the player
@onready var spown_markers = $spown_markers.get_children() # جميع نقاط السبون

func _on_die_area_body_entered(body: Node2D) -> void:
	if body.has_method("check_player_1") or "check_player_1" in body: # التأكد إذا كان اللاعب 1 أو أي كائن آخر
		var random_marker = spown_markers.pick_random()
		body.position = random_marker.position
	else:
		var random_marker = spown_markers.pick_random()
		body.position = random_marker.position

@export var item_spown_timer : float = 0.1
@onready var spown_items_points = $spown_items_markers.get_children()

func _on_item_spown_timer_timeout() -> void:
	# غير وقت التايمر بشكل عشوائي
	$timers/item_spown_timer.wait_time = randi_range(1, 2)
	$timers/item_spown_timer.start()
	
	var empty_points = []
	for point in spown_items_points:
		if is_point_empty(point): # تحقق إذا النقطة فاضية
			empty_points.append(point)
	
	# إذا ما فيه نقاط فاضية → نوقف السبون
	if empty_points.is_empty():
		return
	
	# اختيار نقطة فاضية عشوائية
	var random_point = empty_points.pick_random()
	
	# قائمة العناصر
	var items : Array = [
		grenade_item_scene.instantiate(),
		null,
		speed_item_scene.instantiate(),
		speed_item_scene.instantiate(),
		speed_item_scene.instantiate(),
		null,
		damage_item_scene.instantiate(),
		damage_item_scene.instantiate(),
		damage_item_scene.instantiate(),
		null,
		heart_item_scene.instantiate(),
		heart_item_scene.instantiate(),
		random_box_scene.instantiate(),
		null, null, null
	]
	
	# اختيار أيتم عشوائي
	var random_item = items.pick_random()
	if random_item != null:
		random_item.position = random_point.position
		$items.add_child(random_item)

func is_point_empty(point: Node2D) -> bool:
	for item in $items.get_children():
		if item.global_position.distance_to(point.global_position) < 8.0:
			return false # فيه أيتم → النقطة مش فاضية
	return true # ما فيه أيتم → النقطة فاضية


func _on_if_die_effect_timer_timeout() -> void:
	if_die_effect = false
