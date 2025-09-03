extends StaticBody2D

var touch_walls : bool = false
var grenade_item_scene  = preload("res://Scene/grenades.tscn")
var speed_item_scene  = preload("res://Scene/speed_item.tscn")
var damage_item_scene  = preload("res://Scene/damage_item.tscn")
var heart_item_scene = preload("res://Scene/heart.tscn")
var player_1_enter: bool = false
var player_2_enter: bool = false
var if_opened : bool = false
@export var time : float  = 0.7
@export var the_start_y : int = 200
@export var gra := 1200.0  # قوة الجاذبية (تسارع)
var target





func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	$Sprite2D.visible = false
	$timer/visble_timer.start()
func _physics_process(delta: float) -> void:
	if not touch_walls:
		global_position.y += 1
	# the open
	if (player_1_enter and Input.is_action_just_pressed("player_1_action")) \
	or (player_2_enter and Input.is_action_just_pressed("player_2_action")):
		if_opened = true
		$AnimatedSprite2D.visible = true
		#score
		if "check_player_1" in target:
			Globels.player_score[0] += 3
		elif "check_player_2" in target:
			Globels.player_score[1] += 3
		$timer/anmi_timer.wait_time = time
		$AnimatedSprite2D.play("explosion")
		$timer/anmi_timer.start()
		$Sprite2D.visible = false
		# قائمة العناصر (مع null)
		var items : Array = [
			grenade_item_scene.instantiate(),
			speed_item_scene.instantiate(),
			damage_item_scene.instantiate(),
			heart_item_scene.instantiate(),
			null,null,null
		]
		#create the item
		var random_item = items.pick_random()
		if random_item != null:
			random_item.global_position = $markers/Marker2D.global_position
			get_parent().add_child(random_item)
			
func _on_open_area_body_entered(body: Node2D) -> void:
	if not if_opened:
		target = body
		player_1_enter = true
		player_2_enter = true


func _on_open_area_body_exited(body: Node2D) -> void:
	if not if_opened:
		player_1_enter = false
		player_2_enter = false


func _on_timer_timeout() -> void:
	queue_free()


func _on_touch_area_body_entered(_body: Node2D) -> void:
	touch_walls = true


func _on_animated_sprite_2d_animation_finished() -> void:
	#visble anmi visble off
	if $AnimatedSprite2D.animation_finished and not if_opened:
		$AnimatedSprite2D.visible = false
		$AnimatedSprite2D.position.y = -20


func _on_visble_timer_timeout() -> void:
	$Sprite2D.visible = true
