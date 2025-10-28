extends Control

@onready var buttons : Array = [$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play,
								$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play,
								$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play,
								$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/controls/play,
								$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play
								]
var start_anmi : bool = true
var controls_on_off
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
var start_buttons : bool = false

func _ready() -> void:
	#buttons anmi
	start_buttons = true
	# نبدأ بأن كل الأزرار مو hover
	for b in buttons:
		button_states[b] = false
	$".".modulate = "ffffff00"
	#import the sitting propties
	#partcals
	update_sitting_prpties()
func _physics_process(_delta: float) -> void:
	for button in buttons:
		var is_hover = button.is_hovered()
		if is_hover != button_states[button]:
			button_hover_anmi(button, is_hover)
			button_states[button] = is_hover
	#esc 
	if Input.is_action_just_pressed("esc_menu") and $"../..".sitting_on_off:
		return_button()
	#check controler
	var joypads = Input.get_connected_joypads()
	if joypads.size() > 0:
		$sittings/the_sittings/controls/controlers/TextureRect.visible = true
		$sittings/the_sittings/controls/VBoxContainer.visible = false
	else:
		$sittings/the_sittings/controls/controlers/TextureRect.visible = false
		$sittings/the_sittings/controls/VBoxContainer.visible = true


var play_text : String = "off"
func _on_play_sitting_pressed() -> void:
	$sounds/ButtonPress382713.play()
	if Globels.lights:
		play_text = "off"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0,0,0,1.0))   
		Globels.lights = false
	elif not Globels.lights:
		play_text = "on"
		Globels.lights = true
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.722, 0.251, 1.0)) # أحمر
					  

	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.text = play_text
	

var part_text : String 
func _on_partcals_pressed() -> void:
	$sounds/ButtonPress382713.play()
	if Globels.partcals:
		part_text = "off"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0,0,0,1.0))   
		Globels.partcals = false
	elif not Globels.partcals:
		part_text = "on"
		Globels.partcals = true
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.722, 0.251, 1.0)) # أحمر
					  

	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.text = part_text
	

@export var max_time : int = 15
var time : int = 0
func _on_time_pressed() -> void:
	$sounds/ButtonPress382713.play()
	if not time >= max_time: time +=1
	else:time = 0
	Globels.time = time
	if not time == 0:
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.text = str(time)+"min"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", "ffa100") 
	else:
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.text = "chances"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.64, 0.336, 1.0)) 

var diff : Array = ["Esey","Normal","Hard"]
var index : int = 1
func _on_diffaclity_pressed() -> void:
	$sounds/ButtonPress382713.play()
	if not index == 2:index += 1
	else:index = 0
	if diff[index] == "Esey":
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.827, 0.337, 1.0))
	elif diff[index] == "Normal":
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0, 0.631, 0.0))
	elif diff[index] == "Hard":
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.868, 0.0, 0.0, 1.0))

	Globels.difficlalty = diff[index]
	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.text = diff[index]

signal exit
func _on_texture_button_pressed() -> void:
	return_button()
		
func return_button():
	$sounds/ButtonPress382713.play()
	if not controls_on_off:
		exit.emit()
	else:
		#close controls
		var tween = create_tween()
		tween.tween_property($sittings/the_sittings/controls,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.4)
		tween.tween_property($sittings/the_sittings/MarginContainer,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.4)
		await tween.finished
		$sittings/the_sittings/controls.position = Vector2(3000,3000)
		controls_on_off = false
		
func update_sitting_prpties():
	#import the sitting propties
	#partcals
	if Globels.partcals == false:
		part_text = "off"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0,0,0,1.0))   
	elif Globels.partcals:
		part_text = "on"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.722, 0.251, 1.0)) # أحمر
	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/partcals/HBoxContainer/VBoxContainer/MarginContainer/play/MarginContainer/Label.text = part_text
	#light
	if Globels.lights == false:
		play_text = "off"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0,0,0,1.0))   
	elif Globels.lights:
		play_text = "on"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.722, 0.251, 1.0)) # أحمر
	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/lights/HBoxContainer/play/MarginContainer/Label.text = play_text
	#time
	if not Globels.time == 0:
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.text = str(Globels.time)+"min"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", "ffa100") 
	else:
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.text = "chances"
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.64, 0.336, 1.0)) 
	#diff
	if Globels.difficlalty == "Esey":
		index = 0
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.827, 0.337, 1.0))
	elif Globels.difficlalty == "Normal":
		index = 1
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(1.0, 0.631, 0.0))
	elif Globels.difficlalty== "Hard":
		index = 2
		$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.add_theme_color_override("font_color", Color(0.868, 0.0, 0.0, 1.0))

	$sittings/the_sittings/MarginContainer/HBoxContainer/MarginContainer3/VBoxContainer/MarginContainer/play/MarginContainer/Label.text = diff[index]

#controls
func _on_controls_pressed() -> void:
	$sounds/ButtonPress382713.play()
	controls_on_off = true
	$sittings/the_sittings/controls.position = Vector2(295,103.5)
	
	#open the controls
	var tween = create_tween()
	tween.tween_property($sittings/the_sittings/MarginContainer,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.4)
	tween.tween_property($sittings/the_sittings/controls,"modulate",Color(1.0, 1.0, 1.0, 1.0),0.4)
