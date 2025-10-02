extends Node2D
@export var texture_scale : float = 0.5
@export var light_energy : float = 0.9

@export var rotation_speed : float = 0.2
  # سرعة التأرجح
@export var max_rotation := 0.35    # أقصى زاوية لليمين واليسار
var direction := 1  # 1: زيادة، -1: نقصان
@export var left_or_right = true 
@export var bg : bool = false

func _ready() -> void:
	if left_or_right: rotation = max_rotation
	else:
		rotation = max_rotation
		direction = -1
func _process(delta: float) -> void:
	$PointLight2D.visible = Globels.lights
	#check the lights
	if Globels.lights:
		$GPUParticles2D.visible = Globels.partcals
	else:
		$GPUParticles2D.visible = false
	$PointLight2D.energy = light_energy
	$PointLight2D.texture_scale = texture_scale
	
	$PointLight2D.visible = Globels.lights
	rotation += rotation_speed * delta * direction
	
	#change the image open or off
	if true:
		$Sprite2D.texture = load("res://gra/latren-removebg-preview.png")
	else:
		$Sprite2D.texture = load("res://gra/off_latren.png")

	# عكس الاتجاه عند الوصول للحدود
	if rotation >= max_rotation:
		rotation = max_rotation
		direction = -1
	elif rotation <= -max_rotation:
		rotation = -max_rotation
		direction = 1
	var mat = $GPUParticles2D.process_material
	if bg and Globels.lights:
		if mat is ParticleProcessMaterial:
			mat.scale_min = 0.15
			mat.scale_max = 0.3
	else:
		if mat is ParticleProcessMaterial:
			mat.scale_min = 0.06
			mat.scale_max = 0.1

	
	


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property($PointLight2D,"energy",light_energy-0.2,0.1)
	tween.tween_property($PointLight2D,"energy",light_energy,0.1)
