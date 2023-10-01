extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 101
	
	# tweenの作成
	var tween = get_tree().create_tween()
	
	# 1秒かけて透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,0),0.1).set_trans(Tween.TRANS_CUBIC)
	
	# 1秒かけて不透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.1).set_trans(Tween.TRANS_CUBIC)
	
	# アニメーションを繰り返す設定
	tween.set_loops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if not MyGlobal.is_now_bonus_time:
		hide()
	else:
		print("BonusTime呼ばれてる")
		show()
