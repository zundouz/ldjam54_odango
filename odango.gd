extends RigidBody2D

var Center_X_Pos = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	
	# ボタンを押したときに、座標が串の範囲内だったら特典
	if Input.is_action_pressed("move_up"):
		if transform.get_origin().x < Center_X_Pos + 5 and transform.get_origin().x > Center_X_Pos - 5:
			# スコア加算
			MyGlobalScore.score += 10
			# その後、お団子が消える
			queue_free()

## 画面外に言ったらfreeして消えてもらう
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
