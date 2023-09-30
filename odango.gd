extends RigidBody2D

var Center_X_Pos : float = 320
var is_shot : bool = false
var death_hide_counter : int = 0

var is_already_slowed : bool = false

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	# ボタンを押したときに、座標が串の範囲内だったら特典
	if Input.is_action_just_pressed("move_up"):
		if transform.get_origin().x < Center_X_Pos + 40 and transform.get_origin().x > Center_X_Pos - 40:
			is_shot = true;
			z_index = 10;
			MyGlobal.is_odango_finished = false
			linear_velocity = Vector2.ZERO
			# スコア加算
			MyGlobal.score += 10
			# ちょっと上にずれる演出
			# TODO: いい感じの方法探す、transformだとむずい
			
	if is_shot:
		death_hide_counter += 1
		if death_hide_counter > 30:
			MyGlobal.is_odango_finished = true
			# その後、お団子が消える
			queue_free()
			
	if is_shot == false:		
		if MyGlobal.is_odango_finished == false:
			# TODO: 当たってない団子をちょっと地味にする演出欲しい
			is_already_slowed = true
			if linear_velocity.x >= 0:
				linear_velocity = Vector2(50.0, 0.0)
			else:
				linear_velocity = Vector2(-50.0, 0.0)

		else:
			if transform.get_origin().x < Center_X_Pos + 40 and transform.get_origin().x > Center_X_Pos - 40:
				# すでにスローになっている団子が真ん中で詰まられると困る
				if is_already_slowed:
					if linear_velocity.x >= 0:
						linear_velocity = Vector2(randf_range(150.0, 300.0), 0.0)
					else:
						linear_velocity = Vector2(randf_range(-300.0, -150.0), 0.0)
			else:
				if linear_velocity.x >= 0:
					linear_velocity = Vector2(randf_range(150.0, 300.0), 0.0)
				else:
					linear_velocity = Vector2(randf_range(-300.0, -150.0), 0.0)


## 画面外に言ったらfreeして消えてもらう
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
