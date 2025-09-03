extends player


var player_1_delta  = 0

func check_player_1():pass #Nothing here




func _physics_process(delta):
	if death_var:
		$GPUParticles2D.visible = false
		$spwon_effect.visible = false
	choice_player = 1
	player_1_delta = delta
	Globels.player_1_grenades = grenades
	if die:return
	#globals var == local var 
	#global_position = Globels.player_1_pos
	
	if not is_on_floor() :#and Globels.player_1_gra_bool:
		velocity.y += gravity * delta
		
	var direction = Input.get_action_strength("right_player_1") - Input.get_action_strength("left_player_1")
	if not attack_timer:
		velocity.x = direction * speed
	#from chatgpt attack_1
	if current_boost != 0:
		velocity.x += current_boost * delta
		current_boost = move_toward(current_boost, 0, attack_boost_friction * delta)

	if not attack_timer and Input.is_action_just_pressed("Jump_player_1") and is_on_floor():
		velocity.y = jump_force
			
	#attack_2
	if Input.is_action_just_pressed("attack_2_player_1") and not attack_2_timer and grenades > 0:
		attack_2_timer = true
		grenades -= 1
		$timers/Attack_2_timer.start()
		var grenade = grenade_scene.instantiate()
		grenade.global_position = global_position
		#for move the grenade
		if $AnimatedSprite2D.flip_h:
			grenade.linear_velocity = Vector2(-250, -70)
			grenade.angular_velocity = -6.0
		else:
			grenade.linear_velocity = Vector2(250, -70)
			grenade.angular_velocity = 6.0



		$"../../projectiles".add_child(grenade)

	move_and_slide()

	if direction != 0 and not attack_timer:
		$AnimatedSprite2D.play("Walk")
	elif not attack_timer:
		$AnimatedSprite2D.play("Idle")
	#hit system
	if hit_timer and attack_area:
		target.hit(damage)
		Globels.hit_dmg_win_effect[0] += damage
		Globels.player_score[0] += damage
		hit_timer = false
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	if not attack_timer and not hit_timer and Input.is_action_just_pressed("attack_player_1"):
		attack_timer = true
		$timers/Attack_timer.start()
		$AnimatedSprite2D.play("attack")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if "check_player_2" in body:
		attack_area = true
		target = body

func _on_attack_area_body_exited(body: Node2D) -> void:
	if "check_player_2" in body:
		attack_area = false

func _on_attack_timer_timeout() -> void:
	attack_timer = false
	#attack boost
	if $AnimatedSprite2D.flip_h:
		current_boost = -attack_boost
	else:
		current_boost = attack_boost
	velocity.y = -100
	$timers/Hit_timer.start()
	hit_timer = true


func _on_hit_timer_timeout() -> void:
	hit_timer = false


func _on_attack_2_timer_timeout() -> void:
	attack_2_timer = false                                          
