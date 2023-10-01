extends Node

# 型
enum game_state_type { Title, InGame, Result }
enum odango_type_enum { RED, WHITE, GREEN, BONUS }

# グローバル変数の作成
var score : int = 0
var remained_skewer_init_val : int = 16
var remained_skewer : int = remained_skewer_init_val
var is_odango_finished : bool = true
var shotted_alive_dango_amount : int = 0
var is_now_bonus_time : bool = false
var all_shotted_odango_kind : Array[odango_type_enum] = []

var is_swing_se_playing_on_odango = false

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
	# ブラウザ起動直後に画面押すとうつっちゃうのがうっとうしいので除外
	# ボタンとかがあればいいだろうけど…
#	if Input.is_action_just_pressed("mouse_left"):
#		return true
	return false
