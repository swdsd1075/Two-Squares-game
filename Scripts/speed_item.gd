extends Area2D

var if_player_enter = false
@export var time : float = 3
@export var speed : int = 100

signal player_speeding
signal player_not_speeding
var target

# متغيرات الحركة لأعلى/أسفل
@export var float_amplitude : float = 5.0 # أقصى مسافة يتحركها فوق/تحت
@export var float_speed : float = 2.0 # سرعة الحركة
var start_y : float
#@export var the_start_y : int = 200
#@export var gra := 1200.0  # قوة الجاذبية (تسارع)
#var rest_y: float              # الموضع الذي يتوقف عنده
#var vel_y := 0.0               # السرعة العمودية
var move_up_down : bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	$visble_timer.start()
	$Sprite2D.visible = false
	$GPUParticles2D.visible = false
	start_y = position.y

func _physics_process(delta: float) -> void:
	# حركة لأعلى وأسفل بشكل دائم
	if move_up_down: position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

func _on_body_entered(body: Node2D) -> void:
	if not if_player_enter:
		$effect_timer.wait_time = time
		if "check_player_1" in body:
			Globels.player_speed_propties[0] += speed
			Globels.player_score[0] += 3
		elif "check_player_2" in body:
			Globels.player_speed_propties[1] += speed
			Globels.player_score[1] += 3
		if_player_enter = true
		body.speed += speed
		target = body
		$effect_timer.start()
		player_speeding.emit()
		visible = false

func _on_timer_timeout() -> void:
	player_not_speeding.emit()
	target.speed -= speed
	#speed Globels
	if "check_player_1" in target:
		Globels.player_speed_propties[0] -= speed
	elif "check_player_2" in target:
		Globels.player_speed_propties[1] -= speed
	queue_free()


func _on_visble_timer_timeout() -> void:
	$Sprite2D.visible = true
	$GPUParticles2D.visible = true
	move_up_down = true
