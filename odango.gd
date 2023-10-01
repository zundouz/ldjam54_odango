extends RigidBody2D

var Center_X_Pos : float = 320
var is_shot : bool = false
var death_hide_counter : int = 0

var is_already_slowed : bool = false

var is_integrate_force : bool = false

var first_velocity : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():	
	# TODO: 乱数で色変更
	var rand_int : int = randi_range(0, 2)
	if rand_int == 0:
		$AnimatedSprite2D.set_animation("default")
	elif rand_int == 1:
		$AnimatedSprite2D.set_animation("white")
	else:
		$AnimatedSprite2D.set_animation("green")
	
	$AnimatedSprite2D.play()
	
	# 初期化時の最初の速度を変数に保持しておく
	first_velocity.x = linear_velocity.x
	first_velocity.y = linear_velocity.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if MyGlobal.game_state == MyGlobal.game_state_type.Result:
		# インゲーム以外で入力は受け付けない
		queue_free()
	
	# ボタンを押したときに、座標が串の範囲内だったら得点
	if MyGlobal.is_decide_key_just_pressed():
		if (transform.get_origin().x < Center_X_Pos + 36
			and transform.get_origin().x > Center_X_Pos - 36
			and $SeSwing.playing != true):
			# シングルトンのような運用で、複数の団子がヒットしてしまっても効果音は1回しかならないようにする
			if MyGlobal.is_swing_se_playing_on_odango == false:				
				MyGlobal.is_swing_se_playing_on_odango = true
				$SeSwing.play()
			is_shot = true;
			z_index = 10;
			MyGlobal.is_odango_finished = false
			linear_velocity = Vector2.ZERO
			# スコア加算
			MyGlobal.score += 10
			# ちょっと上にずれる演出
#			position.y = position.y - 20.0
#			# TODO: いい感じの方法探す、transformだとむずい
			is_integrate_force = true
			
	if is_shot:
		death_hide_counter += 1
		if death_hide_counter > 30:
			MyGlobal.is_odango_finished = true
			MyGlobal.is_swing_se_playing_on_odango = false
			# その後、お団子が消える
			queue_free()
			
	if MyGlobal.game_state == MyGlobal.game_state_type.Title:
		# タイトル画面では移動の一切を無効化
		return
		
	do_slowly_when_not_shotted_odango()

## 画面外に言ったらfreeして消えてもらう
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func do_slowly_when_not_shotted_odango():
	# TODO: 今、団子が向かっている方向に応じて方向は変化させずに速度だけを変えたい…
	if is_shot == false:
		if MyGlobal.is_odango_finished == false:
			# TODO: 当たってない団子をちょっと地味にする演出欲しい
			is_already_slowed = true
			# 減速処理。
			linear_velocity.x = first_velocity.x / 4.0
			linear_velocity.y = first_velocity.y / 4.0
			modulate = Color(0.45, 0.45, 0.45, 0.75)

		else:
			linear_velocity.x = first_velocity.x
			linear_velocity.y = first_velocity.y
			# 色味も元に戻す
			modulate = Color(1, 1, 1, 1)

func _integrate_forces(state):
	if is_integrate_force == true:
		state.apply_central_impulse(Vector2(0, -30)) # 回転のことを考慮せずに力を外部から与えることができる
		is_integrate_force = false
