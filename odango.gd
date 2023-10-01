extends RigidBody2D

@export var center_bonus_label: PackedScene

var Center_X_Pos : float = 320
var is_shot : bool = false
var death_hide_counter : int = 0

var is_already_slowed : bool = false

var is_integrate_force : bool = false

var first_velocity : Vector2 = Vector2.ZERO

var shot_hit_judge_val : int = 36

var odango_type : MyGlobal.odango_type_enum

# Called when the node enters the scene tree for the first time.
func _ready():	
	# TODO: 乱数で色変更
	var rand_int : int = randi_range(0, 120)
	if rand_int >= 0 and rand_int < 33:
		$AnimatedSprite2D.set_animation("red")
		odango_type = MyGlobal.odango_type_enum.RED
	elif rand_int >= 33 and rand_int < 66:
		$AnimatedSprite2D.set_animation("white")
		odango_type = MyGlobal.odango_type_enum.WHITE
	elif rand_int >= 66 and rand_int < 100:
		$AnimatedSprite2D.set_animation("green")
		odango_type = MyGlobal.odango_type_enum.GREEN
	else:
		$AnimatedSprite2D.set_animation("bonus")
		odango_type = MyGlobal.odango_type_enum.BONUS
	
	$AnimatedSprite2D.play()
	
	# 初期化時の最初の速度を変数に保持しておく
	first_velocity.x = linear_velocity.x
	first_velocity.y = linear_velocity.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if MyGlobal.game_state == MyGlobal.game_state_type.Result:
		# リザルト画面では団子を消す
		queue_free()
	
	# ボタンを押したときに、座標が串の範囲内だったら得点
	if MyGlobal.is_decide_key_just_pressed():
		if (global_position.x < Center_X_Pos + shot_hit_judge_val
			and global_position.x > Center_X_Pos - shot_hit_judge_val
			and $SeSwing.playing != true
			):
			var center_bonus : int = shot_hit_judge_val - abs(global_position.x - Center_X_Pos)
			# シングルトンのような運用で、複数の団子がヒットしてしまっても効果音は1回しかならないようにする
			if MyGlobal.is_swing_se_playing_on_odango == false:				
				MyGlobal.is_swing_se_playing_on_odango = true
				$SeSwing.play()
			is_shot = true;
			MyGlobal.shotted_alive_dango_amount = MyGlobal.shotted_alive_dango_amount + 1
			MyGlobal.all_shotted_odango_kind.append(odango_type)
			z_index = 10;
			MyGlobal.is_odango_finished = false
			linear_velocity = Vector2.ZERO
			# ちょっと上にずれる演出
#			position.y = position.y - 20.0
#			# TODO: いい感じの方法探す、transformだとむずい
			is_integrate_force = true
			var added_score : int = center_bonus * 2.77 + 1 # 慈悲の1点
			if MyGlobal.remained_skewer != MyGlobal.remained_skewer_init_val - 1:
				# スコア加算
				if MyGlobal.is_now_bonus_time == true:
					MyGlobal.score += (added_score * 2)
				else:
					MyGlobal.score += added_score
				# ボーナスUIの表示
				if center_bonus_label != null:
					show_bonus_ui(added_score, center_bonus)
			
	if is_shot:
		death_hide_counter += 1
		if death_hide_counter > 30:
			MyGlobal.is_odango_finished = true
			MyGlobal.is_swing_se_playing_on_odango = false
			
			MyGlobal.shotted_alive_dango_amount = MyGlobal.shotted_alive_dango_amount - 1
			# その後、お団子が消える
			
			# ボーナス処理
			# どのケースにおいても無効化
			# TODO: 配列で判定
			if (MyGlobal.is_now_bonus_time == true
				and MyGlobal.all_shotted_odango_kind.has(MyGlobal.odango_type_enum.BONUS) != true):
				MyGlobal.is_now_bonus_time = false
			# ボーナス団子とってたら有効
			if odango_type == MyGlobal.odango_type_enum.BONUS:
				MyGlobal.is_now_bonus_time = true
				
			# 配列の後始末は、一番最後の団子に任せる
			if MyGlobal.shotted_alive_dango_amount == 0:
				MyGlobal.all_shotted_odango_kind.clear()
			queue_free()
			
	if MyGlobal.game_state == MyGlobal.game_state_type.Title:
		# タイトル画面では移動の一切を無効化
		return
		
	do_slowly_when_not_shotted_odango()
	print(MyGlobal.is_now_bonus_time)

## 画面外に言ったらfreeして消えてもらう
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()

func show_bonus_ui(added_score, center_bonus):
	var center_bonus_label_instance = center_bonus_label.instantiate()

	if rotation >= 0:
		center_bonus_label_instance.set_rotation(rotation * -1.0) # 団子の回転情報をもとにUIを補正
	else:
		center_bonus_label_instance.set_rotation(rotation * -1.0)
		
	if MyGlobal.is_now_bonus_time == true:
		center_bonus_label_instance.text = "+" + str(added_score) + "×2"
	else:
		center_bonus_label_instance.text = "+" + str(added_score)
	add_child(center_bonus_label_instance)
	
	# tween をするために add_child の後ろに書く
	# 色変化。center_bonus は団子を真ん中に仕留めて36。最低値は0
	if center_bonus <= 5:
		center_bonus_label_instance.modulate = Color(0.0, 0.0, 1.0, 1.0)
		center_bonus_label_instance.scale = Vector2(0.65, 0.65)
	elif center_bonus > 5 and center_bonus <= 15:
		center_bonus_label_instance.modulate = Color(0.5, 1.0, 0.5, 1.0)
		center_bonus_label_instance.scale = Vector2(0.75, 0.75)
	elif center_bonus > 15 and center_bonus <= 25:
		center_bonus_label_instance.scale = Vector2(0.85, 0.85)
		center_bonus_label_instance.modulate = Color(1.0, 0.5, 0.0, 1.0)
	elif center_bonus > 25 and center_bonus <= 34:
		center_bonus_label_instance.scale = Vector2(0.95, 0.95)
		center_bonus_label_instance.modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif center_bonus > 34:
		center_bonus_label_instance.modulate = Color(1.0, 0.0, 0.0, 1.0)
		center_bonus_label_instance.apply_ui_blink(1.0, 0.0, 0.0)

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
			if linear_velocity.y < 0:
				# かすったのと見間違えて紛らわしいから動かさないように
				linear_velocity.y = first_velocity.y / 8.0
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
