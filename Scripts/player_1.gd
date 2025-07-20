extends CharacterBody2D

var attack_timer : bool = false
var attack_area : bool = false
@export var speed: int = 200
@export var gravity: int = 900
@export var jump_force: int = -350
@export var attack_boost : int = 16000
@export var attack_boost_friction := 30000
var current_boost := 0.0
var target: CharacterBody2D
var hit_timer : bool = false
@export var damage : int = 10

func check_player_1():pass #Nothing here

#hit func
func hit(damage):
	Globels.player_1_health -= damage
	if Globels.player_1_health <= 0:
		$AnimatedSprite2D.play("die") #die after make anmi die
		await $AnimatedSprite2D.animation_finished
		queue_free()
	$AnimatedSprite2D.modulate = "ff0422"
	await get_tree().create_timer(0.17).timeout
	$AnimatedSprite2D.modulate = "ffffff"

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_action_strength("right_player_1") - Input.get_action_strength("left_player_1")
	if not attack_timer:
		velocity.x = direction * speed
	#from chatgpt
	if current_boost != 0:
		velocity.x += current_boost * delta
		current_boost = move_toward(current_boost, 0, attack_boost_friction * delta)

	if not attack_timer and Input.is_action_just_pressed("Jump_player_1") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

	if direction != 0 and not attack_timer:
		$AnimatedSprite2D.play("Walk")
	elif not attack_timer:
		$AnimatedSprite2D.play("Idle")
	#hit system
	if hit_timer and attack_area:
		target.hit(damage)
		hit_timer = false
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	if not attack_timer and not hit_timer and Input.is_action_just_pressed("attack_player_1"):
		attack_timer = true
		$Timers/Attack_timer.start()
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
	$Timers/Hit_timer.start()
	hit_timer = true


func _on_hit_timer_timeout() -> void:
	hit_timer = false
