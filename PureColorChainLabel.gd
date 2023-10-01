extends Label

var show_counter : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 101
	
	# tweenの作成
	var tween = get_tree().create_tween()
	
	# 1秒かけて透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,0.2),0.01).set_trans(Tween.TRANS_CUBIC)
	
	# 1秒かけて不透明にする
	tween.tween_property(self, "modulate", Color(1,1,1,1.0), 0.01).set_trans(Tween.TRANS_CUBIC)
	
	# アニメーションを繰り返す設定
	tween.set_loops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MyGlobal.remained_skewer == MyGlobal.remained_skewer_init_val - 1:
		MyGlobal.is_now_pure_color_chain = false
		return # 非表示
	
	if not MyGlobal.is_now_pure_color_chain:
		hide()
	else:
		if show_counter == 0:
			# 効果音
			$SePureBonus.play()
		show_counter = show_counter + 1
		if show_counter > 30:
			hide()
			MyGlobal.is_now_pure_color_chain = false
			show_counter = 0
			MyGlobal.score = MyGlobal.score + 500
		show()
