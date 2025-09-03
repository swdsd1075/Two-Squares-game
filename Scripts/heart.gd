extends Area2D

@export var value : int = 20

@export var float_amplitude : float = 5.0 # أقصى مسافة يتحركها فوق/تحت
@export var float_speed : float = 2.0     # سرعة الحركة
var start_y : float

func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	start_y = position.y

func _physics_process(delta: float) -> void:
	# حركة لأعلى وأسفل بشكل دائم
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

func _on_body_entered(body: Node2D) -> void:
	if "check_player_1" in body:
		Globels.player_1_health += value
		Globels.player_score[0] += 3
		queue_free()
	elif "check_player_2" in body:
		Globels.player_2_health += value
		Globels.player_score[1] += 3
		queue_free()
