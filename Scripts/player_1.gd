extends player


var player_1_delta  = 0

func check_player_1():pass #Nothing here




func _physics_process(delta):
	#partcals and lights open or off
	$PointLight2D2.visible = Globels.lights
	$spwon_effect.visible = Globels.partcals
	$GPUParticles2D.visible = Globels.partcals
	$hit_partcals.visible = Globels.partcals
	
	
	
	if not Globels.start_play:return
	#make the global health
	if Globels.player_1_health > 100:
		Globels.player_1_health = 100
	elif Globels.player_2_health > 100:
		Globels.player_2_health = 100
	if death_var :
		$GPUParticles2D.visible = false
		$spwon_effect.visible = false
	choice_player = 1
	player_1_delta = delta
	Globels.player_1_grenades = grenades
	if die:return
	#globals var == local var 
	#global_position = Globels.player_1_pos
	
	Globels.player_2_grenades = grenades
	Globels.player_1_grenades = grenades
	
	#rocket
	chase_the_marker()
	#speed effect
	if (Globels.player_speed_propties[0] == item_speed_value and not speed_on_off):
		speed_on_off = true
		var tween = create_tween()
		# التوينات كلها تشتغل بالتوازي
		tween.parallel().tween_property($GPUParticles2D, "modulate", Color(0.251, 0.733, 1.0), 0.8)
		damage_or_speed_effect("speed")
	if (not Globels.player_speed_propties[0] == item_speed_value and speed_on_off):
		speed_on_off = false
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.0, 0.0, 0.0),0.5)
	#damage_effect
	if (Globels.player_damage_propties[0] == item_damage_value and not damage_on_off):
		damage_on_off = true
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.895, 0.107, 0.0),0.5)
		damage_or_speed_effect("damege")
	if (not Globels.player_damage_propties[0] == item_damage_value and damage_on_off):
		damage_on_off = false
		var tween = create_tween()
		tween.tween_property($GPUParticles2D,"modulate",Color(0.0, 0.0, 0.0),0.5)
	
	if not is_on_floor() :#and Globels.player_1_gra_bool:
		velocity.y += gravity * delta
		$sounds/WalkingOnGrass363353.stop()
		
	var direction = Input.get_action_strength("right_player_1") - Input.get_action_strength("left_player_1")

	# الحركة فقط لو ما في هجوم
	if not attack_timer and controls:
		velocity.x = direction * speed
		if direction != 0:
			if not $sounds/WalkingOnGrass363353.playing:
				$sounds/WalkingOnGrass363353.play()
		else:
			if $sounds/WalkingOnGrass363353.playing:
				$sounds/WalkingOnGrass363353.stop()
	else:
		# وقت الهجوم وقف الحركة
		velocity.x = 0
		if $sounds/WalkingOnGrass363353.playing:
			$sounds/WalkingOnGrass363353.stop()
	#from chatgpt attack_1
	if current_boost != 0:
		velocity.x += current_boost * delta
		current_boost = move_toward(current_boost, 0, attack_boost_friction * delta)

	if not attack_timer and Input.is_action_just_pressed("Jump_player_1") and is_on_floor() and controls:
		velocity.y = jump_force
		$sounds/CollapsingInGrass101312Ao94e7v9.play()
		slime_effect(0.6)
			
	#attack_2
	if Input.is_action_just_pressed("attack_2_player_1") and not attack_2_timer and grenades > 0:
		attack_2()



	move_and_slide()
	if direction != 0 and not attack_timer:
		$AnimatedSprite2D.play("Walk")
	elif not attack_timer:
		$AnimatedSprite2D.play("Idle")
	#hit system
	if hit_timer and attack_area:
		target.hit(damege)
		Globels.hit_dmg_win_effect[0] += damege
		Globels.player_score[0] += damege
		hit_timer = false
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	if not attack_timer and not hit_timer and Input.is_action_just_pressed("attack_player_1"):
		controls = false
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
	$sounds/FistFight192117.play()
	if $AnimatedSprite2D.flip_h:
		current_boost = -attack_boost
	else:
		current_boost = attack_boost
	velocity.y = -100
	$timers/Hit_timer.start()
	hit_timer = true


func _on_hit_timer_timeout() -> void:
	hit_timer = false
	controls = true


func _on_attack_2_timer_timeout() -> void:
	attack_2_timer = false                                          
