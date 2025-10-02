extends Control

@onready var buttons : Array = [$CanvasLayer/main_menu/button/TextureRect/MarginContainer/VBoxContainer/play,
								$CanvasLayer/main_menu/button/TextureRect/MarginContainer/VBoxContainer/MarginContainer/sittings,
								$CanvasLayer/main_menu/button/TextureRect/MarginContainer/VBoxContainer/MarginContainer2/quit,
								$CanvasLayer/play_menu/return_button/TextureButton,
								$CanvasLayer/play_menu/maps/map_1/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer2/TextureButton
								,$CanvasLayer/quit_screen/TextureRect/MarginContainer/VBoxContainer/yes,$CanvasLayer/quit_screen/TextureRect/MarginContainer/VBoxContainer/no
								]
var start_anmi : bool = true
var start_G
var part_text : String = "on"
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

var button_states = {} # نخزن آخر حالة لكل زر
var start_buttons : bool = false

func _ready() -> void:
	$AnimationPlayer.play("start_anmi")
	#await $AnimationPlayer.animation_finished
	start_buttons = true
	start_anmi = false
	# نبدأ بأن كل الأزرار مو hover
	for b in buttons:
		button_states[b] = false
	#white anmi
	$CanvasLayer/black_color.visible = true
	await get_tree().create_timer(0.8).timeout
	var tween = create_tween()
	tween.tween_property($CanvasLayer/black_color,"color",Color(1.0, 1.0, 1.0, 0.0),0.5)
	await get_tree().create_timer(1).timeout
var quit_screen : bool = false

func _physics_process(delta: float) -> void:
	if not start_anmi:
		for button in buttons:
			var is_hover = button.is_hovered()
			if is_hover != button_states[button]:
				# الحالة تغيرت → نسوي أنيميشن
				button_hover_anmi(button, is_hover)
				button_states[button] = is_hover
	#part
	$bg/GPUParticles2D.visible = Globels.partcals
	$bg/players/GPUParticles2D.visible = Globels.partcals
	$bg/players/GPUParticles2D2.visible = Globels.partcals
	$bg/heart/GPUParticles2D2.visible = Globels.partcals
	#lights
	$bg/DirectionalLight2D.visible = Globels.lights
	$bg/players/PointLight2D2.visible = Globels.lights
	$bg/players/PointLight2D3.visible = Globels.lights
	$bg/heart/PointLight2D2.visible = Globels.lights
	
	#esc
	if sitting_on_off == false and Input.is_action_just_pressed("esc_menu"):
		$sounds/WoodFriction149666LeblnxmaZ6zV1sSh.play()
		var tween = create_tween()
		#$CanvasLayer/black_color2.visible = true
		if quit_screen == false:
			$CanvasLayer/quit_screen.position = Vector2(0,0)
			tween.parallel().tween_property($CanvasLayer/quit_screen,"position",Vector2(0,600),0.5)
			tween.parallel().tween_property($CanvasLayer/black_color2,"color",Color(0.0, 0.0, 0.0, 0.404),0.4)
			quit_screen = true
		else:
			tween.parallel().tween_property($CanvasLayer/quit_screen,"position",Vector2(0,0),0.5)
			tween.parallel().tween_property($CanvasLayer/black_color2,"color",Color(0.0, 0.0, 0.0, 0.0),0.4)
			quit_screen = false
			await tween.finished
			$CanvasLayer/quit_screen.position = Vector2(4000,4000)
			$CanvasLayer/black_color2.visible = false
		
func _on_play_pressed() -> void:
	$sounds/ButtonPress382713.play()
	tp_effect(false,true)

func _switch_menus_simple() -> void:
	if not start_G:
		$CanvasLayer/play_menu.position = Vector2(0,0)
		$main_menu.position = Vector2(10000,0)
	else:
		get_tree().change_scene_to_file("res://Scene/map_1.tscn")


	
var sitting_on_off : bool = false
func _on_sittings_pressed() -> void:
	if not start_buttons:return
	$sounds/ButtonPress382713.play()
	$AnimationPlayer.play("sittings_to_main")
	sitting_on_off = true


func _on_quit_pressed() -> void:
	if not start_buttons:return
	tp_effect(false,true)
	$sounds/ButtonPress382713.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().quit()


func _on_texture_button_pressed() -> void:
	tp_effect(false,true)
	$sounds/ButtonPress382713.play()

func _switch_menus_simple_x() -> void:
	$CanvasLayer/play_menu.position = Vector2(10000,0)
	$CanvasLayer/main_menu.position = Vector2(0,0)

func tp_effect(x:bool,start:bool):
	if not start_buttons:return
	$CanvasLayer/black_color2.visible = true
	$CanvasLayer/black_color2.modulate = Color(0,0,0,0)

	var tween = create_tween()
	tween.tween_property($CanvasLayer/black_color2, "modulate", Color(0,0,0,1), 0.6)
	if x:tween.tween_callback(Callable(self, "_switch_menus_simple_x"))
	elif not x:
		start_G = start
		tween.tween_callback(Callable(self, "_switch_menus_simple"))
			
	tween.tween_property($CanvasLayer/black_color2, "modulate", Color(0,0,0,0), 0.6)
	tween.tween_callback(func():
		$CanvasLayer/black_color2.visible = false
	)

func _on_texture_button_pressed_play_map_1() -> void:pass


func _on_sittings_exit() -> void:
	$sounds/ButtonPress382713.play()
	$AnimationPlayer.play_backwards("sittings_to_main")
	sitting_on_off = false

#quit button
func _on_yes_pressed() -> void:
	if not start_buttons:return
	$sounds/ButtonPress382713.play()
	get_tree().quit()


func _on_no_pressed() -> void:
	$sounds/ButtonPress382713.play()
	var tween = create_tween()
	tween.parallel().tween_property($CanvasLayer/quit_screen,"position",Vector2(0,0),0.5)
	tween.parallel().tween_property($CanvasLayer/black_color2,"color",Color(0.0, 0.0, 0.0, 0.0),0.4)
	quit_screen = false
	await tween.finished
	$sounds/WoodFriction149666LeblnxmaZ6zV1sSh.play()
	$CanvasLayer/quit_screen.position = Vector2(4000,4000)
	$CanvasLayer/black_color2.visible = false
