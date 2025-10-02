extends CharacterBody2D

class_name player

var rocket_scene : PackedScene = preload("res://Scene/target_rocket.tscn")
var damage_on_off : bool = false
var speed_on_off : bool = false
@export var item_speed_value : int = 350 #the complete speed after increes
@export var item_damage_value : int = 20 #the complete speed after increes
var choice_player : int = 1
var attack_timer : bool = false
var attack_area : bool = false
@export var speed: int = 200
@export var gravity: int = 900
@export var jump_force: int = -350
@export var attack_boost : int = 16000
@export var attack_boost_friction := 30000
var current_boost := 0.0
var target: CharacterBody2D
var hit_timer : bool = false
@export var damege : int = 10
@export var grenade_damage : int = 20

var projectiles_node  = null
var attack_2_timer : bool = false
var grenade_scene = preload("res://Scene/greande.tscn")
@export var grenades : int = 2
var die : bool = false
var die_effect : bool = false
var enter_screen : bool = true #i dont know if that correct
var the_last_pos : Vector2
var death_var : bool = false
var whats_the_effect : String = "speed"
var if_has_rocket : bool = false
var Global_rocket
var controls : bool = true

func chase_the_marker():
	if if_has_rocket and is_instance_valid(Global_rocket):
		if not Global_rocket.boom_active and not Global_rocket.start_chasing:
			Global_rocket.position = $markers/rocket_position.global_position
	else:
		if_has_rocket = false
#rocket create
func rocket():
	if not if_has_rocket:
		Global_rocket = rocket_scene.instantiate()
		Global_rocket.position = $markers/rocket_position.global_position
		Global_rocket.player_choice = choice_player
		$"../../projectiles".add_child(Global_rocket)
		if_has_rocket = true

func damage_or_speed_effect(type:String): #damege or speed or coin
	if not $CanvasLayer/texts/VBoxContainer/hbox.modulate == Color(1.0, 1.0, 1.0) or not $CanvasLayer/texts/VBoxContainer/hbox2.modulate == Color(1.0, 1.0, 1.0):
		var the_type
		if type == "speed":the_type = $CanvasLayer/texts/VBoxContainer/hbox2
		elif type == "damege": the_type = $CanvasLayer/texts/VBoxContainer/hbox
		elif type == "coin": the_type =  $CanvasLayer/texts/VBoxContainer/hbox3
		else:print("oops this is error (your type)")
		the_type.visible = true
		var the_loops : int = 2
		if type == "coin":
			the_loops = 1
		var tween = create_tween().set_loops(the_loops) 
		tween.tween_property(the_type, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(the_type, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		

func spown_effect():
	$spwon_effect.emitting = true
	$sounds/MinecraftTypeFireworkBlast.play()
func _ready() -> void:
	random_spown_effect()
	Globels.player_1_grenades = grenades
	Globels.player_2_grenades = grenades
	Globels.player_speed_propties[0] = speed
	Globels.player_speed_propties[1] = speed
	Globels.player_damage_propties[0] = damege
	Globels.player_damage_propties[1] = damege
	
	if Globels.difficlalty == "Esey":
		damege -= 5
		grenade_damage -= 5
	elif Globels.difficlalty == 'Normal':
		pass
	elif Globels.difficlalty == "Hard":
		damege += 5
		grenade_damage -= 10

#attack_2 func
func attack_2(): #player_1_or_2
	attack_2_timer = true
	grenades -= 1
	$sounds/GrenadeLauncher106342.play()
	$timers/Attack_2_timer.start()
	var grenade = grenade_scene.instantiate()
	grenade.global_position = global_position
	grenade.player_1_or_2 = choice_player
	grenade.damage = grenade_damage
	#for move the grenade
	if $AnimatedSprite2D.flip_h:
		grenade.linear_velocity = Vector2(-250, -70)
		grenade.angular_velocity = -6.0
	else:
		grenade.linear_velocity = Vector2(250, -70)
		grenade.angular_velocity = 6.0
	projectiles_node.add_child(grenade)


func death():
	#this is for UI
	death_var = true
	if Globels.player_1_heart == 0:
		Globels.player_1_health = 0
	elif Globels.player_2_heart == 0:
		Globels.player_2_health = 0 
	$sounds/Explosion312361.play()
	$AnimatedSprite2D2.play("death_effect")
	await get_tree().create_timer(0.15).timeout
	$"../..".start_shake(15)
	$AnimatedSprite2D.visible = false
	$spwon_effect.visible = false
	await $AnimatedSprite2D2.animation_finished

@onready var spown_markers : Array = $"../../spown_markers".get_children()

func slime_effect(time: float = 0.2) -> void:
	var tween = create_tween()
	# يضغط شوي بالعرض ويتمدّد بالطول
	tween.tween_property(self, "scale", Vector2(1, 1.4), time * 0.5)
	# يرجع للحجم الطبيعي
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), time * 0.5)


func random_spown_effect():
	var point = spown_markers.pick_random()
	if point in Globels.spown_player_not_one_point:
		random_spown_effect()
		return
	global_position = point.global_position
	Globels.spown_player_not_one_point.append(point)

func hit(damage):
	if not die:
		#damege += 10
		if not damage == 0.1:
			$sounds/MinecraftHitSoundDjlunatique_com.play()
		else:
			$"sounds/hit loop".play()
		if Globels.difficlalty == "Esey" and not damege == 0.1:
			damege -= 4
			abs(damege)
			if damage == 0:
				damege += 2
		elif Globels.difficlalty == "Normal":
			pass
		elif Globels.difficlalty == "Hard" and not damege == 0.1:
			damege += 8
		#damage += 100
		#hit partcals
		if damege == item_damage_value:
			$hit_partcals.amount += 25
		else:
			$hit_partcals.amount = 50
		$hit_partcals.restart()
		Globels.damage_win_effect[choice_player-1] += damage

		if choice_player == 1:
			Globels.player_1_health -= damage
		elif choice_player == 2:
			Globels.player_2_health -= damage

		if (Globels.player_1_health <= 0 and choice_player == 1 and not die) \
		or (Globels.player_2_health <= 0 and choice_player == 2 and not die):

			die = true
			$AnimatedSprite2D.play("die")
			await $AnimatedSprite2D.animation_finished

			# ✅ تحقق أولاً: إذا اللاعب خلصت قلوبه → مباشرة استدعاء death()
			if (choice_player == 1 and Globels.player_1_heart <= 1) \
			or (choice_player == 2 and Globels.player_2_heart <= 1):
				# ينقص آخر قلب
				if choice_player == 1:
					Globels.player_1_heart = 0
				else:
					Globels.player_2_heart = 0

				# نهاية اللعبة مباشرة
				death()
				return  # 🛑 وقف هنا، لا تكمل reset ولا effect

			# ✅ في حالة عنده قلوب يرجع يعيش
			if (choice_player == 1 and Globels.player_1_heart > 1) \
			or (choice_player == 2 and Globels.player_2_heart > 1):
				$"../..".start_shake(10)
				if Globels.partcals: $spwon_effect.restart()
				die_effect = true
				if_has_rocket = false
				$sounds/MinecraftTypeFireworkBlast.play()
				if is_instance_valid(Global_rocket):
					Global_rocket.queue_free()
				$timers/die_effect_timer.start()
				the_last_pos = global_position
			# -heart & respawn
			if choice_player == 1:
				Globels.player_1_heart -= 1
				Globels.player_1_health = 100
				Globels.player_score[1] += 50
				var random_point = spown_markers.pick_random()
				global_position = random_point.global_position
				die = false

			elif choice_player == 2:
				Globels.player_2_heart -= 1
				Globels.player_score[0] += 50
				Globels.player_2_health = 100
				var random_point = spown_markers.pick_random()
				global_position = random_point.global_position
				die = false

		# hit flash effect
		$AnimatedSprite2D.modulate = "ff0422"
		await get_tree().create_timer(0.17).timeout
		$AnimatedSprite2D.modulate = "ffffff"





func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enter_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enter_screen = false


func _on_attack_2_timer_timeout() -> void:
	attack_2_timer = false


func _on_die_effect_timer_timeout() -> void:
	die_effect = false
