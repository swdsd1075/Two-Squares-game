extends Area2D
#
#var player_enter : bool = true
#@export var up_speed : int = 30
#var target : CharacterBody2D
#
#func _process(delta: float) -> void:
	##up and check player
	#if player_enter:
		#if target == $"../../Players/player_1" and Input.is_action_pressed('up_player_1'):
			#Globels.player_1_pos.y -= up_speed
			#Globels.player_1_gra_bool = player_enter
		#elif target == $"../../Players/player_2" and Input.is_action_pressed('Jump_player_2'):
			#Globels.player_2_pos.y -= up_speed
			#Globels.player_2_gra_bool = player_enter
#func _on_body_entered(body: Node2D) -> void:
	#if "check_player_1" in body or "check_player_2" in body:
		#player_enter = false
		#target = body
#
#func _on_body_exited(body: Node2D) -> void:
	#if "check_player_1" in body or "check_player_2" in body:
		#player_enter = true
		#target = null
