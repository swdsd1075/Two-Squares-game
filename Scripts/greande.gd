extends RigidBody2D

@export var player_1_or_2 : int  = 1
@export var explotion_time : float = 1.0
@export var gravity : int = 1
@export var rotation_scale : int = 5
var grenade_start : bool = false
var player_1_eneter : bool = false
var player_2_eneter : bool = false
var targets : Array
@export var damage : int = 20
var light_effect : bool = false

func _ready() -> void:
	gravity_scale = gravity
	#theres the proplem here
	$for_change_size/PointLight2D.visible = Globels.lights
	$for_change_size/GPUParticles2Ds.emitting = true
	$for_change_size/GPUParticles2Ds.visible = Globels.partcals
	$PointLight2D2.visible = Globels.lights
	$spwon_effect.visible = Globels.partcals
	$for_change_size/timer/Timer.wait_time = explotion_time
	$for_change_size/timer/Timer.start()
	#change color if player_1 or 2
	if player_1_or_2 == 1:
		$for_change_size/Player1Grenade.visible = true
		$for_change_size/Player2Grenade.visible = false
	elif player_1_or_2 == 2:
		$for_change_size/Player1Grenade.visible = false
		$for_change_size/Player2Grenade.visible = true
func _physics_process(delta: float) -> void:
	#stop e$for_change_size/PointLight2Dxplsion rotate
	if  Globels.start_play: 
		$AnimatedSprite2D.rotation = -rotation
		if not grenade_start: $for_change_size/timer/Timer.paused = false
		freeze = false
	else:
		if not grenade_start: $for_change_size/timer/Timer.paused = true
		freeze = true   # توقف الفيزياء بالكامل

#the explostio meknak
func _on_timer_timeout() -> void:
	grenade_start = true
	gravity_scale = 0
	$"../..".start_shake(15)
	if player_2_eneter or player_1_eneter:
		for player in targets:
			player.hit(damage)
			#this is for damage
			if "check_player_1" in player and player_1_or_2 == 2:
				Globels.hit_dmg_win_effect[player_1_or_2-1] += damage
				Globels.player_score[player_1_or_2-1] += damage
			if "check_player_2" in player and player_1_or_2 == 1:
				Globels.hit_dmg_win_effect[player_1_or_2-1] += damage
				Globels.player_score[player_1_or_2-1] += damage
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("explosion")
	$Explosion312361.play()
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	var tween = create_tween() #light effect and partclals
	tween.tween_property($PointLight2D2,"energy",8,0.2)
	tween.tween_property($PointLight2D2,"energy",0,0.2)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	$spwon_effect.restart()
	
	await get_tree().create_timer(0.4).timeout #if exp timer changes chenge this
	$for_change_size.queue_free()
	$CollisionShape2D.queue_free()
	await get_tree().create_timer(0.7).timeout #if exp timer changes chenge this
	queue_free()

func _on_hit_arae_body_entered(body: Node2D) -> void:
	if "hit" in body:
		targets.append(body)
		if "check_player_1" in body:player_1_eneter = true
		elif "check_player_2" in body:player_2_eneter = true


func _on_hit_arae_body_exited(body: Node2D) -> void:
	if "hit" in body:
		while targets.has(body):
			targets.erase(body)
		if "check_player_1" in body:player_1_eneter = false
		elif "check_player_2" in body:player_2_eneter = false


func _on_light_effect_timer_timeout() -> void:
	var tween = create_tween()
	if light_effect == false:
		tween.tween_property($for_change_size/PointLight2D,"energy",2.68,$for_change_size/timer/light_effect_timer.wait_time  )
		light_effect = true
	elif light_effect == true:
		tween.tween_property($for_change_size/PointLight2D,"energy",0.2,$for_change_size/timer/light_effect_timer.wait_time )
		light_effect = false
