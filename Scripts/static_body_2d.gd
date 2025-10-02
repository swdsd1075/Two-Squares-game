extends StaticBody2D

@export var jump_boost : int = -500

func _process(_delta: float) -> void:
	$PointLight2D.visible = Globels.lights

func change_image():
		$image_close.visible = false
		$image_open.visible = true
		await get_tree().create_timer(0.2).timeout
		$image_close.visible = true
		$image_open.visible = false

func _on_player_enetr_area_body_entered(body: Node2D) -> void:
	if "check_player_1" in body:
		$"../../Players/player_1".velocity.y = jump_boost
		change_image()
		$CartoonJump6462.play()
		light_effect()
	elif "check_player_2" in body:
		$"../../Players/player_2".velocity.y = jump_boost
		change_image()
		$CartoonJump6462.play()
		light_effect()

func _on_player_enetr_area_body_exited(body: Node2D) -> void:
	if "check_player_1" in body:
		#Globels.player_1_jump_boost = false
		body.jump_force = -350
	elif "check_player_2" in body:
		#Globels.player_2_jump_boost = false
		body.jump_force = -350

func light_effect():
	var tween = create_tween()
	tween.tween_property($PointLight2D,"energy",4,0.5)
	tween.tween_property($PointLight2D,"energy",1.5,0.5)
