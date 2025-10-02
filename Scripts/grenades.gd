extends Area2D

@export var grenads_count: int = 2
signal enter

# متغيرات الحركة لأعلى/أسفل
@export var float_amplitude : float = 5.0 # أقصى مسافة يتحركها فوق/تحت
@export var float_speed : float = 2.0     # سرعة الحركة
var start_y : float

func _ready() -> void:
	$AnimatedSprite2D.play("visble_effect")
	$visble_timer.start()
	$GPUParticles2D.visible = false
	start_y = position.y

func _physics_process(_delta: float) -> void:
	# حركة لأعلى وأسفل فقط (بدون سقوط أولي)
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude

var entered : bool = false
func _on_body_entered(body: Node2D) -> void:
	if entered:return
	body.grenades += grenads_count
	if "check_player_1" in body:
		Globels.player_score[0] += 3
	elif "check_player_2" in body:
		Globels.player_score[1] += 3
	enter.emit()
	$"../..".items_now -= 1
	entered = true
	$ItemCollected1367087.play()
	visible = false
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_visble_timer_timeout() -> void:
	$GPUParticles2D.visible = true
