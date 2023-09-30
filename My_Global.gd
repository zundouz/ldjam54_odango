extends Node

# グローバル変数の作成
var score : int = 0
var remained_skewer : int = 11
var is_odango_finished : bool = true

var is_swing_se_playing_on_odango = false

enum game_state_type { Title, InGame, Result }

var game_state : game_state_type = game_state_type.Title

func is_decide_key_just_pressed():
	# キーボード
	if (Input.is_action_just_pressed("space") or
		Input.is_action_just_pressed("w_key") or
		Input.is_action_just_pressed("move_up") or
		Input.is_action_just_pressed("enter")
		):
		return true
	# Joy-Pad
	if (Input.is_action_just_pressed("joy_buttonA") or
		Input.is_action_just_pressed("joy_buttonB") or
		Input.is_action_just_pressed("joy_buttonX") or
		Input.is_action_just_pressed("joy_buttonY")
		):
		return true
	# mouse
	if Input.is_action_just_pressed("mouse_left"):
		return true
	return false
