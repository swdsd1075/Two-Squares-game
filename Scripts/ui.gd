extends CanvasLayer

var last_heart_1: int
var last_heart_2: int

var win_1_effect : bool = false
var win_2_effect : bool = false
var can_skip : bool = false

func skip_anmi():
	$AnimationPlayer.play("skip_anmi")
	can_skip = true
	$win_player/MarginContainer.visible = true

func score_effect():
	pass


func _ready() -> void:
	$ColorRect.color = "ffffff00"
	$win_player.visible = false
	#$AnimationPlayer.play("win_player")
	last_heart_1 = Globels.player_1_heart
	last_heart_2 = Globels.player_2_heart

func _process(_delta: float) -> void:
	#if win_1_effect or win_2_effect:
	#	return
	#skip win
	if can_skip and Input.is_action_pressed("skip_button"):
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	#player 1 win effect
	if Globels.player_1_heart != last_heart_1 and not win_1_effect:
		if not Globels.player_1_heart == 0:
			last_heart_1 = Globels.player_1_heart
			$AnimationPlayer.play("heart_negtive")
		else:
			win_1_effect = true
			$AnimationPlayer.play("win_player")
			$win_player.visible = true
			$win_player/VBoxContainer/Label.text = "player 2 win"
			$player_1/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_1/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
	#player 2 win effect
	if Globels.player_2_heart != last_heart_2 and not win_2_effect:
		if not Globels.player_2_heart == 0:
			last_heart_2 = Globels.player_2_heart
			$AnimationPlayer.play("heart_negtive")
		else:
			$AnimationPlayer.play("win_player")
			win_2_effect = true
			$win_player.visible = true
			$player_2/VBoxContainer/HBoxContainer2/Label.modulate = "e90034"
			$player_2/VBoxContainer/HBoxContainer2/heart1.texture = load("res://gra/kenney_assets/no_heart.png")
	#make resposive ui
	$player_1/VBoxContainer/MarginContainer/TextureProgressBar.value = Globels.player_1_health
	$player_2/VBoxContainer/MarginContainer/TextureProgressBar.value = Globels.player_2_health
	$player_1/VBoxContainer/HBoxContainer3/Label.text = str(Globels.player_1_grenades)+"x"
	$player_2/VBoxContainer/HBoxContainer3/Label.text = "x"+str(Globels.player_2_grenades)
	$player_2/VBoxContainer/HBoxContainer2/Label.text = "x"+str(Globels.player_2_heart)
	$player_1/VBoxContainer/HBoxContainer2/Label.text = str(Globels.player_1_heart)+"x"
	#... for win effect player_1
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/health/Label2.text = str(round(Globels.player_1_health))
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/damage/Label2.text = str(round(Globels.damage_win_effect[0]))
	$"win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/hit damage/Label2".text = str(round(Globels.hit_dmg_win_effect[0]))
	$win_player/HBoxContainer/VBoxContainer/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/score/Label2.text = str(round(Globels.player_score[0]))

	#... for win effect player_2
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/health/Label2.text = str(round(Globels.player_2_health))
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/damage/Label2.text = str(round(Globels.damage_win_effect[1]))
	$"win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/hit damage/Label2".text = str(round(Globels.hit_dmg_win_effect[1]))
	$win_player/HBoxContainer/VBoxContainer2/VBoxContainer2/NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/score/Label2.text = str(round(Globels.player_score[1]))

	  

@onready var label_1 = $player_1/VBoxContainer/HBoxContainer2/Label
@onready var label_2 = $player_2/VBoxContainer/HBoxContainer2/Label
