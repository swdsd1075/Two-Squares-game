extends Node


#this is for player_1 or 2 propties
var lights : bool = true
var partcals : bool = true
var time : int = 0
var difficlalty : String = "Normal"
var player_1_wins : int = 0
var player_2_wins : int = 0
var spown_player_not_one_point : Array
var player_speed_propties : Array = [0,0]
var player_damage_propties : Array = [0,0]
var player_score : Array = [0,0]
var hit_dmg_win_effect : Array = [0,0]
var damage_win_effect : Array = [0,0]
var player_1_heart : int = 3
var player_2_heart : int = 3
var player_1_grenades : int = 2
var player_2_grenades : int = 2
var player_1_health : int = 100
var player_2_health : int = 100
var player_1_pos  : Vector2 #this var for future
var player_2_pos  : Vector2 #this var for future
var start_play : bool = false
#-------------------------------------
