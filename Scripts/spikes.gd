extends Area2D

var player_1_enter : bool = false
var player_2_enter : bool = false
var target : CharacterBody2D
var open_or_close : bool = false # نبدأ مغلقين


@export var damage : float = 0.1

func _ready() -> void:
	#لمسات نهاءية
	var random_time = randf_range(0.7, 2.0)
	$timers/open_and_close_timer.wait_time = random_time
	var random_num = randi_range(1, 2)
	if random_num == 1:
		$image_open.visible = false
		$image_open.visible = true
	elif random_num == 1:
		$image_open.visible = true
		$image_open.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("check_player_1"):
		player_1_enter = true
		target = body
	elif body.has_method("check_player_2"):
		player_2_enter = true
		target = body

	# إذا كانت الأشواك مفتوحة فعليًا، ابدأ التايمر فورًا
	if open_or_close:
		$timers/hit_timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("check_player_1"):
		player_1_enter = false
	elif body.has_method("check_player_2"):
		player_2_enter = false

	# إذا خرج اللاعب، أوقف التايمر (اختياري)
	if not player_1_enter and not player_2_enter:
		$timers/hit_timer.stop()




func _on_open_and_close_timer_timeout() -> void:
	open_or_close = !open_or_close
	$image_open.visible = open_or_close
	$image_close.visible = !open_or_close
	if sound_area_enter:
		$ButtonPress382713.play()

	# عندما تُفتح الأشواك، وتكون لاعب داخل المنطقة
	if open_or_close and (player_1_enter or player_2_enter):
		if target and target.has_method("hit"):
			target.hit(damage)
		$timers/hit_timer.start()


func _on_hit_timer_timeout() -> void:
	if open_or_close and (player_1_enter or player_2_enter):
		if target and target.has_method("hit"):
			target.hit(damage)
		$timers/hit_timer.start()

var sound_area_enter : bool = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hit"): sound_area_enter = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("hit"): sound_area_enter = false
