extends Area2D

@export var float_amplitude : float = 5.0 # أقصى مسافة يتحركها فوق/تحت
@export var float_speed : float = 2.0 # سرعة الحركة
var start_y : float

func _ready() -> void:
	start_y = position.y
	
func _process(delta: float) -> void:
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("check_player_1") or body.has_method("check_player_2"):
		body.rocket()
		queue_free()
