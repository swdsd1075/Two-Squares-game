extends Node2D

var player_1 : CharacterBody2D
var player_2 : CharacterBody2D
@onready var camera = $Players/Camera2D

var shake_strength : float = 0.0
var shake_decay : float = 19.0 # سرعة اختفاء الاهتزاز
var coin_item_scene = preload("res://Scene/coin.tscn")
var rocket_item_scene = preload("res://Scene/rocket_item.tscn")
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
var zoom_out : bool = false

func start_shake(strength: float = 10.0) -> void:
	shake_strength = strength

func _ready():
	player_1 = get_node("Players/player_1")
	player_2 = get_node("Players/player_2")
	#make the projectile node
	$Players/player_1.projectiles_node = $projectiles
	$Players/player_2.projectiles_node = $projectiles
	#Diff
	if Globels.difficlalty == "Esey":
		item_max_number -= 2
		item_spown_timer += 1.5
	elif Globels.difficlalty == "Normal":
		pass
	elif Globels.difficlalty == "Hard":
		item_max_number += 3
		item_spown_timer -= 2
	$timers/item_spown_timer.wait_time = item_spown_timer
	
func _process(delta):
	#for partcals matrial
	if Globels.lights == false:
		$Players/kill_effect.material.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
		$Players/kill_effect.material.light_mode = CanvasItemMaterial.LIGHT_MODE_NORMAL
	else:
		$Players/kill_effect.material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		$Players/kill_effect.material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	
	if not Globels.start_play:return
	if Globels.lights == false: 
		$CanvasModulate.color = Color(1.0, 1.0, 1.0)
	else:
		$CanvasModulate.color = Color(0.114, 0.114, 0.114)
	#if not Globels.lights: $"particals and lights/GPUParticles2D".position = Vector2(8888,8888)
	$Players/kill_effect.visible = Globels.partcals
	$"particals and lights/GPUParticles2D".visible = Globels.partcals
	#esc
	#ui
	#die partcels system
	
	if shake_strength > 0:
		$Players/Camera2D.offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		$Players/Camera2D.offset = Vector2.ZERO
	
	if player_1 and player_2:
		if ($Players/player_1.die_effect and not if_die_effect) or ($Players/player_2.die_effect and not if_die_effect):
			if_die_effect = true
			$timers/if_die_effect_timer.start()
			$Players/kill_effect.emitting = true
			if $Players/player_1.die_effect:$Players/kill_effect.position = $Players/player_1.the_last_pos
			elif $Players/player_2.die_effect:$Players/kill_effect.position = $Players/player_2.the_last_pos
	return
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
		target_zoom.x -= 0.385
		target_zoom.y -= 0.385
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
	if body.has_method("check_player_1") or body.has_method("check_player_2"): # التأكد إذا كان اللاعب 1 أو أي كائن آخر
		var random_marker = spown_markers.pick_random()
		body.position = random_marker.position
		start_shake()
		#spown partcals
		
		if body.has_method("check_player_1"):
			$Players/player_1.spown_effect()
			$Players/player_1.hit(5)
		elif body.has_method("check_player_2"):
			$Players/player_2.spown_effect()
			$Players/player_2.hit(5)
			
@export var item_spown_timer : float = 9
@onready var spown_items_points = $spown_items_markers.get_children()
var items_now : int = 0
@export var item_max_number : int = 5

func _on_item_spown_timer_timeout() -> void:
	if not Globels.start_play and item_max_number <= items_now:return
	# غير وقت التايمر بشكل عشوائي
	$timers/item_spown_timer.start()
	var empty_points = []
	for point in spown_items_points:
		if is_point_empty(point): # تحقق إذا النقطة فاضية
			empty_points.append(point)
	
	# إذا ما فيه نقاط فاضية → نوقف السبون
	if empty_points.is_empty() and not item_max_number <= items_now:
		return
	
	# اختيار نقطة فاضية عشوائية
	var random_point = empty_points.pick_random()
		
	# قائمة العناصر
	var items : Array = [
		rocket_item_scene.instantiate(),
		random_box_scene.instantiate(),
		damage_item_scene.instantiate(),
		speed_item_scene.instantiate(),
		heart_item_scene.instantiate(),
		coin_item_scene.instantiate(),
		null,
		grenade_item_scene.instantiate()
	]

	# اختيار أيتم عشوائي
	var nasbah = randf() # بين 0 و 1
	var random_item

	if Globels.difficlalty == "Esey":
		if nasbah >= 0.02 and nasbah < 0.07: # rocket (5%)
			random_item = items[0]
		elif nasbah >= 0.07 and nasbah < 0.17: # random box (10%)
			random_item = items[1]
		elif nasbah >= 0.17 and nasbah < 0.33: # damage item (16%)
			random_item = items[2]
		elif nasbah >= 0.33 and nasbah < 0.49: # speed item (16%)
			random_item = items[3]
		elif nasbah >= 0.49 and nasbah < 0.64: # heart (15%)
			random_item = items[4]
		elif nasbah >= 0.64 and nasbah < 0.70: # grenade (6%)
			random_item = items[7]
		elif nasbah >= 0.70 and nasbah < 0.90: # coin (20%)
			random_item = items[5]
		else: # null (10%)
			random_item = items[6]

	elif Globels.difficlalty == "Normal":
		if nasbah >= 0.02 and nasbah < 0.08: # rocket (6%)
			random_item = items[0]
		elif nasbah >= 0.08 and nasbah < 0.18: # random box (10%)
			random_item = items[1]
		elif nasbah >= 0.18 and nasbah < 0.34: # damage item (16%)
			random_item = items[2]
		elif nasbah >= 0.34 and nasbah < 0.50: # speed item (16%)
			random_item = items[3]
		elif nasbah >= 0.50 and nasbah < 0.62: # heart (12%)
			random_item = items[4]
		elif nasbah >= 0.62 and nasbah < 0.71: # grenade (9%)
			random_item = items[7]
		elif nasbah >= 0.71 and nasbah < 0.91: # coin (20%)
			random_item = items[5]
		else: # null (9%)
			random_item = items[6]

	elif Globels.difficlalty == "Hard":
		if nasbah >= 0.02 and nasbah < 0.12: # rocket (10%)
			random_item = items[0]
		elif nasbah >= 0.12 and nasbah < 0.22: # random box (10%)
			random_item = items[1]
		elif nasbah >= 0.22 and nasbah < 0.38: # damage item (16%)
			random_item = items[2]
		elif nasbah >= 0.38 and nasbah < 0.54: # speed item (16%)
			random_item = items[3]
		elif nasbah >= 0.54 and nasbah < 0.64: # heart (10%)
			random_item = items[4]
		elif nasbah >= 0.64 and nasbah < 0.76: # grenade (12%)
			random_item = items[7]
		elif nasbah >= 0.76 and nasbah < 0.96: # coin (20%)
			random_item = items[5]
		else: # null (4%)
			random_item = items[6]






	if random_item != null and not item_max_number <= items_now:
		if (random_item == items[1] and random_point.global_position.distance_to(Globels.player_1_pos) < 43.0) \
		or (random_item == items[1] and random_point.global_position.distance_to(Globels.player_2_pos) < 43.0):
			return

		random_item.position = random_point.position
		$items.add_child(random_item)
		items_now += 1

func is_point_empty(point: Node2D) -> bool:
	for item in $items.get_children():
		if item.global_position.distance_to(point.global_position) < 30.0:
			return false # فيه أيتم → النقطة مش فاضية
	return true # ما فيه أيتم → النقطة فاضية


func _on_if_die_effect_timer_timeout() -> void:
	if_die_effect = false
