extends Area2D

@export var value : int = 12

@export var float_amplitude : float = 5.0 # أقصى مسافة يتحركها فوق/تحت
@export var float_speed : float = 2.0     # سرعة الحركة
var start_y : float

func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	start_y = position.y

func _physics_process(_delta: float) -> void:
	# حركة لأعلى وأسفل بشكل دائم
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	$PointLight2D.visible = Globels.lights
var enter : bool = false
func _on_body_entered(body: Node2D) -> void:
	if "check_player_1" in body and not enter:
		Globels.player_score[0] += value
		body.damage_or_speed_effect("coin")
		$"../..".items_now -= 1
		enter = true
		$Coin257878.play()
		visible = false
		await $Coin257878.finished
		queue_free()
	elif "check_player_2" in body and not enter:
		enter = true
		Globels.player_score[1] += 12
		$"../..".items_now -= 1
		body.damage_or_speed_effect("coin")
		$Coin257878.play()
		visible = false
		await $Coin257878.finished
		queue_free()


func _on_coin_anmi_timer_timeout() -> void:
	$forward_coin.visible = !$forward_coin.visible
