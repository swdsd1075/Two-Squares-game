extends CharacterBody2D

class_name player

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
@export var damage : int = 10
@export var grenade_damage : int = 20

var projectiles_node  = null
var attack_2_timer : bool = false
var grenade_scene = preload("res://Scene/greande.tscn")
var grenades : int = 5
var die : bool = false
var die_effect : bool = false
var enter_screen : bool = true #i dont know if that correct
var the_last_pos : Vector2
var death_var : bool = false

#attack_2 func
func attack_2(player: int): #player_1_or_2
	attack_2_timer = true
	grenades -= 1
	$timers/Attack_2_timer.start()
	var grenade = grenade_scene.instantiate()
	grenade.global_position = global_position
	grenade.player_1_or_2 = player
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
	$AnimatedSprite2D2.play("death_effect")
	await get_tree().create_timer(0.15).timeout
	$AnimatedSprite2D.visible = false
	$spwon_effect.visible = false
	await $AnimatedSprite2D2.animation_finished

@onready var spown_markers = $"../../spown_markers".get_children()
func hit(damage):
	if not die:
		damage += 100
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
				$spwon_effect.emitting = true
				die_effect = true
				$timers/die_effect_timer.start()
				the_last_pos = global_position
			# -heart & respawn
			if choice_player == 1:
				Globels.player_1_heart -= 1
				Globels.player_1_health = 100
				var random_point = spown_markers.pick_random()
				global_position = random_point.global_position
				die = false

			elif choice_player == 2:
				Globels.player_2_heart -= 1
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
