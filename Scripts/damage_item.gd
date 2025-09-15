extends Area2D

var if_player_enter = false
@export var time : float = 3
@export var damage : int = 10
signal player_damaging
signal player_not_damaging
var target

# متغيرات الحركة لأعلى/أسفل
@export var float_amplitude : float = 5.0 # المسافة لأعلى/أسفل
@export var float_speed : float = 2.0     # سرعة الحركة
var start_y : float

func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	$GPUParticles2D.visible = false
	$Sprite2D.visible = false
	$Timer.start()
	start_y = position.y

func _physics_process(delta: float) -> void:
	# حركة لأعلى وأسفل فقط
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

func _on_body_entered(body: Node2D) -> void:
	if not if_player_enter:
		if "check_player_1" in body:
			Globels.player_score[0] += 3
			Globels.player_damage_propties[0] += damage
		elif "check_player_2" in body:
			Globels.player_score[1] += 3
			Globels.player_damage_propties[1] += damage
		$effect_timer.wait_time = time
		if_player_enter = true
		target = body
		body.damege += damage
		body.grenade_damage += damage
		
		$effect_timer.start()
		player_damaging.emit()
		visible = false

func _on_effect_timer_timeout() -> void:
	player_not_damaging.emit()
	if "check_player_1" in target:
		Globels.player_damage_propties[0] -= damage
	elif "check_player_2" in target:
		Globels.player_damage_propties[1] -= damage
	target.damege -= damage
	target.grenade_damage -= damage
	queue_free()


func _on_timer_timeout() -> void:
	$Sprite2D.visible = true
	$GPUParticles2D.visible = true
