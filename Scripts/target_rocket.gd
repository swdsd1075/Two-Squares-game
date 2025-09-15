extends Area2D


@export var speed: float = 300.0          # سرعة الصاروخ
@export var turn_speed: float = 3.0       # سرعة الدوران (أكبر = يلف أسرع)
@export var inaccuracy: float = 0.15      # مقدار الانحراف (راديان) ~ 0.15 ≈ 8.6°

@export var player: int = 1               # 1 = يلاحق اللاعب 2 / 2 = يلاحق اللاعب 1
var boom_active : bool = false
var start_chasing : bool = false
var target_angle
var target: Vector2
var players_target: Array = []
@export var damage : int = randi_range(30,40)
var dir : Vector2
var noise
var button_pressed_1 : bool = false
var button_pressed_2 : bool = false

func duble_chose_the_player():
	start_chasing = true
	$timer/end_timer.start()
	#return rotation for 0
	$rocket_image.rotation = 0
	$CollisionShape2D.rotation = 0

func rocket_rotate(delta):
		# حدد الهدف
		var target_node : Node2D = null
		if player == 1:
			target_node = $"../../Players/player_2"
		elif player == 2:
			target_node = $"../../Players/player_1"
		else:
			return
		
		# تأكد أن الهدف موجود
		if not is_instance_valid(target_node):
			return

		var target_pos = target_node.global_position

		# اتجاه الوحدة نحو الهدف
		var dir = (target_pos - global_position).normalized()

		# زاوية الهدف + تشويش عشوائي
		var noise = randf_range(-inaccuracy, inaccuracy)
		var target_angle = dir.angle() + noise

		# إضافة زاوية 90 درجة صحيحة
		var extra_angle = deg_to_rad(90)
		target_angle += extra_angle

		# تدوير الصاروخ تدريجيًا نحو الهدف
		rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

		# تحريك الصاروخ بالاتجاه الحالي
		var forward = Vector2.RIGHT.rotated(rotation - PI/2) # أو بدون -PI/2 إذا كانت sprite موجهة للأمام
		position += forward * speed * delta



func _exploion():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("explosion")
	boom_active = true
	$rocket_image.visible = false
	$"../..".start_shake(20)
	await get_tree().create_timer(0.3).timeout
	for player in players_target:
		player.hit(damage)
	await $AnimatedSprite2D.animation_finished
	boom_active = false
	queue_free()

func _ready() -> void:
	$AnimatedSprite2D.visible = false

func _process(delta: float) -> void:
	if player == 1:
		if not Input.is_action_just_pressed("player_1_action") and not start_chasing:
			look_at($"../../Players/player_2".global_position)
			return
		elif not start_chasing:
			duble_chose_the_player()

	elif player == 2:
		if not Input.is_action_just_pressed("player_2_action") and not start_chasing:
			look_at($"../../Players/player_1".global_position)
			return
		elif not start_chasing:
			duble_chose_the_player()
			
# تحديث حالة الأزرار
	if Input.is_action_just_pressed('player_1_action'):
		button_pressed_1 = true
	if Input.is_action_just_pressed('player_2_action'):
		button_pressed_2 = true

	# شرط تشغيل الصاروخ
	if start_chasing and ((button_pressed_1 and player == 1) or (button_pressed_2 and player == 2)):
		# تغيير الصور والجزيئات مرة واحدة
		$rocket_image/GPUParticles2D.visible = true
		$rocket_image/rocket_no_fire.visible = false
		$rocket_image/rocket_fire.visible = true

		# دوران الصاروخ بشكل دائم طالما الشرط صحيح
		if not boom_active:
			rocket_rotate(delta)

			


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("check_player_1") and player == 2:
		_exploion()
		players_target.append(body)
	elif body.has_method("check_player_2") and player == 1:
		_exploion()
		players_target.append(body)

func _on_end_timer_timeout() -> void:
	if not boom_active: _exploion()


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("check_player_1") and player == 2:
		_exploion()
		players_target.erase(body)
	elif body.has_method("check_player_2") and player == 1:
		_exploion()
		players_target.erase(body)
