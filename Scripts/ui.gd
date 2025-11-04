extends CanvasLayer

var last_heart_1: int
var last_heart_2: int

var tie : bool = false
var sitting_on_off : bool = false
var win_1_effect : bool = false
var win_2_effect : bool = false
var can_skip : bool = false
var quit_esc_button : bool = false
var the_start_anmi : bool = true

@onready var buttons : Array = [$esc_menu/MarginContainer/TextureRect/MarginContainer/VBoxContainer/start/TextureButton,
								$esc_menu/MarginContainer/TextureRect/MarginContainer/VBoxContainer/resturt/TextureButton,
								$esc_menu/MarginContainer/TextureRect/MarginContainer/VBoxContainer/quit/TextureButton,
								$win_player/MarginContainer2/resturt]
var start_anmi : bool = true
var start_G

var last_angle : int 
func button_hover_anmi(button: TextureButton, hover: bool = true) -> void:
	button.pivot_offset = button.size / 2  #for make scaling from center
	var tween = create_tween()
	if hover:
		last_angle =  button.rotation_degrees
		# وقت hover (يتكبر شوية ويميل)
		tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		var random_rotation = [5, -5].pick_random()
		tween.tween_property(button, "rotation_degrees", random_rotation, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	else:
		# وقت الخروج (يرجع للوضع الطبيعي)
		tween.tween_property(button, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation_degrees", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

var button_states = {} 

func skip_anmi():
	$AnimationPlayer.play("skip_anmi")
	can_skip = true
	$win_player/MarginContainer.visible = true

func score_effect(): #i dont know whats is this func meaning here
	pass

func start_menu():
	Globels.start_play = !Globels.start_play
	if not Globels.start_play: 
		$AnimationPlayer.play("esc_menu_anmi")
		esc_menu = true
	else:
		$AnimationPlayer.play_backwards("esc_menu_anmi")
		esc_menu = false
	quit_esc_button = false

func _ready() -> void:
	$sounds/GameLoadingSoundEffect380367.play()
	$ColorRect.color = "ffffff00"
	$win_player.visible = false
	#$AnimationPlayer.play("win_player")
	last_heart_1 = Globels.player_1_heart
	last_heart_2 = Globels.player_2_heart
	# start effect
	$ColorRect.color = Color(0.0, 0.0, 0.0)
	$start_effect/Label2.modulate = Color(1.0, 1.0, 1.0)
	var text : String = "loading..."
	var tween_1 = create_tween()
	
	start_anmi = false
	# عمل تأثير "loading..."
	for i in range(3):
		if text != "loading...":
			text += "."
		else:
			text = "loading"
		tween_1.tween_callback(Callable($start_effect/Label2, "set_text").bind(text))
		tween_1.tween_interval(0.44) # تأخير بين كل تحديث
	await get_tree().create_timer(0.44*3).timeout #changed if you edit the range
	# اختفاء Label2
	#tween_1.tween_property($start_effect/Label2, "modulate", Color(0,0,0,0), 0.5)
	$start_effect/Label2.modulate = "ffffff00"
	await get_tree().create_timer(0.2).timeout
	$sounds/GameLoadingSoundEffect380367.stop()
	# ظهور Label1 وتغيير لون الـ ColorRect
	var tween_2 = create_tween()
	tween_2.tween_property($start_effect/Label, "modulate", Color(1,1,1,1), 0.5)
	$sounds/GameStart317318.play()
	await get_tree().create_timer(1).timeout
	var tween_3 = create_tween()
	tween_3.tween_property($ColorRect, "color", Color(0,0,0,0), 0.4)
	tween_3.tween_property($start_effect/Label,"modulate", Color(0,0,0,0),0.5)
	for b in buttons:
		button_states[b] = false
	Globels.start_play = true

	the_start_anmi = false
	if not Globels.time == 0:
		Globels.player_1_heart += 2839479
		Globels.player_1_heart += 2174897
		$player_1/VBoxContainer/HBoxContainer2.visible = false
		$player_2/VBoxContainer/HBoxContainer2.visible = false
		$game_timer.wait_time = Globels.time * 60
		$game_timer.start()
		$change_time_text.autostart = true
		$change_time_text.one_shot = false
		$change_time_text.start()
		var time_str = str(Globels.time / 60) + ":" + str(Globels.time % 60).pad_zeros(2)
		$end_timer/Label.text = time_str
		tween_3.tween_property($end_timer,"position",Vector2(507.5,0),0.7)
		
var one_time : bool = false
var time_anmi : bool = false
func _process(_delta: float) -> void:
	if not start_anmi:
		for button in buttons:
			var id = button.get_instance_id()
			var is_hover = button.is_hovered()
			var last_state = button_states.get(id, false) # القيمة السابقة أو false

			if is_hover != last_state:
				# الحالة تغيرت → نسوي أنيميشن
				button_hover_anmi(button, is_hover)
				button_states[id] = is_hover
	
	if not Globels.start_play and $game_timer.is_stopped() == false:
		$game_timer.paused = true
	elif Globels.start_play and $game_timer.is_stopped():
		$game_timer.paused = false
	
	#grenade make th color red
	if Globels.player_2_grenades == 0:$player_2/VBoxContainer/HBoxContainer3/Label.modulate = Color(0.882, 0.0, 0.0, 1.0)
	else:$player_2/VBoxContainer/HBoxContainer3/Label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if Globels.player_1_grenades == 0:$player_1/VBoxContainer/HBoxContainer3/Label.modulate = Color(0.882, 0.0, 0.0, 1.0)
	else:$player_1/VBoxContainer/HBoxContainer3/Label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	if (Globels.player_1_health <= 13 and not Globels.player_1_health == 0) or (Globels.player_2_health <= 13  and not Globels.player_2_health == 0):
		if not $AnimationPlayer.is_playing(): $AnimationPlayer.play("heart_negtive")
	
	if (Input.is_action_just_pressed("esc_menu") and not win_1_effect and not win_2_effect and not the_start_anmi and not sitting_on_off and not tie):
		start_menu()
	#skip win
	if can_skip and Input.is_action_pressed("skip_button"):
		$AnimationPlayer.play("fade_in")
		$win_skip_timer.start()
		
	#player 1 win effect
	if Globels.player_1_heart != last_heart_1 and not win_1_effect:
		if not Globels.player_1_heart == 0:
			last_heart_1 = Globels.player_1_heart
			$AnimationPlayer.play("heart_negtive")
		else:
			win_1_effect = true
			$AnimationPlayer.play("win_player")
			Globels.player_2_wins += 1
			$win_player/VBoxContainer/Label.text = "player 2 win"
			$player_1/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_1/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
	#player 2 win effect
	if Globels.player_2_heart != last_heart_2 and not win_2_effect:
		if not Globels.player_2_heart == 0:
			last_heart_2 = Globels.player_2_heart
			$AnimationPlayer.play("heart_negtive")
		else:
			$AnimationPlayer.play("win_player")
			win_2_effect = true
			Globels.player_1_wins += 1
			$player_2/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_2/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
	#make resposive ui
	$player_1/VBoxContainer/MarginContainer/TextureProgressBar.value = Globels.player_1_health
	$player_2/VBoxContainer/MarginContainer/TextureProgressBar.value = Globels.player_2_health
	$player_1/VBoxContainer/HBoxContainer3/Label.text = str(Globels.player_1_grenades)+"x"
	$player_2/VBoxContainer/HBoxContainer3/Label.text = "x"+str(Globels.player_2_grenades)
	$player_2/VBoxContainer/HBoxContainer2/Label.text = "x"+str(Globels.player_2_heart)
	$player_1/VBoxContainer/HBoxContainer2/Label.text = str(Globels.player_1_heart)+"x"
	#... for win effect player_1
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/health/Label2.text = str(round(Globels.player_1_health))
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/damage/Label2.text = str(round(Globels.damage_win_effect[0]))
	$"win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/hit damage/Label2".text = str(round(Globels.hit_dmg_win_effect[0]))
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/score/Label2.text = str(round(Globels.player_score[0]))
	#... for win effect player_2
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/health/Label2.text = str(round(Globels.player_2_health))
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/damage/Label2.text = str(round(Globels.damage_win_effect[1]))
	$"win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/hit damage/Label2".text = str(round(Globels.hit_dmg_win_effect[1]))
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/score/Label2.text = str(round(Globels.player_score[1]))
	$win_skip_timer.wait_time = 0.5
	#win
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/win/Label2.text = str(Globels.player_1_wins) 
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/win/Label2.text = str(Globels.player_2_wins)
	#time visble
	if Globels.time >= 1:
		$end_timer.visible = true
	else:
		$end_timer.visible = false

@onready var label_1 = $player_1/VBoxContainer/HBoxContainer2/Label
@onready var label_2 = $player_2/VBoxContainer/HBoxContainer2/Label


func _on_texture_button_pressed() -> void:
	quit_esc_button = true
	$sounds/ButtonPress382713.play()

var esc_menu : bool = false
func _on_texture_start_button_pressed() -> void:
	if esc_menu == false:return
	start_menu()
	$sounds/ButtonPress382713.play()

func restart():
	start_menu()
	$sounds/ButtonPress382713.play()
	$AnimationPlayer.play("fade_in")
	Globels.start_play = false
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scene/map_1.tscn")

func _on_texture_resturt_button_pressed() -> void:
	restart()


func _on_texture_sittings_button_pressed() -> void:
	$AnimationPlayer.play("main_to_sitting")
	sitting_on_off = true
	$sounds/ButtonPress382713.play()

func _on_texture_quit_button_pressed() -> void:
	$AnimationPlayer.play("fade_in")
	$sounds/ButtonPress382713.play()
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


func _on_win_skip_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

#if time
func _on_game_timer_timeout() -> void:
	win_effect()


var win_effect_v : bool = false
func win_effect():
	if not win_effect_v:
		$end_timer/Label.text = "0:00"
		Globels.start_play = false
		win_effect_v = true
		#Globels.player_score[1] += 100
		if Globels.player_score[0] > Globels.player_score[1]:
			win_1_effect = true
			Globels.player_1_wins += 1
			$player_2/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_2/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
		elif Globels.player_score[0] < Globels.player_score[1]:
			win_2_effect = true
			Globels.player_2_wins += 1
			$win_player/VBoxContainer/Label.text = "player 2 win"
			$player_1/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_1/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
		else:
			tie = true
			$win_player/VBoxContainer/Label.text = "Tie"
		$AnimationPlayer.stop()
		$AnimationPlayer.play("win_player")

#change the time text
var min : int = Globels.time
var sec : int
func _on_change_time_text_timeout() -> void:
	if not Globels.start_play:return
	# نقص ثانية
	if sec > 0:
		sec -= 1
	elif min > 0:
		min -= 1
		sec = 59
	else:
		# الوقت وصل للصفر
		$end_timer/Label.text = "0:00"
		$change_time_text.stop()
		win_effect()
		return
	if min == 0 and sec == 10:
		$AnimationPlayer.play("time_anmi")
		$"sounds/10SecDigitalCountdownSfx319873".play()
	# تحديث النص
	$end_timer/Label.text = str(min) + ":" + str(sec).pad_zeros(2)

#restart button
func _on_resturt_pressed() -> void:
	restart()
