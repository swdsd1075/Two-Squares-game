extends player

var player_2_delta  = 0


func check_player_2():pass #Nothing here




func _physics_process(delta):
	if death_var:
		$GPUParticles2D.visible = false
		$spwon_effect.visible = false
	choice_player = 2
	player_2_delta = delta
	Globels.player_2_grenades = grenades
	if die:return
	
	#globals var == local var
	#global_position = Globels.player_2_pos
	
	#rocket
	chase_the_marker()
	#speed effect
	if (Globels.player_speed_propties[1] == item_speed_value and not speed_on_off):
		speed_on_off = true
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.251, 0.733, 1.0),0.5)
	if (Globels.player_speed_propties[1] == item_speed_value and speed_on_off):
		speed_on_off = false
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.533, 0.533, 0.533),0.5)
	#damage effect
	if (Globels.player_damage_propties[1] == item_damage_value and not damage_on_off):
		damage_on_off = true
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.895, 0.107, 0.0),0.5)
	if (not Globels.player_damage_propties[1] == item_damage_value and damage_on_off):
		damage_on_off = false
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.533, 0.533, 0.533),0.5)
	
	if not is_on_floor(): #and Globels.player_2_gra_bool:
		velocity.y += gravity * delta

	var direction = Input.get_action_strength("right_player_2") - Input.get_action_strength("left_player_2")
	if not attack_timer:
		velocity.x = direction * speed
	#from chatgpt
	if current_boost != 0:
		velocity.x += current_boost * delta
		current_boost = move_toward(current_boost, 0, attack_boost_friction * delta)
	#jump system
	if not attack_timer and Input.is_action_just_pressed("Jump_player_2") and is_on_floor():
		velocity.y = jump_force
	#attack_2
	if Input.is_action_just_pressed("attack_2_player_2") and not attack_2_timer and grenades > 0:
		attack_2(2)
	move_and_slide()

	if direction != 0 and not attack_timer:
		$AnimatedSprite2D.play("Walk")
	elif not attack_timer:
		$AnimatedSprite2D.play("Idle")
	#hit system
	if hit_timer and attack_area:
		target.hit(damege)
		Globels.hit_dmg_win_effect[1] += damege
		hit_timer = false
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	if not attack_timer and not hit_timer and Input.is_action_just_pressed("attack_player_2"):
		attack_timer = true
		$timers/Attack_timer.start()
		$AnimatedSprite2D.play("attack")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if "check_player_1" in body:
		attack_area = true
		target = body

func _on_attack_area_body_exited(body: Node2D) -> void:
	if "check_player_1" in body:
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
