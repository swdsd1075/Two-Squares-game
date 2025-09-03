extends Control

@onready var buttons : Array = [$main_menu/button/VBoxContainer/play,$main_menu/button/VBoxContainer/MarginContainer/sittings,$main_menu/button/VBoxContainer/MarginContainer2/quit,$play_menu/return_button/TextureButton,$play_menu/maps/map_1/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer2/TextureButton]
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

var button_states = {} # نخزن آخر حالة لكل زر

func _ready() -> void:
	$AnimationPlayer.play("start_anmi")
	await get_tree().create_timer(2).timeout #change this if change the start anmi
	$AnimationPlayer.play("bg_anmi")
	start_anmi = false
	# نبدأ بأن كل الأزرار مو hover
	for b in buttons:
		button_states[b] = false

func _physics_process(delta: float) -> void:
	if not start_anmi:
		for button in buttons:
			var is_hover = button.is_hovered()
			if is_hover != button_states[button]:
				# الحالة تغيرت → نسوي أنيميشن
				button_hover_anmi(button, is_hover)
				button_states[button] = is_hover


func _on_play_pressed() -> void:
	tp_effect(false,false)

func _switch_menus_simple() -> void:
	if not start_G:
		$play_menu.position = Vector2(0,0)
		$main_menu.position = Vector2(10000,0)
	else:
		get_tree().change_scene_to_file("res://Scene/map_1.tscn")


	
	
func _on_sittings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:tp_effect(true,false)

func _switch_menus_simple_x() -> void:
	$play_menu.position = Vector2(10000,0)
	$main_menu.position = Vector2(0,0)

func tp_effect(x:bool,start:bool):
	$black_color2.visible = true
	$black_color2.modulate = Color(0,0,0,0)

	var tween = create_tween()
	tween.tween_property($black_color2, "modulate", Color(0,0,0,1), 0.6)
	if x:tween.tween_callback(Callable(self, "_switch_menus_simple_x"))
	elif not x:
		start_G = start
		tween.tween_callback(Callable(self, "_switch_menus_simple"))
			
	tween.tween_property($black_color2, "modulate", Color(0,0,0,0), 0.6)
	tween.tween_callback(func():
		$black_color2.visible = false
	)

func _on_texture_button_pressed_play_map_1() -> void:
	tp_effect(false,true)
